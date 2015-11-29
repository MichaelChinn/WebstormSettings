using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using System.Xml;
using System.Xml.Schema;

using StateEval;
using StateEval.Security;

using EDSIntegrationLib;


using Microsoft.IdentityModel.Claims;
using Microsoft.IdentityModel.Configuration;
using Microsoft.IdentityModel.Protocols.WSTrust;
using Microsoft.IdentityModel.SecurityTokenService;


using NUnit.Framework;

namespace StateEval.tests
{
    [TestFixture]
    class tEDSUserSync:tBase
    {
        /*******************************************************************************************/
        /*******************************************************************************************/
        /*******************************************************************************************/
        /*
         * Rather than deriving form tBase, which has a setup and teardown using transaction rollbacks,
         * I discovered this test doesn't like that method of restoration.  So, we do this here for this test
         * alone.  In fact, it works out better this way, as the ss/restore overhead is then only encountered
         * for these tests, rather than the entire suite.
         * 
         */
       /*  
        string SS_SUFFIX = "_snapshot_EDSSync";
        [SetUp]
        public void SetUp()
        {
            SnapshotDB(Fixture.DatabaseName(Fixture._connectionString));
            //SnapshotDB(Fixture.DatabaseName(Fixture._repoConnectionString));
        }

        [TearDown]
        public void TearDown()
        {
            RevertSnapshot(Fixture.DatabaseName(Fixture._connectionString));
            //RevertSnapshot(Fixture.DatabaseName(Fixture._repoConnectionString));
        }

        void RevertSnapshot(string dbName)
        {
            ExecuteMasterNonQuery("use master ALTER DATABASE " + dbName + " SET SINGLE_USER WITH ROLLBACK IMMEDIATE");


            string backupPath = Fixture.DATABASE_BACKUP_PATH + dbName + SS_SUFFIX; ;
            string sqlCmd = "RESTORE DATABASE [" + dbName + "] FROM  DISK = N'"
                + backupPath + "' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10";
            ExecuteMasterNonQuery(sqlCmd);


            //take it back out of single user mode
            ExecuteMasterNonQuery("ALTER DATABASE " + dbName + " SET MULTI_USER");
        }



        void SnapshotDB(string dbName)
        {
            ExecuteMasterNonQuery("ALTER DATABASE " + dbName + " SET SINGLE_USER WITH ROLLBACK IMMEDIATE");


            string backupPath = Fixture.DATABASE_BACKUP_PATH + dbName + SS_SUFFIX; ;
            string sqlCmd = "BACKUP DATABASE [" + dbName + "] TO  DISK = N'" + backupPath
                       + "' WITH NOFORMAT, INIT,  NAME = N'" + dbName + " Snapshot For Test', SKIP, NOREWIND, NOUNLOAD,  STATS = 10";
            ExecuteMasterNonQuery(sqlCmd);



            ExecuteMasterNonQuery("ALTER DATABASE " + dbName + " SET MULTI_USER");
        }

        void ExecuteMasterNonQuery(string sqlCmd)
        {
            DbConnector masterDbConnector = new DbConnector(Fixture.MasterConnectionString);
            masterDbConnector.ExecuteNonSpNonQuery(sqlCmd);
            masterDbConnector.Close();
        }
        * */
        /*******************************************************************************************/
        /*******************************************************************************************/
        /*******************************************************************************************/



        const string USERNAME = "mgronaval";

