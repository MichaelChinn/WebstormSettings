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
using System.Transactions;

namespace StateEval.Core.Test
{
    [TestClass]
    public class AssignmentsServiceTest
    {
        void CreateAssignmentRequest(AssignmentsService assignmentsService)
        {
            EvalAssignmentRequestModel requestModel = new EvalAssignmentRequestModel();
            requestModel.SchoolYear = TestHelper.DEFAULT_SCHOOLYEAR;
            requestModel.DistrictCode = TestHelper.DEFAULT_DISTRICTCODE;
            requestModel.EvaluatorId = DefaultDTE.UserId;
            requestModel.EvaluateeId = DefaultTeacher.UserId;
            assignmentsService.CreateEvalAssignmentRequestForDTE(requestModel);

        }

        void AcceptRequest(AssignmentsService assignmentsService)
        {
            List<EvalAssignmentRequestModel> requests = GetEvalAssignmentRequestsForDTE();
            requests[0].EvalRequestStatus = (short)SEEvalRequestStatusEnum.ACCEPTED;
            requests[0].EvalRequestType = (short)SEEvalRequestTypeEnum.ASSIGNED_EVALUATOR;
            assignmentsService.UpdateEvalAssignmentRequestForDTE(requests[0]);
        }

        void AcceptObserveOnlyRequest(AssignmentsService assignmentsService)
        {
            List<EvalAssignmentRequestModel> requests = GetEvalAssignmentRequestsForDTE();
            requests[0].EvalRequestStatus = (short)SEEvalRequestStatusEnum.ACCEPTED;
            requests[0].EvalRequestType = (short)SEEvalRequestTypeEnum.OBSERVATION_ONLY;
            assignmentsService.UpdateEvalAssignmentRequestForDTE(requests[0]);
        }

        void RejectRequest(AssignmentsService assignmentsService)
        {
            List<EvalAssignmentRequestModel> requests = GetEvalAssignmentRequestsForDTE();
            requests[0].EvalRequestStatus = (short)SEEvalRequestStatusEnum.REJECTED;
            requests[0].EvalRequestType = (short)SEEvalRequestTypeEnum.ASSIGNED_EVALUATOR;
            assignmentsService.UpdateEvalAssignmentRequestForDTE(requests[0]);
        }

        List<EvalAssignmentRequestModel> GetEvalAssignmentRequestsForDTE()
        {
            var assignmentsService = new AssignmentsService();

            return assignmentsService.GetEvalAssignmentRequestsForDTE(
                                                       TestHelper.DEFAULT_SCHOOLYEAR,
                                                       TestHelper.DEFAULT_DISTRICTCODE,
                                                       DefaultDTE.UserId).ToList();
        }

        [TestMethod]
        public void EvalRequestsForDTE_EvaluatorAssignedOnAcceptance()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();

                CreateAssignmentRequest(assignmentsService);

                EvaluationModel evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                AcceptRequest(assignmentsService);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultDTE.UserId, evalModel.EvaluatorId);

