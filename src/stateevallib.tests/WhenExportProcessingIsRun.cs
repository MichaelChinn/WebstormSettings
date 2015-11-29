using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using System.Xml;
using System.Xml.Schema;
using System.Linq;

using StateEval;
using StateEval.Security;

using EDSIntegrationLib;

using NUnit.Framework;


namespace StateEval.tests
{

    public static class TestUtils
    {
        public static string GetCSStringFromList<T>(List<T> items)
        {
            StringBuilder sbRetVal = new StringBuilder();
            foreach (T item in items)
            {
                sbRetVal.Append("," + item.ToString());
            }
            if (sbRetVal.Length > 0)
                sbRetVal.Remove(0, 1);
            return sbRetVal.ToString();
        }
        public static List<string> UserNameList(List<int>PersonIds)
        {
            List<string> retVal = new List<string>();
            retVal.Add("'boobity'");
            foreach (int personid in PersonIds)
            {
                retVal.Add("'" + personid.ToString() + "_edsUser'");
            }
            return retVal;
        }
        public static List<T> GetListOfItemsFromDB<T>(T firstItem, string columnName, string sqlCmd)
        {
            SqlDataReader r = Fixture.SEMgr.DbConnector.ExecuteNonSpDataReader(sqlCmd);

            List<T> retVal = new List<T>();
            retVal.Add(firstItem);

            while (r.Read())
            {
                retVal.Add((T)r[columnName]);
            }

            r.Close();

            return retVal;

        }
        public static List<long> UserIdsForTest(List<int>PersonIds)
        {
            string sqlCmd = "select seUserId from seuser where username in (" + GetCSStringFromList<string>(UserNameList(PersonIds)) + ")";
            return GetListOfItemsFromDB<long>(0, "seUserId", sqlCmd);
        }
        public static List<long> EvaluationIdsForTest(List<int> PersonIds)
        {
            string sqlCmd = "select EvaluationId from SEEvaluation where Evaluateeid in  (" + GetCSStringFromList<long>(UserIdsForTest(PersonIds)) + ")";
            return GetListOfItemsFromDB<long>(0, "EvaluationId", sqlCmd);
        }
        public static List<long> EvalSessionIdsForTest(List<int> PersonIds)
        {
            string sqlCmd = "select EvalSessionid from SEEvalSession where EvaluateeUserid in  (" + GetCSStringFromList<long>(UserIdsForTest(PersonIds)) + ")";
            return GetListOfItemsFromDB<long>(0, "EvalSessionId", sqlCmd);
        }
        public static List<string> UserIdGuidsForTest(List<int> PersonIds)
        {
            string sqlCmd = "select aspnetUserid from seuser where seUserid in (" + GetCSStringFromList<long>(UserIdsForTest(PersonIds)) + ")";
            SqlDataReader r = Fixture.SEMgr.DbConnector.ExecuteNonSpDataReader(sqlCmd);
            List<string> retVal = new List<string>();
            retVal.Add("'" + new Guid("00000000-0000-0000-0000-000000000000") + "'");

            while (r.Read())
            {
                retVal.Add("'" + (Guid)r["aspnetUserid"] + "'");
            }

            r.Close();

            return retVal;
        }
        public static void FlushWhereIn(string tableName, string identifier, string values)
        {
            string sqlCmd = String.Format("delete {0} where {1} in ({2})", tableName, identifier, values);
            Fixture.SEMgrExecute(sqlCmd);
        }
        public static void FlushTable(string tableName)
        {
            string sqlCmd = String.Format("delete {0}", tableName);
            Fixture.SEMgrExecute(sqlCmd);
        }
    }
    
