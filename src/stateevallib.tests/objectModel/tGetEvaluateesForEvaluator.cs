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
    class tGetEvaluateesForEvaluator : tBase
    {
         [Test]
         public void SA_TR()
         {
             SEUser teacher1_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
             SEUser teacher2_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
             SEUser teacher3_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_TMS);
             SEUser sa_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_AD);

 
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, true, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, false, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, true, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);

             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, false, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);

             // submit T1
             Fixture.SEMgr.SubmitFinalScore(teacher1_nt.Id, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode);

             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, true, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, false, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, true, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);

             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, false, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(sa_nt, SEActiveEvaluatorRole.SA_TR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);
         }

         [Test]
         public void PR_TR()
         {
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser teacher1_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
             SEUser teacher2_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
             SEUser teacher3_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_TMS);

             Fixture.SEMgr.AssignEvaluatorToEvaluatee(teacher1_nt.Id, pr_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, true);
             Fixture.SEMgr.AssignEvaluatorToEvaluatee(teacher2_nt.Id, pr_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, false);
             Fixture.SEMgr.AssignEvaluatorToEvaluatee(teacher3_nt.Id, pr_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, false);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, true, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, false, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, true, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, false, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);

             // submit T1
             Fixture.SEMgr.SubmitFinalScore(teacher1_nt.Id, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, true, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, false, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, true, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);

             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, false, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(pr_nt, SEActiveEvaluatorRole.PR_TR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);
         }

         [Test]
         public void DTE_TR()
         {
             SEUser dte_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DTE);
             SEUser teacher1_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
             SEUser teacher2_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);

             Fixture.SEMgr.InsertEvalAssignmentRequest(dte_nt.Id, teacher1_nt.Id, Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston);
             Fixture.SEMgr.InsertEvalAssignmentRequest(dte_nt.Id, teacher2_nt.Id, Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston);

             // make T1 observations_only, T2 assigned evaluator
             Fixture.SEMgr.UpdateEvalAssignmentRequestType(teacher1_nt.Id, dte_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, dte_nt.DistrictCode, SEEvalRequestType.OBSERVATION_ONLY);
             Fixture.SEMgr.UpdateEvalAssignmentRequestStatus(teacher1_nt.Id, dte_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, dte_nt.DistrictCode, SEEvalRequestStatus.ACCEPTED);

             Fixture.SEMgr.UpdateEvalAssignmentRequestType(teacher2_nt.Id, dte_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, dte_nt.DistrictCode, SEEvalRequestType.ASSIGNED_EVALUATOR);
             Fixture.SEMgr.UpdateEvalAssignmentRequestStatus(teacher2_nt.Id, dte_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, dte_nt.DistrictCode, SEEvalRequestStatus.ACCEPTED);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, true, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, false, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, true, SEEvaluateeSubmissionRetrievalType.All, 2);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, false, SEEvaluateeSubmissionRetrievalType.All, 2);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);

             // submit T1, observation only
             Fixture.SEMgr.SubmitFinalScore(teacher1_nt.Id, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, true, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, false, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, true, SEEvaluateeSubmissionRetrievalType.All, 2);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, false, SEEvaluateeSubmissionRetrievalType.All, 2);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(dte_nt, SEActiveEvaluatorRole.DTE_TR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);
         }

         [Test]
         public void DE_PR()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
             SEUser de_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser pr_aspire = Fixture.SEMgr.SEUser(Fixture.AspireMSUserName_PR);
             SEUser pr_horizon = Fixture.SEMgr.SEUser(Fixture.HorizonsMSUserName_PR);

             Fixture.SEMgr.AssignEvaluatorToEvaluatee(pr_nt.Id, de_nt.Id, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear, true);
             Fixture.SEMgr.AssignEvaluatorToEvaluatee(pr_aspire.Id, de_nt.Id, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear, true);
             Fixture.SEMgr.AssignEvaluatorToEvaluatee(pr_horizon.Id, de_nt.Id, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear, true);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, true, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, false, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, true, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 67);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, false, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 67);

             // submit pr_nt
             Fixture.SEMgr.SubmitFinalScore(pr_nt.Id, Fixture.CurrentSchoolYear, de_nt.DistrictCode);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, true, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, false, SEEvaluateeSubmissionRetrievalType.All, 3);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 2);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, true, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 66);

             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, false, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(de_nt, SEActiveEvaluatorRole.DE_PR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 66);
         }

         [Test]
         public void DA_PR()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
             SEUser da_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DA);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser pr_aspire = Fixture.SEMgr.SEUser(Fixture.AspireMSUserName_PR);
             SEUser pr_horizon = Fixture.SEMgr.SEUser(Fixture.HorizonsMSUserName_PR);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, true, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, false, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, true, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 67);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, false, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 67);

             // submit pr_nt
             Fixture.SEMgr.SubmitFinalScore(pr_nt.Id, Fixture.CurrentSchoolYear, da_nt.DistrictCode);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, true, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, false, SEEvaluateeSubmissionRetrievalType.All, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, true, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 66);

             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, false, SEEvaluateeSubmissionRetrievalType.All, 67);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(da_nt, SEActiveEvaluatorRole.DA_PR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 66);
         }

         [Test]
         public void PRH_PR()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
             SEUser prh_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PRH);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             Fixture.SEMgr.AssignEvaluatorToEvaluatee(pr_nt.Id, prh_nt.Id, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear, true);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, true, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, false, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 1);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, true, SEEvaluateeSubmissionRetrievalType.All, 4);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 4);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, false, SEEvaluateeSubmissionRetrievalType.All, 4);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 0);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 4);

             // submit pr_nt
             Fixture.SEMgr.SubmitFinalScore(pr_nt.Id, Fixture.CurrentSchoolYear, prh_nt.DistrictCode);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, true, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, false, SEEvaluateeSubmissionRetrievalType.All, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, true, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 0);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, true, SEEvaluateeSubmissionRetrievalType.All, 4);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, true, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, true, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);

             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, false, SEEvaluateeSubmissionRetrievalType.All, 4);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, false, SEEvaluateeSubmissionRetrievalType.Submitted, 1);
             VerifyGetEvaluateesForEvaluator(prh_nt, SEActiveEvaluatorRole.PR_PR, false, false, SEEvaluateeSubmissionRetrievalType.NotSubmitted, 3);
         }

         protected void VerifyGetEvaluateesForEvaluator(SEUser evaluator, SEActiveEvaluatorRole role, bool assignedOnly, bool includeEvalData, SEEvaluateeSubmissionRetrievalType retrievalType, int userCount)
         {
             SEUser[] users = SEMgr.Instance.GetEvaluateesForEvaluator(evaluator, Fixture.CurrentSchoolYear, role, assignedOnly, includeEvalData, retrievalType);
             Assert.AreEqual(userCount, users.Length);
             if (userCount > 0)
             {
                 if (includeEvalData)
                 {
                     Assert.IsNotNull(users[0].UserEvaluation);
                 }
                 else
                 {
                     Assert.IsNull(users[0].UserEvaluation);
                 }
             }
         }

 
    }
}