                transaction.Dispose();
            }
        }

        [TestMethod]
        public void EvalRequestsForDTE_EvaluatorUnAssignedOnRejection()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();

                CreateAssignmentRequest(assignmentsService);

                EvaluationModel evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                AcceptRequest(assignmentsService);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultDTE.UserId, evalModel.EvaluatorId);

                RejectRequest(assignmentsService);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.IsNull(evalModel.EvaluatorId);

                transaction.Dispose();
            }
        }

        [TestMethod]
        public void EvalRequestsForDTE_EvaluatorUnAssignedOnChangeToObserveOnly()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();

                CreateAssignmentRequest(assignmentsService);

                EvaluationModel evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                AcceptRequest(assignmentsService);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultDTE.UserId, evalModel.EvaluatorId);

                AcceptObserveOnlyRequest(assignmentsService);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.IsNull(evalModel.EvaluatorId);

                transaction.Dispose();
            }
        }

        [TestMethod]
        public void EvalRequestsForDTE_EvaluatorUnAssignedOAcceptObserveOnly()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();

                CreateAssignmentRequest(assignmentsService);

                EvaluationModel evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                AcceptObserveOnlyRequest(assignmentsService);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                transaction.Dispose();
            }
        }

        [TestMethod]
        public void EvalRequestsForDTE_EvaluatorUnAssignedODelete()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();

                CreateAssignmentRequest(assignmentsService);

                EvaluationModel evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                AcceptRequest(assignmentsService);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultDTE.UserId, evalModel.EvaluatorId);

                List<EvalAssignmentRequestModel> requests = GetEvalAssignmentRequestsForDTE();
                assignmentsService.DeleteAssignmentRequestForDTE(requests[0].Id);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.IsNull(evalModel.EvaluatorId);
                requests = GetEvalAssignmentRequestsForDTE();
                Assert.AreEqual(0, requests.Count);


                transaction.Dispose();
            }
        }

        [TestMethod]
        public void DelegateTeacherAssignments()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();

                Assert.AreEqual(false, assignmentsService.DistrictDelegatedTeacherAssignmentsForSchool(
                                                    (SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                                    TestHelper.DEFAULT_DISTRICTCODE,
                                                    TestHelper.DEFAULT_SCHOOLCODE));

                assignmentsService.DelegateAssignments( (SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                                    TestHelper.DEFAULT_DISTRICTCODE,
                                                    TestHelper.DEFAULT_SCHOOLCODE, true);

                Assert.AreEqual(true, assignmentsService.DistrictDelegatedTeacherAssignmentsForSchool(
                                                    (SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                                    TestHelper.DEFAULT_DISTRICTCODE,
                                                    TestHelper.DEFAULT_SCHOOLCODE));

                assignmentsService.DelegateAssignments((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                                    TestHelper.DEFAULT_DISTRICTCODE,
                                                    TestHelper.DEFAULT_SCHOOLCODE, false);


                Assert.AreEqual(false, assignmentsService.DistrictDelegatedTeacherAssignmentsForSchool(
                                    (SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                    TestHelper.DEFAULT_DISTRICTCODE,
                                    TestHelper.DEFAULT_SCHOOLCODE));


                transaction.Dispose();
            }
        }

        [TestMethod]
        public void AssignEvaluator()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();

                EvaluationModel evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                assignmentsService.AssignEvaluator((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR, 
                                            DefaultTeacher.DistrictCode, SEEvaluationTypeEnum.TEACHER, 
                                            DefaultTeacher.UserId,
                                            null);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.IsNull(evalModel.EvaluatorId);

                assignmentsService.AssignEvaluator((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                            DefaultTeacher.DistrictCode, SEEvaluationTypeEnum.TEACHER,
                            DefaultTeacher.UserId,
                            DefaultPrincipal.UserId);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual(DefaultPrincipal.UserId, evalModel.EvaluatorId);

                transaction.Dispose();
            }
        }

        [TestMethod]
        public void AssignEvaluateePlanType()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                FrameworkModel framework = TestHelper.GetStateFramework(SEEvaluationTypeEnum.TEACHER);
                FrameworkNodeModel c3FrameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "C3");

                var assignmentsService = new AssignmentsService();

                short? planTypeBefore = TestHelper.GetEvaluationForDefaultTeacher().PlanType;
                Assert.AreEqual((short)SEEvaluateePlanTypeEnum.COMPREHENSIVE, planTypeBefore);

                assignmentsService.AssignEvaluateePlanType((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                            DefaultTeacher.DistrictCode, SEEvaluationTypeEnum.TEACHER,
                                            DefaultTeacher.UserId,
                                            SEEvaluateePlanTypeEnum.FOCUSED,
                                            c3FrameworkNode.Id, c3FrameworkNode.Id);

                EvaluationModel evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual((short)SEEvaluateePlanTypeEnum.FOCUSED, evalModel.PlanType);
                Assert.AreEqual(c3FrameworkNode.Id, evalModel.FocusFrameworkNodeId);
                Assert.AreEqual(c3FrameworkNode.Id, evalModel.FocusSGFrameworkNodeId);

                FrameworkNodeModel c1FrameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "C1");

                assignmentsService.AssignEvaluateePlanType((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                            DefaultTeacher.DistrictCode, SEEvaluationTypeEnum.TEACHER,
                                            DefaultTeacher.UserId,
                                            SEEvaluateePlanTypeEnum.FOCUSED,
                                            c1FrameworkNode.Id, c3FrameworkNode.Id);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual((short)SEEvaluateePlanTypeEnum.FOCUSED, evalModel.PlanType);
                Assert.AreEqual(c1FrameworkNode.Id, evalModel.FocusFrameworkNodeId);
                Assert.AreEqual(c3FrameworkNode.Id, evalModel.FocusSGFrameworkNodeId);

                assignmentsService.AssignEvaluateePlanType((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                            DefaultTeacher.DistrictCode, SEEvaluationTypeEnum.TEACHER,
                                            DefaultTeacher.UserId,
                                            SEEvaluateePlanTypeEnum.COMPREHENSIVE,
                                            null, null);

                evalModel = TestHelper.GetEvaluationForDefaultTeacher();
                Assert.AreEqual((short)SEEvaluateePlanTypeEnum.COMPREHENSIVE, evalModel.PlanType);
                Assert.IsNull(evalModel.FocusFrameworkNodeId);
                Assert.IsNull(evalModel.FocusSGFrameworkNodeId);


                transaction.Dispose();
            }
        }

        [TestMethod]
        public void GetTeachersForAssignment()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();
                List<UserModel> teachers = assignmentsService.GetTeachersForAssignment((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                        DefaultTeacher.DistrictCode, SchoolCodes.NorthThurston_NorthThurstonHighSchool).ToList();

                Assert.IsNotNull(teachers.FirstOrDefault(x => x.FirstName == "T1"));
                Assert.IsNotNull(teachers.FirstOrDefault(x => x.FirstName == "T2"));

                // this user is in two schools, but only a teacher in this school
                Assert.IsNotNull(teachers.FirstOrDefault(x => x.FirstName == "T_PRH" && x.LastName == "s3_s4"));

                teachers = assignmentsService.GetTeachersForAssignment((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                        DefaultTeacher.DistrictCode, SchoolCodes.NorthThurston_SouthBayElementary).ToList();

                Assert.IsNotNull(teachers.FirstOrDefault(x => x.FirstName == "T1"));
                Assert.IsNotNull(teachers.FirstOrDefault(x => x.FirstName == "T2"));

                // this user is in two schools, but only a teacher in one of them. not this one
                Assert.IsNull(teachers.FirstOrDefault(x => x.FirstName == "T_PRH" && x.LastName == "s3_s4"));

                transaction.Dispose();

            }
        }

        [TestMethod]
        public void GetPrincipalsForAssignment()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var assignmentsService = new AssignmentsService();
                List<UserModel> principals = assignmentsService.GetPrincipalsForAssignment((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                                        DistrictCodes.NorthThurston).ToList();

                Assert.IsNotNull(principals.FirstOrDefault(x => x.FirstName == "PR1" && x.LastName == "North Thurston High School"));
                Assert.IsNotNull(principals.FirstOrDefault(x => x.FirstName == "PR2" && x.LastName == "North Thurston High School"));
                Assert.IsNotNull(principals.FirstOrDefault(x => x.FirstName == "PRH" && x.LastName == "North Thurston High School"));

                // this user is in multiple districts/different roles, in NT he is a principal
                Assert.IsNotNull(principals.FirstOrDefault(x => x.FirstName == "DA_PR2" && x.LastName == "d1_s4"));

                Assert.IsNotNull(principals.FirstOrDefault(x => x.FirstName == "PR1" && x.LastName == "South Bay Elementary"));
                Assert.IsNotNull(principals.FirstOrDefault(x => x.FirstName == "PR2" && x.LastName == "South Bay Elementary"));
                Assert.IsNotNull(principals.FirstOrDefault(x => x.FirstName == "PRH" && x.LastName == "South Bay Elementary"));

                principals = assignmentsService.GetPrincipalsForAssignment((SESchoolYearEnum)TestHelper.DEFAULT_SCHOOLYEAR,
                        DistrictCodes.Othello).ToList();

                // this user is in multiple districts/different roles, in OThello he is a DA so shouldn't be found as a principal
                Assert.IsNull(principals.FirstOrDefault(x => x.FirstName == "DA_PR2" && x.LastName == "d1_s4"));

                transaction.Dispose();

            }
        }

    }
}