    public class EDSUser 
    {
        public string PersonId { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Email { get; set; }
        public string EmailAddressAlternate { get; set; }
        public string PreviousPersonId { get; set; }
        public string LoginName { get; set; }
        public string CertNumber { get; set; }
        public List<EDSLR> LocRoles{get;set;}
        public EDSUser() { }

        public void Init(List<string>initialValues)
        {
            PersonId = initialValues[0];
            LastName = initialValues[2];
            FirstName = initialValues[3];
            Email = initialValues[3];
            PreviousPersonId = initialValues[4];
            LoginName = initialValues[5];
            EmailAddressAlternate = initialValues[6];
            CertNumber = initialValues[7];
        }
        public string SQL
        {
            get
            {
                return String.Format("insert edsUsersv1 (personid, firstname, lastname, email"
                            +", previouspersonid, loginname, emailAddressAlternate, certificateNumber) "
                            + "values ({0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}')",
                            PersonId, FirstName, LastName, Email, PreviousPersonId, LoginName, EmailAddressAlternate, CertNumber);
                
            }
        }
    }
    public class EDSLR
    {
        public string PersonId { get; set; }
        public string OrganizationName { get; set; }
        public string OSPILegacyCode { get; set; }
        public string OrganizationRoleName { get; set; }
        public List<string> RolesList { get; set; }
        public EDSLR() { }
        public void Init (List<string> initialValues)
        {
            PersonId = initialValues[0];
            OrganizationName = initialValues[1];
            OSPILegacyCode = initialValues[2];
            //OrganizationRoleName = initialValues[3];

            RolesList = new List<string>();
            for (int i=3; i< initialValues.Count; i++)
            {
                RolesList.Add(initialValues[i]);
            }

            OrganizationRoleName = TestUtils.GetCSStringFromList<string>(RolesList);

        }

        public string SQL
        {
            get
            {
                string roleString = TestUtils.GetCSStringFromList<string>(RolesList);
                return String.Format("insert edsRolesv1 (personId, organizationName, ospiLegacyCode, organizationRoleName) "
                              + "values ({0},'{1}', '{2}','{3}')",
                              PersonId, OrganizationName, OSPILegacyCode, roleString);
            }
        }
    }
 
    [TestFixture]
    public class WhenExportProcessingIsRun
    {

        [TearDown]
        public void TearDown()
        {
            Fixture f = new Fixture();
            f.Cleanup();
        }

        [SetUp]
        public void Init()
        {
            Fixture f = new Fixture();
            f.Init();
            RoleX = new Dictionary<string, string>();
            InitRoleX();
        }

        public Dictionary<string, string> RoleX { get; set; }
       
        public void InitRoleX()
        {
            if (!RoleX.ContainsKey(EdsIdentity.RoleSuperAdmin)) RoleX.Add(EdsIdentity.RoleSuperAdmin, UserRole.SESuperAdmin);
            if (!RoleX.ContainsKey(EdsIdentity.RoleStateAdmin)) RoleX.Add(EdsIdentity.RoleStateAdmin, UserRole.SEStateAdmin);

            if (!RoleX.ContainsKey(EdsIdentity.RoleDistrictAdmin)) RoleX.Add(EdsIdentity.RoleDistrictAdmin, UserRole.SEDistrictAdmin);
            if (!RoleX.ContainsKey(EdsIdentity.RoleDistrictEvaluator)) RoleX.Add(EdsIdentity.RoleDistrictEvaluator, UserRole.SEDistrictEvaluator);
            if (!RoleX.ContainsKey(EdsIdentity.RoleDistrictTeacherEvaluator)) RoleX.Add(EdsIdentity.RoleDistrictTeacherEvaluator, UserRole.SEDistrictWideTeacherEvaluator);

            if (!RoleX.ContainsKey(EdsIdentity.RoleSchoolAdmin)) RoleX.Add(EdsIdentity.RoleSchoolAdmin, UserRole.SESchoolAdmin);
            if (!RoleX.ContainsKey(EdsIdentity.RoleHeadPrincipal)) RoleX.Add(EdsIdentity.RoleHeadPrincipal, UserRole.SESchoolHeadPrincipal);
            if (!RoleX.ContainsKey(EdsIdentity.RoleSchoolPrincipal)) RoleX.Add(EdsIdentity.RoleSchoolPrincipal, UserRole.SESchoolPrincipal);

            if (!RoleX.ContainsKey(EdsIdentity.RoleSchoolTeacher)) RoleX.Add(EdsIdentity.RoleSchoolTeacher, UserRole.SESchoolTeacher);
            if (!RoleX.ContainsKey(EdsIdentity.RoleDistrictViewer)) RoleX.Add(EdsIdentity.RoleDistrictViewer, UserRole.SEDistrictViewer);
            if (!RoleX.ContainsKey(EdsIdentity.RoleDistrictAssignmentManager)) RoleX.Add(EdsIdentity.RoleDistrictAssignmentManager, UserRole.SEDistrictAssignmentManager);

        }
        
        
        List<int> PersonIds = new List<int>
            {
                141,
                145,
                169,
                172,
                179,
                190,
                192
            };

