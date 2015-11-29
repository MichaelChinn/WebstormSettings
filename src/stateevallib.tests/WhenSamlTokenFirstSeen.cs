using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.IdentityModel.Claims;
using System.Collections;
using EDSIntegrationLib;
using System.Data.SqlClient;

using NUnit.Framework;
using StateEval.Security;

namespace StateEval.tests
{
    class WhenSamlTokenFirstSeen
    {

        //todo: what happens when exception occurs during ccam.auth?
 
        /*
         *  https://eds.ospi.k12.wa.us/edssts/federationmetadata/2007-06/federationmetadata.xml 
         * Role (Role) - Organization Name;Organization Code;Role[;Role...]
         * Name (PersonId) - The unique identifier of the person
         * NameIdentifier (PreviousName) - The previous unique identifiers of the person. OldId[;OldId...]
         * emailaddress (EMail Address) - EMail Address</auth:Description>
         * givenname" (Given Name) - Given name of the person
         * sid" (Sid) - The secure identifier for the person
         * privatepersonalidentifier (Ppid) - The teacher cert number for the person
         */
        #region test specific infrastructure



        Hashtable CCARoleTranslator { get; set; }

        ClaimsIdentity GenerateToken(Dictionary<string, string> tokenData, Dictionary<string, List<string>> roleData)
        {
            ClaimsIdentity retVal = new ClaimsIdentity();
            foreach (var item in tokenData)
            {
                Claim claim = new Claim(item.Key, item.Value, "MyValueType", "LOCALAUTHORITY", "MyOriginalIssuer");
                retVal.Claims.Add(claim);
            }

            foreach (var item in roleData)
            {
                string claimValue = item.Key;
                foreach (var role in item.Value)
                {
                    claimValue = claimValue + ";" + role;
                }
                Claim claim = new Claim(ClaimTypes.Role, claimValue, "MyValueType", "LOCALAUTHORITY", "MyOriginalIssuer");
                retVal.Claims.Add(claim);
            }

            return retVal;
        }
        List<string> GetEDSRolesList(Dictionary<string, List<string>> locationRoles)
        {
            List<string> retVal = new List<string>();
            foreach (var item in locationRoles)
            {
                var roles = item.Value;
                foreach (var role in roles)
                    if (!retVal.Contains(role))
                        retVal.Add(role);
            }
            return retVal;
        }
        List<string> GetEDSLocationCodeList(Dictionary<string, List<string>> locationRoles)
        {
            List<string> retVal = new List<string>();

            foreach (var item in locationRoles)
            {
                //the lcoations are: LocationName;locationCode; 
                //got to just get the location code
                string[] tok = item.Key.Split(new char[] { ';' });
                retVal.Add(tok[1]);
            }
            return retVal;
        }

        List<string> GetEDSRolesAt(Dictionary<string, List<string>> locationRoles, string locationCode)
        {
            foreach (var item in locationRoles)
            {
                if (item.Key.Contains(locationCode))
                    return item.Value;
            }
            return null;
        }
        bool AreSame<T>(List<T> l1, List<T> l2)
        {
            if (l1.Count != l2.Count)
                return false;

            foreach (T item in l1)
                if (!l1.Contains(item))
                    return false;

            return true;
        }
        List<string> XLateRoles(List<string> edsRoleList)
        {
            List<string> retVal = new List<string>();

            foreach (var item in edsRoleList)
            {
                //have to xlate the home location, else can't pick home 
                //if (item.Contains("Home"))
                //    continue;
                retVal.Add((string)CCARoleTranslator[item]);
            }

            return retVal;
        }

