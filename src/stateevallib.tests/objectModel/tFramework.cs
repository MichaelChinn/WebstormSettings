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
using StateEval.Security;

namespace StateEval.tests.objectModel
{
     [TestFixture]
    class tFramework : tBase
    {
         [Test]
         public void IDbObject()
         {
             SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.AreEqual(f.Id, ((IDbObject)f).Id);
         }

         protected void VerifyFrameworkLoad(SEFramework framework, string districtCode, string name, string description, SEFrameworkType frameworkType, SESchoolYear schoolYear)
         {
             Assert.IsNotNull(framework);
             Assert.AreEqual(districtCode, framework.DistrictCode);
             Assert.AreEqual(name, framework.Name);
             Assert.AreEqual(description, framework.Description);
             Assert.AreEqual(frameworkType, framework.FrameworkType);
             Assert.AreEqual(schoolYear, framework.SchoolYear);
         }

         [Test]
         public void Load()
         {
             VerifyFrameworkLoad(Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE), PilotDistricts.NorthThurston, "North Thurston Public Schools-TState", "", SEFrameworkType.TSTATE, SESchoolYear.SY_2013);
             VerifyFrameworkLoad(Fixture.SEMgr.Framework(PilotDistricts.Othello, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE), PilotDistricts.Othello, "Othello School District-TState", "", SEFrameworkType.TSTATE, SESchoolYear.SY_2013);