        public List<EDSUser> InitializeEDSUserList(List<List<string>> initialData)
        {
            List<EDSUser> retVal = new List<EDSUser>();

            foreach (List<string> initItem in initialData)
            {
                EDSUser item = new EDSUser();
                item.Init(initItem);
                retVal.Add(item);
            }

            return retVal;
        }
        public List<EDSLR> InitializeEDSLRList(List<List<string>> initialData)
        {
            List<EDSLR> retVal = new List<EDSLR>();

            foreach (List<string> initItem in initialData)
            {
                EDSLR item = new EDSLR();
                item.Init(initItem);
                retVal.Add(item);
            }

            return retVal;
        }


        List<EDSUser> InitEDSExportTables(List<List<string>> userTestData, List<List<string>> roleTestData)
        {

            TestUtils.FlushTable("EDSUsersV1");
            TestUtils.FlushTable("EDSRolesV1");


            List<EDSUser> edsUsers = InitializeEDSUserList(userTestData);
            List<EDSLR> locRoles = InitializeEDSLRList(roleTestData);

            foreach (EDSUser user in edsUsers)
            {
                Fixture.SEMgrExecute(user.SQL);
            }
            foreach (EDSLR r in locRoles)
            {
                Fixture.SEMgrExecute(r.SQL);
            }

            Fixture.SEMgrExecute("exec dbo.ProcessOSPIUserExport");

            foreach (EDSUser user in edsUsers)
            {
                user.LocRoles = locRoles.Where(item => item.PersonId == user.PersonId).ToList();

            }
            return edsUsers;
        }

        void AssertUserHasRole(SEUser u, string seUserRole)
        {   
            List<string> roles = u.Roles("SE");
            Assert.IsTrue(roles.Contains(seUserRole));
        }
        void AssertUserHasNRoles(SEUser u, int n)
        {
            List<string> roles = u.Roles("SE");
            Assert.AreEqual(n, roles.Count);
        }
        void AssertUserHasNLocations(SEUser u, int n)
        {
            Assert.AreEqual(n, u.LocationRoles.Localities.Count);
        }
        void AssertUserHasLocation(SEUser u, string CDSCode)
        {
            Assert.IsTrue(u.LocationRoles.Localities.Contains(CDSCode));
        }

