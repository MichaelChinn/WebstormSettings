using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;
using System.Data;
using System.Transactions;



namespace StateEval.Core.Test
{
    [TestClass]
    public class WhenSamlTokenSeenSprocsTests
    {
        public bool IsDistrictLocation(string locationCode)
        {
            return locationCode.Length == 5 ? true : false;
        }
        public class LocationRole
        {
            public string LocationCode {get;set;}
            public string RoleString {get;set;}

            public LocationRole(string locationCode, string roleString)
            {
                LocationCode = locationCode.Trim();
                RoleString = roleString.Trim();
            }
            public LocationRole (string lrPair)
            {
                string [] toks = lrPair.Split(new char[]{'|'});
                LocationCode = toks[0].Trim();
                RoleString = toks[1].Trim();
            }
        }
        void CheckReferenceTables(long seUserId, string lrString)
        {
            string[] lrPairs = lrString.Split(new char[] { ',' });
            List<LocationRole> locationRoles = new List<LocationRole>();
            List<string> distinctLocations = new List<string>();

            foreach (string pair in lrPairs)
            {
                LocationRole lr = new LocationRole(pair);
                locationRoles.Add(lr);

                if (!distinctLocations.Contains(lr.LocationCode))
                    distinctLocations.Add(lr.LocationCode);
            }

            UserService us = new UserService();

            //check the userlocation role table first...
            List<UserLocationRoleModel> ulr = us.GetLocationRolesForUser(seUserId).ToList();

            Assert.AreEqual(lrPairs.Length, ulr.Count);

            foreach (LocationRole lr in locationRoles)
            {
                if (IsDistrictLocation(lr.LocationCode))
                    Assert.IsNotNull(ulr.Any(x => x.DistrictCode == lr.LocationCode && x.RoleName == lr.RoleString));
                else
                    Assert.IsNotNull(ulr.Any(x => x.SchoolCode == lr.LocationCode && x.RoleName == lr.RoleString));
            }

            //check userdistrictschool table next
            /* TODO: ac: remove since we have removed SEUserDistrictSchool
            List<UserDistrictSchoolModel> uds = us.GetDistrictSchoolsForUser(seUserId).ToList();

            Assert.AreEqual(distinctLocations.Count, uds.Count);
            foreach (string location in distinctLocations)
            {
                if (IsDistrictLocation(location))
                    Assert.IsNotNull(uds.Any(x => x.DistrictCode == location));
                else
                    Assert.IsNotNull(uds.Any(x => x.SchoolCode == location));
            }
             */
 
        }

        [TestMethod]
        public void UnknownUserGeneratesNewUserRecords()
        {
            var service = new UserService();
            long edsPersonId = 1000000001;


            UserModel myTestUser = service.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
            Assert.IsNull(myTestUser);

            using (TransactionScope transaction = new TransactionScope())
            {
                service.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                myTestUser = service.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                Assert.IsNotNull(myTestUser);

                Assert.AreEqual("test", myTestUser.LastName);
                Assert.AreEqual("tester", myTestUser.FirstName);
                Assert.AreEqual("testerTest@test.me", myTestUser.EMailAddress);
                Assert.AreEqual("t34223", myTestUser.CertificateNumber);
                Assert.IsFalse(myTestUser.HasMultipleBuildings);
                transaction.Dispose();

            }
        }

        [TestMethod]
        public void KnownUserUpdatesUserRecord()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var service = new UserService();

                long edsPersonId = 1000000001;


                UserModel t1 = service.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                Assert.IsNull(t1);



                service.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                t1 = service.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                Assert.IsNotNull(t1);

                Assert.AreEqual("test", t1.LastName);
                Assert.AreEqual("tester", t1.FirstName);
                Assert.AreEqual("testerTest@test.me", t1.EMailAddress);
                Assert.AreEqual("t34223", t1.CertificateNumber);
                Assert.IsFalse(t1.HasMultipleBuildings);


                service.InsertOrFindSeUserId(edsPersonId, "best", "bester", "besterBest@test.me", "b34223", true);

                service = new UserService();
                UserModel t2 = service.GetUserByUserName(edsPersonId.ToString() + "_edsUser");


                Assert.IsNotNull(t2);

                Assert.AreEqual("best", t2.LastName);
                Assert.AreEqual("bester", t2.FirstName);
                Assert.AreEqual("besterBest@test.me", t2.EMailAddress);
                Assert.AreEqual("b34223", t2.CertificateNumber);
                Assert.IsTrue(t2.HasMultipleBuildings);