        public void Verify(Dictionary<string, string> inputData
                        , Dictionary<string, List<string>> roleData
                        , SAMLTokenProcessor stp
                        , ClaimCollection resultantClaims)
        {
            /*
                public string EDSUserId { get; private set; }
                public string AppUserName { get; private set; }
                public string OldEDSIds { get; private set; }
                public string FullName { get; private set; }
                public string LastName { get; private set; }
                public string FirstName { get; private set; }
                public string EMail { get; private set; }
                public string SID { get; private set; }
                public string LRString { get; private set; }
                public LocalityRoleContainer LRContainer
             */

            //check the stp Properties against the input data...
            Assert.AreEqual(inputData[ClaimTypes.Name], stp.EDSUserId);
            Assert.AreEqual(inputData[ClaimTypes.Name] + "_edsUser", stp.AppUserName);
            Assert.AreEqual(inputData[ClaimTypes.PPID], stp.CertNo);
            Assert.AreEqual(inputData[ClaimTypes.GivenName], stp.FullName);
            //todo: lastnam
            //todo: firstname
            Assert.AreEqual(inputData[ClaimTypes.Email], stp.EMail);
            Assert.AreEqual(inputData[ClaimTypes.Sid], stp.SID);
            Assert.AreEqual(inputData[ClaimTypes.NameIdentifier], stp.OldEDSIds);

            //check the LRC string (localities and roles at those localities
            List<string> locations = GetEDSLocationCodeList(roleData);
            List<string> expectedSERoles;

            Assert.AreEqual(locations.Count, stp.LRContainer.Localities.Count);
            foreach (var location in locations)
            {
                expectedSERoles = XLateRoles(GetEDSRolesAt(roleData, location));
                List<string> stpRoles = XLateRoles(GetEDSRolesAt(roleData, location));

                Assert.IsTrue(AreSame(expectedSERoles, stpRoles));
            }


            //check the rewritten claims
            Assert.AreEqual(inputData[ClaimTypes.Name] + "_edsUser", resultantClaims.Where(x => x.ClaimType == ClaimTypes.Name).FirstOrDefault().Value);
            Assert.AreEqual(inputData[ClaimTypes.Sid], resultantClaims.Where(x => x.ClaimType == ClaimTypes.Sid).FirstOrDefault().Value);
            Assert.AreEqual(inputData[ClaimTypes.NameIdentifier], resultantClaims.Where(x => x.ClaimType == ClaimTypes.NameIdentifier).FirstOrDefault().Value);
            Assert.AreEqual(inputData[ClaimTypes.Email], resultantClaims.Where(x => x.ClaimType == ClaimTypes.Email).FirstOrDefault().Value);
            Assert.AreEqual(inputData[ClaimTypes.GivenName], resultantClaims.Where(x => x.ClaimType == ClaimTypes.GivenName).FirstOrDefault().Value);
            Assert.AreEqual(inputData[ClaimTypes.PPID], resultantClaims.Where(x => x.ClaimType == ClaimTypes.PPID).FirstOrDefault().Value);
        }

        private void SetupSTPAndProcess(Dictionary<string, string> tokenData, Dictionary<string, List<string>> roleData, out ClaimsIdentity incomingClaims, out SAMLTokenProcessor stp)
        {
            CustomClaimsAuthMgr cca = new CustomClaimsAuthMgr();
            cca.HydrateEDSRoleHashtable();
            CCARoleTranslator = cca.RoleTranslator;
            incomingClaims = GenerateToken(tokenData, roleData);
            stp = new SAMLTokenProcessor(CCARoleTranslator, EdsIdentity.EdsNameTag, "eVal");
            stp.RolePickerFunction = Fixture.SEMgr.PickFirstLocation;
            stp.RoleAugmenterFunction = null;
            stp.RoleConsistencyFunction = Fixture.SEMgr.RoleLocationConsistencyCheck;
            stp.ProcessToken(incomingClaims.Claims);
        }

        string GetLRString(Dictionary<string, List<string>> roleData)
        {
            StringBuilder sbLRString = new StringBuilder();
            foreach (var item in roleData)
            {
                sbLRString.Append("|" + item.Key);

                foreach (var role in item.Value)
                {
                    sbLRString.Append(";" + role);
                }
            }

            sbLRString.Remove(0, 1);
            return sbLRString.ToString();
        }

        Dictionary<string, string> _baseUserData
        {
            get
            {
                return new Dictionary<string, string>()
                    {
                        {ClaimTypes.Name, "134"},       //personId
                        {ClaimTypes.GivenName, "Public, John Q."},
                        {ClaimTypes.Email, "fleeble@flooble.com"},
                        {ClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {ClaimTypes.NameIdentifier,""},     //previous personIds
                        {ClaimTypes.PPID,"28-48492C"}        //cert number
                    };
            }
        }
        #endregion

        [Test]
        public void STP_VerifySomeDistrictRoles()
        {
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston Public Schools;34003", new List<string>(){ 
                    EdsIdentity.RoleDistrictViewer, 
                    EdsIdentity.RoleDistrictAdmin, 
                    EdsIdentity.RoleDistrictAssignmentManager,
                    EdsIdentity.RoleDistrictEvaluator
                    }}
                
            };