             VerifyFrameworkLoad(Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.PSTATE), PilotDistricts.NorthThurston, "North Thurston Public Schools-PState", "", SEFrameworkType.PSTATE, SESchoolYear.SY_2013);
             VerifyFrameworkLoad(Fixture.SEMgr.Framework(PilotDistricts.Othello, Fixture.CurrentSchoolYear, SEFrameworkType.PSTATE), PilotDistricts.Othello, "Othello School District-PState", "", SEFrameworkType.PSTATE, SESchoolYear.SY_2013);
         }

         [Test]
         public void CoreProperties()
         {
             SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.AreEqual(f.Id, Fixture.SEMgr.Framework(f.Id).Id);
             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(f.AllNodes, "C1");
             Assert.AreEqual(f.Id, c1Node.Framework.Id);
             Assert.AreEqual(f.Id, c1Node.FrameworkId);
             Assert.AreEqual("C1", c1Node.ShortName);
             Assert.AreEqual("Centering instruction on high expectations for student achievement.", c1Node.Title);
             Assert.AreEqual("", c1Node.Description);
             Assert.AreEqual(11, c1Node.Sequence);
             Assert.IsNull(c1Node.ParentNodeId);
          }

         [Test]
         public void Annotations()
         {
             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");

             SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
             Assert.IsNotNull(instructFramework);

             SEFrameworkNode d2Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D2");
             SEFrameworkNode d3Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D3");

             SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");

             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
             SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);

             SEEvalSession s1_t1 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher1.Id);
             SEEvalSession s1_t2 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher2.Id);

             // Add another sesssion for another teacher just to make sure we only get the ones for this teacher
             SEEvalSession s2_t1 = Fixture.CreateTestTeacherEvalSession("S2", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher1.Id);
             SEEvalSession s2_t2 = Fixture.CreateTestTeacherEvalSession("S2", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher2.Id);

             s1_t1.UpdateIsPublic(false, false, false);
             s1_t2.UpdateIsPublic(false, false, false);
             s2_t1.UpdateIsPublic(false, false, false);
             s2_t2.UpdateIsPublic(false, false, false);

             tEvalSession.AnnotateRubricRowForEvalSession(s1_t1, rrows, "2b", "Annotation for s1-2b");
             tEvalSession.AnnotateRubricRowForEvalSession(s2_t1, rrows, "3a", "Annotation for s2-3a");
             tEvalSession.AnnotateRubricRowForEvalSession(s1_t2, rrows, "2b", "Annotation for s1-2b");
             tEvalSession.AnnotateRubricRowForEvalSession(s2_t2, rrows, "3a", "Annotation for s2-3a");

             SERubricRowAnnotation[] annotations = c1Node.Annotations(teacher1.Id, false);
             // zero when session isn't public
             Assert.AreEqual(0, annotations.Length);

             s1_t1.UpdateIsPublic(true, true, true);
             s1_t2.UpdateIsPublic(true, true, true);
             s2_t1.UpdateIsPublic(true, true, true);
             s2_t2.UpdateIsPublic(true, true, true);

             annotations = c1Node.Annotations(teacher1.Id, true);
             Assert.AreEqual(2, annotations.Length);
             Assert.IsNotNull(tEvalSession.FindAnnotationInSession(annotations, s1_t1.Id, c1Node.Id, Fixture.FindRubricRowTitleStartWith(rrows, "2b").Id));
             Assert.IsNotNull(tEvalSession.FindAnnotationInSession(annotations, s2_t1.Id, c1Node.Id, Fixture.FindRubricRowTitleStartWith(rrows, "3a").Id));

             annotations = d2Node.Annotations(teacher1.Id, true);
             Assert.AreEqual(1, annotations.Length);
             Assert.IsNotNull(tEvalSession.FindAnnotationInSession(annotations, s1_t1.Id, d2Node.Id, Fixture.FindRubricRowTitleStartWith(rrows, "2b").Id));

             annotations = d3Node.Annotations(teacher1.Id, true);
             Assert.AreEqual(1, annotations.Length);
             Assert.IsNotNull(tEvalSession.FindAnnotationInSession(annotations, s2_t1.Id, d3Node.Id, Fixture.FindRubricRowTitleStartWith(rrows, "3a").Id));
         }


         [Test]
         public void AllNodes()
         {
             SEFrameworkNode[] nodes = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE).AllNodes;
             Assert.AreEqual(8, nodes.Length);

             for (int i = 1; i <= 8; ++i)
             {
                 Assert.IsNotNull(Fixture.FindFrameworkNodeWithShortName(nodes, "C"+i));
             }

             nodes = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.PSTATE).AllNodes;
             Assert.AreEqual(8, nodes.Length);

             for (int i = 1; i <= 8; ++i)
             {
                 Assert.IsNotNull(Fixture.FindFrameworkNodeWithShortName(nodes, "C" + i));
             }
         }

         protected void VerifyStateFocusNodes(SEFramework framework, SEEvalSession s, bool c1, bool c2, bool c3, bool c4, bool c5, bool c6, bool c7, bool c8)
         {
             SEFrameworkNode[] nodes = framework.AllNodesIncludeSessionInfo(s);
 
             Assert.AreEqual(c1, Fixture.FindFrameworkNodeWithShortName(nodes, "C1").HasFocus);
             Assert.AreEqual(c2, Fixture.FindFrameworkNodeWithShortName(nodes, "C2").HasFocus);
             Assert.AreEqual(c3, Fixture.FindFrameworkNodeWithShortName(nodes, "C3").HasFocus);
             Assert.AreEqual(c4, Fixture.FindFrameworkNodeWithShortName(nodes, "C4").HasFocus);
             Assert.AreEqual(c5, Fixture.FindFrameworkNodeWithShortName(nodes, "C5").HasFocus);
             Assert.AreEqual(c6, Fixture.FindFrameworkNodeWithShortName(nodes, "C6").HasFocus);
             Assert.AreEqual(c7, Fixture.FindFrameworkNodeWithShortName(nodes, "C7").HasFocus);
             Assert.AreEqual(c8, Fixture.FindFrameworkNodeWithShortName(nodes, "C8").HasFocus);
         }


         protected void VerifyInstructionalFocusNodes(SEFramework framework, SEEvalSession s, bool d1, bool d2, bool d3, bool d4)
         {
             SEFrameworkNode[] nodes = framework.AllNodesIncludeSessionInfo(s);

             Assert.AreEqual(d1, Fixture.FindFrameworkNodeWithShortName(nodes, "D1").HasFocus);
             Assert.AreEqual(d2, Fixture.FindFrameworkNodeWithShortName(nodes, "D2").HasFocus);
             Assert.AreEqual(d3, Fixture.FindFrameworkNodeWithShortName(nodes, "D3").HasFocus);
             Assert.AreEqual(d4, Fixture.FindFrameworkNodeWithShortName(nodes, "D4").HasFocus);
         }

         [Test]
         public void AllNodesWithSessionInfo()
         {
             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
             Assert.IsNotNull(instructFramework);

             SERubricRow[] stateRRows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");
             SERubricRow[] instructionalRRows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TINSTRUCTIONAL, "D1");

            SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1");
            SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2");
         
            VerifyStateFocusNodes(stateFramework, s1, false, false, false, false, false, false, false, false);
            VerifyInstructionalFocusNodes(instructFramework, s1, false, false, false, false);
            VerifyStateFocusNodes(stateFramework, s2, false, false, false, false, false, false, false, false);
            VerifyInstructionalFocusNodes(instructFramework, s2, false, false, false, false);

            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATOR, stateRRows, "2b", true);
            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATOR, stateRRows, "3a", true);

            VerifyStateFocusNodes(stateFramework, s1, true, false, false, false, false, false, false, false);
            VerifyInstructionalFocusNodes(instructFramework, s1, false, true, true, false);
            VerifyStateFocusNodes(stateFramework, s2, false, false, false, false, false, false, false, false);
            VerifyInstructionalFocusNodes(instructFramework, s2, false, false, false, false);

            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, instructionalRRows, "1a", true);
            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, instructionalRRows, "1b", true);
            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, instructionalRRows, "1c", true);
            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, instructionalRRows, "1d", true);
            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, instructionalRRows, "1e", true);
            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, instructionalRRows, "1f", true);

            VerifyStateFocusNodes(stateFramework, s1, true, false, false, false, false, false, false, false);
            VerifyInstructionalFocusNodes(instructFramework, s1, false, true, true, false);
            VerifyStateFocusNodes(stateFramework, s2, false, false, true, true, false, true, false, false);
            VerifyInstructionalFocusNodes(instructFramework, s2, true, false, false, false);


            SEFrameworkNode[] s1StateNodes = stateFramework.AllNodesIncludeSessionInfo(s1);
            Assert.AreEqual(8, s1StateNodes.Length);

            for (int i = 1; i <= 8; ++i)
            {
                Assert.IsNotNull(Fixture.FindFrameworkNodeWithShortName(s1StateNodes, "C" + i));
            }

            SEFrameworkNode[] s1InstructionalNodes = instructFramework.AllNodesIncludeSessionInfo(s1);
            Assert.AreEqual(4, s1InstructionalNodes.Length);

            for (int i = 1; i <= 4; ++i)
            {
                Assert.IsNotNull(Fixture.FindFrameworkNodeWithShortName(s1InstructionalNodes, "D" + i));
            }


             
            SEFrameworkNode[] s2StateNodes = stateFramework.AllNodesIncludeSessionInfo(s2);
            Assert.AreEqual(8, s2StateNodes.Length);

            for (int i = 1; i <= 8; ++i)
            {
                Assert.IsNotNull(Fixture.FindFrameworkNodeWithShortName(s2StateNodes, "C" + i));
            }


            SEFrameworkNode[] s2InstructionalNodes = instructFramework.AllNodesIncludeSessionInfo(s2);
            Assert.AreEqual(4, s2InstructionalNodes.Length);

            for (int i = 1; i <= 4; ++i)
            {
                Assert.IsNotNull(Fixture.FindFrameworkNodeWithShortName(s1InstructionalNodes, "D" + i));
            }
         }

         protected bool FrameworkIsLoaded(SEEvaluationType evalType, SESchoolYear schoolYear)
         {
             try
             {
                 // Will throw an exception if the framework does not exist.
                 SEFramework f = Fixture.SEMgr.GetStateFramework(PilotDistricts.NorthThurston, schoolYear, evalType);
                 return true;
             }
             catch
             {
                 return false;
             }
         }

         [Test]
         public void LoadFrameworkSets()
         {
             Assert.IsTrue(FrameworkIsLoaded(SEEvaluationType.TEACHER_OBSERVATION, SESchoolYear.SY_2013));
             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.TEACHER_OBSERVATION, SESchoolYear.SY_2014));
             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.TEACHER_OBSERVATION, SESchoolYear.SY_2015));

             Assert.IsTrue(FrameworkIsLoaded(SEEvaluationType.PRINCIPAL_OBSERVATION, SESchoolYear.SY_2013));
             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.PRINCIPAL_OBSERVATION, SESchoolYear.SY_2014));
             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.PRINCIPAL_OBSERVATION, SESchoolYear.SY_2015));

             SESchoolConfiguration sc_2013 = Fixture.SEMgr.SchoolConfiguration(PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SESchoolYear.SY_2013);
             Fixture.SEMgr.UpdatePrincipalAssignmentDelegated(SESchoolYear.SY_2013, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, true);

             // Load 2015 without first loading 2015. Shouldn't carry forward anything with a gap in years
             Fixture.SEMgr.LoadFrameworkSet("BDAN", PilotDistricts.NorthThurston, Fixture.NorthThurstonDistrictUser, "Teacher", Convert.ToInt32(SESchoolYear.SY_2015));

             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.TEACHER_OBSERVATION, SESchoolYear.SY_2014));
             Assert.IsTrue(FrameworkIsLoaded(SEEvaluationType.TEACHER_OBSERVATION, SESchoolYear.SY_2015));

             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.PRINCIPAL_OBSERVATION, SESchoolYear.SY_2014));
             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.PRINCIPAL_OBSERVATION, SESchoolYear.SY_2015));

             SEFramework f_2013 = Fixture.SEMgr.GetStateFramework(PilotDistricts.NorthThurston, SESchoolYear.SY_2013, SEEvaluationType.TEACHER_OBSERVATION);
             SEFramework f_2015 = Fixture.SEMgr.GetStateFramework(PilotDistricts.NorthThurston, SESchoolYear.SY_2015, SEEvaluationType.TEACHER_OBSERVATION);
             Assert.AreEqual(f_2013.StickyId, f_2015.StickyId);
             SESchoolConfiguration sc_2015 = Fixture.SEMgr.SchoolConfiguration(PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SESchoolYear.SY_2015);
             Assert.IsFalse(sc_2015.IsPrincipalAssignmentDelegated);

              SEUserPrompt[] prompts_2013 = SEUserPrompt.GetQuestionBankUserPrompts(SESchoolYear.SY_2013, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, 2,
                                         SEEvaluationType.TEACHER_OBSERVATION, SEUserPromptType.PRE_CONFERENCE, UserRole.SEDistrictAdmin);

              SEUserPrompt[] prompts_2015 = SEUserPrompt.GetQuestionBankUserPrompts(SESchoolYear.SY_2015, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, 2,
                            SEEvaluationType.TEACHER_OBSERVATION, SEUserPromptType.PRE_CONFERENCE, UserRole.SEDistrictAdmin);
              Assert.AreEqual(0, prompts_2015.Length);

             // Load 2014, should carry forward everything
             Fixture.SEMgr.LoadFrameworkSet("BDAN", PilotDistricts.NorthThurston, Fixture.NorthThurstonDistrictUser, "Teacher", Convert.ToInt32(SESchoolYear.SY_2014));

             Assert.IsTrue(FrameworkIsLoaded(SEEvaluationType.TEACHER_OBSERVATION, SESchoolYear.SY_2014));
             Assert.IsFalse(FrameworkIsLoaded(SEEvaluationType.PRINCIPAL_OBSERVATION, SESchoolYear.SY_2014));
             SEFramework f_2014 = Fixture.SEMgr.GetStateFramework(PilotDistricts.NorthThurston, SESchoolYear.SY_2014, SEEvaluationType.TEACHER_OBSERVATION);
             Assert.AreEqual(f_2013.StickyId, f_2014.StickyId);
             SESchoolConfiguration sc_2014 = Fixture.SEMgr.SchoolConfiguration(PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SESchoolYear.SY_2014);
             Assert.IsTrue(sc_2014.IsPrincipalAssignmentDelegated);

             SEUserPrompt[] prompts_2014 = SEUserPrompt.GetQuestionBankUserPrompts(SESchoolYear.SY_2014, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, 2,
             SEEvaluationType.TEACHER_OBSERVATION, SEUserPromptType.PRE_CONFERENCE, UserRole.SEDistrictAdmin);
             Assert.AreEqual(prompts_2013.Length, prompts_2014.Length);
         }
    }
}