                transaction.Dispose();

            }
        }

        [TestMethod]
        public void UpdateUserRecordUpdatesOneRecord()
        {
            using (TransactionScope transaction = new TransactionScope())
            {

                var service = new UserService();
                long p1 = 1000000001;
                long p2 = 1000000002;


                UserModel t1 = service.GetUserByUserName(p1.ToString() + "_edsUser");
                UserModel t2 = service.GetUserByUserName(p2.ToString() + "_edsUser");
                Assert.IsNull(t1);
                Assert.IsNull(t2);

                service.InsertOrFindSeUserId(p1, "test", "tester", "testerTest@test.me", "t34223", false);
                service.InsertOrFindSeUserId(p2, "mary", "martha", "maryMartha@test.me", "m34223", false);

                t1 = service.GetUserByUserName(p1.ToString() + "_edsUser");

                Assert.IsNotNull(t1);

                Assert.AreEqual("test", t1.LastName);
                Assert.AreEqual("tester", t1.FirstName);
                Assert.AreEqual("testerTest@test.me", t1.EMailAddress);
                Assert.AreEqual("t34223", t1.CertificateNumber);


                service.InsertOrFindSeUserId(p1, "best", "bester", "besterBest@test.me", "b34223", true);

                service = new UserService();
                t1 = service.GetUserByUserName(p1.ToString() + "_edsUser");


                Assert.IsNotNull(t1);

                Assert.AreEqual("best", t1.LastName);
                Assert.AreEqual("bester", t1.FirstName);
                Assert.AreEqual("besterBest@test.me", t1.EMailAddress);
                Assert.AreEqual("b34223", t1.CertificateNumber);

                service = new UserService();
                t2 = service.GetUserByUserName(p2.ToString() + "_edsUser");
                Assert.AreEqual("mary", t2.LastName);
                Assert.AreEqual("martha", t2.FirstName);
                Assert.AreEqual("maryMartha@test.me", t2.EMailAddress);
                Assert.AreEqual("m34223", t2.CertificateNumber);

                transaction.Dispose();

            }
        }



        [TestMethod]
        public void ReferenceTablesPersistedCorrectlyForSingleSchoolRole()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var us = new UserService();
                var es = new EvaluationService();

                long edsPersonId = 1000000001;

                UserModel t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                Assert.IsNull(t1);

                long seUserId = us.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                List<EvaluationModel> evaluations = es.GetEvaluationsForUser(seUserId).ToList();
                Assert.AreEqual(0, evaluations.Count);

                string lrString = "3010|SESchoolPrincipal";
                us.InsertUpdateUserReferenceTables(edsPersonId, lrString);

                CheckReferenceTables(seUserId, lrString);


                es = new EvaluationService();
                evaluations = es.GetEvaluationsForUser(seUserId).ToList();

                Assert.AreEqual(1, evaluations.Count);
                Assert.AreEqual("34003", evaluations[0].DistrictCode);


                transaction.Dispose();

            }
        }

        [TestMethod]
        public void ReferenceTablesPersistedCorrectlyForMultipleSchoolRole()
        {
            {
                using (TransactionScope transaction = new TransactionScope())
                {
                    var us = new UserService();
                    var es = new EvaluationService();

                    long edsPersonId = 1000000001;

                    UserModel t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                    Assert.IsNull(t1);

                    long seUserId = us.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                    t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                    List<EvaluationModel> evaluations = es.GetEvaluationsForUser(seUserId).ToList();
                    Assert.AreEqual(0, evaluations.Count);

                    string lrString = "3010|SESchoolAdmin,3010|SESchoolPrincipal,3015|SESchoolAdmin";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);


                    es = new EvaluationService();
                    evaluations = es.GetEvaluationsForUser(seUserId).ToList();

                    Assert.AreEqual(1, evaluations.Count);

                    transaction.Dispose();

                }
            }
        }

        [TestMethod]
        public void ReferenceTablesUpdatedAsSchoolLocationsChanged()
        {
            {
                using (TransactionScope transaction = new TransactionScope())
                {
                    var us = new UserService();
                    var es = new EvaluationService();

                    long edsPersonId = 1000000001;

                    UserModel t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                    Assert.IsNull(t1);

                    long seUserId = us.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                    t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                    List<EvaluationModel> evaluations = es.GetEvaluationsForUser(seUserId).ToList();
                    Assert.AreEqual(0, evaluations.Count);

                    string lrString = "3010|SESchoolAdmin,3010|SESchoolPrincipal";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);

                    lrString = "3010|SESchoolAdmin,3010|SESchoolPrincipal,2754|SESchoolPrincipal";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);



                    //TODO... test data needs to be set up with second framework for Othello
                    es = new EvaluationService();
                    evaluations = es.GetEvaluationsForUser(seUserId).ToList();

                    Assert.AreEqual(1, evaluations.Count);

                    transaction.Dispose();

                }
            }
        }

        [TestMethod]
        public void ReferenceTablesUpdatedAsSchoolLocationsAdded()
        {
            {
                using (TransactionScope transaction = new TransactionScope())
                {
                    var us = new UserService();
                    var es = new EvaluationService();

                    long edsPersonId = 1000000001;

                    UserModel t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                    Assert.IsNull(t1);

                    long seUserId = us.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                    t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                    List<EvaluationModel> evaluations = es.GetEvaluationsForUser(seUserId).ToList();
                    Assert.AreEqual(0, evaluations.Count);

                    string lrString = "3010|SESchoolAdmin";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);

                    lrString = "3010|SESchoolAdmin,3010|SESchoolPrincipal";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);

                    lrString = "3010|SESchoolAdmin,3010|SESchoolPrincipal,2754|SESchoolPrincipal";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);


                    //TODO... test data needs to be set up with second framework for Othello
                    es = new EvaluationService();
                    evaluations = es.GetEvaluationsForUser(seUserId).ToList();

                    Assert.AreEqual(1, evaluations.Count);

                    transaction.Dispose();

                }
            }
        }




        [TestMethod]
        public void ReferenceTablesPersistedCorrectlyForSingleDistrictRole()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var us = new UserService();
                var es = new EvaluationService();

                long edsPersonId = 1000000001;

                UserModel t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                Assert.IsNull(t1);

                long seUserId = us.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                List<EvaluationModel> evaluations = es.GetEvaluationsForUser(seUserId).ToList();
                Assert.AreEqual(0, evaluations.Count);

                string lrString = "34003|SEDistrictAdmin";
                us.InsertUpdateUserReferenceTables(edsPersonId, lrString);

                CheckReferenceTables(seUserId, lrString);

                transaction.Dispose();

            }
        }

        [TestMethod]
        public void ReferenceTablesPersistedCorrectlyForMultipleDistrictRole()
        {
            {
                using (TransactionScope transaction = new TransactionScope())
                {
                    var us = new UserService();
                    var es = new EvaluationService();

                    long edsPersonId = 1000000001;

                    UserModel t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                    Assert.IsNull(t1);

                    long seUserId = us.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                    t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                    List<EvaluationModel> evaluations = es.GetEvaluationsForUser(seUserId).ToList();
                    Assert.AreEqual(0, evaluations.Count);

                    string lrString = "34003|SEDistrictAdmin,34003|SEDistrictWideTeacherEvaluator, 34003|SEDistrictEvaluator";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);

                    transaction.Dispose();

                }
            }
        }

        [TestMethod]
        public void ReferenceTablesUpdatedAsDistrictLocationsAdded()
        {
            {
                using (TransactionScope transaction = new TransactionScope())
                {
                    var us = new UserService();
                    var es = new EvaluationService();

                    long edsPersonId = 1000000001;

                    UserModel t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");
                    Assert.IsNull(t1);

                    long seUserId = us.InsertOrFindSeUserId(edsPersonId, "test", "tester", "testerTest@test.me", "t34223", false);
                    t1 = us.GetUserByUserName(edsPersonId.ToString() + "_edsUser");

                    List<EvaluationModel> evaluations = es.GetEvaluationsForUser(seUserId).ToList();
                    Assert.AreEqual(0, evaluations.Count);

                    string lrString = "34003|SEDistrictAdmin";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);

                    lrString = "34003|SEDistrictAdmin,34003|SEDistrictWideTeacherEvaluator";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);

                    lrString = "34003|SEDistrictAdmin,34003|SEDistrictWideTeacherEvaluator, 01147|SEDistrictEvaluator";
                    us.InsertUpdateUserReferenceTables(edsPersonId, lrString);
                    CheckReferenceTables(seUserId, lrString);

                    transaction.Dispose();

                }
            }
        }
    }

}