        void AssertEDSUserIsAbsent(string userName)
        {/*
                DELETE  dbo.aspnet_usersInRoles       
                DELETE  seUserDistrictSchool
          * 
          * anne says to leave these alone:
                 dbo.aspnet_membership      
                 dbo.aspnet_Profile       
                 dbo.aspnet_users     
                 dbo.seUser leave aspnetUserID, userName
                
            */

            //keeping records in profile, membership, aspnet_users, seUsers
            SEUser u = (SEUser)Fixture.SEMgr.SEUser(userName);
            Assert.AreEqual(userName.ToLower(), u.UserName.ToLower());

            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count(*) from aspnet_users where username =  '" + userName + "'") };
            int count = (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GEtOneOff", aParams);
            Assert.AreEqual(1, count);

            //membership
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count(*) from aspnet_membership m join aspnet_Users u on u.userid = m.userid where userName = '" + userName + "'") };
            Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            //aspnet_userId... this should be here, else you wouldn't get a user, but what the heck...
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select aspnetuserId from seUser where UserName = '" + userName + "'") };
            Guid guid = (Guid)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams);
            Assert.IsNotNull(guid);

            //profile may or may not be there, so this is commented out
            //aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count(*) from profile m join aspnet_Users user on user.userid = m.userid where userName = '" + userName + "'") };
            //Assert.AreEqual(1, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));


            //no roles or locations for him.
            //roles
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count(*) from aspnet_usersInRoles uir join aspnet_users u on u.userid = uir.userid where userName = '" + userName + "'") };
            Assert.AreEqual(0, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

            //seUserDistrictSchool
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count(*) from seUserDistrictSchool uds join seUser su on su.seUserid = uds.seUserId where userName = '" + userName + "'") };
            Assert.AreEqual(0, (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

        
        
        
        private void VerifyData(List<EDSUser> edsUsers, int expectedNUsers)
        {
            int nUsers = 0;
            foreach (EDSUser eu in edsUsers)
            {
                SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId(eu.PersonId);
                if (eu.LocRoles.Count==0)
                {
                    Assert.IsNull(u);
                    continue;
                }
                AssertUserHasNLocations(u, eu.LocRoles.Count);
                nUsers++;
                foreach (var locRol in eu.LocRoles)
                {
                    AssertUserHasLocation(u, locRol.OSPILegacyCode);

                    foreach (string role in locRol.RolesList)
                    {
                        AssertUserHasRole(u, RoleX[role]);
                    }

                    //adjust the expected roles count
                    int nRolesExpected = locRol.RolesList.Count;

                    AssertUserHasNRoles(u, nRolesExpected);
                }

                
            }
            Assert.AreEqual(expectedNUsers, nUsers);
        }
        private void VerifyEDSError(string edsPersonId, string ErrorCodeExpected)
        {
            string sqlCmd =String.Format("select stagingid from edsError where Personid = {0} and errorMsg like '{1}%'", edsPersonId, ErrorCodeExpected);
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", sqlCmd) };
            long stagingId = (long)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams);

            Assert.IsNotNull(stagingId);
        }
        private List<EDSUser> DoTest(List<List<string>> UserTestData, List<List<string>> RoleTestData)
        {
            List<EDSUser> edsUsers = InitEDSExportTables(UserTestData, RoleTestData);
            return edsUsers;
        }

        [Test]
        public void VerifyRolesForUsersInSingleLocation()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 
                new List<string>() {"169","KAREN","ANASTASIO","karen.anastasio@bellinghamschools.org","457848","karen.anastasio@bellinghamschools.org","","358861C"}, 
                new List<string>() {"172","JASON","SCOTT","Jason_L_Scott@hotmail.com","","Jason.Scott@evergreenps.org","","494635F"}, 
                new List<string>() {"179","David","Shockley","DShockley@bisd303.org","","DShockley@bisd303.org","",""}, 
                new List<string>() {"190","Joshua","Cowart","josh.cowart@mead354.org","787606","josh.cowart@mead354.org","","464359R"}, 
                new List<string>() {"192","Ian","Manheimer","imanheimer06@comcast.net","","Ian.Manheimer@vansd.org","","428249G"},
                new List<string>() {"194","Michael","Chinn","chnn.michael@gmail.com","233404","chnn.michael@gmail.com","","433359R"}, 
                new List<string>() {"196","Jason","Manheimer","chnn.michael@gmail.com","","chnn.michael@gmail.com","","233333G"}
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolTeacher"},
                new List<string>(){"145","South Bay Elementary", "2754","eValSchoolAdmin"},
                new List<string>(){"169","South Bay Elementary", "2754","eValSchoolPrincipal"},
                new List<string>(){"172","South Bay Elementary", "2754","eValHeadPrincipal"},
                new List<string>(){"179","North Thurston Public Schools", "34003","eValDistrictTeacherEvaluator"},
                new List<string>(){"190","North Thurston Public Schools", "34003","eValDistrictEvaluator"},
                new List<string>(){"192","North Thurston Public Schools", "34003","eValDistrictAdmin"},
                new List<string>(){"194","North Thurston Public Schools", "34003","eValDistrictViewer"},
                new List<string>(){"196","North Thurston Public Schools", "34003","eValDistrictAssignmentManager"}
            };
            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyData(edsUsers,9);
        }
        [Test]
        public void VerifyForRoleTeacherInSingleLocation()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolTeacher"},
            };
            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyData(edsUsers, 1);
        }
        [Test]
        public void VerifyRoleForTeacherInMultipleSchoolsInDistrict()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolTeacher"},
                new List<string>(){"141","North Thurston High School", "3010","eValSchoolTeacher"},
            };
            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyData(edsUsers, 1);
        }
        [Test]
        public void VerifyDistrictRoleInSchoolErrorCondition()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValDistrictEvaluator"},
                //new List<string>(){"141","North Thurston High School", "3010","eValSchoolTeacher"},
            };

            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyEDSError("141", "DRSCH");
        }
        [Test]
        public void VerifySchoolRoleInDistrictErrorCondition()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","North Thurston Public Schools", "34003","eValSchoolTeacher"}
            };

            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyEDSError("141",  "SRDST");
        }
        [Test]
        public void VerifyUnknownLocationErrorCondition()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","SomeRandomSchool", "1000","eValSchoolTeacher"}
            };

            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyEDSError("141", "UNKLOC");
        }
        [Test]
        public void VerifyINCROLErrorCondition()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolPrincipal"},
                new List<string>(){"141","North Thurston High School", "3010","eValSchoolTeacher"},
            };

            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyEDSError("141", "INCROL");
        }
        [Test]
        public void VerifyUnionizingOfRoles()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
     
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolAdmin", EdsIdentity.RoleSchoolPrincipal},
                new List<string>(){"141","North Thurston High School", "3010","eValSchoolAdmin"},

            };
            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);

            //can't just iterate through the user's array here.

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId(edsUsers[0].PersonId);

            List<string> roles = u.Roles("SE");
            Assert.AreEqual(2, roles.Count);
            Assert.IsTrue(roles.Contains(UserRole.SESchoolAdmin));
            Assert.IsTrue(roles.Contains(UserRole.SESchoolPrincipal));



        }
        [Test]
        public void VerifyMultiLocationUserHome()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 
                new List<string>() {"169","KAREN","ANASTASIO","karen.anastasio@bellinghamschools.org","457848","karen.anastasio@bellinghamschools.org","","358861C"}, 
                new List<string>() {"172","JASON","SCOTT","Jason_L_Scott@hotmail.com","","Jason.Scott@evergreenps.org","","494635F"}, 
                new List<string>() {"179","David","Shockley","DShockley@bisd303.org","","DShockley@bisd303.org","",""}, 
                new List<string>() {"190","Joshua","Cowart","josh.cowart@mead354.org","787606","josh.cowart@mead354.org","","464359R"}, 
                new List<string>() {"192","Ian","Manheimer","imanheimer06@comcast.net","","Ian.Manheimer@vansd.org","","428249G"}
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolAdmin"},
                new List<string>(){"141","Othello High School", "3015","eValSchoolAdmin"},
                new List<string>(){"141","North Thurston High School", "3010","eValSchoolAdmin"},
                new List<string>(){"141","Scootney Springs Elementary", "3730","eValSchoolAdmin"},
                new List<string>(){"145","Scootney Springs Elementary", "3730","eValSchoolAdmin"}

            };
            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyData(edsUsers, 2);
        }
        [Test]
        public void VerifySingleEvlRecordForMultiLocationUser()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 
                new List<string>() {"169","KAREN","ANASTASIO","karen.anastasio@bellinghamschools.org","457848","karen.anastasio@bellinghamschools.org","","358861C"}, 
                new List<string>() {"172","JASON","SCOTT","Jason_L_Scott@hotmail.com","","Jason.Scott@evergreenps.org","","494635F"}, 
                new List<string>() {"179","David","Shockley","DShockley@bisd303.org","","DShockley@bisd303.org","",""}, 
                new List<string>() {"190","Joshua","Cowart","josh.cowart@mead354.org","787606","josh.cowart@mead354.org","","464359R"}, 
                new List<string>() {"192","Ian","Manheimer","imanheimer06@comcast.net","","Ian.Manheimer@vansd.org","","428249G"}
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolAdmin"},
                new List<string>(){"141","Othello High School", "3015","eValSchoolAdmin","eValSchoolPrincipal"},
                new List<string>(){"141","North Thurston High School", "3010","eValSchoolAdmin","eValSchoolPrincipal"},
                new List<string>(){"141","Scootney Springs Elementary", "3730","eValSchoolAdmin"},
                new List<string>(){"145","North Thurston High School", "3010","eValSchoolAdmin","eValSchoolPrincipal"},
                
            };
            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);

            SEUser u = Fixture.SEMgr.SEUserFromEDSPersonId("141");
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count (*) from seevaluation where evaluateeId = " + u.Id.ToString()) };
            int evalCount = (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams);
            Assert.AreEqual(1, evalCount);
        }      
        [Test]
        public void VerifyUpdateItems()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
                                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 


            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolPrincipal"},
               new List<string>(){"145","South Bay Elementary", "2754","eValSchoolTeacher"},
            };

            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);


            /**/

            UserTestData = new List<List<string>>() {
                new List<string>() {"141","boggy","smythe","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 
            };

            RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolPrincipal", "eValSchoolAdmin"},
               new List<string>(){"145","South Bay Elementary", "2754","eValSchoolTeacher"},
            };

            edsUsers = InitEDSExportTables(UserTestData, RoleTestData);
            VerifyData(edsUsers, 2);

        }
        [Test]
        public void VerifyUserRemovalAndReAdd()
        {
            List<List<string>> UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 
                new List<string>() {"169","KAREN","ANASTASIO","karen.anastasio@bellinghamschools.org","457848","karen.anastasio@bellinghamschools.org","","358861C"}, 
                new List<string>() {"172","JASON","SCOTT","Jason_L_Scott@hotmail.com","","Jason.Scott@evergreenps.org","","494635F"}, 
                new List<string>() {"179","David","Shockley","DShockley@bisd303.org","","DShockley@bisd303.org","",""}, 
                new List<string>() {"190","Joshua","Cowart","josh.cowart@mead354.org","787606","josh.cowart@mead354.org","","464359R"}, 
                new List<string>() {"192","Ian","Manheimer","imanheimer06@comcast.net","","Ian.Manheimer@vansd.org","","428249G"}
            };

            List<List<string>> RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolTeacher"},
                new List<string>(){"145","South Bay Elementary", "2754","eValSchoolAdmin"},
                new List<string>(){"169","South Bay Elementary", "2754","eValSchoolPrincipal"},
                new List<string>(){"172","South Bay Elementary", "2754","eValHeadPrincipal"},
                new List<string>(){"179","North Thurston Public Schools", "34003","eValDistrictTeacherEvaluator"},
                new List<string>(){"190","North Thurston Public Schools", "34003","eValDistrictEvaluator"},
                new List<string>(){"192","North Thurston Public Schools", "34003","eValDistrictAdmin"}
            };
            List<EDSUser> edsUsers = DoTest(UserTestData, RoleTestData);
            VerifyData(edsUsers, 7);



            /**/
            UserTestData = new List<List<string>>() {
                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 
                new List<string>() {"169","KAREN","ANASTASIO","karen.anastasio@bellinghamschools.org","457848","karen.anastasio@bellinghamschools.org","","358861C"}, 
                new List<string>() {"172","JASON","SCOTT","Jason_L_Scott@hotmail.com","","Jason.Scott@evergreenps.org","","494635F"}, 
                new List<string>() {"179","David","Shockley","DShockley@bisd303.org","","DShockley@bisd303.org","",""}, 
                new List<string>() {"190","Joshua","Cowart","josh.cowart@mead354.org","787606","josh.cowart@mead354.org","","464359R"}, 
                new List<string>() {"192","Ian","Manheimer","imanheimer06@comcast.net","","Ian.Manheimer@vansd.org","","428249G"}
            };

            RoleTestData = new List<List<string>>() {
                new List<string>(){"145","South Bay Elementary", "2754","eValSchoolAdmin"},
                new List<string>(){"169","South Bay Elementary", "2754","eValSchoolPrincipal"},
                new List<string>(){"172","South Bay Elementary", "2754","eValHeadPrincipal"},
                new List<string>(){"179","North Thurston Public Schools", "34003","eValDistrictTeacherEvaluator"},
                new List<string>(){"190","North Thurston Public Schools", "34003","eValDistrictEvaluator"},
                new List<string>(){"192","North Thurston Public Schools", "34003","eValDistrictAdmin"}
            };

            edsUsers = InitEDSExportTables(UserTestData, RoleTestData);
            VerifyData(edsUsers, 6);

            AssertEDSUserIsAbsent("141_edsUser");

            /***/
            UserTestData = new List<List<string>>() {
                new List<string>() {"141","LAWRENCE","BERG","lberg@lopez.k12.wa.us","775467","lberg@lopez.k12.wa.us","","258758B"},
                new List<string>() {"145","PATRICIA","BROWN","tbrown4@nsd.org","530945","tbrown4@nsd.org","","331327G"}, 
                new List<string>() {"169","KAREN","ANASTASIO","karen.anastasio@bellinghamschools.org","457848","karen.anastasio@bellinghamschools.org","","358861C"}, 
                new List<string>() {"172","JASON","SCOTT","Jason_L_Scott@hotmail.com","","Jason.Scott@evergreenps.org","","494635F"}, 
                new List<string>() {"179","David","Shockley","DShockley@bisd303.org","","DShockley@bisd303.org","",""}, 
                new List<string>() {"190","Joshua","Cowart","josh.cowart@mead354.org","787606","josh.cowart@mead354.org","","464359R"}, 
                new List<string>() {"192","Ian","Manheimer","imanheimer06@comcast.net","","Ian.Manheimer@vansd.org","","428249G"}
            };

            RoleTestData = new List<List<string>>() {
                new List<string>(){"141","South Bay Elementary", "2754","eValSchoolTeacher"},
                new List<string>(){"145","South Bay Elementary", "2754","eValSchoolAdmin"},
                new List<string>(){"169","South Bay Elementary", "2754","eValSchoolPrincipal"},
                new List<string>(){"172","South Bay Elementary", "2754","eValHeadPrincipal"},
                new List<string>(){"179","North Thurston Public Schools", "34003","eValDistrictTeacherEvaluator"},
                new List<string>(){"190","North Thurston Public Schools", "34003","eValDistrictEvaluator"},
                new List<string>(){"192","North Thurston Public Schools", "34003","eValDistrictAdmin"}
            };


            edsUsers = InitEDSExportTables(UserTestData, RoleTestData);
            VerifyData(edsUsers, 7);

        
        }

        [Test]
        public void VerifyLRCSmokeTest()
        {
            LocalityRoleContainer lrc = new LocalityRoleContainer("South Bay Elementary;2754;CSSchoolAdvisorR;CSSchoolAdvisorW", Fixture.SEMgr.HydrateSchool2DistrictIfNecessary());

            Assert.IsFalse(lrc.IsSchool("XXXX"));
            Assert.IsTrue(lrc.LooksLikeSchool("XXXX"));
            Assert.IsFalse(lrc.LooksLikeSchool("XXXXX"));
            Assert.AreEqual(lrc.DistrictCodeFor("XXXX"), lrc.BogusDistrict);

            Assert.IsTrue(lrc.IsSchool("2754"));
            Assert.AreEqual(lrc.DistrictCodeFor("2754"), "34003");

            Assert.AreEqual("South Bay Elementary;2754;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.ToString());
            Assert.AreEqual("South Bay Elementary;2754;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.RolesAtString("2754"));
            Assert.AreEqual("South Bay Elementary", lrc.OrgNameOf("2754"));
            Assert.AreEqual(1, lrc.Localities.Count);

            Assert.AreEqual(2, lrc.htRolesAt("2754").Count);
            Assert.IsTrue(lrc.htRolesAt("2754").ContainsKey("CSSchoolAdvisorR"));
            Assert.IsTrue(lrc.htRolesAt("2754").ContainsKey("CSSchoolAdvisorW"));

            Assert.AreEqual(2, lrc.RolesAtList("2754").Count);
            Assert.AreEqual(lrc.RolesAtList("2754")[0], "CSSchoolAdvisorR");
            Assert.AreEqual(lrc.RolesAtList("2754")[1], "CSSchoolAdvisorW");


            lrc = new LocalityRoleContainer("South Bay Elementary;2754;CSSchoolAdvisorR;CSSchoolAdvisorW"
                    + "|North Thurston High School;3010;CSSchoolPrincipal;CSSchoolAdvisorM;CSSchoolAdvisorR;CSSchoolAdvisorW"
                    , Fixture.SEMgr.HydrateSchool2DistrictIfNecessary());

            Assert.AreEqual("South Bay Elementary;2754;CSSchoolAdvisorR;CSSchoolAdvisorW"
                    + "|North Thurston High School;3010;CSSchoolPrincipal;CSSchoolAdvisorM;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.ToString());

            Assert.AreEqual(2, lrc.Localities.Count);


            Assert.AreEqual("South Bay Elementary;2754;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.RolesAtString("2754"));
            Assert.AreEqual("South Bay Elementary", lrc.OrgNameOf("2754"));

            Assert.AreEqual(2, lrc.htRolesAt("2754").Count);
            Assert.IsTrue(lrc.htRolesAt("2754").ContainsKey("CSSchoolAdvisorR"));
            Assert.IsTrue(lrc.htRolesAt("2754").ContainsKey("CSSchoolAdvisorW"));

            Assert.AreEqual(2, lrc.RolesAtList("2754").Count);
            Assert.AreEqual(lrc.RolesAtList("2754")[0], "CSSchoolAdvisorR");
            Assert.AreEqual(lrc.RolesAtList("2754")[1], "CSSchoolAdvisorW");


            Assert.AreEqual("North Thurston High School;3010;CSSchoolPrincipal;CSSchoolAdvisorM;CSSchoolAdvisorR;CSSchoolAdvisorW", lrc.RolesAtString("3010"));
            Assert.AreEqual("North Thurston High School", lrc.OrgNameOf("3010"));
            Assert.AreEqual(2, lrc.Localities.Count);

            Assert.AreEqual(4, lrc.htRolesAt("3010").Count);
            Assert.IsTrue(lrc.htRolesAt("3010").ContainsKey("CSSchoolPrincipal"));
            Assert.IsTrue(lrc.htRolesAt("3010").ContainsKey("CSSchoolAdvisorM"));
            Assert.IsTrue(lrc.htRolesAt("3010").ContainsKey("CSSchoolAdvisorR"));
            Assert.IsTrue(lrc.htRolesAt("3010").ContainsKey("CSSchoolAdvisorW"));

            Assert.AreEqual(4, lrc.RolesAtList("3010").Count);
            Assert.AreEqual(lrc.RolesAtList("3010")[0], "CSSchoolPrincipal");
            Assert.AreEqual(lrc.RolesAtList("3010")[1], "CSSchoolAdvisorM");
            Assert.AreEqual(lrc.RolesAtList("3010")[2], "CSSchoolAdvisorR");
            Assert.AreEqual(lrc.RolesAtList("3010")[3], "CSSchoolAdvisorW");

        }


    
    
    }
}
