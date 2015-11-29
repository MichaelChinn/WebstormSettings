using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using StateEval;
using StateEval.Security;
using System.Xml;
using System.Xml.Schema;

using Microsoft.IdentityModel.Claims;
using Microsoft.IdentityModel.Configuration;
using Microsoft.IdentityModel.Protocols.WSTrust;
using Microsoft.IdentityModel.SecurityTokenService;
using System.Threading;
using System.Security.Principal;
using EDSIntegrationLib;


using NUnit.Framework;

namespace StateEval.tests
{
    [TestFixture]
    class tClaimsRewrite
    {

        Hashtable _roleXlate = new Hashtable();
        [SetUp]
        public void Init()
        {


            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictEvaluator)) _roleXlate.Add(EdsIdentity.RoleDistrictEvaluator, UserRole.SEDistrictEvaluator);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictAdmin)) _roleXlate.Add(EdsIdentity.RoleDistrictAdmin, UserRole.SEDistrictAdmin);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolAdmin)) _roleXlate.Add(EdsIdentity.RoleSchoolAdmin, UserRole.SESchoolAdmin);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolPrincipal)) _roleXlate.Add(EdsIdentity.RoleSchoolPrincipal, UserRole.SESchoolPrincipal);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictTeacherEvaluator)) _roleXlate.Add(EdsIdentity.RoleDistrictTeacherEvaluator, UserRole.SETeacherEvaluator);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleHeadPrincipal)) _roleXlate.Add(EdsIdentity.RoleHeadPrincipal, UserRole.SEPrincipalEvaluator);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolTeacher)) _roleXlate.Add(EdsIdentity.RoleSchoolTeacher, UserRole.SESchoolTeacher);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleStateAdmin)) _roleXlate.Add(EdsIdentity.RoleStateAdmin, UserRole.SEStateAdmin);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSuperAdmin)) _roleXlate.Add(EdsIdentity.RoleSuperAdmin, UserRole.SESuperAdmin);

            foreach (string districtCode in _ImportTestDistrictCodes)
            {
                SetupFrameworks(districtCode);
                SetupSchoolYearDistrictConfig(districtCode);
            }

        }
        private void SetupFrameworks(string districtCode)
        {
            Fixture.SEMgrExecute(
                "INSERT dbo.SEFramework( DistrictCode ,SchoolYear ,FrameworkTypeID ,IFWTypeID ,IsPrototype ,"
                + "HasBeenModified ,HasBeenApproved ,DerivedFromFrameworkID ,DerivedFromFrameworkAuthor ,LoadDateTime ,"
                + "EvaluationTypeID  )VALUES  ( '" + districtCode + "' ,2014 , 1 , 1 , 0 ,0 ,1 , 32 ,'boljs' ,'2013-07-11 00:19:14' , 1  )");

            Fixture.SEMgrExecute(
                "INSERT dbo.SEFramework( DistrictCode ,SchoolYear ,FrameworkTypeID ,IFWTypeID ,IsPrototype ,"
                + "HasBeenModified ,HasBeenApproved ,DerivedFromFrameworkID ,DerivedFromFrameworkAuthor ,LoadDateTime ,"
                + "EvaluationTypeID  )VALUES  ( '" + districtCode + "' ,2014 , 1 , 1 , 0 ,0 ,1 , 32 ,'boljs' ,'2013-07-11 00:19:14' , 2  )");
        }
        private static void SetupSchoolYearDistrictConfig(string districtCode)
        {
            Fixture.SEMgrExecute("insert SESchoolYearDistrictConfig (schoolYear, districtCode, SchoolYearIsVisible, SchoolYearIsDefault) values (2014, '" + districtCode + "', 1, 1)");
        }

        [Test]
        public void TestReWrite()
        {
            //test that an undecorated name gets decorated, and that bogus claims are filtered and put in 'actor'
            ClaimsIdentity testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;09206;foo;bar;adam"));


            SAMLTokenProcessor stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            Assert.AreEqual(2, testIdentity.Claims.Count);  //actor is now exposed in the roles

            Assert.AreEqual(testIdentity.Claims[0].Value, "TheUserName_edsUser");
           


            //test that a decorated name stays decorated, and that bogus claims are filtered and put in 'actor'
            testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName_edsUser"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;09206;foo;bar;adam"));

            stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            Assert.AreEqual(2, testIdentity.Claims.Count);
            Assert.AreEqual(testIdentity.Claims[0].Value, "TheUserName_edsUser");

            //retest the above two cases; this time with a valid eVal claim coming after the bogus claim
            testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName_edsUser"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;09206;foo;bar;adam"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Fobson School District;42422;" + EdsIdentity.RoleDistrictAdmin));

            stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            Assert.AreEqual(4, testIdentity.Claims.Count);

            int claimTouch = 0;
            foreach (Claim claim in testIdentity.Claims)
            {
                switch (claim.ClaimType)
                {
                    case ClaimTypes.Name:
                        Assert.AreEqual("TheUserName_edsUser", claim.Value);
                        claimTouch += 1;
                        break;
                    case ClaimTypes.Actor:
                        Assert.IsTrue(claim.Value.Contains("09206"));
                        Assert.IsTrue(claim.Value.Contains("UserName"));
                        Assert.IsTrue(claim.Value.Contains("42422"));
                        Assert.IsTrue(claim.Value.Contains("adam"));
                        Assert.IsTrue(claim.Value.Contains(EdsIdentity.RoleDistrictAdmin));
                        claimTouch += 2;
                        break;
                    case ClaimTypes.Role:
                        Assert.AreEqual(UserRole.SEDistrictAdmin, claim.Value);
                        claimTouch += 4;
                        break;
                    case ClaimTypes.Locality:
                        Assert.AreEqual("42422", claim.Value);
                        claimTouch += 8;
                        break;
                }
            }
            Assert.AreEqual(15, claimTouch);

            testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;09206;foo;bar;adam"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Fobson School District;42422;" + EdsIdentity.RoleDistrictAdmin));

            stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            Assert.AreEqual(4, testIdentity.Claims.Count);

  
            claimTouch = 0;
            foreach (Claim claim in testIdentity.Claims)
            {
                switch (claim.ClaimType)
                {
                    case ClaimTypes.Name:
                        Assert.AreEqual("TheUserName_edsUser", claim.Value);
                        claimTouch += 1;
                        break;
                    case ClaimTypes.Actor:
                        Assert.IsTrue(claim.Value.Contains("09206"));
                        Assert.IsTrue(claim.Value.Contains("UserName"));
                        Assert.IsTrue(claim.Value.Contains("42422"));
                        Assert.IsTrue(claim.Value.Contains("adam"));
                        Assert.IsTrue(claim.Value.Contains(EdsIdentity.RoleDistrictAdmin));
                        claimTouch += 2;
                        break;
                    case ClaimTypes.Role:
                        Assert.AreEqual(UserRole.SEDistrictAdmin, claim.Value);
                        claimTouch += 4;
                        break;
                    case ClaimTypes.Locality:
                        Assert.AreEqual("42422", claim.Value);
                        claimTouch += 8;
                        break;
                }
            }
            Assert.AreEqual(15, claimTouch);

            //see that things still work when you have two eVal roles...
            testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;09206;foo;bar;adam"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Fobson School District;42422" +
                ";" + EdsIdentity.RoleDistrictAdmin +
                ";" + EdsIdentity.RoleDistrictEvaluator));

            stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            Assert.AreEqual(5, testIdentity.Claims.Count);

            Hashtable expectedRoles = new Hashtable();
            expectedRoles.Add(UserRole.SEDistrictAdmin, null);
            expectedRoles.Add(UserRole.SEDistrictEvaluator, null);

            claimTouch = 0;
            foreach (Claim claim in testIdentity.Claims)
            {
                switch (claim.ClaimType)
                {
                    case ClaimTypes.Name:
                        Assert.AreEqual("TheUserName_edsUser", claim.Value);
                        claimTouch += 1;
                        break;

                    case ClaimTypes.Actor:
                        Assert.IsTrue(claim.Value.Contains("09206"));
                        Assert.IsTrue(claim.Value.Contains("UserName"));
                        Assert.IsTrue(claim.Value.Contains("42422"));
                        Assert.IsTrue(claim.Value.Contains("adam"));
                        Assert.IsTrue(claim.Value.Contains(EdsIdentity.RoleDistrictAdmin));
                        Assert.IsTrue(claim.Value.Contains(EdsIdentity.RoleDistrictEvaluator));
                        break;
                    case ClaimTypes.Role:
                        Assert.IsTrue(expectedRoles.ContainsKey(claim.Value));
                        expectedRoles.Remove(claim.Value);
                        break;
                    case ClaimTypes.Locality:
                        claimTouch += 2;
                        Assert.AreEqual("42422", claim.Value);
                        break;

                }
            }
            Assert.AreEqual(expectedRoles.Count, 0);
            Assert.AreEqual(3, claimTouch);

            //what happens when this is a non-eds format token?...
            testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "foglestomp"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "figglesWorth"));

            stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            Assert.AreEqual(3, testIdentity.Claims.Count);

            expectedRoles = new Hashtable();
            expectedRoles.Add("foglestomp", null);
            expectedRoles.Add("figglesWorth", null);

            foreach (Claim claim in testIdentity.Claims)
            {
                switch (claim.ClaimType)
                {
                    case ClaimTypes.Name:
                        Assert.AreEqual("TheUserName", claim.Value);
                        break;

                    case ClaimTypes.Role:
                        Assert.IsTrue(expectedRoles.ContainsKey(claim.Value));
                        expectedRoles.Remove(claim.Value);
                        break;

                    case ClaimTypes.Actor:
                        throw new Exception("shouldn't have any actors here, but there are@!!");
                }
            }
            Assert.AreEqual(expectedRoles.Count, 0);
        }
        [Test]
        public void TestReWriteII()
        {
            //test that an undecorated name gets decorated
            //test that eds formatted role strings with unfamiliar roles get expunged
            //test expungement with an eds formatted role string with a mixture of unfamiliar/familar roles
            //try the case where the name isn't decorated, but the claims have already been rewritten

            ClaimsIdentity testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;09206;foo;bar;adam"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;17412;one;two;three;four"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;17414;alpha;bravo;charlie"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;01147;foo;bar;adam"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;04246;"
                + EdsIdentity.RoleDistrictEvaluator + ";" + EdsIdentity.RoleDistrictAdmin));


            SAMLTokenProcessor stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            Hashtable htFoundClaims = new Hashtable();

            int claimTouch = 0;
            foreach (Claim claim in testIdentity.Claims)
            {
                switch (claim.ClaimType)
                {
                    //only care about the role and name claims
                    case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name":
                        Assert.AreEqual("TheUserName_edsUser", claim.Value);
                        claimTouch += 1;
                        break;

                    case ClaimTypes.Role:
                        //just collect the claims for now
                        htFoundClaims.Add(claim.Value, null);
                        break;

                    case ClaimTypes.Locality:
                        Assert.AreEqual("04246", claim.Value);
                        claimTouch += 2;
                        break;
                }
            }

            Assert.IsTrue(htFoundClaims.ContainsKey(UserRole.SEDistrictAdmin));
            Assert.IsTrue(htFoundClaims.ContainsKey(UserRole.SEDistrictEvaluator));
            Assert.AreEqual(2, htFoundClaims.Count);
            Assert.AreEqual(3, claimTouch);


            //test that the right thing happens even though the username might already be decorated

            testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName_edsUser"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;09206;foo;bar;adam"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;17412;one;two;three;four"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;17414;alpha;bravo;charlie"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;01147;foo;bar;adam"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, "Wenatchee School District;04246;"
                + EdsIdentity.RoleDistrictAdmin + ";" + EdsIdentity.RoleDistrictEvaluator));

            stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            htFoundClaims = new Hashtable();
            claimTouch = 0;

            foreach (Claim claim in testIdentity.Claims)
            {
                switch (claim.ClaimType)
                {
                    //only care about the role and name claims
                    case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name":
                        Assert.AreEqual("TheUserName_edsUser", claim.Value);
                        claimTouch += 1;
                        break;

                    case ClaimTypes.Role:
                        //just collect the claims for now
                        htFoundClaims.Add(claim.Value, null);
                        break;

                    case ClaimTypes.Locality:
                        Assert.AreEqual("04246", claim.Value);
                        claimTouch += 2;
                        break;
                }
            }

            Assert.IsTrue(htFoundClaims.ContainsKey(UserRole.SEDistrictAdmin));
            Assert.IsTrue(htFoundClaims.ContainsKey(UserRole.SEDistrictEvaluator));

            Assert.AreEqual(2, htFoundClaims.Count);

            //try the case where the name isn't decorated, but the claims have already been rewritten
            testIdentity = new ClaimsIdentity();
            testIdentity.Claims.Add(new Claim(ClaimTypes.Name, "TheUserName"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "04246"));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SEDistrictEvaluator));
            testIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SEDistrictAdmin));

            stp = new SAMLTokenProcessor(_roleXlate, "_edsUser", "eVal");
            stp.ProcessToken(testIdentity.Claims);

            htFoundClaims = new Hashtable();
            claimTouch = 0;
            foreach (Claim claim in testIdentity.Claims)
            {
                switch (claim.ClaimType)
                {
                    //only care about the role and name claims
                    case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name":
                        Assert.AreEqual("TheUserName", claim.Value);
                        claimTouch += 1;
                        break;

                    case ClaimTypes.Role:
                        //just collect the claims for now
                        htFoundClaims.Add(claim.Value, null);
                        break;

                    case ClaimTypes.Locality:
                        Assert.AreEqual("04246", claim.Value);
                        claimTouch += 2;
                        break;
                }
            }
            Assert.IsTrue(htFoundClaims.ContainsKey(UserRole.SEDistrictAdmin));
            Assert.IsTrue(htFoundClaims.ContainsKey(UserRole.SEDistrictEvaluator));

            Assert.AreEqual(2, htFoundClaims.Count);
        }

        List<string> _ImportTestDistrictCodes = new List<string>() { "01147", "34003" };
        const string D10 = "Othello School District;01147";
        const string S11="Othello High School;3015"           ;
        const string S12="Scootney Springs Elementary;3730"   ;

        const string D20 = "North Thurston Public Schools;34003";
        const string S21 = "South Bay Elementary;2754";
        const string S22 = "North Thurston High School;3010";

        string T = UserRole.SESchoolTeacher.ToString();
        string P = UserRole.SESchoolPrincipal.ToString();
        string DE = UserRole.SEDistrictEvaluator.ToString();
        string DTE = UserRole.SETeacherEvaluator.ToString();
        string DA = UserRole.SEDistrictAdmin.ToString();
        string SA = UserRole.SESchoolAdmin.ToString();
        string PE = UserRole.SEPrincipalEvaluator.ToString();
        string TE = UserRole.SETeacherEvaluator.ToString();


        const string eDA = "eValDistrictAdmin";
        const string eDE = "eValDistrictEvaluator";
        const string eSA = "eValSchoolAdmin";
        const string ePR = "eValSchoolPrincipal";
        const string eT = "eValSchoolTeacher";
        const string eDTE = "eValDistrictTeacherEvaluator";
        const string ePRH = "eValHeadPrincipal";

        //basic test; everything should just work
        [Test]
        public void TestMultiSchoolTeachers()
        {
            Hashtable roles = new Hashtable();
            roles.Add("SESchoolTeacher", null);
            string userName = "firstTestUser";
            List<string> schoolCodes = new List<string>();

            string t1 = S21 + ";" + T + "|" 
                      + S22 + ";" + T;

            Fixture.SEMgr.PersistLocalityRoleClaim(userName, t1);
            Fixture.SEMgr.CheckRolesForUserName(userName);
            SEUser u = Fixture.SEMgr.SyncUserInner("foo@bar.com", userName, "first", "last", roles, "34003", "2754");
            schoolCodes.Clear();
            schoolCodes.Add("2754");
            schoolCodes.Add("3010");
            
            CheckUserSchools(u, schoolCodes);


            t1 = S11 + ";" + T +   "|" 
               + S12 + ";" + T;
            Fixture.SEMgr.PersistLocalityRoleClaim(userName, t1);
            Fixture.SEMgr.CheckRolesForUserName(userName);

            u = Fixture.SEMgr.SyncUserInner("foo@bar.com", userName, "first", "last", roles, "01147", "3015");
            schoolCodes.Clear();

            schoolCodes.Add("3015");
            schoolCodes.Add("3730");
            CheckUserSchools(u, schoolCodes);


            //change him, and make sure it ripples through
            t1 = S11 + ";" + T;

            Fixture.SEMgr.PersistLocalityRoleClaim(userName, t1);
            Fixture.SEMgr.CheckRolesForUserName(userName);

            u = Fixture.SEMgr.SyncUserInner("foo@bar.com", userName, "first", "last", roles, "01147", "3015");
            schoolCodes.Clear();

            schoolCodes.Add("3015");

            CheckUserSchools(u, schoolCodes);
        }

        private static void CheckUserSchools(SEUser u, List<string>schoolCodes)
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pSqlCmd", "select * from dbo.seUserDistrictSchool where seUserID = " + u.Id.ToString() + " order by schoolcode")
            };

            int returnCount = 0;

            SqlDataReader r = Fixture.SEMgr.DbConnector.ExecuteDataReader("GetOneOff", aParams);
            List<string> ret = new List<string>();
            while (r.Read())
            {
                string val = (string)r["SchoolCode"];
                ret.Add(val);
                returnCount++;
            }
            r.Close();

            Assert.AreEqual(returnCount, schoolCodes.Count);
            
            for (int i = 0; i < schoolCodes.Count; i++)
            {
                Assert.AreEqual(schoolCodes[i], ret[i]);
            }

        }

        [Test]
        public void TestBaseErrors()
        {
            string userName = "__msi!x_user1;";
            StringBuilder sbRoleString = new StringBuilder();

            //Cannot be associated with more than one district
            //Unknown district code
            //Unknown school code

            sbRoleString.Append(D20 + ";" + DA + "|" + D10 + ";" + DA);
            LookForException(userName, "person in multiple locations, with at least one district", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + T + "|" + S11 + ";" + T);
            LookForException(userName, "person in schools from different districts", sbRoleString);
            sbRoleString.Clear();


            /*

            sbRoleString.Append("foobarDistrict;01000" + ";" + DA);
            LookForException(userName, "is unrecognized in our list of districts/schools", sbRoleString);
            sbRoleString.Clear();
            */

            sbRoleString.Append("foobarSchool;0100" + ";" + SA + ";" + T);
            LookForException(userName, "is unrecognized in our list of districts/schools", sbRoleString);
            sbRoleString.Clear();
        }

        public bool AlwaysTrue(string locality, string role)
        {
            return true;
        }
 
        Hashtable SetupClaims(Hashtable roleXlate, string roleString)
        {
            ClaimsIdentity identity = new ClaimsIdentity();
            identity.Claims.Add(new Claim(ClaimTypes.Name, "AnEdsUserUserName", ClaimValueTypes.String, "eds.tst.ospi.k12.wa.us", "eds.tst.ospi.k12.wa.us"));
            identity.Claims.Add(new Claim(ClaimTypes.GivenName, "Shapur, Tuber", ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
            identity.Claims.Add(new Claim(ClaimTypes.Email, "shabber@shabber.com", ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
            identity.Claims.Add(new Claim(ClaimTypes.Role, roleString, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));

            SAMLTokenProcessor stp = new SAMLTokenProcessor(roleXlate, "", "eVal");
            stp.RoleConsistencyFunction = AlwaysTrue;
            stp.ProcessToken(identity.Claims);

            Fixture.SEMgr.AugmentEValTypeRoleClaims(identity.Claims);

            Hashtable roleResultant = new Hashtable();
            foreach (Claim c in identity.Claims)
            {
                if (c.ClaimType == ClaimTypes.Role)
                {
                    roleResultant.Add(c.Value,null);
                }
            }

            return roleResultant;
        }
 
        [Test]
        public void RoleAugmentation()
        {
            //augmentaion of roles...
            //in terms of what combined inputs to test, 
            // should only need to test those things that come
            // from EDS... for instance, TE or PE is never assigned
            // at EDS
            
            //just to get the roleXlator going...
            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();
            
            //at district:
            // DE -> DE + PrE
            // DTE -> DTE + TE

            Hashtable RoleResultant = SetupClaims(ccam.RoleTranslator, D10 + ";" + eDE);
            Assert.IsTrue (RoleResultant.ContainsKey(DE));
            Assert.IsTrue (RoleResultant.ContainsKey(PE));

            RoleResultant = SetupClaims(ccam.RoleTranslator, D10 + ";" + eDTE);
            Assert.IsTrue (RoleResultant.ContainsKey(DTE));
            Assert.IsTrue (RoleResultant.ContainsKey(TE));
            
            //At School:
            // PR -> PR + TE
            // HP -> PE + PR + TE
            // HP + PR -> PE + PR + TE
            RoleResultant = SetupClaims(ccam.RoleTranslator, S11 + ";" + ePR);
            Assert.IsTrue (RoleResultant.ContainsKey(P));
            Assert.IsTrue (RoleResultant.ContainsKey(TE));

            RoleResultant = SetupClaims(ccam.RoleTranslator, S11 + ";" + ePRH);
            Assert.IsTrue(RoleResultant.ContainsKey(P));
            Assert.IsTrue(RoleResultant.ContainsKey(TE));
            Assert.IsTrue(RoleResultant.ContainsKey(PE));

            RoleResultant = SetupClaims(ccam.RoleTranslator, S11 + ";" + ePR + ";" + ePRH);
            Assert.IsTrue (RoleResultant.ContainsKey(P));
            Assert.IsTrue (RoleResultant.ContainsKey(TE));
            Assert.IsTrue (RoleResultant.ContainsKey(PE));
        }

        [Test]
        public void AllowableRoleCombinations()
        {
            string userName = "__msi!x_user1;";
            StringBuilder sbRoleString = new StringBuilder();

            sbRoleString.Append(D20 + ";" + DA + ";" + DE + ";" + TE + ";" + PE);
            Fixture.SEMgr.PersistLocalityRoleClaim(userName, sbRoleString.ToString());
            Fixture.SEMgr.CheckRolesForUserName(userName);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + SA + ";" + PE + ";" + P + ";" + TE);
            Fixture.SEMgr.PersistLocalityRoleClaim(userName, sbRoleString.ToString());
            Fixture.SEMgr.CheckRolesForUserName(userName);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + SA + ";" + T);
            Fixture.SEMgr.PersistLocalityRoleClaim(userName, sbRoleString.ToString());
            Fixture.SEMgr.CheckRolesForUserName(userName);
            sbRoleString.Clear();
        }
        [Test]
        public void RoleMismatch_II()
        {
            string userName = "__msi!x_user1;";
            StringBuilder sbRoleString = new StringBuilder();

            sbRoleString.Append(D20 + ";" + DA + ";" + T);
            LookForException(userName, "school role in district", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S11 + ";" + DA + ";" + T);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S11 + ";" + T + "|" + S12 + ";" + TE);
            LookForException(userName, "across the organizations, teacher and principal roles", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S11 + ";" + T + ";" + TE);
            LookForException(userName, "across the organizations, teacher and principal roles", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S11 + ";" + T + ";" + P);
            LookForException(userName, "across the organizations, teacher and principal roles", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S11 + ";" + T + "|" + S21 + ";" + T);
            LookForException(userName, "person in schools from different districts", sbRoleString);
            sbRoleString.Clear();
        }

        [Test]
        public void TestRoleMisMatches()
        {
            string userName = "__msi!x_user1;";
            StringBuilder sbRoleString = new StringBuilder();
            
            //In a district,
            //.cannot have any school roles
            //.no multi locations
            
            sbRoleString.Append(D20 + ";" + DA + ";" + T);
            LookForException(userName, "school role in district", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(D20 + ";" + DA + ";" + SA);
            LookForException(userName, "school role in district", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(D20 + ";" + DA + ";" + P);
            LookForException(userName, "school role in district", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(D20 + ";" + DA + "|" + D10 + ";" + TE);
            LookForException(userName, "person in multiple locations, with at least one district", sbRoleString);
            sbRoleString.Clear();

       
            sbRoleString.Append(D20 + ";" + DE + "|" + D10 + ";" + TE);
            LookForException(userName, "person in multiple locations, with at least one district", sbRoleString);
            sbRoleString.Clear();

            //single school tests:
            sbRoleString.Append(S21 + ";" + T + ";" + P);  //teacher & principal
            LookForException(userName, "across the organizations, teacher and principal roles", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + T + ";" + PE);  //teacher & head principal
            LookForException(userName, "across the organizations, teacher and principal roles", sbRoleString);
            sbRoleString.Clear();


            /*sbRoleString.Append(S21 + ";" + HP);  //hp without principal
            LookForException(userName, "You may not be a principal evaluator unless you are also a principal", sbRoleString);
            sbRoleString.Clear();
             */

            //A School
            //.may not have district roles
            //.may only be in one school

            sbRoleString.Append(S21 + ";" + SA + ";" + DA);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + SA + ";" + DE);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + SA + ";" + DA);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + T + ";" + DA);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + T + ";" + DE);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + T + ";" + DA);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + PE + ";" + P + ";" + DA);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + PE + ";" + P + ";" + DE);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S21 + ";" + PE + ";" + P + ";" + DA);
            LookForException(userName, "district role in school", sbRoleString);
            sbRoleString.Clear();


            //multi school tests:
            //teacher and anything else
            sbRoleString.Append(S21 + ";" + T + "|" + S11 + ";" + T);
            LookForException(userName, "person in schools from different districts", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S12 + ";" + T + "|" + S11 + ";" + P);  //teacher & principal
            LookForException(userName, "across the organizations, teacher and principal roles", sbRoleString);
            sbRoleString.Clear();

            sbRoleString.Append(S12 + ";" + T + "|" + S11 + ";" + PE);  //teacher & head principal
            LookForException(userName, "across the organizations, teacher and principal roles", sbRoleString);
            sbRoleString.Clear();

        }

        private void LookForException(string userName, string expectedErrorMsg, StringBuilder sbRoleString)
        {
            string em = "";
            Fixture.SEMgr.PersistLocalityRoleClaim(userName, sbRoleString.ToString());
            try
            {
                Fixture.SEMgr.CheckRolesForUserName(userName);

            }
            catch (Exception e)
            {
                em= e.Message;
            }
            Assert.IsTrue(em.Contains(expectedErrorMsg), "-" + em + "-..." + sbRoleString.ToString());
           
        }
    }
}
