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
    class tEvaluation : tBase
    {

         [Test]
         public void MultipleSchoolYears()
         {
             SEUser da_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DA);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser tr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEEvaluation[] e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, pr_nt.DistrictCode);
             Assert.AreEqual(1, e.Length);

             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(tr_nt.Id, tr_nt.DistrictCode);
             Assert.AreEqual(1, e.Length);

             Fixture.SEMgr.LoadFrameworkSet("BPRIN", da_nt.DistrictCode, da_nt.District, "Principal", Convert.ToInt32(SESchoolYear.SY_2014));
             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, pr_nt.DistrictCode);
             Assert.AreEqual(2, e.Length);

             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(tr_nt.Id, tr_nt.DistrictCode);
             Assert.AreEqual(1, e.Length);

             Fixture.SEMgr.LoadFrameworkSet("BDAN", da_nt.DistrictCode, da_nt.District, "Teacher", Convert.ToInt32(SESchoolYear.SY_2014));
             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, pr_nt.DistrictCode);
             Assert.AreEqual(2, e.Length);

             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(tr_nt.Id, tr_nt.DistrictCode);
             Assert.AreEqual(2, e.Length);
         }

         [Test]
         public void DTE()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
 
             SEUser dte_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DTE);
             SEUser teacher1_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             // insert a request for both north thurston
             Fixture.SEMgr.InsertEvalAssignmentRequest(dte_nt.Id, teacher1_nt.Id, Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston);

             SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(teacher1_nt.Id, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode);
             Assert.AreEqual(-1, e.EvaluatorId);

             Fixture.SEMgr.UpdateEvalAssignmentRequestStatus(teacher1_nt.Id, dte_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode, SEEvalRequestStatus.ACCEPTED);
             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(teacher1_nt.Id, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode);
             Assert.AreEqual(dte_nt.Id, e.EvaluatorId);

             Fixture.SEMgr.UpdateEvalAssignmentRequestType(teacher1_nt.Id, dte_nt.Id, SEEvaluationType.TEACHER_OBSERVATION, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode, SEEvalRequestType.OBSERVATION_ONLY);
             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(teacher1_nt.Id, Fixture.CurrentSchoolYear, teacher1_nt.DistrictCode);
             Assert.AreEqual(-1, e.EvaluatorId);

        }

         [Test]
         public void AssignedEvaluator()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
             SEUser de_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             Fixture.SEMgr.AssignEvaluatorToEvaluatee(pr_nt.Id, de_nt.Id, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear, true);
             SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             Assert.AreEqual(de_nt.Id, e.EvaluatorId);
         }

         [Test]
         public void SubmissionStatus()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
             SEUser de_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             Fixture.SEMgr.AssignEvaluatorToEvaluatee(pr_nt.Id, de_nt.Id, SEEvaluationType.PRINCIPAL_OBSERVATION, Fixture.CurrentSchoolYear, true);
             SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             Assert.AreEqual(false, e.HasBeenSubmitted);
             Assert.AreEqual(DateTime.MinValue, e.SubmissionDate);

             // submit pr_nt
             Fixture.SEMgr.ScoreFinalScore(de_nt.Id, pr_nt.Id, SERubricPerformanceLevel.PL1, Fixture.CurrentSchoolYear, de_nt.DistrictCode);
             Fixture.SEMgr.SubmitFinalScore(pr_nt.Id, Fixture.CurrentSchoolYear, de_nt.DistrictCode);
             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             Assert.AreEqual(true, e.HasBeenSubmitted);
             Assert.Greater(DateTime.Now, e.SubmissionDate);
         }

         [Test]
         public void PlanType()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
             SEUser de_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             Assert.AreEqual(SEEvaluateePlanType.COMPREHENSIVE, e.EvaluateePlanType);

             Fixture.SEMgr.UpdateEvaluateePlanType(pr_nt.Id, SEEvaluateePlanType.FOCUSED, Fixture.CurrentSchoolYear, pr_nt.DistrictCode, SEEvaluationType.PRINCIPAL_OBSERVATION);
             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             Assert.AreEqual(SEEvaluateePlanType.FOCUSED, e.EvaluateePlanType);
         }

         SEFrameworkNode FindFrameworkNode(SEFrameworkNode[] nodes, string shortName)
         {
             foreach (SEFrameworkNode n in nodes)
             {
                 if (n.ShortName == shortName)
                 {
                     return n;
                 }
             }
             return null;
         }

         [Test]
         public void Focus()
         {
             Fixture.SEMgrExecute("update SEEvaluation set EvaluatorID=null");
             SEUser de_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser pr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             SEFrameworkNode[] nodes = Fixture.SEMgr.GetStateFramework(pr_nt.DistrictCode, Fixture.CurrentSchoolYear, SEEvaluationType.PRINCIPAL_OBSERVATION).AllNodes;
             SEFrameworkNode fn = FindFrameworkNode(nodes, "C3");
             SEFrameworkNode focus_fn = FindFrameworkNode(nodes,"C8");
             Fixture.SEMgr.UpdateEvaluateePlanType(pr_nt.Id, SEEvaluateePlanType.FOCUSED, Fixture.CurrentSchoolYear, pr_nt.DistrictCode, SEEvaluationType.PRINCIPAL_OBSERVATION);
             Fixture.SEMgr.UpdateEvaluateeFocusFrameworkNode(pr_nt.Id, fn.Id, focus_fn.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode, SEEvaluationType.PRINCIPAL_OBSERVATION);

             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             Assert.AreEqual(fn.Id, e.FocusedFrameworkNodeId);
             Assert.AreEqual(focus_fn.Id, e.FocusedSGFrameworkNodeId);

             Fixture.SEMgr.UpdateEvaluateeFocusFrameworkNode(pr_nt.Id, null, null, Fixture.CurrentSchoolYear, pr_nt.DistrictCode, SEEvaluationType.PRINCIPAL_OBSERVATION);
             e = SEMgr.Instance.GetEvaluationDataForEvaluatee(pr_nt.Id, Fixture.CurrentSchoolYear, pr_nt.DistrictCode);
             Assert.AreEqual(-1, e.FocusedFrameworkNodeId);
             Assert.AreEqual(-1, e.FocusedSGFrameworkNodeId);
         }
 
    }
}
