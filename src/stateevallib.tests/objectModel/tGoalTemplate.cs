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

using RepositoryLib;

namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tGoalTemplate : tBase
    {
        SESchoolYear SchoolYear = SESchoolYear.SY_2015;

        SEGoalTemplate GoalTemplate { get; set; }

        SEGoalTemplate CreateTemplate(SEUser u, SEGoalTemplateType templateType, SEEvaluationType evalType, string title)
        {
            long id = SEMgr.Instance.InsertGoalTemplate(u.Id, templateType, evalType, SchoolYear, title, u.DistrictCode);
            return SEMgr.Instance.GoalTemplate(id);
        }

        void GoalTemplate_GoalOutcomeGet(SEGoalTemplate t, int goalIndex, string Outcome)
        {
            Assert.AreEqual(Outcome, t.Goals[goalIndex].Outcome);
        }

        void GoalTemplate_GoalOutcomeSetGet(SEGoalTemplate t, int goalIndex, string Outcome)
        {
            SEMgr.Instance.UpdateGoalResultOutcome(t.Goals[goalIndex].Id, Outcome);
            GoalTemplate_GoalOutcomeGet(t, goalIndex, Outcome);
        }

        [Test]
        public void GoalTemplate_GoalOutcome()
        {
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SEGoalTemplate t = CreateTemplate(u, SEGoalTemplateType.STUDENT_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, "Test");
            GoalTemplate_GoalOutcomeSetGet(t, 0, "Test Outcome 1");
            GoalTemplate_GoalOutcomeSetGet(t, 1, "Test Outcome 2");
            GoalTemplate_GoalOutcomeGet(t, 0, "Test Outcome 1");

            t = CreateTemplate(u, SEGoalTemplateType.PROFESSIONAL_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, "Test");
            GoalTemplate_GoalOutcomeSetGet(t, 0, "Test Outcome 1");

            t = CreateTemplate(u, SEGoalTemplateType.STUDENT_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, "Test");
            GoalTemplate_GoalOutcomeSetGet(t, 0, "Test Outcome 1");
            GoalTemplate_GoalOutcomeSetGet(t, 1, "Test Outcome 2");
            GoalTemplate_GoalOutcomeGet(t, 0, "Test Outcome 1");

            t = CreateTemplate(u, SEGoalTemplateType.PROFESSIONAL_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, "Test");
            GoalTemplate_GoalOutcomeSetGet(t, 0, "Test Outcome 1");
        }

        void GoalTemplate_GoalReflectionGet(SEGoalTemplate t, int goalIndex, string reflection)
        {
            Assert.AreEqual(reflection, t.Goals[goalIndex].Reflection);
        }

        void GoalTemplate_GoalReflectionSetGet(SEGoalTemplate t, int goalIndex, string reflection)
        {
            SEMgr.Instance.UpdateGoalResultReflection(t.Goals[goalIndex].Id, reflection);
            GoalTemplate_GoalReflectionGet(t, goalIndex, reflection);
        }

        [Test]
        public void GoalTemplate_GoalReflection()
        {
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SEGoalTemplate t = CreateTemplate(u, SEGoalTemplateType.STUDENT_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, "Test");
            GoalTemplate_GoalReflectionSetGet(t, 0, "Test Reflection 1");
            GoalTemplate_GoalReflectionSetGet(t, 1, "Test Reflection 2");
            GoalTemplate_GoalReflectionGet(t, 0, "Test Reflection 1");

            t = CreateTemplate(u, SEGoalTemplateType.PROFESSIONAL_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, "Test");
            GoalTemplate_GoalReflectionSetGet(t, 0, "Test Reflection 1");

            t = CreateTemplate(u, SEGoalTemplateType.STUDENT_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, "Test");
            GoalTemplate_GoalReflectionSetGet(t, 0, "Test Reflection 1");
            GoalTemplate_GoalReflectionSetGet(t, 1, "Test Reflection 2");
            GoalTemplate_GoalReflectionGet(t, 0, "Test Reflection 1");

            t = CreateTemplate(u, SEGoalTemplateType.PROFESSIONAL_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, "Test");
            GoalTemplate_GoalReflectionSetGet(t, 0, "Test Reflection 1");
        }


        void GoalTemplate_GoalStatementGet(SEGoalTemplate t, int goalIndex, string statement)
        {
            Assert.AreEqual(statement, t.Goals[goalIndex].GoalStatement);
        }

        void GoalTemplate_GoalStatementSetGet(SEGoalTemplate t, int goalIndex, string statement)
        {
            SEMgr.Instance.UpdateGoalTemplateGoalStatement(t.Goals[goalIndex].Id, statement);
            GoalTemplate_GoalStatementGet(t, goalIndex, statement);
        }

        [Test]
        public void GoalTemplate_GoalStatement()
        {
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SEGoalTemplate t = CreateTemplate(u, SEGoalTemplateType.STUDENT_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, "Test");
            GoalTemplate_GoalStatementSetGet(t, 0, "Test Statement 1");
            GoalTemplate_GoalStatementSetGet(t, 1, "Test Statement 2");
            GoalTemplate_GoalStatementGet(t, 0, "Test Statement 1");

            t = CreateTemplate(u, SEGoalTemplateType.PROFESSIONAL_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, "Test");
            GoalTemplate_GoalStatementSetGet(t, 0, "Test Statement 1");

            t = CreateTemplate(u, SEGoalTemplateType.STUDENT_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, "Test");
            GoalTemplate_GoalStatementSetGet(t, 0, "Test Statement 1");
            GoalTemplate_GoalStatementSetGet(t, 1, "Test Statement 2");
            GoalTemplate_GoalStatementGet(t, 0, "Test Statement 1");

            t = CreateTemplate(u, SEGoalTemplateType.PROFESSIONAL_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, "Test");
            GoalTemplate_GoalStatementSetGet(t, 0, "Test Statement 1");
        }

        void GoalTemplate_GoalProcessGet(SEGoalTemplate t, int goalIndex, int stepIndex, string response)
        {
            Assert.AreEqual(response, Fixture.SEMgr.GetGoalTemplateProcessSteps(t.Id, t.Goals[goalIndex].RubricRowId)[stepIndex].Response);
        }
        void GoalTemplate_GoalProcessSetGet(SEGoalTemplate t, int goalIndex, int stepIndex, string response)
        {
            Fixture.SEMgr.UpdateGoalProcessStep(Fixture.SEMgr.GetGoalTemplateProcessSteps(t.Id, t.Goals[goalIndex].RubricRowId)[stepIndex].Id, response);
            GoalTemplate_GoalProcessGet(t, goalIndex, stepIndex, response);     
        }

        void GoalTemplate_GoalProcessInner(SEGoalTemplateType templateType, SEEvaluationType evalType, int stepCount)
        {
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SEGoalTemplate t = CreateTemplate(u, templateType, evalType, "Test");
            SEGoalProcessStep[] steps = Fixture.SEMgr.GetGoalTemplateProcessSteps(t.Id, t.Goals[0].RubricRowId);
            Assert.AreEqual(stepCount, steps.Length);

            GoalTemplate_GoalProcessSetGet(t, 0, 0, "Response 1");
            GoalTemplate_GoalProcessSetGet(t, 0, 1, "Response 2");
            // make sure the first one is still ok after another one is set
            GoalTemplate_GoalProcessGet(t, 0, 0, "Response 1");
        }

        void GoalTemplate_GoalProcessInner(SEGoalTemplateType templateType, SEEvaluationType evalType, int g1stepCount, int g2stepCount, int g3stepCount)
        {
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SEGoalTemplate t = CreateTemplate(u, templateType, evalType, "Test");
            Assert.AreEqual(g1stepCount, Fixture.SEMgr.GetGoalTemplateProcessSteps(t.Id, t.Goals[0].RubricRowId).Length);
            Assert.AreEqual(g2stepCount, Fixture.SEMgr.GetGoalTemplateProcessSteps(t.Id, t.Goals[1].RubricRowId).Length);
            Assert.AreEqual(g3stepCount, Fixture.SEMgr.GetGoalTemplateProcessSteps(t.Id, t.Goals[2].RubricRowId).Length);

            GoalTemplate_GoalProcessSetGet(t, 0, 0, "Response 1");
            GoalTemplate_GoalProcessSetGet(t, 0, 1, "Response 2");
            // make sure the first one is still ok after another one is set
            GoalTemplate_GoalProcessGet(t, 0, 0, "Response 1");
        }

        [Test]
        public void GoalTemplate_GoalProcess()
        {
            GoalTemplate_GoalProcessInner(SEGoalTemplateType.STUDENT_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, 5);
            GoalTemplate_GoalProcessInner(SEGoalTemplateType.STUDENT_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, 4, 6, 4);

            GoalTemplate_GoalProcessInner(SEGoalTemplateType.PROFESSIONAL_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, 6);
            GoalTemplate_GoalProcessInner(SEGoalTemplateType.PROFESSIONAL_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, 6);
        }

        public SEGoalTemplate GoalTemplate_TestPropertiesInner(SEUser u, string title, SEGoalTemplateType templateType, SEEvaluationType evalType)
        {
            SEGoalTemplate t = CreateTemplate(u, templateType, evalType, title);
            Assert.AreEqual(title, t.Title);
            Assert.AreEqual(templateType, t.TemplateType);
            Assert.AreEqual(SchoolYear, t.SchoolYear);
            Assert.AreEqual(0, t.RubricRowScores.Length);
            Assert.AreEqual(evalType, t.EvaluationType);
            Assert.AreEqual(u.Id, t.UserId);

            return t;
        }

        [Test]
        public void GoalTemplate_TestProperties()
        {
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SEGoalTemplate t;

            t = GoalTemplate_TestPropertiesInner(u, "New Student Growth Goals", SEGoalTemplateType.STUDENT_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION);
            Assert.AreEqual(3,t.Goals.Length);

            SEFramework f = Fixture.GetFrameworkForDistrict(u.DistrictCode, SchoolYear, SEFrameworkType.TSTATE);
            SEFrameworkNode[] nodes = f.AllStudentGrowthNodes;
            Assert.IsNotNull(FindGoal(t.Goals, Fixture.FindRubricRowWithShortName(Fixture.FindFrameworkNodeWithShortName(nodes, "C3").StudentGrowthRubricRows, "SG 3.1").Id));
            Assert.IsNotNull(FindGoal(t.Goals, Fixture.FindRubricRowWithShortName(Fixture.FindFrameworkNodeWithShortName(nodes, "C6").StudentGrowthRubricRows, "SG 6.1").Id));
            Assert.IsNotNull(FindGoal(t.Goals, Fixture.FindRubricRowWithShortName(Fixture.FindFrameworkNodeWithShortName(nodes, "C8").StudentGrowthRubricRows, "SG 8.1").Id));

            t = GoalTemplate_TestPropertiesInner(u, "New Student Growth Goals", SEGoalTemplateType.STUDENT_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION);
            Assert.AreEqual(3,t.Goals.Length);
            
            f = Fixture.GetFrameworkForDistrict(u.DistrictCode, SchoolYear, SEFrameworkType.PSTATE);
            nodes = f.AllStudentGrowthNodes;
            Assert.IsNotNull(FindGoal(t.Goals, Fixture.FindRubricRowWithShortName(Fixture.FindFrameworkNodeWithShortName(nodes, "C3").StudentGrowthRubricRows, "SG 3.5").Id));
            Assert.IsNotNull(FindGoal(t.Goals, Fixture.FindRubricRowWithShortName(Fixture.FindFrameworkNodeWithShortName(nodes, "C5").StudentGrowthRubricRows, "SG 5.5").Id));
            Assert.IsNotNull(FindGoal(t.Goals, Fixture.FindRubricRowWithShortName(Fixture.FindFrameworkNodeWithShortName(nodes, "C8").StudentGrowthRubricRows, "SG 8.3").Id));


            t = GoalTemplate_TestPropertiesInner(u, "New PD Goal", SEGoalTemplateType.PROFESSIONAL_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION);
            Assert.AreEqual(1,t.Goals.Length);
            Assert.AreEqual(-1, t.Goals[0].RubricRowId);

            t = GoalTemplate_TestPropertiesInner(u, "New PD Goal", SEGoalTemplateType.PROFESSIONAL_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION);
            Assert.AreEqual(1,t.Goals.Length);
            Assert.AreEqual(-1, t.Goals[0].RubricRowId);
        }

        SEGoalTemplateGoal FindGoal(SEGoalTemplateGoal[] goals, long rrId)
        {
            foreach (SEGoalTemplateGoal g in goals)
            {
                if (g.RubricRowId == rrId)
                {
                    return g;
                }
            }
            return null;
        }

        SERubricPerformanceLevel FindScoreForGoal(SEGoalTemplateGoal goal, SEGoalTemplateRubricRowScore[] scores)
        {
            foreach (SEGoalTemplateRubricRowScore s in scores)
            {
                if (s.RubricRowId == goal.RubricRowId)
                {
                    return s.PerformanceLevel;
                }
            }
            return SERubricPerformanceLevel.UNDEFINED;
        }

        void GoalTemplate_TestRubricScoreInner(SEUser u, SEGoalTemplate t, SEGoalTemplateGoal goal, long rrId, SERubricPerformanceLevel pl)
        {
            SEMgr.Instance.ScoreGoalTemplateRubricRow(u.Id, t.Id, rrId, pl);
            SEGoalTemplateRubricRowScore[] scores = t.RubricRowScores;
            Assert.AreEqual(pl, FindScoreForGoal(goal, scores));
        }

        public void GoalTemplate_RubricScoresInner(SEGoalTemplateType templateType, SEEvaluationType evalType, SEFrameworkType frameworkType, string fnShortName, string rrShortName)
        {
            SEUser u = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEGoalTemplate t1 = CreateTemplate(u, templateType, evalType, "Test 1");

            SEUser u2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEGoalTemplate t2 = CreateTemplate(u2, templateType, evalType, "Test 2");

            SEFramework f = Fixture.GetFrameworkForDistrict(u2.DistrictCode, SchoolYear, frameworkType);
            SEFrameworkNode[] nodes = f.AllStudentGrowthNodes;
            SEFrameworkNode fn = Fixture.FindFrameworkNodeWithShortName(nodes, fnShortName);
            SERubricRow[] sgRubricRows = fn.StudentGrowthRubricRows;
            SERubricRow rr = Fixture.FindRubricRowWithShortName(sgRubricRows, rrShortName);

            SEGoalTemplateGoal[] goals1 = SEMgr.Instance.GoalTemplateGoals(t1.Id);

            SEGoalTemplateGoal goal1 = FindGoal(goals1, rr.Id);

            SEGoalTemplateGoal[] goals2 = SEMgr.Instance.GoalTemplateGoals(t2.Id);

            SEGoalTemplateGoal goal2 = FindGoal(goals2, rr.Id);

            Assert.AreEqual(rr.Id, goal1.RubricRowId);
            Assert.AreEqual(t1.Id, goal1.GoalTemplateId);

            GoalTemplate_TestRubricScoreInner(u, t1, goal1, rr.Id, SERubricPerformanceLevel.PL1);
            GoalTemplate_TestRubricScoreInner(u, t1, goal1, rr.Id, SERubricPerformanceLevel.PL2);
            GoalTemplate_TestRubricScoreInner(u, t1, goal1, rr.Id, SERubricPerformanceLevel.PL3);
            GoalTemplate_TestRubricScoreInner(u, t1, goal1, rr.Id, SERubricPerformanceLevel.PL4);
            GoalTemplate_TestRubricScoreInner(u, t1, goal1, rr.Id, SERubricPerformanceLevel.UNDEFINED);
            GoalTemplate_TestRubricScoreInner(u, t1, goal1, rr.Id, SERubricPerformanceLevel.PL1);

            GoalTemplate_TestRubricScoreInner(u, t2, goal1, rr.Id, SERubricPerformanceLevel.PL1);
            GoalTemplate_TestRubricScoreInner(u, t2, goal1, rr.Id, SERubricPerformanceLevel.PL2);
            GoalTemplate_TestRubricScoreInner(u, t2, goal1, rr.Id, SERubricPerformanceLevel.PL3);
            GoalTemplate_TestRubricScoreInner(u, t2, goal1, rr.Id, SERubricPerformanceLevel.PL4);
            GoalTemplate_TestRubricScoreInner(u, t2, goal1, rr.Id, SERubricPerformanceLevel.UNDEFINED);        
 
            // make sure t1 is still intacts
            SEGoalTemplateRubricRowScore[] scores = t1.RubricRowScores;
            Assert.AreEqual(SERubricPerformanceLevel.PL1, FindScoreForGoal(goal1, scores));
        }

        [Test]
        public void GoalTemplate_RubricScores()
        {
            GoalTemplate_RubricScoresInner(SEGoalTemplateType.STUDENT_GROWTH_TR_2015, SEEvaluationType.TEACHER_OBSERVATION, SEFrameworkType.TSTATE, "C3", "SG 3.1");
            GoalTemplate_RubricScoresInner(SEGoalTemplateType.STUDENT_GROWTH_PR_2015, SEEvaluationType.PRINCIPAL_OBSERVATION, SEFrameworkType.PSTATE, "C3", "SG 3.5");
        }
     }
}
