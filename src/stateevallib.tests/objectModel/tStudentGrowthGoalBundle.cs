using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;

using NUnit.Framework;
using DbUtils;

using RepositoryLib;
using StateEval;

namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tStudentGrowthGoalBundle : tBase
    {
        
        SEStudentGrowthGoalBundle CreateTestStudentGrowthGoalBundleInner()
        {
            SEUser tr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(tr_nt.Id, Fixture.CurrentSchoolYear, tr_nt.DistrictCode);

            SEStudentGrowthGoalBundle b = SEStudentGrowthGoalBundle.Create(e.Id, "Title", "Comments", "Course", "Grade");
            b.Save();
            return b;
        }

        [Test]
        public void CreateStudentGrowthGoalBundle()
        {
            SEStudentGrowthGoalBundle b = CreateTestStudentGrowthGoalBundleInner();
            SEStudentGrowthGoalBundle b2 = SEStudentGrowthGoalBundle.Get(b.Id);
            Assert.AreEqual(b2.Comments, b.Comments);
            Assert.AreEqual(b2.Title, b.Title);
            Assert.AreEqual(b2.Course, b.Course);
            Assert.AreEqual(b2.Grade, b.Grade);
            Assert.AreEqual(b2.WfState, b.WfState);
        }

        [Test]
        public void UpdateStudentGrowthGoalBundle()
        {
            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);

            SEStudentGrowthGoalBundle b = CreateTestStudentGrowthGoalBundleInner();
            b.Comments = "Comments2";
            b.Title = "Title2";
            b.Course = "Course2";
            b.Grade = "Grade2";

            b.WfState = SEWfState.GOAL_IN_PROGRESS;
            b.Save();

            SEStudentGrowthGoalBundle b2 = SEStudentGrowthGoalBundle.Get(b.Id);
            Assert.AreEqual(b2.Comments, b.Comments);
            Assert.AreEqual(b2.Title, b.Title);
            Assert.AreEqual(b2.Course, b.Course);
            Assert.AreEqual(b2.Grade, b.Grade);
            Assert.AreEqual(b2.WfState, b.WfState);
        }

        [Test]
        public void CreateStudentGrowthGoalBundles()
        {
            SEStudentGrowthGoalBundle b = CreateTestStudentGrowthGoalBundleInner();
            SEStudentGrowthGoalBundle b2 = CreateTestStudentGrowthGoalBundleInner();
        
            List<SEStudentGrowthGoalBundle> bundles = SEStudentGrowthGoalBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.GOAL_IN_PROGRESS);
            Assert.AreEqual(2, bundles.Count);
        }

        [Test]
        public void DeleteStudentGrowthGoalBundle()
        {
            SEStudentGrowthGoalBundle b = CreateTestStudentGrowthGoalBundleInner();
            SEStudentGrowthGoalBundle b2 = CreateTestStudentGrowthGoalBundleInner();

            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            SEFrameworkNode c3Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C3");
            SEFrameworkNode c6Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C6");
            SEFrameworkNode c8Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C8");

            SEStudentGrowthGoal g = CreateTestStudentGrowthGoal(b, c3Node);
            g = CreateTestStudentGrowthGoal(b, c6Node);
            g = CreateTestStudentGrowthGoal(b, c8Node);

            b.Delete();

            b = SEStudentGrowthGoalBundle.Get(b.Id);
            Assert.IsNull(b);
            b2 = SEStudentGrowthGoalBundle.Get(b2.Id);
            Assert.IsNotNull(b2);
        }


        SEStudentGrowthGoal CreateTestStudentGrowthGoal(SEStudentGrowthGoalBundle b, SEFrameworkNode n)
        {
            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            SEFrameworkNode node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, n.ShortName);

            SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C3");

            SEUser tr_nt = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvaluation e = SEMgr.Instance.GetEvaluationDataForEvaluatee(tr_nt.Id, Fixture.CurrentSchoolYear, tr_nt.DistrictCode);

            SEStudentGrowthGoal g = SEStudentGrowthGoal.Create(b.Id, e.Id, node.Id, Fixture.FindRubricRowTitleStartWith(rrows, "SG 3.1").Id,
                Fixture.FindRubricRowTitleStartWith(rrows, "SG 3.2").Id);

            g.Save();
            return g;
        }

        [Test]
        public void CreateAndUpdateStudentGrowthGoal()
        {
            SEStudentGrowthGoalBundle b = CreateTestStudentGrowthGoalBundleInner();

            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            SEFrameworkNode c3Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C3");

            SEStudentGrowthGoal g = CreateTestStudentGrowthGoal(b, c3Node);
            g.Save();

            SEStudentGrowthGoal g2 = SEStudentGrowthGoal.Get(g.Id);
            Assert.AreEqual(g.EvaluationId, g2.EvaluationId);
            Assert.AreEqual(g.FrameworkNodeId, g2.FrameworkNodeId);
            Assert.AreEqual(g.GoalBundleId, g2.GoalBundleId);

            g.EvidenceAll = "EvidenceAll2";
            g.EvidenceMost = "EvidenceMost2";
            g.GoalStatement = "GoalStatement2";
            g.GoalTargets = "GoalTargets2";

            g.Save();

            g2 = SEStudentGrowthGoal.Get(g.Id);
            Assert.AreEqual(g.EvidenceMost, g2.EvidenceMost);
            Assert.AreEqual(g.EvidenceAll, g2.EvidenceAll);
            Assert.AreEqual(g.GoalStatement, g2.GoalStatement);
            Assert.AreEqual(g.GoalTargets, g2.GoalTargets);

            g.ProcessPerformanceLevel = SERubricPerformanceLevel.PL1;
            g.SaveProcessScore();
            g2 = SEStudentGrowthGoal.Get(g.Id);
            Assert.AreEqual(g.ProcessPerformanceLevel, g2.ProcessPerformanceLevel);
            Assert.AreEqual(g.ResultsPerformanceLevel, g2.ResultsPerformanceLevel);

            g.ResultsPerformanceLevel = SERubricPerformanceLevel.PL2;
            g.SaveResultScore();
            g2 = SEStudentGrowthGoal.Get(g.Id);
            Assert.AreEqual(g.ProcessPerformanceLevel, g2.ProcessPerformanceLevel);
            Assert.AreEqual(g.ResultsPerformanceLevel, g2.ResultsPerformanceLevel);
        }

        [Test]
        public void CreateAddingMultipleStudentGrowthGoals()
        {
            SEStudentGrowthGoalBundle b = CreateTestStudentGrowthGoalBundleInner();

            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            SEFrameworkNode c3Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C3");
            SEFrameworkNode c6Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C6");
            SEFrameworkNode c8Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C8");

            SEStudentGrowthGoal g = CreateTestStudentGrowthGoal(b, c3Node);
            g = CreateTestStudentGrowthGoal(b, c6Node);
            g = CreateTestStudentGrowthGoal(b, c8Node);

            List<SEStudentGrowthGoal> goals = b.Goals;
            Assert.AreEqual(3, goals.Count);
        }


        void GetStudentGrowthGoalBundlesByWfStateInner(SEStudentGrowthGoalBundle b, int bundleCount, int inprogressCount, int submittedCount) 
        {
            Assert.AreEqual(bundleCount, SEStudentGrowthGoalBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.UNDEFINED).Count);
            Assert.AreEqual(inprogressCount, SEStudentGrowthGoalBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.GOAL_IN_PROGRESS).Count);
            Assert.AreEqual(submittedCount, SEStudentGrowthGoalBundle.GetBundlesForEvaluation(b.EvaluationId, SEWfState.GOAL_SUBMITTED).Count);
        }

        [Test]
        public void GetStudentGrowthGoalBundlesByWfState()
        {
            SEStudentGrowthGoalBundle b = CreateTestStudentGrowthGoalBundleInner();

            GetStudentGrowthGoalBundlesByWfStateInner(b, 1, 1, 0);

            b = SEStudentGrowthGoalBundle.Get(b.Id);
            Assert.AreEqual(SEWfState.GOAL_IN_PROGRESS, b.WfState);

            b.WfState = SEWfState.GOAL_SUBMITTED;
            b.Save();

            GetStudentGrowthGoalBundlesByWfStateInner(b, 1, 0, 1);
        }
    }
}