        bool IsInSchool(SEUser user, string schoolCode, string role)
        {
            SEUser[] users = Fixture.SEMgr.GetUsersInRoleInSchool(schoolCode, role);

            foreach (SEUser u in users)
            {
                if (u.Id == user.Id)
                    return true;

            }
            return false;
        }
        void FlushUsersFromTheseTests()
        {
            return;
            string[] Users = new string[]
            {
                "aLincoln"
                ,"mgronaval"
                ,"mgronaval_edsUser"
                ,"aLincoln_edsUser"
                ,"10_edsUser"
                ,"11_edsUser"
                ,"12_edsUser"
                ,"13_edsUser"
                ,"14_edsUser"
                ,"15_edsUser"
            };

            //Fixture.UserExecute("update coeStudent set coeUserId = null");
            foreach (string userName in Users)
            {
                Fixture.SEMgrExecute(
                    "delete SEUserDistrictSchool where SEUserID in"
                    + "(select SEUserID from SEUser su join aspnet_Users au "
                    + "on su.ASPNetUserID = au.UserId where au.UserName = '" + userName + "')");

                Fixture.SEMgrExecute(
                    "delete LocationRoleClaim where username = '" + userName + "'");

                Fixture.SEMgrExecute(
                        "delete SeEvalvisibility where evaluationId in "
                    + "(select EvaluationId from SEEvaluation where EvaluateeId in"
                    + "(select SEUserID from SEUser su join aspnet_Users au "
                    + "on su.ASPNetUserID = au.UserId where au.UserName = '" + userName + "'))");

                Fixture.SEMgrExecute(
                    "delete SEEvaluation where EvaluateeId in"
                   + "(select SEUserID from SEUser su join aspnet_Users au "
                   + "on su.ASPNetUserID = au.UserId where au.UserName = '" + userName + "')");

                Fixture.SEMgrExecute(
                    "delete SEEvaluation where EvaluatorId in"
                  + "(select SEUserID from SEUser su join aspnet_Users au "
                  + "on su.ASPNetUserID = au.UserId where au.UserName = '" + userName + "')");

                Fixture.SEMgrExecute(
                    "delete seUserPromptResponse where evaluateeId in "
                     + "(select SEUserID from SEUser su join aspnet_Users au "
                  + "on su.ASPNetUserID = au.UserId where au.UserName = '" + userName + "')");

                Fixture.SEMgrExecute(
                    " delete seUser where aspnetUserID in (select userID from aspnet_users au where au.userName = '" + userName + "')"
                  + " declare @foo int select @foo=4 exec aspnet_users_deleteUser @applicationName='SE'"
                  + ", @userName ='" + userName + "', @TablesToDeleteFrom =15, @NumTablesDeletedFrom=@foo output");


                Fixture.SEMgrExecute("delete edsUsersv1");
                Fixture.SEMgrExecute("delete edsRolesV1");
      
            }
             

        }
        void CheckRoles(SEUser u, Hashtable rolesHash)
        {
            List<string> roles = u.Roles(SEMgr.AspNetAppName);

            foreach (string role in roles)
            {
                Assert.IsTrue(rolesHash.ContainsKey(role));
            }
            Assert.AreEqual(rolesHash.Count, roles.Count);
        }
        string MakeRoleString(Hashtable roles)
        {
            StringBuilder rsb = new StringBuilder();
            foreach (DictionaryEntry item in roles)
            {
                rsb.Append("," + item.Key.ToString());
            }
            return rsb.ToString().Substring(1);
        }
        Hashtable BuildRolesHash(List<string> roleString)
        {
            Hashtable rolesHash = new Hashtable();
            foreach (string role in roleString)
                rolesHash.Add(role, null);
            return rolesHash;
        }
        void CheckUserDistrictSchool(SEUser u, string schoolCode)
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter ("@pSqlCmd", "Select * from SEUserDistrictSchool where seUserID = " + u.Id.ToString())
            };

        }
        ClaimsIdentity ConstructBaseClaimForUserNameChangeTests(string userName)
        {
            ClaimsIdentity outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "17408"));

            List<string> seRoles = new List<string>();
            seRoles.Add(UserRole.SEDistrictAdmin);
            seRoles.Add(UserRole.SEDistrictEvaluator);

            foreach (string role in seRoles)
            {
                outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, role));
            }
            return outputIdentity;
        }

        [Test]
        public void tEDSExportPersonIdChange_Basic()
        {
            //set up the username 10_edsUser, and then set up edsUsers file to change his username
            string firstUserName = "10_edsUser";
            FlushUsersFromTheseTests();
            ClaimsIdentity outputIdentity = ConstructBaseClaimForUserNameChangeTests(firstUserName);

            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstUserName, u.UserName);

            //setup the edsUsers table
            Fixture.SEMgrExecute("delete vedsUsers");    //flush first
            //.(recall that in the OSPIExport file, the old personids are separated by commas)
            Fixture.SEMgrExecute("insert vedsUsers (personId, firstName, lastName, email, previousPersonid)"
                + "values (15,'michael','gronaval','foo@bro.com','10,11,12,13')");

            //now execute the new EDS Import Processing proc
            Fixture.SEMgr.DbConnector.ExecuteNonQuery("EDSExport_ProcessMergedUsers");

            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pSqlCmd", "select userName from aspnet_users where userName like '%_edsUser'")
            };
            SqlDataReader r = Fixture.SEMgr.DbConnector.ExecuteDataReader("GetOneOff", aParams);

            int count = 0;
            string userName = "";

            while (r.Read())
            {
                count++;
                userName = (string)r["userName"];
            }
            r.Close();

            Assert.AreEqual(1, count);
            Assert.AreEqual("15_edsuser", userName.ToLower());
        }

        [Test]
        public void tEDSExportPersonIdChange_Loop()
        {
            //set up a couple of users and see if they all get picked up
            //set up the username 10_edsUser

            FlushUsersFromTheseTests();
            ClaimsIdentity outputId1 = ConstructBaseClaimForUserNameChangeTests("11_edsUser");
            ClaimsIdentity outputId2 = ConstructBaseClaimForUserNameChangeTests("12_edsUser");
            ClaimsIdentity outputId3 = ConstructBaseClaimForUserNameChangeTests("13_edsUser");


            SEUser u11_10= Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputId1);
            SEUser u12 = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputId2);
            SEUser u13_15 = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputId3);

            //setup the edsUsers table; this time two records
            Fixture.SEMgrExecute("delete vedsUsers");    //flush first
            //.(recall that in the OSPIExport file, the old personids are separated by commas)
            Fixture.SEMgrExecute("insert vedsUsers (personId, firstName, lastName, email, previousPersonid)"
                + "values (10,'michael','gronaval','foo@bro.com','47, 48, 52, 11, 134')");
            Fixture.SEMgrExecute("insert vedsUsers (personId, firstName, lastName, email, previousPersonid)"
                + "values (15,'michael','gronaval','foo@bro.com','67, 13, 68, 234')");

            //now execute the new EDS Import Processing proc
            Fixture.SEMgr.DbConnector.ExecuteNonQuery("EDSExport_ProcessMergedUsers");

            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pSqlCmd", "select userName from aspnet_users where userName like '%_edsUser' order by userName")
            };
            SqlDataReader r = Fixture.SEMgr.DbConnector.ExecuteDataReader("GetOneOff", aParams);

            List<string> userNames = new List<string>();

            while (r.Read())
            {
                userNames.Add((string)r["userName"]);
            }
            r.Close();

            Assert.AreEqual(3, userNames.Count);
            Assert.AreEqual("10_edsuser", userNames[0].ToLower());
            Assert.AreEqual("12_edsuser", userNames[1].ToLower());
            Assert.AreEqual("15_edsuser", userNames[2].ToLower());

            u11_10 = Fixture.SEMgr.SEUser(u11_10.Id);
            u12 = Fixture.SEMgr.SEUser(u12.Id);
            u13_15 = Fixture.SEMgr.SEUser(u13_15.Id);

            Assert.AreEqual("10_edsuser", u11_10.UserName.ToLower());
            Assert.AreEqual("12_edsuser", u12.UserName.ToLower());
            Assert.AreEqual("15_edsuser", u13_15.UserName.ToLower());

        }

        [Test]
        public void tEDSPersonIdChange_Basic()
        {
            //something simple... just change his username from 10 to 11; no problems
            string firstUserName = "10_edsUser";
            FlushUsersFromTheseTests();
            ClaimsIdentity outputIdentity = ConstructBaseClaimForUserNameChangeTests(firstUserName);

            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstUserName, u.UserName);

            long userId = u.Id; //squirrel away userid to check later

            //same identity, *except* change userName and add NameIdentifier claim
            string secondUserName = "11_edsUser";
            outputIdentity = ConstructBaseClaimForUserNameChangeTests(secondUserName);
            outputIdentity.Claims.Add(new Claim(ClaimTypes.NameIdentifier, "10;12;13"));

            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(secondUserName.ToUpper(), u.UserName);
            Assert.AreEqual(userId, u.Id);

            //make sure that the seUser table gets changed as well...
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select userName from seUser where seUserid = " + userId.ToString()) };
            DbConnector conn = Fixture.SEMgr.DbConnector;
            string userName = (string)conn.ExecuteScalar("GetOneOff", aParams);
            Assert.AreEqual(secondUserName.ToUpper(), userName);
        }

        [Test]
        public void tEDSPersonIdChange_NewUser_with_NameIDentifier()
        {
            //here, there is NameIdentifier claim, but old IDs are unrecognized, so user really is new
            string firstUserName = "10_edsUser";

            FlushUsersFromTheseTests();

            //make sure he isn't here
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select userName from seUser where username = '" + firstUserName + "'") };
            DbConnector conn = Fixture.SEMgr.DbConnector;
            string userName = (string)conn.ExecuteScalar("GetOneOff", aParams);
            Assert.IsNull(userName);


            ClaimsIdentity outputIdentity = ConstructBaseClaimForUserNameChangeTests(firstUserName);
            outputIdentity.Claims.Add(new Claim(ClaimTypes.NameIdentifier, "11;12;13"));

            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstUserName, u.UserName);

            //make sure that the seUser table gets changed as well...
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select userName from seUser where username = '" + firstUserName + "'") };
            conn = Fixture.SEMgr.DbConnector;
            userName = (string)conn.ExecuteScalar("GetOneOff", aParams);
            Assert.AreEqual(firstUserName.ToUpper(), userName.ToUpper());
        }

        [Test]
        public void tEDSPersonIdChange_NewUser_with_NewSchool()
        {
            //test a new user who is at a school not recognized
            string firstUserName = "10_edsUser";

            FlushUsersFromTheseTests();

            //make sure he isn't here
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select userName from seUser where username = '" + firstUserName + "'") };
            DbConnector conn = Fixture.SEMgr.DbConnector;
            string userName = (string)conn.ExecuteScalar("GetOneOff", aParams);
            Assert.IsNull(userName);

            //construct a claim for him as teacher in school
            ClaimsIdentity outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", firstUserName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "3010")); //North Thurston High School , 34003

            List<string> seRoles = new List<string>();
            seRoles.Add(UserRole.SESchoolTeacher);

            foreach (string role in seRoles)
            {
                outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, role));
            }


            //the reason we don't know the school is that we delete the school here
            Fixture.SEMgrExecute("delete seDistrictSchool where schoolCode = '3010'");
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select districtCode from seDistrictSchool where schoolcode = '3010'") };
            string districtCodeOfSchool = (string)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams);
            Assert.IsNull(districtCodeOfSchool); // there should be no school there; we've just deleted it!

            Fixture.SEMgr.HydrateSchool2DistrictIfNecessary();
            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstUserName, u.UserName);

            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select districtCode from seDistrictSchool where schoolcode = '3010'") };
            districtCodeOfSchool = (string)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams);
            Assert.AreEqual("34003", districtCodeOfSchool);

        }

        [Test]
        public void tEDSPersonIdChange_NewUser_II()
        {
            //set up a user; 
            //set up a second claim for different username but with name identifier that *does not*
            // include first user

            //verify you end up with two users

            string firstUserName = "10_edsUser";
            FlushUsersFromTheseTests();
            ClaimsIdentity outputIdentity = ConstructBaseClaimForUserNameChangeTests(firstUserName);

            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstUserName, u.UserName);

            long userId = u.Id; //squirrel away userid to check later

            //same identity, *except* change userName and add NameIdentifier claim; but claim doesn't include previous name
            string secondUserName = "11_edsUser";
            outputIdentity = ConstructBaseClaimForUserNameChangeTests(secondUserName);
            outputIdentity.Claims.Add(new Claim(ClaimTypes.NameIdentifier, "14;12;13"));

            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(secondUserName.ToUpper(), u.UserName.ToUpper());
            //should be a new user
            Assert.AreNotEqual(userId, u.Id);

            //make sure that the first user still exists...
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select userName from seUser where seUserid = " + userId.ToString()) };
            DbConnector conn = Fixture.SEMgr.DbConnector;
            string userName = (string)conn.ExecuteScalar("GetOneOff", aParams);
            Assert.AreEqual(firstUserName.ToUpper(), userName.ToUpper());
        }

        [Test]
        public void tEDSPersonIdChange_MultiOldId_Error()
        {
            //setup two users; then set up claim with both users in Name Identifier; verify error
            FlushUsersFromTheseTests();

            string firstUserName = "10_edsUser";
            ClaimsIdentity outputIdentity = ConstructBaseClaimForUserNameChangeTests(firstUserName);
            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstUserName, u.UserName);

            long userId = u.Id; //squirrel away userid to check later

            //second user
            string secondUserName = "11_edsUser";
            outputIdentity = ConstructBaseClaimForUserNameChangeTests(secondUserName);
            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(secondUserName.ToUpper(), u.UserName.ToUpper());
            Assert.AreNotEqual(userId, u.Id);

            //third user; who had *both* 10 and 11 as previous person ids
            string thirdUserName = "12_edsUser";
            outputIdentity = ConstructBaseClaimForUserNameChangeTests(thirdUserName);
            outputIdentity.Claims.Add(new Claim(ClaimTypes.NameIdentifier, "10;11;13"));

            string errorMsg = "";
            try
            {
                u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }
            catch (Exception e)
            {
                errorMsg = e.Message;
            }
            Assert.IsTrue(errorMsg.Contains("Multiple old identities"));

        }

        [Test]
        public void tEDSPersonIdChange_AlreadyFixed()
        {
            //setup a user
            //setup user 2
            //setup second claimn for user 2 with name identifier pointint to first user

            //expect that you just end up with two users

            //this simulates the transition case where:
            //.a user existed
            //.the user was merged, and logged in *before* fixup code was implemented
            //
            //In this case, we want to end up with two user records, because we don't
            //.know that the second user has no data

            FlushUsersFromTheseTests();

            string firstUserName = "10_edsUser";
            ClaimsIdentity outputIdentity = ConstructBaseClaimForUserNameChangeTests(firstUserName);
            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstUserName, u.UserName);

            long u1Id = u.Id; //squirrel away userid to check later

            //second user
            string secondUserName = "11_edsUser";
            outputIdentity = ConstructBaseClaimForUserNameChangeTests(secondUserName);
            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(secondUserName.ToUpper(), u.UserName.ToUpper());
            Assert.AreNotEqual(u1Id, u.Id);
            long u2Id = u.Id;

            //user the same claim, but this time, add nameIdentifier pointing to first user
            outputIdentity.Claims.Add(new Claim(ClaimTypes.NameIdentifier, "10;11;13"));
            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(u2Id, u.Id);

            //make sure that the first user still exists...
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select userName from seUser where seUserid = " + u1Id.ToString()) };
            DbConnector conn = Fixture.SEMgr.DbConnector;
            string userName = (string)conn.ExecuteScalar("GetOneOff", aParams);
            Assert.AreEqual(firstUserName.ToUpper(), userName.ToUpper());

        }


        void AddEDSUsersRecord(long personId, List<long> prevPersonIds)
        {
            StringBuilder sbPrevPersonIds = new StringBuilder();
            sbPrevPersonIds.Append ("");
            foreach (long ppid in prevPersonIds)
            {
                sbPrevPersonIds.Append(ppid.ToString() + ",");
            }
            if (prevPersonIds.Count > 0)
                sbPrevPersonIds.Length--;

            string sqlCmd = string.Format("insert edsUsersv1(personId, firstname, lastname, email, previousPersonId) values ("
                                        + "{0}, '{0}-First', '{0}-Last', '{0}-Email','{1}')", personId, sbPrevPersonIds.ToString());

            Fixture.SEMgrExecute(sqlCmd);
        }
        [Test]
        public void tEDSChangeNamesErrorTests()
        {
            FlushUsersFromTheseTests();
            
            //put some users in aspnet_users...
            List<string> userNames = new List<string>() { "10_edsUser", "11_edsUser", "12_edsUser", "13_edsUser", "14_edsUser" };

            foreach (string name in userNames)
            {
                ClaimsIdentity outputIdentity = ConstructBaseClaimForUserNameChangeTests(name);
                Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }

            string errorString = "none";

            //now test error conditions for ChangeEDSUserName

            //this case for when sproc is called and username already exists
            SqlParameter outputErrorParam = new SqlParameter("@errorMsg", System.Data.SqlDbType.VarChar);
            outputErrorParam.Direction = System.Data.ParameterDirection.Output;
            outputErrorParam.Size = 8000;

            SqlParameter[] aParams = new SqlParameter[] {
                new SqlParameter("@pCurrentEDSUserName", "10_edsUser"),
                new SqlParameter("@pIdHistory", "11,12"),
                new SqlParameter("@pApplicationName", "SE"),
                outputErrorParam
            };

            try
            {
                Fixture.SEMgr.DbConnector.ExecuteNonQuery("ChangeEDSUserName", aParams);
            }
            catch (Exception e)
            {
                errorString = e.Message;
            }
            Assert.AreNotEqual(errorString, "none");

            
            //this case where the id history refers to multiple present users
            aParams = new SqlParameter[] {
                new SqlParameter("@pCurrentEDSUserName", "15_edsUser"),
                new SqlParameter("@pIdHistory", "11,12"),
                new SqlParameter("@pApplicationName", "SE"),
                outputErrorParam
            };
            try
            {
                Fixture.SEMgr.DbConnector.ExecuteNonQuery("ChangeEDSUserName", aParams);
            }
            catch (Exception e)
            {
                errorString = e.Message;
            }
            Assert.AreNotEqual(errorString, "none");
        }
  
        [Test]
        public void TestInner()
        {
            /* set up a user that's completely new
             *  verify you get back a user with all the fields filled out
             *  
             * change something in the user
             *  verify you get back the changed fields
             *  verify that the userId didn't change
             *  
             * remove some roles
             *  verify that the roles are removed
             *  verify the rest of the roles are the same
             *  
             * add a role
             *  verify that the role is added
             *  verify you have the rest of the roles the same
             */

            string email = "mgronaval@farklebutt.com";
            string edsUserName = USERNAME;
            string firstName = "michael";
            string lastName = "gronoval";
            string districtCode = "34003";
            string schoolCode = "3010";

            FlushUsersFromTheseTests();

            List<string> roles = new List<string>();
            roles.Add(UserRole.SEDistrictAdmin);
            roles.Add(UserRole.SESchoolAdmin);
            roles.Add(UserRole.SEDistrictEvaluator);
            roles.Add(UserRole.SESchoolPrincipal);
            roles.Add(UserRole.SESchoolTeacher);


            SEUser edsUser = Fixture.SEMgr.SyncUserInner(email, edsUserName, firstName, lastName, BuildRolesHash(roles), districtCode, schoolCode);

            Assert.AreEqual(edsUser.FirstName, firstName);
            Assert.AreEqual(edsUser.LastName, lastName);
            Assert.AreEqual(edsUser.DistrictCode, districtCode);
            Assert.AreEqual(edsUser.SchoolCode, schoolCode);
            Assert.AreEqual(edsUser.UserName, edsUserName);
            Assert.AreEqual(edsUser.Email, email);
            //check his roles

            CheckRoles(edsUser, BuildRolesHash(roles));

            long firstUserId = edsUser.Id;

            //change his email and check
            email = "v_barry@foo.com";
            edsUser = Fixture.SEMgr.SyncUserInner(email, edsUserName, firstName, lastName, BuildRolesHash(roles), districtCode, schoolCode);

            Assert.AreEqual(firstUserId, edsUser.Id);
            Assert.AreEqual(edsUser.FirstName, firstName);
            Assert.AreEqual(edsUser.LastName, lastName);
            Assert.AreEqual(edsUser.DistrictCode, districtCode);
            Assert.AreEqual(edsUser.SchoolCode, schoolCode);
            Assert.AreEqual(edsUser.UserName, edsUserName);
            Assert.AreEqual(edsUser.Email, email);

            //change his firstname and check
            firstName = "barry";
            edsUser = Fixture.SEMgr.SyncUserInner(email, edsUserName, firstName, lastName, BuildRolesHash(roles), districtCode, schoolCode);

            Assert.AreEqual(firstUserId, edsUser.Id);
            Assert.AreEqual(edsUser.FirstName, firstName);
            Assert.AreEqual(edsUser.LastName, lastName);
            Assert.AreEqual(edsUser.DistrictCode, districtCode);
            Assert.AreEqual(edsUser.SchoolCode, schoolCode);
            Assert.AreEqual(edsUser.UserName, edsUserName);
            Assert.AreEqual(edsUser.Email, email);


            //check his roles
            //change a role and check
            roles.Remove(UserRole.SEDistrictAdmin);
            roles.Remove(UserRole.SEDistrictEvaluator);

            edsUser = Fixture.SEMgr.SyncUserInner(email, edsUserName, firstName, lastName, BuildRolesHash(roles), districtCode, schoolCode);
            Assert.AreEqual(firstUserId, edsUser.Id);
            CheckRoles(edsUser, BuildRolesHash(roles));

            roles.Add(UserRole.SESuperAdmin);

            edsUser = Fixture.SEMgr.SyncUserInner(email, edsUserName, firstName, lastName, BuildRolesHash(roles), districtCode, schoolCode);
            Assert.AreEqual(firstUserId, edsUser.Id);
            CheckRoles(edsUser, BuildRolesHash(roles));
        }
        [Test]
        public void TestSyncWrapper()
        {
            string userName = USERNAME;
            FlushUsersFromTheseTests();
            ClaimsIdentity outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));

            List<string> eCOERoles = new List<string>();
            eCOERoles.Add(UserRole.SEDistrictAdmin);
            eCOERoles.Add(UserRole.SEDistrictEvaluator);


            foreach (string role in eCOERoles)
            {
                outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, role));
            }

            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "17408"));


            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);

            Assert.AreEqual("17408", u.DistrictCode);
            Assert.AreEqual(userName, u.UserName);
            Assert.AreEqual("foo@bro.com", u.Email);

            Hashtable rolesHash = new Hashtable();

            rolesHash = BuildRolesHash(eCOERoles);

            CheckRoles(u, rolesHash);

        }
        [Test]
        public void TestRoleErrors()
        {

            //school user, district role
            //district user, school role
            //unrecognizable school*
            //multiple locations
            //no location
            //no roles

            //*you could test for an unrecognizeable district, but at the expense of another db call
            // on the other hand, having an unrecognizeable district should be harmless, as long as he has a district at all

            string userName = "mgronaval";
            FlushUsersFromTheseTests();

            //school user, district role
            ClaimsIdentity outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "3010"));

            outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SEDistrictAdmin));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SESchoolPrincipal));

            //this is kind of odd, because i think LocationRoleClaim is supposed to be always consistent...
            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pUserName", userName)
                    ,new SqlParameter("@pLocationCDSCode", "3010")
                    ,new SqlParameter("@pLocationName", "North Thurston High School")
                    ,new SqlParameter("@pRoleString", UserRole.SEDistrictAdmin.ToString() + ";" + UserRole.SESchoolPrincipal.ToString())
                   
                };
            Fixture.SEMgr.DbConnector.ExecuteNonQuery("InsertEDSFormattedRoleClaims", aParams);


            string message = "";
            try
            {
                SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.ToLower().Contains("district role in school"));


            //district user, school role
            FlushUsersFromTheseTests();
            outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "03017"));

            outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SESchoolPrincipal));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SEDistrictAdmin));

            //oddness again... because i think LocationRoleClaim is supposed to be always consistent...
            aParams = new SqlParameter[]
                {
                    new SqlParameter("@pUserName", userName)
                    ,new SqlParameter("@pLocationCDSCode", "34003")
                    ,new SqlParameter("@pLocationName", "North Thurston Public Schools")
                    ,new SqlParameter("@pRoleString", UserRole.SEDistrictAdmin.ToString() + ";" + UserRole.SESchoolPrincipal.ToString())
                   
                };
            Fixture.SEMgr.DbConnector.ExecuteNonQuery("InsertEDSFormattedRoleClaims", aParams);

            message = "";
            try
            {
                SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.Contains("E_ROLES_MISMATCH: person in multiple "));

            /*
            //... this is kind of obsoleted by the OSPI cds code lookup service
            //unrecognizable school
            FlushUsersFromTheseTests();
            outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "XXXX"));

            outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SESchoolPrincipal));

            message = "";
            try
            {
                SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.Contains("not recognize what school/district"));
            */

            //multiple locations
            FlushUsersFromTheseTests();
            outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "36140"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "09206"));

            outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SEDistrictAdmin));

            message = "";
            try
            {
                SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.Contains("in with multiple locations at one"));

            //no locations
            FlushUsersFromTheseTests();
            outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));

            outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, UserRole.SEDistrictAdmin));

            message = "";
            try
            {
                SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.Contains("could not match you to a school or location"));

            //no roles at all
            FlushUsersFromTheseTests();
            outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", "michael gronaval"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "36140"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "09206"));

            message = "";
            try
            {
                SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            }
            catch (Exception e)
            {
                message = e.Message;
            }
            Assert.IsTrue(message.Contains("seem to have any permissions in this application"));


        }
        [Test]
        public void TestSEUserFieldRepair()
        {
            /* set up a user that's completely new
             *  verify you get back a user with all the fields filled out
             *  
             * Remove all his fields from the seUserTable
             * 
             * then Sync him again to see if he gets his SEUser table fields back
             *  
             */

            string email = "mgronaval@farklebutt.com";
            string edsUserName = USERNAME;
            string firstName = "michael";
            string lastName = "gronoval";
            string districtCode = "34003";
            string schoolCode = "3010";

            FlushUsersFromTheseTests();

            List<string> roles = new List<string>();
            roles.Add(UserRole.SEDistrictAdmin);
            roles.Add(UserRole.SESchoolAdmin);
            roles.Add(UserRole.SEDistrictEvaluator);
            roles.Add(UserRole.SESchoolPrincipal);
            roles.Add(UserRole.SESchoolTeacher);


            SEUser edsUser = Fixture.SEMgr.SyncUserInner(email, edsUserName, firstName, lastName, BuildRolesHash(roles), districtCode, schoolCode);

            Assert.AreEqual(edsUser.FirstName, firstName);
            Assert.AreEqual(edsUser.LastName, lastName);
            Assert.AreEqual(edsUser.DistrictCode, districtCode);
            Assert.AreEqual(edsUser.SchoolCode, schoolCode);
            Assert.AreEqual(edsUser.UserName, edsUserName);
            Assert.AreEqual(edsUser.Email, email);
            //check his roles

            CheckRoles(edsUser, BuildRolesHash(roles));

            Fixture.SEMgrExecute("update seUser set firstname='', lastName='', schoolCode='', districtCode='' where seUserID = " + edsUser.Id.ToString());

            edsUser = Fixture.SEMgr.SyncUserInner(email, edsUserName, firstName, lastName, BuildRolesHash(roles), districtCode, schoolCode);
            Assert.AreEqual(edsUser.FirstName, firstName);
            Assert.AreEqual(edsUser.LastName, lastName);
            Assert.AreEqual(edsUser.DistrictCode, districtCode);
            Assert.AreEqual(edsUser.SchoolCode, schoolCode);
            Assert.AreEqual(edsUser.UserName, edsUserName);
            Assert.AreEqual(edsUser.Email, email);
            //check his roles

            CheckRoles(edsUser, BuildRolesHash(roles));

        }
        [Test]
        public void TestDecodeEDSGivenName()
        {
            string userName = USERNAME;
            FlushUsersFromTheseTests();
            string firstName = "michael";
            string lastName = "gronaval";

            ClaimsIdentity outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name", userName));
            outputIdentity.Claims.Add(new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress", "foo@bro.com"));

            Claim givenNameClaim = new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", firstName + " " + lastName);
            outputIdentity.Claims.Add(givenNameClaim);

            List<string> eCOERoles = new List<string>();
            eCOERoles.Add(UserRole.SEDistrictAdmin);
            eCOERoles.Add(UserRole.SEDistrictEvaluator);


            foreach (string role in eCOERoles)
            {
                outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, role));
            }

            outputIdentity.Claims.Add(new Claim(ClaimTypes.Locality, "03421"));
            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);

            Assert.AreEqual(firstName, u.FirstName);
            Assert.AreEqual(lastName, u.LastName);


            //test comma-separated given name format
            outputIdentity.Claims.Remove(givenNameClaim);
            givenNameClaim = new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", lastName + "," + firstName);
            outputIdentity.Claims.Add(givenNameClaim);

            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstName, u.FirstName);
            Assert.AreEqual(lastName, u.LastName);

            //test if the new format accommodates multi-word first, last names 
            firstName = "Jonathan Frank";
            lastName = "Torrance Smythe";
            outputIdentity.Claims.Remove(givenNameClaim);
            givenNameClaim = new Claim("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname", lastName + "," + firstName);
            outputIdentity.Claims.Add(givenNameClaim);

            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual(firstName, u.FirstName);
            Assert.AreEqual(lastName, u.LastName);
        }
        [Test]
        public void TestUserDistrictSchool()
        {
            string userName = USERNAME + EdsIdentity.EdsNameTag;
            FlushUsersFromTheseTests();
            ClaimsIdentity outputIdentity = new ClaimsIdentity();
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Name, userName));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Email, "foo@bro.com"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.GivenName, "michael gronaval"));
            List<string> eCOERoles = new List<string>();

            eCOERoles.Add(UserRole.SEDistrictAdmin);

            foreach (string role in eCOERoles)
            {
                outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, role));
            }

            Claim localityClaim = new Claim(ClaimTypes.Locality, "03422");

            outputIdentity.Claims.Add(localityClaim);

            SqlParameter[]aParams = new SqlParameter[]
                {
                    new SqlParameter("@pUserName", userName)
                    ,new SqlParameter("@pLocationCDSCode", "03422")
                    ,new SqlParameter("@pLocationName", "North Thurston Public Schools")
                    ,new SqlParameter("@pRoleString", UserRole.SEDistrictAdmin.ToString())
                   
                };
            Fixture.SEMgr.DbConnector.ExecuteNonQuery("InsertEDSFormattedRoleClaims", aParams);


            SEUser u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);


            int nUsers = (int)Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff",
            new SqlParameter[]{
                new SqlParameter("@pSqlCmd", "select count (*) from SEUserDistrictSchool where seUserID = " 
                    + u.Id.ToString())});
            Assert.AreEqual(1, nUsers);

            //did the district get there?
            Assert.AreEqual("03422", u.DistrictCode);
            Assert.AreEqual(userName, u.UserName);
            Assert.AreEqual("foo@bro.com", u.Email);

            //change to a different district
            outputIdentity.Claims.Remove(localityClaim);
            localityClaim = new Claim(ClaimTypes.Locality, "31201");
            outputIdentity.Claims.Add(localityClaim);
            u = Fixture.SEMgr.SEUserFromEDSInfo((IClaimsIdentity)outputIdentity);
            Assert.AreEqual("31201", u.DistrictCode);
        }
    

    
    }
}