            ClaimsIdentity incomingClaims;
            SAMLTokenProcessor stp;
            SetupSTPAndProcess(_baseUserData, roleData, out incomingClaims, out stp);

            Verify(_baseUserData, roleData, stp, incomingClaims.Claims);

            List<string> homeRoles = incomingClaims.Claims.Where(x => x.ClaimType == ClaimTypes.Role).ToList().Select(c => c.Value).ToList();

            Assert.IsTrue(homeRoles.Contains(UserRole.SEDistrictEvaluator));
            Assert.IsTrue(homeRoles.Contains(UserRole.SEDistrictAdmin));
            Assert.IsTrue(homeRoles.Contains(UserRole.SEDistrictViewer));
            Assert.IsTrue(homeRoles.Contains(UserRole.SEDistrictAssignmentManager));

        }

        [Test]
        public void STP_VerifySomeSchoolRoles()
        {
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
                
            };

            ClaimsIdentity incomingClaims;
            SAMLTokenProcessor stp;
            SetupSTPAndProcess(_baseUserData, roleData, out incomingClaims, out stp);

            Verify(_baseUserData, roleData, stp, incomingClaims.Claims);

            List<string> homeRoles = incomingClaims.Claims.Where(x => x.ClaimType == ClaimTypes.Role).ToList().Select(c => c.Value).ToList();

            Assert.IsTrue(homeRoles.Contains(UserRole.SESchoolHeadPrincipal));
            Assert.IsTrue(homeRoles.Contains(UserRole.SESchoolAdmin));
        }


        [Test]
        public void STP_NoRolePickerSetupGetsRolesAnyway()
        {
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston Public Schools;34003", new List<string>(){ 
                    EdsIdentity.RoleDistrictViewer, 
                    EdsIdentity.RoleDistrictAdmin, 
                    EdsIdentity.RoleDistrictAssignmentManager,
                    EdsIdentity.RoleDistrictEvaluator
                    
                    }
                }
                
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);
            SAMLTokenProcessor stp = new SAMLTokenProcessor(CCARoleTranslator, EdsIdentity.EdsNameTag, "eVal");
            //stp.RoleAugmenterFunction = Fixture.SEMgr.GetAuxRolesList;
            stp.RoleConsistencyFunction = Fixture.SEMgr.RoleLocationConsistencyCheck;
            stp.ProcessToken(incomingClaims.Claims);


            Claim claim = incomingClaims.Claims.Where(x => x.ClaimType == ClaimTypes.Locality).FirstOrDefault();
            Assert.IsNotNull(claim);


            List<string> homeRoles = incomingClaims.Claims.Where(x => x.ClaimType == ClaimTypes.Role).ToList().Select(c => c.Value).ToList();

            Assert.IsTrue(homeRoles.Contains(UserRole.SEDistrictAdmin));
            Assert.IsTrue(homeRoles.Contains(UserRole.SEDistrictViewer));
            Assert.IsTrue(homeRoles.Contains(UserRole.SEDistrictAssignmentManager));

        }

        [Test]
        public void STP_SingleUserNoHomeRoleGetsRolesAnyway()
        {
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
                
            };

            ClaimsIdentity incomingClaims;
            SAMLTokenProcessor stp;
            SetupSTPAndProcess(_baseUserData, roleData, out incomingClaims, out stp);

            //problem is, i don't have a home location!!
            //Verify(_baseUserData, roleData, stp, incomingClaims.Claims);

            Claim claim = incomingClaims.Claims.Where(x => x.ClaimType == ClaimTypes.Locality).FirstOrDefault();
            Assert.AreEqual("3010", claim.Value);

            claim = incomingClaims.Claims.Where(x => x.ClaimType == ClaimTypes.Role).FirstOrDefault();
            Assert.AreEqual(UserRole.SESchoolTeacher, claim.Value);
        }

        [TearDown]
        public void Flush2()
        {
            Fixture f = new Fixture();
            f.Cleanup();
        }

        public void Flush()
        {
        }

        [SetUp]
        public void Init()
        {
            Fixture f = new Fixture();
            f.Init();
        }
        
        [Test]
        public void MGR_NewlyCreatedTeacherShouldHaveBasePropertiesAndEvalRecord()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);
            
            //check for a single evaluation record, and it's type should be TEACHEROBS
            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1}"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION)))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));


        }

        [Test]
        public void MGR_NewlyCreatedSDUHasHomeDistrictSetAndOneEvalRecord()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);
           
            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            Dictionary<string, string> s2d = Fixture.SEMgr.HydrateSchool2DistrictIfNecessary();
            string districtCode = s2d["3010"];

            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), districtCode))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        [Test]
        public void MGR_SDUWhoChangedDistrictsShouldTwoEvalRecords()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            roleData = new Dictionary<string, List<string>>()
            {
                {"Scootney Springs Elementary;3730;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };
            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1}"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION)))
            };
            Assert.AreEqual(2, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        [Test]
        public void MGR_NewlyCreatedMDUHasEvalRecordInEachDistrict()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);


            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");


            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        
        }

        [Test]
        public void MGR_SDUTransitionToMDUHaEvalRecordInBothDistricts()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };
            incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);
            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

                        SqlParameter[]aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        


        }

        [Test]
        public void MGR_MDUTransitionToSDUStillHasEvalRecordsForBothDistricts()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);


            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            roleData = new Dictionary<string, List<string>>()
            {
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };
            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);
            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");


            SqlParameter[]aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        

        }

        [Test]
        public void MGR_NewlyCreatedPrincipalShouldHaveBasePropertiesAndEvalRecord()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);

            //check for a single evaluation record, and it's type should be PrincipalObs
            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1}"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION)))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));


            Flush();

            roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleHeadPrincipal}}
            };

            incomingClaims = GenerateToken(_baseUserData, roleData);
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            //check for a single evaluation record, and it's type should be PrincipalObs
            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1}"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION)))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));



        }

        [Test]
        public void MGR_UpdateBaseUserInfo()
        {
            Flush();
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);

            u.Email = "floogle@farble.com";
            u.FirstName = "jane";
            u.LastName = "simple";
            u.CertificateNumber = "24Skiddooo";

            u.SaveUserBaseData();

            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");
            Assert.AreEqual("jane", u.FirstName);
            Assert.AreEqual("simple", u.LastName);
            Assert.AreEqual("floogle@farble.com", u.Email);
            Assert.AreEqual("24Skiddooo", u.CertificateNumber);

        }

        [Test]
        public void MGR_SearchForUserWhoExistsWithNoPreviousPersonId()
        {
            Flush();
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);
        }

        [Test]
        public void MGR_UserWithPreviousPersonIdShouldBeFound()
        {
            Flush();
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);

            u = Fixture.SEMgr.SearchForSEUser("5174", "6;4;36;134;1;4;5;22");

            Assert.AreEqual("5174_edsuser", u.UserName.ToLower());
            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);

            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");
            Assert.IsNull(u);
        }

        [Test]
        public void MGR_PersistLocalityRoleClaim()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
                
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");  
            Assert.AreEqual(2, u.LocationRoles.htRolesAt(u.LocationRoles.Localities[0]).Count);

            Assert.AreEqual(2, u.LocationRoles.Schools.Count);
            
            List<string> roles = u.Roles("SE");
            Assert.AreEqual(2, roles.Count);
        }

        [Test]
        public void MGR_VerifyUserAndHomeCreatedFromSTP()
        {
            Flush();
            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims;
            SAMLTokenProcessor stp;
            SetupSTPAndProcess(_baseUserData, roleData, out incomingClaims, out stp);

            Fixture.SEMgr.CreateUserFromSAMLInfo(stp);

            Fixture.SEMgr.SEUserFromEDSPersonId("134");

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);
            Assert.AreEqual("134_edsUser", u.UserName);

            Assert.AreEqual("3010", u.SchoolCode);
        }

        [Test]
        public void MGR_FormerTeacherNowPrincipalGetsMoreEvaluationRecords()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            roleData = roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}}
            };

            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);
            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }
 
        [Test]
        public void MGR_FormerPrincipalNowTeacherGetsMoreEvaluationRecords()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);
            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            roleData = roleData = new Dictionary<string, List<string>>()
             {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);
            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");


            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        [Test]
        public void MGR_FormerOthelloNowNorthThurstonGetsMoreEvaluationRecords()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {

                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            roleData = roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}},
            };

            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);
            
            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");


            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        [Test]
        public void MGR_MDUGetsOneVisibilityRecordForEachEvaluationRecord()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            string sqlcmd = "select count(*) from seEvalVisibility v join seEvaluation e on e.EvaluationId = v.EvaluationId where e.evaluateeid = " + u.Id;
            SqlParameter[] aParams = new SqlParameter[]{new SqlParameter ("@pSqlCmd", sqlcmd)            };
            Assert.AreEqual(2, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        [Test]
        public void MGR_MDUFormerPrincipalNowTeacherGetsOneVisibilityRecordForEachEvalRecord()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            roleData = roleData = new Dictionary<string, List<string>>()
             {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);
            u = Fixture.SEMgr.SEUserFromEDSPersonId("134");


            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "34003"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION), "01147"))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            //check the evalvisibility record count per district
            string sqlcmd = "select count(*) from seEvalVisibility"
                + " v join seEvaluation e on e.EvaluationId = v.EvaluationId where e.evaluateeid = " + u.Id
                + " and e.districtCode = '01147'";
            aParams = new SqlParameter[]{new SqlParameter ("@pSqlCmd", sqlcmd)            };
            Assert.AreEqual(2, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            sqlcmd = "select count(*) from seEvalVisibility"
                + " v join seEvaluation e on e.EvaluationId = v.EvaluationId where e.evaluateeid = " + u.Id
                + " and e.districtCode = '34003'";
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", sqlcmd) };
            Assert.AreEqual(2, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        [Test]
        public void MGR_MDUEndsUpWithConsistentSchoolAndDistrict()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}},
                {"Othello High School;3015;", new List<string>(){ EdsIdentity.RoleSchoolPrincipal}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            Dictionary<string, string> school2District = Fixture.SEMgr.HydrateSchool2DistrictIfNecessary();

            Assert.AreEqual(school2District[u.SchoolCode], u.DistrictCode);

        }
        
        [Test]
        public void CCAM_ProcessClaimsWillChangeLocationAndRoles()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
            };

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();
            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            roleData = new Dictionary<string, List<string>>()
            {
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            List<string> roles = u.Roles("SE");
            Assert.AreEqual(1, roles.Count);
            Assert.AreEqual("2754", u.SchoolCode);
            Assert.IsFalse(roles.Contains(UserRole.SESchoolPrincipal));
            Assert.IsTrue(roles.Contains(UserRole.SESchoolTeacher));

            //he now should only have one locatoin;
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count (*) from seUserDistrictSchool where seUserid = " + u.Id.ToString()) };
            int nLocations = (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams);
            Assert.AreEqual(1, nLocations);
        }

        [Test]
        public void CCAM_AuthProcessWillSetupNewUserAndProcessClaims()
        {
            //most of the component functionality of the CCAM processing
            // has been tested above.  This function merely verifies the
            // the ccam *components* were called
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
                
            };
            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr cca = new CustomClaimsAuthMgr();
            cca.HydrateEDSRoleHashtable();
            CCARoleTranslator = cca.RoleTranslator;
            incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            //the fact that the user is there, means that:
            //..the stp was invoked,
            //..a user was searched for and created

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            Assert.AreEqual(_baseUserData[ClaimTypes.Name] + "_edsUser", u.UserName);
            Assert.AreEqual(_baseUserData[ClaimTypes.PPID], u.CertificateNumber);
            Assert.AreEqual(_baseUserData[ClaimTypes.Email], u.Email);
                        
            //check that the user is marked with multiple locations
            Assert.IsTrue(u.HasMultipleBuildings);
        
            //he should have two locations over all
            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seUserDistrictSchool where seUserId = {0}"
                    , u.Id))
            };
            Assert.AreEqual(2, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        
            //the eval record is such a big deal and so problematic, we'll just check it for fun.
            //in this case, user is from only one districtCode, so expect one seEvaluation record
            Dictionary <string, string> s2d = Fixture.SEMgr.HydrateSchool2DistrictIfNecessary();
            string districtCode = s2d["3010"];
                        
            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} and districtcode='{2}'"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION), districtCode))
            };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        

        }

        [Test]
        public void CCAM_AuthProcessShouldNotCreateNewUserWhenUserIsKnown()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
                
            };
            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr cca = new CustomClaimsAuthMgr();
            cca.HydrateEDSRoleHashtable();
            CCARoleTranslator = cca.RoleTranslator;
            incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            long firstSeenId = u.Id;

            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            Assert.AreEqual(firstSeenId, u.Id);
        }

        [Test]
        public void CCAM_AuthProcessWillChangeBaseUserDataIfNecessary()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
                
            };

            CustomClaimsAuthMgr cca = new CustomClaimsAuthMgr();
            cca.HydrateEDSRoleHashtable();
            CCARoleTranslator = cca.RoleTranslator;
            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            string firstSeenEmail = u.Email;

            Dictionary<string, string> NewData = _baseUserData;

            NewData[ClaimTypes.Email] = "someEmailNotFleeble@flooble.com";
            incomingClaims = GenerateToken(NewData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            u = Fixture.SEMgr.SEUserFromEDSPersonId(NewData[ClaimTypes.Name]);
            Assert.AreNotEqual(firstSeenEmail, u.Email);
            Assert.AreEqual("someEmailNotFleeble@flooble.com",u.Email);

        }

        [Test]
        public void CCAM_ChangingHomeDistrictGivesUserNewEvaluationRecord()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
            };

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();
            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            roleData = new Dictionary<string, List<string>>()
            {
                {"Scootney Springs Elementary;3730",  new List<string>(){ EdsIdentity.RoleSchoolTeacher}}
            };

            incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("134");

            List<string> roles = u.Roles("SE");
            Assert.AreEqual(1, roles.Count);
            Assert.AreEqual("3730", u.SchoolCode);
            Assert.IsFalse(roles.Contains(UserRole.SESchoolPrincipal));
            Assert.IsTrue(roles.Contains(UserRole.SESchoolTeacher));

            //check for an additional evaluation record, and one for othello, one for north thurston
            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select districtCode from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1}"
                    , u.Id, Convert.ToInt16(SEEvaluationType.TEACHER_OBSERVATION)))
            };
            Assert.AreEqual("01147", (string)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select districtCode from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1}"
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION)))
            };
            Assert.AreEqual("34003", (string)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

        }

        [Test]
        public void CCAM_AuthProcessShouldRecognizeOldPersonIdentifier()
        {
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal}},
                {"South Bay Elementary;2754",  new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin}}
                
            };
            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr cca = new CustomClaimsAuthMgr();
            cca.HydrateEDSRoleHashtable();
            CCARoleTranslator = cca.RoleTranslator;
            incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            long firstSeenId = u.Id;

            incomingClaims = GenerateToken(_baseUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            Assert.AreEqual(firstSeenId, u.Id);


            //give him a new personid
            Dictionary<string, string> modifiedUserData = _baseUserData;
            modifiedUserData[ClaimTypes.Name] = "4234";
            modifiedUserData[ClaimTypes.NameIdentifier] = "6;4;36;134;1;4;5;22";

            //and just for fun, give him another schoolCode
            roleData.Add( "Othello High School;3015", new List<string>(){ EdsIdentity.RoleHeadPrincipal, EdsIdentity.RoleSchoolAdmin});

            incomingClaims = GenerateToken(modifiedUserData, roleData);
            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            Assert.IsNull(u);

            u = Fixture.SEMgr.SEUserFromEDSPersonId("4234");

            Assert.AreEqual(firstSeenId, u.Id);
            Assert.AreEqual("4234_edsuser", u.UserName.ToLower());
            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);
        }

        [Test]
        public void CCAM_AuthProcessWillAllowMultDistrictPrincipals()
        {
            //most of the component functionality of the CCAM processing
            // has been tested above.  This function merely verifies the
            // the ccam *components* were called
            Flush();

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010", new List<string>(){ EdsIdentity.RoleHeadPrincipal }},
                {"Scootney Springs Elementary;3730",  new List<string>(){ EdsIdentity.RoleHeadPrincipal,EdsIdentity.RoleSchoolAdmin}}
                
            };
            ClaimsIdentity incomingClaims = GenerateToken(_baseUserData, roleData);

            CustomClaimsAuthMgr cca = new CustomClaimsAuthMgr();
            cca.HydrateEDSRoleHashtable();
            CCARoleTranslator = cca.RoleTranslator;
            incomingClaims = GenerateToken(_baseUserData, roleData);

            Fixture.SEMgr.ProcessClaimsAndSetupUser(CCARoleTranslator, incomingClaims.Claims);

            //the fact that the user is there, means that:
            //..the stp was invoked,
            //..a user was searched for and created

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId(_baseUserData[ClaimTypes.Name]);
            Assert.AreEqual(_baseUserData[ClaimTypes.Name] + "_edsUser", u.UserName);
            Assert.AreEqual(_baseUserData[ClaimTypes.PPID], u.CertificateNumber);
            Assert.AreEqual(_baseUserData[ClaimTypes.Email], u.Email);

            //check that the user is marked with multiple locations
            Assert.IsTrue(u.HasMultipleBuildings);

            //he should have two locations over all
          
            SqlParameter[]aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(*) from seUserDistrictSchool where seUserId = {0}"
                    , u.Id))
            };
            Assert.AreEqual(2, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            //New plan here...multi districtCode users just get an eval record for each districtCode they are in...

            aParams = new SqlParameter[]{
                new SqlParameter ("@pSqlCmd"
                    , String.Format("Select count(distinct districtcode) from seEvaluation where evaluateeID = {0} and evaluationTypeID= {1} "
                    , u.Id, Convert.ToInt16(SEEvaluationType.PRINCIPAL_OBSERVATION)))
            };
            Assert.AreEqual(2, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        [Test]
        public void LRC_VerifyDistrictsPropertyOfLRC()
        {
            StringBuilder sbInput = new StringBuilder();
            sbInput.Append("Othello School District;01147;role1; role2; role3; role1");

            LocalityRoleContainer lrc = new LocalityRoleContainer(sbInput.ToString(), Fixture.SEMgr.HydrateSchool2DistrictIfNecessary());
            Assert.AreEqual(1, lrc.Districts.Count());
            Assert.AreEqual(3, lrc.Roles.Count());
            Assert.IsFalse(lrc.IsMultiDistrict);
            Assert.AreEqual(0, lrc.Schools.Count());
            Assert.AreEqual("01147", lrc.Districts[0]);
            List<string> expectedRoles = new List<string>() { "role1", "role2", "role3" };
            Assert.AreEqual(0, expectedRoles.Except(lrc.Roles).ToList().Count() + lrc.Roles.Except(expectedRoles).ToList().Count());

            sbInput.Append("|Othello High School;3015; role4; role5; role2");
            lrc = new LocalityRoleContainer(sbInput.ToString(), Fixture.SEMgr.HydrateSchool2DistrictIfNecessary());
            Assert.AreEqual(1, lrc.Districts.Count());
            Assert.AreEqual(5, lrc.Roles.Count());
            Assert.IsFalse(lrc.IsMultiDistrict);
            Assert.AreEqual(1, lrc.Schools.Count());
            expectedRoles.Add("role4");
            expectedRoles.Add("role5");
            Assert.AreEqual(0, expectedRoles.Except(lrc.Roles).ToList().Count() + lrc.Roles.Except(expectedRoles).ToList().Count());

            sbInput.Append("|North Thurston High School;3010; role4; role5; role2");
            sbInput.Append("|Sout Bay Elementary;2754; role4; role5; role2");
            lrc = new LocalityRoleContainer(sbInput.ToString(), Fixture.SEMgr.HydrateSchool2DistrictIfNecessary());

            Assert.AreEqual(2, lrc.Districts.Count());
            Assert.AreEqual(5, lrc.Roles.Count());
            Assert.IsTrue(lrc.IsMultiDistrict);
            Assert.AreEqual(3, lrc.Schools.Count());

            Assert.AreEqual(0, expectedRoles.Except(lrc.Roles).ToList().Count() + lrc.Roles.Except(expectedRoles).ToList().Count());


            List<string> expectedSchools = new List<string>() { "3015", "3010", "2754" };
            Assert.AreEqual(0, expectedSchools.Except(lrc.Schools).ToList().Count() + lrc.Schools.Except(expectedSchools).ToList().Count());

            List<string> expectedDistricts = new List<string>(){"34003", "01147"};
            Assert.AreEqual(0, expectedDistricts.Except(lrc.Districts).ToList().Count() + lrc.Districts.Except(expectedDistricts).ToList().Count());


        }

        [Test]
        public void STP__NewUserWithNoPreviousPersonIDDoesNotExcept()
        {
            Flush();

            Dictionary<string, string> myUserData = new Dictionary<string, string>()
                    {
                        {ClaimTypes.Name, "134"},       //personId
                        {ClaimTypes.GivenName, "Public, John Q."},
                        {ClaimTypes.Email, "fleeble@flooble.com"},
                        {ClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        //{ClaimTypes.NameIdentifier,""},     //previous personIds... exclude this
                        {ClaimTypes.PPID,"28-48492C"}        //cert number
                    };

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);



        }

        [Test]
        public void STP__NewUserWithNoEmailDoesNotExcept()
        {
            Flush();

            Dictionary<string, string> myUserData = new Dictionary<string, string>()
                    {
                        {ClaimTypes.Name, "134"},       //personId
                        {ClaimTypes.GivenName, "Public, John Q."},
                        //{ClaimTypes.Email, "fleeble@flooble.com"},
                        {ClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {ClaimTypes.NameIdentifier,""},     //previous personIds... exclude this
                        {ClaimTypes.PPID,"28-48492C"}        //cert number
                    };

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);



        }

        [Test]
        public void STP__NewUserWithNoSIDDoesNotExcept()
        {
            Flush();

            Dictionary<string, string> myUserData = new Dictionary<string, string>()
                    {
                        {ClaimTypes.Name, "134"},       //personId
                        {ClaimTypes.GivenName, "Public, John Q."},
                        {ClaimTypes.Email, "fleeble@flooble.com"},
                        //{ClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {ClaimTypes.NameIdentifier,""},     //previous personIds... exclude this
                        {ClaimTypes.PPID,"28-48492C"}        //cert number
                    };

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);
        }

        [Test]
        public void STP__NewUserWithNoCertNumberDoesNotExcept()
        {
            Flush();

            Dictionary<string, string> myUserData = new Dictionary<string, string>()
                    {
                        {ClaimTypes.Name, "134"},       //personId
                        {ClaimTypes.GivenName, "Public, John Q."},
                        {ClaimTypes.Email, "fleeble@flooble.com"},
                        {ClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {ClaimTypes.NameIdentifier,""},     //previous personIds... exclude this
                        //{ClaimTypes.PPID,"28-48492C"}        //cert number
                    };

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("John Q.", u.FirstName);
            Assert.AreEqual("Public", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("", u.CertificateNumber);



        }
        [Test]
        public void STP__NewUserWithNoGivenNameDoesNotExcept()
        {
            Flush();

            Dictionary<string, string> myUserData = new Dictionary<string, string>()
                    {
                        {ClaimTypes.Name, "134"},       //personId
                        //{ClaimTypes.GivenName, ""},
                        {ClaimTypes.Email, "fleeble@flooble.com"},
                        {ClaimTypes.Sid, "Ar3948"},       //unique return identifier
                        {ClaimTypes.NameIdentifier,""},     //previous personIds... exclude this
                        {ClaimTypes.PPID,"28-48492C"}        //cert number
                    };

            Dictionary<string, List<string>> roleData = new Dictionary<string, List<string>>()
            {
                {"North Thurston High School;3010;", new List<string>(){ "eValSchoolTeacher"}}
            };

            ClaimsIdentity incomingClaims = GenerateToken(myUserData, roleData);

            CustomClaimsAuthMgr ccam = new CustomClaimsAuthMgr();
            ccam.HydrateEDSRoleHashtable();

            Fixture.SEMgr.ProcessClaimsAndSetupUser(ccam.RoleTranslator, incomingClaims.Claims);

            SEUser u = Fixture.SEMgr.SearchForSEUser("134", "");

            Assert.AreEqual("", u.FirstName);
            Assert.AreEqual("", u.LastName);
            Assert.AreEqual("fleeble@flooble.com", u.Email);
            Assert.AreEqual("28-48492C", u.CertificateNumber);



        }
    

    
    }
}