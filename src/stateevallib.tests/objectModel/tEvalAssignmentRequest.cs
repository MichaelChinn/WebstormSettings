using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;
using System.EnterpriseServices;

using NUnit.Framework;
using DbUtils;
using StateEval.Security;
using RepositoryLib;

namespace StateEval.tests.objectModel
{
     [TestFixture]
    class tEvalAssignmentRequest : tBase
    {

         void CheckEvalAssignmentRequestFieldValues(SEEvalAssignmentRequest r, SEUser evaluator, SEEvalRequestType requestType, SEEvalRequestStatus status)
         {
            Assert.AreEqual(evaluator.Id, r.EvaluatorId);
             Assert.AreEqual(status, r.Status);
             Assert.AreEqual(requestType, r.RequestType);
             Assert.AreEqual(Fixture.CurrentSchoolYear, r.SchoolYear);
             Assert.AreEqual(evaluator.DistrictCode, r.DistrictCode);
         }

         [Test]
         public void TestRequests()
         {
             SEUser dte_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DTE);
             SEUser da_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DA);
             SEUser teacher1_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEUser dte_othello = Fixture.SEMgr.SEUser(Fixture.OthelloDistrictUserName_DTE);
             SEUser da_othello = Fixture.SEMgr.SEUser(Fixture.OthelloDistrictUserName_DA);
             SEUser teacher1_othello = Fixture.SEMgr.SEUser(Fixture.OthelloHSUserName_T1);

             // insert a request for both north thurston and othello
             Fixture.SEMgr.InsertEvalAssignmentRequest(dte_nt.Id, teacher1_nt.Id, Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston);
             Fixture.SEMgr.InsertEvalAssignmentRequest(dte_othello.Id, teacher1_othello.Id, Fixture.CurrentSchoolYear, PilotDistricts.Othello);

             // make sure they are there and have the right fields
             SEEvalAssignmentRequest[] requests = Fixture.SEMgr.GetEvalAssignmentRequestsForEvaluator(dte_nt.Id, Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston);
             Assert.AreEqual(1, requests.Length);
             CheckEvalAssignmentRequestFieldValues(requests[0], dte_nt, SEEvalRequestType.ASSIGNED_EVALUATOR, SEEvalRequestStatus.PENDING);

             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForEvaluator(dte_othello.Id, Fixture.CurrentSchoolYear, PilotDistricts.Othello);
             Assert.AreEqual(1, requests.Length);
             CheckEvalAssignmentRequestFieldValues(requests[0], dte_othello, SEEvalRequestType.ASSIGNED_EVALUATOR, SEEvalRequestStatus.PENDING);

             // retrieve them by the different methods
             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForDistrict(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear);
             Assert.AreEqual(1, requests.Length);

             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForDistrict(PilotDistricts.Othello, Fixture.CurrentSchoolYear);
             Assert.AreEqual(1, requests.Length);

             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForSchool(PilotSchools.NorthThurston_NorthThurstonHS, Fixture.CurrentSchoolYear);
             Assert.AreEqual(1, requests.Length);

             // delete the north thurston requestion
             Fixture.SEMgr.DeleteEvalAssignmentRequest(requests[0].Id);
             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForSchool(PilotSchools.NorthThurston_NorthThurstonHS, Fixture.CurrentSchoolYear);
             Assert.AreEqual(0, requests.Length);

             // make sure the othello one is still there
             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForEvaluator(dte_othello.Id, Fixture.CurrentSchoolYear, PilotDistricts.Othello);
             Assert.AreEqual(1, requests.Length);
             CheckEvalAssignmentRequestFieldValues(requests[0], dte_othello, SEEvalRequestType.ASSIGNED_EVALUATOR, SEEvalRequestStatus.PENDING);

             // change the status
             Fixture.SEMgr.UpdateEvalAssignmentRequestStatus(teacher1_othello.Id, dte_othello.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, dte_othello.DistrictCode, SEEvalRequestStatus.ACCEPTED);
             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForEvaluator(dte_othello.Id, Fixture.CurrentSchoolYear, PilotDistricts.Othello);
             CheckEvalAssignmentRequestFieldValues(requests[0], dte_othello, SEEvalRequestType.ASSIGNED_EVALUATOR, SEEvalRequestStatus.ACCEPTED);
             Assert.AreEqual(dte_othello.Id, Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1_othello.Id, Fixture.CurrentSchoolYear, teacher1_othello.DistrictCode).EvaluatorId);

             // change the request type and make sure the assigned evaluator is updated correctly
             Fixture.SEMgr.UpdateEvalAssignmentRequestType(teacher1_othello.Id, dte_othello.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, dte_othello.DistrictCode, SEEvalRequestType.OBSERVATION_ONLY);
             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForEvaluator(dte_othello.Id, Fixture.CurrentSchoolYear, PilotDistricts.Othello);
             CheckEvalAssignmentRequestFieldValues(requests[0], dte_othello, SEEvalRequestType.OBSERVATION_ONLY, SEEvalRequestStatus.ACCEPTED);
             Assert.AreEqual(-1, Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1_othello.Id, Fixture.CurrentSchoolYear, teacher1_othello.DistrictCode).EvaluatorId);

             Fixture.SEMgr.UpdateEvalAssignmentRequestType(teacher1_othello.Id, dte_othello.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, dte_othello.DistrictCode, SEEvalRequestType.ASSIGNED_EVALUATOR);
             requests = Fixture.SEMgr.GetEvalAssignmentRequestsForEvaluator(dte_othello.Id, Fixture.CurrentSchoolYear, PilotDistricts.Othello);
             CheckEvalAssignmentRequestFieldValues(requests[0], dte_othello, SEEvalRequestType.ASSIGNED_EVALUATOR, SEEvalRequestStatus.ACCEPTED);
             Assert.AreEqual(dte_othello.Id, Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1_othello.Id, Fixture.CurrentSchoolYear, teacher1_othello.DistrictCode).EvaluatorId);
           }
 
    }
}
