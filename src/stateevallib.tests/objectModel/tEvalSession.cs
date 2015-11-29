using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

using NUnit.Framework;
using DbUtils;
using StateEval;
using RepositoryLib;


namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tEvalSession : tBase
     {
        protected void VerifyFrameworkLoad(SEFramework framework, string districtCode, string name, string description, SEFrameworkType frameworkType)
        {
            Assert.IsNotNull(framework);
            Assert.AreEqual(districtCode, framework.DistrictCode);
            Assert.AreEqual(name, framework.Name);
            Assert.AreEqual(description, framework.Description);
            Assert.AreEqual(frameworkType, framework.FrameworkType);
        }

        #region Load_Tests

         protected void VerifySessionLoad(SEEvalSession session, string districtCode, string schoolCode, string district, string school,
                                            string title, SEEvaluationType evalType, bool isPublic,
                                            SEUser evaluatee, long evaluatorId, string evaluatorDisplayName,
                                            DateTime startTime, DateTime endTime, string location, 
                                            string observeNotes, SEEvaluationScoreType scoreType, SEAnchorType anchorType,
                                            long anchorSessionId, long libVideo, SERubricPerformanceLevel pl)
         {
             Assert.AreEqual(evaluatee.Id, session.Evaluatee.Id);
             Assert.AreEqual(evaluatee.DisplayName, session.EvaluateeDisplayName);
             Assert.AreEqual(evaluatorDisplayName, session.EvaluatorDisplayName);
             Assert.AreEqual(evaluatee.Id, session.EvaluateeId);

             Assert.AreEqual(evaluatorId, session.EvaluatorId);
             Assert.AreEqual(startTime.ToString(), session.ObserveStartTime.ToString());
             Assert.AreEqual(endTime.ToString(), session.ObserveEndTime.ToString());

             Assert.AreEqual(location, session.ObserveLocation);
             Assert.AreEqual(title, session.Title);
             Assert.AreEqual(evalType, session.EvaluationType);
             Assert.AreEqual(observeNotes, session.ObserveNotes);
             Assert.AreEqual(isPublic, session.ObserveIsPublic);

             Assert.AreEqual(scoreType, session.EvaluationScoreType);
             Assert.AreEqual(anchorType, session.AnchorType);
             Assert.AreEqual(pl, session.Score);

             if (startTime == DateTime.MinValue && (session.EvaluationType== SEEvaluationType.TEACHER_OBSERVATION || session.EvaluationType == SEEvaluationType.PRINCIPAL_OBSERVATION))
             {
                 if (session.IsSelfAssess)
                 {
                     Assert.AreEqual("Not started", session.ObserveScheduledDate);
                     Assert.AreEqual("Not started", session.ShortObserveScheduledDate);
                 }
                 else
                 {
                     Assert.AreEqual("Not scheduled", session.ObserveScheduledDate);
                     Assert.AreEqual("Not scheduled", session.ShortObserveScheduledDate);
                 }
             }
             else
             {
                 Assert.AreEqual(startTime.ToShortDateString(), session.ShortObserveScheduledDate);
             }
         }

         [Test]
         public void SessionIDbObject()
         {
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                                                        principal.Id, teacher.Id);
             Assert.AreEqual(s1.Id, ((IDbObject)s1).Id);
         }

         [Test]
         public void CreateTeacherStandardSession()
         {
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                                                        principal.Id, teacher.Id);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);

             VerifySessionLoad(s1, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, "North Thurston Public Schools",
                                            "North Thurston High School", "S1", SEEvaluationType.TEACHER_OBSERVATION, false,Fixture.SEMgr.SEUser(teacher.Id), principal.Id,
                                             principal.DisplayName, DateTime.MinValue, DateTime.MinValue, "",
                                             "",  SEEvaluationScoreType.STANDARD, SEAnchorType.UNDEFINED, -1, -1, SERubricPerformanceLevel.UNDEFINED);
			 SEUser[] evaluatees = Fixture.SEMgr.GetTeacherEvaluateesInSchoolForAssignment(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS);
			 Assert.AreEqual(2, evaluatees.Length);
			 Assert.AreEqual(2, evaluatees.Length);
         }

         [Test]
         public void CreatePrinciaplStandardSession()
         {
             SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

             SEEvalSession s1 = Fixture.CreateTestPrincipalEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                                                        de.Id, principal.Id);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);

             VerifySessionLoad(s1, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, "North Thurston Public Schools",
                                            "North Thurston High School", "S1", SEEvaluationType.PRINCIPAL_OBSERVATION, false, Fixture.SEMgr.SEUser(principal.Id), de.Id,
                                             de.DisplayName, DateTime.MinValue, DateTime.MinValue, "",
                                             "", SEEvaluationScoreType.STANDARD, SEAnchorType.UNDEFINED, -1, -1, SERubricPerformanceLevel.UNDEFINED);
         }


         [Test]
         public void CreateTeacherSelfAssessSession()
         {
             SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEEvalSession s1 = Fixture.CreateTestTeacherSelfAssessSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, teacher.Id);
             Assert.AreEqual("Not started", s1.ObserveScheduledDate);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);

             VerifySessionLoad(s1, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, "North Thurston Public Schools",
                                            "North Thurston High School", "S1", SEEvaluationType.TEACHER_OBSERVATION, false, Fixture.SEMgr.SEUser(teacher.Id), teacher.Id,
                                             teacher.DisplayName, DateTime.MinValue, DateTime.MinValue, "",
                                             "", SEEvaluationScoreType.STANDARD, SEAnchorType.UNDEFINED, -1, -1, SERubricPerformanceLevel.UNDEFINED);
         }


         [Test]
         public void CreatePrincipalSelfAssessSession()
         {
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
 
             SEEvalSession s1 = Fixture.CreateTestPrincipalSelfAssessSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);

             VerifySessionLoad(s1, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, "North Thurston Public Schools",
                                            "North Thurston High School", "S1", SEEvaluationType.PRINCIPAL_OBSERVATION, false, Fixture.SEMgr.SEUser(principal.Id), principal.Id,
                                             principal.DisplayName, DateTime.MinValue, DateTime.MinValue, "",
                                             "", SEEvaluationScoreType.STANDARD, SEAnchorType.UNDEFINED, -1, -1, SERubricPerformanceLevel.UNDEFINED);
         }

         protected void SessionIsCompleteInner(SEEvalSession s1, SEEvalSession s2, bool s1PreConfIsComplete, bool s1ObsIsComplete, bool s1PostConfIsComplete, 
                                            bool s2PreConfIsComplete, bool s2ObsIsComplete, bool s2PostConfIsComplete)
         {
             s1.UpdateIsComplete(s1PreConfIsComplete, s1ObsIsComplete, s1PostConfIsComplete);
             s2.UpdateIsComplete(s2PreConfIsComplete, s2ObsIsComplete, s2PostConfIsComplete);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);
             s2 = Fixture.SEMgr.EvalSession(s2.Id);
             Assert.AreEqual(s1.PreConfIsComplete, s1PreConfIsComplete);
             Assert.AreEqual(s1.ObserveIsComplete, s1ObsIsComplete);
             Assert.AreEqual(s1.PostConfIsComplete, s1PostConfIsComplete);
             Assert.AreEqual(s2.PreConfIsComplete, s2PreConfIsComplete);
             Assert.AreEqual(s2.ObserveIsComplete, s2ObsIsComplete);
             Assert.AreEqual(s2.PostConfIsComplete, s2PostConfIsComplete);
         }


         protected void SessionIsPublicInner(SEEvalSession s1, SEEvalSession s2, bool s1PreConfIsPublic, bool s1ObsIsPublic, bool s1PostConfIsPublic,
                                            bool s2PreConfIsPublic, bool s2ObsIsPublic, bool s2PostConfIsPublic)
         {
             s1.UpdateIsPublic(s1PreConfIsPublic, s1ObsIsPublic, s1PostConfIsPublic);
             s2.UpdateIsPublic(s2PreConfIsPublic, s2ObsIsPublic, s2PostConfIsPublic);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);
             s2 = Fixture.SEMgr.EvalSession(s2.Id);
             Assert.AreEqual(s1.PreConfIsPublic, s1PreConfIsPublic);
             Assert.AreEqual(s1.ObserveIsPublic, s1ObsIsPublic);
             Assert.AreEqual(s1.PostConfIsPublic, s1PostConfIsPublic);
             Assert.AreEqual(s2.PreConfIsPublic, s2PreConfIsPublic);
             Assert.AreEqual(s2.ObserveIsPublic, s2ObsIsPublic);
             Assert.AreEqual(s2.PostConfIsPublic, s2PostConfIsPublic);
         }


         protected void SessionLocationInner(SEEvalSession s1, SEEvalSession s2, string s1PreConfLocation, string s1ObsLocation, string s1PostConfLocation,
                                            string s2PreConfLocation, string s2ObsLocation, string s2PostConfLocation)
         {
             Fixture.SEMgr.UpdatePreConfLocation(s1.Id, s1PreConfLocation);
             Fixture.SEMgr.UpdateObserveLocation(s1.Id, s1ObsLocation);
             Fixture.SEMgr.UpdatePostConfLocation(s1.Id, s1PostConfLocation);

             Fixture.SEMgr.UpdatePreConfLocation(s2.Id, s2PreConfLocation);
             Fixture.SEMgr.UpdateObserveLocation(s2.Id, s2ObsLocation);
             Fixture.SEMgr.UpdatePostConfLocation(s2.Id, s2PostConfLocation);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);
             s2 = Fixture.SEMgr.EvalSession(s2.Id);
             Assert.AreEqual(s1.PreConfLocation, s1PreConfLocation);
             Assert.AreEqual(s1.ObserveLocation, s1ObsLocation);
             Assert.AreEqual(s1.PostConfLocation, s1PostConfLocation);
             Assert.AreEqual(s2.PreConfLocation, s2PreConfLocation);
             Assert.AreEqual(s2.ObserveLocation, s2ObsLocation);
             Assert.AreEqual(s2.PostConfLocation, s2PostConfLocation);
         }

         protected void SessionScheduledDateInner(SEEvalSession s1, SEEvalSession s2, DateTime s1PreConf, DateTime s1Obs, DateTime s1PostConf,
                                      DateTime s2PreConf, DateTime s2Obs, DateTime s2PostConf)
         {
             s1.UpdatePreConfSchedule(s1PreConf, s1PreConf.AddHours(2));
             s1.UpdateObserveSchedule(s1Obs, s1Obs.AddHours(3));
             s1.UpdatePostConfSchedule(s1PostConf, s1PostConf.AddHours(4));

             s2.UpdatePreConfSchedule(s2PreConf, s2PreConf.AddHours(4));
             s2.UpdateObserveSchedule(s2Obs, s2Obs.AddHours(3));
             s2.UpdatePostConfSchedule(s2PostConf, s2PostConf.AddHours(2));

             s1 = Fixture.SEMgr.EvalSession(s1.Id);
             s2 = Fixture.SEMgr.EvalSession(s2.Id);
             Assert.AreEqual(s1.PreConfStartTime.ToShortDateString(), s1PreConf.ToShortDateString());
             Assert.AreEqual(s1.PreConfStartTime.ToShortTimeString(), s1PreConf.ToShortTimeString());
             Assert.AreEqual(s1.PreConfEndTime.ToShortDateString(), s1PreConf.AddHours(2).ToShortDateString());
             Assert.AreEqual(s1.PreConfEndTime.ToShortTimeString(), s1PreConf.AddHours(2).ToShortTimeString());
             Assert.AreEqual(s1.ObserveStartTime.ToShortDateString(), s1Obs.ToShortDateString());
             Assert.AreEqual(s1.ObserveStartTime.ToShortTimeString(), s1Obs.ToShortTimeString());
             Assert.AreEqual(s1.ObserveEndTime.ToShortDateString(), s1Obs.AddHours(3).ToShortDateString());
             Assert.AreEqual(s1.ObserveEndTime.ToShortTimeString(), s1Obs.AddHours(3).ToShortTimeString());
             Assert.AreEqual(s1.PostConfStartTime.ToShortDateString(), s1PostConf.ToShortDateString());
             Assert.AreEqual(s1.PostConfStartTime.ToShortTimeString(), s1PostConf.ToShortTimeString());
             Assert.AreEqual(s1.PostConfEndTime.ToShortDateString(), s1PostConf.AddHours(4).ToShortDateString());
             Assert.AreEqual(s1.PostConfEndTime.ToShortTimeString(), s1PostConf.AddHours(4).ToShortTimeString());

             Assert.AreEqual(s2.PreConfStartTime.ToShortDateString(), s2PreConf.ToShortDateString());
             Assert.AreEqual(s2.PreConfStartTime.ToShortTimeString(), s2PreConf.ToShortTimeString());
             Assert.AreEqual(s2.PreConfEndTime.ToShortDateString(), s2PreConf.AddHours(4).ToShortDateString());
             Assert.AreEqual(s2.PreConfEndTime.ToShortTimeString(), s2PreConf.AddHours(4).ToShortTimeString());
             Assert.AreEqual(s2.ObserveStartTime.ToShortDateString(), s2Obs.ToShortDateString());
             Assert.AreEqual(s2.ObserveStartTime.ToShortTimeString(), s2Obs.ToShortTimeString());
             Assert.AreEqual(s2.ObserveEndTime.ToShortDateString(), s2Obs.AddHours(3).ToShortDateString());
             Assert.AreEqual(s2.ObserveEndTime.ToShortTimeString(), s2Obs.AddHours(3).ToShortTimeString());
             Assert.AreEqual(s2.PostConfStartTime.ToShortDateString(), s2PostConf.ToShortDateString());
             Assert.AreEqual(s2.PostConfStartTime.ToShortTimeString(), s2PostConf.ToShortTimeString());
             Assert.AreEqual(s2.PostConfEndTime.ToShortDateString(), s2PostConf.AddHours(2).ToShortDateString());
             Assert.AreEqual(s2.PostConfEndTime.ToShortTimeString(), s2PostConf.AddHours(2).ToShortTimeString());
         }

         [Test]
         public void SessionEvents()
         {
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher.Id);
             SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher.Id);

             SessionIsPublicInner(s1, s2, true, true, true, false, false, false);
             SessionIsPublicInner(s1, s2, true, false, true, false, true, false);
             SessionIsPublicInner(s1, s2, false, true, false, true, false, true);
             SessionIsPublicInner(s1, s2, false, false, false, true, true, true);

             SessionIsCompleteInner(s1, s2, true, true, true, false, false, false);
             SessionIsCompleteInner(s1, s2, true, false, true, false, true, false);
             SessionIsCompleteInner(s1, s2, false, true, false, true, false, true);
             SessionIsCompleteInner(s1, s2, false, false, false, true, true, true);

             SessionScheduledDateInner(s1, s2, DateTime.Now.AddHours(1), DateTime.Now.AddHours(2), DateTime.Now.AddHours(3),
                                               DateTime.Now.AddHours(5), DateTime.Now.AddHours(6), DateTime.Now.AddHours(7));

         }

         [Test]
         public void UpdateSession()
         {
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher.Id);

             s1.UpdateObservationNotes("Observation Notes"); 
             DateTime start = DateTime.Now;
             DateTime end = DateTime.Now;

             s1.UpdateObserveSchedule(start, end);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);
             Assert.AreEqual(start.ToShortDateString() + " " + start.ToShortTimeString() + " - " + end.ToShortTimeString(), s1.ObserveScheduledDate);
             Assert.AreEqual(principal.DisplayName + " - " + "S1" + " - " + s1.ShortObserveScheduledDate, s1.HistoryLinkTitle);

             s1.UpdateEvalSessionMain(principal.Id, teacher.Id, "NewTitle");
             Fixture.SEMgr.UpdateObserveLocation(s1.Id, "location");
             s1.UpdateIsPublic(true, true, true);

             s1.ScoreSession(SERubricPerformanceLevel.PL1);

             s1 = Fixture.SEMgr.EvalSession(s1.Id);
          
             VerifySessionLoad(s1, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, "North Thurston Public Schools",
                                            "North Thurston High School", "NewTitle", SEEvaluationType.TEACHER_OBSERVATION, true, Fixture.SEMgr.SEUser(teacher.Id), principal.Id,
                                             principal.DisplayName, start, end, "location",
                                             "Observation Notes", SEEvaluationScoreType.STANDARD, SEAnchorType.UNDEFINED, -1, -1, SERubricPerformanceLevel.PL1);

             Fixture.SEMgr.UnscheduleEvalSession_Observe(s1.Id);
             s1 = Fixture.SEMgr.EvalSession(s1.Id);
             Assert.AreEqual(DateTime.MinValue, s1.ObserveStartTime);
             Assert.AreEqual(DateTime.MinValue, s1.ObserveEndTime);
         }

         #endregion

        #region Focus_Tests

        protected void VerifyFocusRubricRowCount(SEFramework stateFramework, SEFramework instructFramework, SEEvalSession session, SEEvaluationRole role, int countStateFramework, int countInstFramework, int countSession)
        {
            SERubricRow[] rrows = session.FocusRubricRows(role);
            Assert.AreEqual(rrows.Length, countSession);

            rrows = session.FocusRubricRows(stateFramework.Id, role);
            Assert.AreEqual(rrows.Length, countStateFramework);

            if (instructFramework != null)
            {
                rrows = session.FocusRubricRows(instructFramework.Id, role);
                Assert.AreEqual(rrows.Length, countInstFramework);
            }
        }

        SEFrameworkNode[] VerifyFocusNodesCount(SEEvalSession s, SEFrameworkType frameworkType, SEEvaluationRole roleType, int count)
        {
            SEFrameworkNode[] focusNodes = s.FocusNodes(frameworkType, roleType);
            Assert.AreEqual(count, focusNodes.Length);
            return focusNodes;
        }

        [Test]
        public void FocusRubricRows_TE()
        {
            SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            Assert.IsNotNull(stateFramework);

            // The instructional framework has these aligned under D1 and D2
            SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
            Assert.IsNotNull(instructFramework);

            SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");

            SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1");
            SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2");

            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATOR, rrows, "2b", true);
            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATOR, rrows, "3a", true);

            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, rrows, "2b", true);

            SEFrameworkNode[] focusNodes = VerifyFocusNodesCount(s1, SEFrameworkType.TSTATE, SEEvaluationRole.EVALUATOR, 1);
            Assert.AreEqual("C1", focusNodes[0].ShortName);

            SERubricRow[] rubricRowsWithSessionInfo = focusNodes[0].RubricRowsForEvalSession(s1, false);
            Assert.IsTrue(Fixture.FindRubricRowTitleStartWith(rubricRowsWithSessionInfo, "2b").HasFocus);

            // Make sure objects are loaded with Context to execute other object calls
            Assert.AreEqual(3, focusNodes[0].RubricRows.Length);

            focusNodes = VerifyFocusNodesCount(s1, SEFrameworkType.TINSTRUCTIONAL, SEEvaluationRole.EVALUATOR, 2);
            Assert.AreEqual("D2", focusNodes[0].ShortName);
            Assert.AreEqual("D3", focusNodes[1].ShortName);

            focusNodes = VerifyFocusNodesCount(s2, SEFrameworkType.TSTATE, SEEvaluationRole.EVALUATOR, 1);
            Assert.AreEqual("C1", focusNodes[0].ShortName);

            VerifyFocusRubricRowCount(stateFramework, instructFramework, s1, SEEvaluationRole.EVALUATOR, 2, 2, 2);
            VerifyFocusRubricRowCount(stateFramework, instructFramework, s2, SEEvaluationRole.EVALUATOR, 1, 1, 1);

            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATEE, rrows, "2b", true);
            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATEE, rrows, "2b", true);

            VerifyFocusRubricRowCount(stateFramework, instructFramework, s1, SEEvaluationRole.EVALUATEE, 1, 1, 1);
            VerifyFocusRubricRowCount(stateFramework, instructFramework, s2, SEEvaluationRole.EVALUATEE, 1, 1, 1);

            // Remove focus for all D2 rubricrows, which removes 2b
            Fixture.FocusFrameworkNodeForEvalSession(s1, SEEvaluationRole.EVALUATOR, Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D2"), false);
            focusNodes = VerifyFocusNodesCount(s1, SEFrameworkType.TINSTRUCTIONAL, SEEvaluationRole.EVALUATOR, 1);
            Assert.AreEqual("D3", focusNodes[0].ShortName);
            VerifyFocusRubricRowCount(stateFramework, instructFramework, s1, SEEvaluationRole.EVALUATOR, 1, 1, 1);

            Fixture.FocusFrameworkNodeForEvalSession(s1, SEEvaluationRole.EVALUATOR, Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D2"), true);
            focusNodes = VerifyFocusNodesCount(s1, SEFrameworkType.TINSTRUCTIONAL, SEEvaluationRole.EVALUATOR, 2);
            Assert.AreEqual("D2", focusNodes[0].ShortName);
            Assert.AreEqual("D3", focusNodes[1].ShortName);
            // all the rubricrows should be added from D1, 1a-1f (6) + 1 for D2, 2b
            VerifyFocusRubricRowCount(stateFramework, instructFramework, s1, SEEvaluationRole.EVALUATOR, 6, 6, 6);

            // Make sure we can delete a session with focus.
            Fixture.SEMgr.RemoveEvalSession(s1.Id);
        }

         [Test]
        public void FocusRubricRows_PE()
        {
            SEFramework f = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.PSTATE);
            Assert.IsNotNull(f);

            SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.PSTATE, "C1");

            SEEvalSession s1 = Fixture.CreateTestPrincipalEvalSession("S1");
            SEEvalSession s2 = Fixture.CreateTestPrincipalEvalSession("S2");

            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATOR, rrows, "1.1", true);
            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATOR, rrows, "1.2", true);

            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATOR, rrows, "1.3", true);

            VerifyFocusRubricRowCount(f, null, s1, SEEvaluationRole.EVALUATOR, 2, 2, 2);
            VerifyFocusRubricRowCount(f, null, s2, SEEvaluationRole.EVALUATOR, 1, 1, 1);

            Fixture.FocusRubricRowForEvalSession(s1, SEEvaluationRole.EVALUATEE, rrows, "1.3", true);
            Fixture.FocusRubricRowForEvalSession(s2, SEEvaluationRole.EVALUATEE, rrows, "1.3", true);

            VerifyFocusRubricRowCount(f, null, s1, SEEvaluationRole.EVALUATEE, 1, 1, 1);
            VerifyFocusRubricRowCount(f, null, s2, SEEvaluationRole.EVALUATEE, 1, 1, 1);

            // Make sure we can delete a session with focus.
            Fixture.SEMgr.RemoveEvalSession(s1.Id);
        }
        #endregion

         #region RubricRow_Tests

         [Test]
         public void IDbObject()
         {
             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");
             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
             Assert.AreEqual(c1Node.Id, ((IDbObject)c1Node).Id);
             Assert.AreEqual(rrows[0].Id, ((IDbObject)rrows[0]).Id);
         }

         protected void VerifyRubricRow(SERubricRow[] rrows, string titleStartsWith, string title,string desc, string pl1Desc, string pl2Desc, string pl3Desc, string pl4Desc)
         {
             SERubricRow rr = Fixture.FindRubricRowTitleStartWith(rrows, titleStartsWith);
             VerifyRubricRow(rr, titleStartsWith, title, desc, pl1Desc, pl2Desc, pl3Desc, pl4Desc);
         }

         protected void VerifyRubricRow(SERubricRow rr, string titleStartsWith, string title, string desc, string pl1Desc, string pl2Desc, string pl3Desc, string pl4Desc)
         {
             Assert.AreEqual(title, rr.Title);
             Assert.AreEqual(desc, rr.Description);
             Assert.IsTrue(rr.PL1Descriptor.Contains(pl1Desc));
             Assert.IsTrue(rr.PL2Descriptor.Contains(pl2Desc));
             Assert.IsTrue(rr.PL3Descriptor.Contains(pl3Desc));
             Assert.IsTrue(rr.PL4Descriptor.Contains(pl4Desc));
             Assert.IsTrue(Fixture.SEMgr.GetRubricRowDescriptor(rr.Id, SERubricPerformanceLevel.PL1).Contains(pl1Desc));
             Assert.IsTrue(Fixture.SEMgr.GetRubricRowDescriptor(rr.Id, SERubricPerformanceLevel.PL2).Contains(pl2Desc));
             Assert.IsTrue(Fixture.SEMgr.GetRubricRowDescriptor(rr.Id, SERubricPerformanceLevel.PL3).Contains(pl3Desc));
             Assert.IsTrue(Fixture.SEMgr.GetRubricRowDescriptor(rr.Id, SERubricPerformanceLevel.PL4).Contains(pl4Desc));
         }

         [Test]
         public void RubricRowLoad()
         {
             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");
             SERubricRow rr = Fixture.SEMgr.RubricRow(rrows[0].Id);
             VerifyRubricRow(rr, "2b", "2b: Establishing a Culture for Learning",
            "",
            "The classroom culture is characterized by a lack of teacher or student commitment",
            "The classroom culture is characterized by little commitment",
            "The classroom culture is a cognitively busy place",
            "The classroom culture is a cognitively vibrant place");

             VerifyRubricRow(rrows, "2b", "2b: Establishing a Culture for Learning",
            "",
             "The classroom culture is characterized by a lack of teacher or student commitment",
            "The classroom culture is characterized by little commitment",
            "The classroom culture is a cognitively busy place",
            "The classroom culture is a cognitively vibrant place");    
         }   

         #endregion

         #region RRAnnotation_Tests

         protected void VerifyRubricRowAnnotation(SERubricRowAnnotation annotation, SEEvalSession session, string text, SERubricRow rr)
         {
             Assert.AreEqual(text, annotation.Annotation);
             Assert.AreEqual(session.EvaluatorDisplayName, annotation.EvaluatorDisplayName);
             Assert.AreEqual(session.Title, annotation.EvalSessionTitle);
             Assert.AreEqual(rr.Id, annotation.RubricRowId);
             Assert.AreEqual(rr.Title, annotation.RubricRowTitle);
         }

         public static SERubricRowAnnotation FindAnnotationInSession(SERubricRowAnnotation[] annotations, long sessionId, long fnId, long rrId)
         {
             foreach (SERubricRowAnnotation a in annotations)
             {
                 if (a.EvalSessionId == sessionId && a.FrameworkNodeId == fnId && a.RubricRowId == rrId)
                     return a;
             }
             return null;
         }

         [Test]
         public void RubricRowAnnotationLoad()
         {
             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");

             SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
             Assert.IsNotNull(instructFramework);

             SEFrameworkNode d2Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D2");

             SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1");
             SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2");

             AnnotateRubricRowForEvalSession(s1, rrows, "2b", "Annotation for s1-2b");
             AnnotateRubricRowForEvalSession(s2, rrows, "2b", "Annotation for s2-2b");

             // the rubric row will be aligned to C1 and D1
             SERubricRowAnnotation[] annotations = s1.AllRubricRowAnnotations;
             Assert.AreEqual(2, annotations.Length);
             SERubricRow rr = Fixture.FindRubricRowTitleStartWith(rrows, "2b");
             VerifyRubricRowAnnotation(FindAnnotationInSession(annotations, s1.Id, c1Node.Id, rr.Id), s1, "Annotation for s1-2b", rr);
             VerifyRubricRowAnnotation(FindAnnotationInSession(annotations, s1.Id, d2Node.Id, rr.Id), s1, "Annotation for s1-2b", rr);

             DateTime currentTime = DateTime.Now;
             Assert.AreEqual("OBS: " + s1.EvaluatorDisplayName + " - " + s1.Title + " - Not scheduled", annotations[0].EvalSessionDisplayTitle);
             s1.UpdateObserveSchedule(currentTime, currentTime);
             annotations = s1.AllRubricRowAnnotations;
             Assert.AreEqual("OBS: " + s1.EvaluatorDisplayName + " - " + s1.Title + " - " + currentTime.ToShortDateString(), annotations[0].EvalSessionDisplayTitle);

             Assert.AreEqual(annotations[0].Id, ((IDbObject)annotations[0]).Id);

             annotations = s2.AllRubricRowAnnotations;
             Assert.AreEqual(2, annotations.Length);
             rr = Fixture.FindRubricRowTitleStartWith(rrows, "2b");
             VerifyRubricRowAnnotation(FindAnnotationInSession(annotations, s2.Id, c1Node.Id, rr.Id), s2, "Annotation for s2-2b", rr);
             VerifyRubricRowAnnotation(FindAnnotationInSession(annotations, s2.Id, d2Node.Id, rr.Id), s2, "Annotation for s2-2b", rr);

         }   

         public static void AnnotateRubricRowForEvalSession(SEEvalSession s, SERubricRow[] rrows, string rrTitleStart, string annotation)
         {
             SERubricRow rr = Fixture.FindRubricRowTitleStartWith(rrows, rrTitleStart);
             Assert.IsNotNull(rr);
             s.UpdateRubricRowAnnotation(rr.Id, annotation, s.EvaluatorId);
             Assert.AreEqual(Fixture.SEMgr.EvalSession(s.Id).RubricRowAnnotation(rr.Id, s.EvaluatorId).Annotation, annotation);
         }

         public bool AnnotationExistsInSession(SERubricRowAnnotation[] annotations, long sessionId, long fnId, long rrId)
         {
             foreach (SERubricRowAnnotation a in annotations)
             {
                 if (a.EvalSessionId == sessionId && a.FrameworkNodeId == fnId && a.RubricRowId == rrId)
                     return true;
             }
             return false;
         }

         [Test]
         public void RubricRowAnnotations()
         {
             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");

             SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
             Assert.IsNotNull(instructFramework);

             SEFrameworkNode d2Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D2");

             SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1");
             SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2");

             AnnotateRubricRowForEvalSession(s1, rrows, "2b", "Annotation for s1-2b");
             AnnotateRubricRowForEvalSession(s2, rrows, "2b", "Annotation for s2-2b");

             SERubricRowAnnotation[] annotations = s1.AllRubricRowAnnotations;
             Assert.AreEqual(2, annotations.Length);
             SERubricRow rr = Fixture.FindRubricRowTitleStartWith(rrows, "2b");

             Assert.IsTrue(AnnotationExistsInSession(annotations, s1.Id, c1Node.Id, rr.Id));
             Assert.IsTrue(AnnotationExistsInSession(annotations, s1.Id, d2Node.Id, rr.Id)); 
         }

        #endregion

        #region PullQuote_Tests

         protected bool FindQuote(SEPullQuote[] quotes, long id, Guid guid, string quote)
         {
             foreach (SEPullQuote q in quotes)
             {
                 if (q.Id == id && q.Guid == guid && q.Text == quote)
                     return true;
             }

             return false;
         }

         protected bool FindFrameworkNodeQuote(SEPullQuote[] quotes, long fnId, long id, Guid guid, string quote)
         {
             foreach (SEPullQuote q in quotes)
             {
                 if (q.Id == id && q.Guid == guid && q.Text == quote && q.FrameworkNodeId == fnId)
                     return true;
             }

             return false;
         }

         [Test]
         public void InsertPullQuote()
         {
             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
             SEFrameworkNode c2Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C2");

             // The instructional framework has these aligned under D1 and D2
             SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
             Assert.IsNotNull(instructFramework);

             SEFrameworkNode d1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "D1");
             SEFrameworkNode d2Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "D2");

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1");
             SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2");

             Guid S1C1Q1 = new Guid();
             SEPullQuote PQS1C1Q1 = s1.PutQuote(c1Node.Id, "S1C1Q1", S1C1Q1);

             Guid S1C1Q2 = new Guid();
             SEPullQuote PQS1C1Q2 = s1.PutQuote(c1Node.Id, "S1C1Q2", S1C1Q2);

             Guid S2C1Q1 = new Guid();
             SEPullQuote PQS2C1Q1= s2.PutQuote(c1Node.Id, "S2C1Q1", S2C1Q1);

             Guid S2C1Q2 = new Guid();
             SEPullQuote PQS2C1Q2 = s2.PutQuote(c1Node.Id, "S2C1Q2", S2C1Q2);

             Guid S1C2Q1 = new Guid();
             SEPullQuote PQS1C2Q1 = s1.PutQuote(c2Node.Id, "S1C2Q1", S1C2Q1);

             Guid S1C2Q2 = new Guid();
             SEPullQuote PQS1C2Q2 = s1.PutQuote(c2Node.Id, "S1C2Q2", S1C2Q2);

             Guid S2C2Q1 = new Guid();
             SEPullQuote PQS2C2Q1 = s2.PutQuote(c2Node.Id, "S2C2Q1", S2C2Q1);

             Guid S2C2Q2 = new Guid();
             SEPullQuote PQS2C2Q2 = s2.PutQuote(c2Node.Id, "S2C2Q2", S2C2Q2);

             SEPullQuote[] s1Quotes = s1.PullQuotes;
             Assert.AreEqual(4, s1Quotes.Length);

             SEPullQuote[] s2Quotes = s2.PullQuotes;
             Assert.AreEqual(4, s2Quotes.Length);

             Assert.IsTrue(FindQuote(s1Quotes, PQS1C1Q1.Id, S1C1Q1, "S1C1Q1"));
             Assert.IsTrue(FindQuote(s1Quotes, PQS1C1Q2.Id, S1C1Q2, "S1C1Q2"));

             Assert.IsTrue(FindQuote(s2Quotes, PQS2C1Q1.Id, S2C1Q1, "S2C1Q1"));
             Assert.IsTrue(FindQuote(s2Quotes, PQS2C1Q2.Id, S2C1Q2, "S2C1Q2"));

             Assert.IsTrue(FindQuote(s1Quotes, PQS1C2Q1.Id, S1C2Q1, "S1C2Q1"));
             Assert.IsTrue(FindQuote(s1Quotes, PQS1C2Q2.Id, S1C2Q2, "S1C2Q2"));

             Assert.IsTrue(FindQuote(s2Quotes, PQS2C2Q1.Id, S2C2Q1, "S2C2Q1"));
             Assert.IsTrue(FindQuote(s2Quotes, PQS2C2Q2.Id, S2C2Q2, "S2C2Q2"));

             SEPullQuote[] c1NodeQuotes = s1.PullQuotesForFrameworkNode(c1Node.Id);
             SEPullQuote[] c2NodeQuotes = s1.PullQuotesForFrameworkNode(c2Node.Id);

             Assert.AreEqual(2, c1NodeQuotes.Length);
             Assert.AreEqual(2, c2NodeQuotes.Length);

             Assert.IsTrue(FindFrameworkNodeQuote(c1NodeQuotes, c1Node.Id, PQS1C1Q1.Id, S1C1Q1, "S1C1Q1"));
             Assert.IsTrue(FindFrameworkNodeQuote(c1NodeQuotes, c1Node.Id, PQS1C1Q2.Id, S1C1Q2, "S1C1Q2"));

             Assert.IsTrue(FindFrameworkNodeQuote(c2NodeQuotes, c2Node.Id, PQS1C2Q1.Id, S1C2Q1, "S1C2Q1"));
             Assert.IsTrue(FindFrameworkNodeQuote(c2NodeQuotes, c2Node.Id, PQS1C2Q2.Id, S1C2Q2, "S1C2Q2"));

             c1NodeQuotes = s2.PullQuotesForFrameworkNode(c1Node.Id);
             c2NodeQuotes = s2.PullQuotesForFrameworkNode(c2Node.Id);

             Assert.AreEqual(2, c1NodeQuotes.Length);
             Assert.AreEqual(2, c2NodeQuotes.Length);

             Assert.IsTrue(FindFrameworkNodeQuote(c1NodeQuotes, c1Node.Id, PQS2C1Q1.Id, S2C1Q1, "S2C1Q1"));
             Assert.IsTrue(FindFrameworkNodeQuote(c1NodeQuotes, c1Node.Id, PQS2C1Q2.Id, S2C1Q2, "S2C1Q2"));

             Assert.IsTrue(FindFrameworkNodeQuote(c2NodeQuotes, c2Node.Id, PQS2C2Q1.Id, S2C2Q1, "S2C2Q1"));
             Assert.IsTrue(FindFrameworkNodeQuote(c2NodeQuotes, c2Node.Id, PQS2C2Q2.Id, S2C2Q2, "S2C2Q2"));

             Assert.IsFalse(Fixture.SEMgr.PullQuote(PQS1C1Q1.Id).IsImportant);
             Fixture.SEMgr.UpdatePullQuoteImportant(PQS1C1Q1.Id, true);
             Assert.IsTrue(Fixture.SEMgr.PullQuote(PQS1C1Q1.Id).IsImportant);
             int before = Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM SEPullQuote"));
             Fixture.SEMgr.RemovePullQuote(PQS1C1Q2.Id);
             int after = Convert.ToInt32(Fixture.SEMgr.DbConnector.ExecuteNonSpScalar("SELECT COUNT(*) FROM SEPullQuote"));
             Assert.AreEqual(after+1, before);

             SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

              Assert.AreEqual(1, Fixture.SEMgr.GetImportantPullQuotesForEvaluatee(teacher.Id, stateFramework.Id, true).Length);

         }
        #endregion

        #region Scoring_Tests

         protected void SessionScoreInner(SEEvalSession s, SERubricPerformanceLevel pl)
         {
             s.ScoreSession(pl);
             s = Fixture.SEMgr.EvalSession(s.Id);
             Assert.AreEqual(pl, s.Score);
         }

         [Test]
         public void SessionScore()
         {
             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1");
             SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2");

             SessionScoreInner(s1, SERubricPerformanceLevel.PL1);
             SessionScoreInner(s2, SERubricPerformanceLevel.PL1);
             SessionScoreInner(s1, SERubricPerformanceLevel.PL2);
             SessionScoreInner(s2, SERubricPerformanceLevel.PL2);
             SessionScoreInner(s1, SERubricPerformanceLevel.PL3);
             SessionScoreInner(s1, SERubricPerformanceLevel.PL4);
             SessionScoreInner(s1, SERubricPerformanceLevel.UNDEFINED);
         }

         protected SEFrameworkNodeScore FindFrameworkNodeScore(SEFrameworkNodeScore[] scores, long sessionId, long nodeId, SERubricPerformanceLevel pl, long scorerId)
         {
             foreach (SEFrameworkNodeScore score in scores)
             {
                 if (score.EvalSessionId == sessionId && score.FrameworkNodeId == nodeId && score.PerformanceLevel == pl && score.UserId == scorerId)
                 {
                     return score;
                 }
             }
             return null;
         }

         protected void FrameworkNodeScoreInner(SEEvalSession s, SEFrameworkNode fn, SERubricPerformanceLevel pl, int count)
         {
             s.ScoreFrameworkNode(1, fn.Id,pl);
             s = Fixture.SEMgr.EvalSession(s.Id);
             SEFrameworkNodeScore[] scores = s.FrameworkNodeScores;
             Assert.AreEqual(scores[0].Id, ((IDbObject)scores[0]).Id);
             Assert.AreEqual(count, scores.Length);
             Assert.IsNotNull(FindFrameworkNodeScore(scores, s.Id, fn.Id, pl, 1));
         }

         [Test]
         public void FrameworkNodeScore()
         {
             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1");
             SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2");

             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
             Assert.AreEqual(c1Node.Id, Fixture.SEMgr.FrameworkNode(c1Node.Id).Id);

             FrameworkNodeScoreInner(s1, c1Node, SERubricPerformanceLevel.PL1, 1);
             FrameworkNodeScoreInner(s2, c1Node, SERubricPerformanceLevel.PL1, 1);
             FrameworkNodeScoreInner(s1, c1Node, SERubricPerformanceLevel.PL2, 1);
             FrameworkNodeScoreInner(s2, c1Node, SERubricPerformanceLevel.PL2, 1);
             FrameworkNodeScoreInner(s1, c1Node, SERubricPerformanceLevel.PL3, 1);
             FrameworkNodeScoreInner(s1, c1Node, SERubricPerformanceLevel.PL4, 1);
             FrameworkNodeScoreInner(s1, c1Node, SERubricPerformanceLevel.UNDEFINED, 1);

             SEFrameworkNode c2Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C2");

             FrameworkNodeScoreInner(s1, c2Node, SERubricPerformanceLevel.PL1, 2);
             FrameworkNodeScoreInner(s2, c2Node, SERubricPerformanceLevel.PL1, 2);
             FrameworkNodeScoreInner(s1, c2Node, SERubricPerformanceLevel.PL2, 2);
             FrameworkNodeScoreInner(s2, c2Node, SERubricPerformanceLevel.PL2, 2);
             FrameworkNodeScoreInner(s1, c2Node, SERubricPerformanceLevel.PL3, 2);
             FrameworkNodeScoreInner(s1, c2Node, SERubricPerformanceLevel.PL4, 2);
             FrameworkNodeScoreInner(s1, c2Node, SERubricPerformanceLevel.UNDEFINED, 2);

             SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
             Assert.IsNotNull(instructFramework);

             SEFrameworkNode d1Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D1");

             FrameworkNodeScoreInner(s1, d1Node, SERubricPerformanceLevel.PL1, 3);
             FrameworkNodeScoreInner(s2, d1Node, SERubricPerformanceLevel.PL1, 3);
             FrameworkNodeScoreInner(s1, d1Node, SERubricPerformanceLevel.PL2, 3);
             FrameworkNodeScoreInner(s2, d1Node, SERubricPerformanceLevel.PL2, 3);
             FrameworkNodeScoreInner(s1, d1Node, SERubricPerformanceLevel.PL3, 3);
             FrameworkNodeScoreInner(s1, d1Node, SERubricPerformanceLevel.PL4, 3);
             FrameworkNodeScoreInner(s1, d1Node, SERubricPerformanceLevel.UNDEFINED, 3);

         }

         SERubricRowScore FindRubricRowScore(SERubricRowScore[] scores, long sessionId, long rrId, SERubricPerformanceLevel pl, long scorerId)
         {
             foreach (SERubricRowScore score in scores)
             {
                 if (score.EvalSessionId == sessionId && score.RubricRowId == rrId && score.PerformanceLevel == pl && score.UserId == scorerId)
                 {
                     return score;
                 }
             }
             return null;
         }

         protected SERubricRowScore RubricRowScoreInner(SEEvalSession s, SEUser scorer, SERubricRow rr, SERubricPerformanceLevel pl, int count)
         {
             s.ScoreRubricRow(scorer.Id, rr.Id, pl);
             s = Fixture.SEMgr.EvalSession(s.Id);
             SERubricRowScore[] scores = s.AllRubricRowScores;
             Assert.AreEqual(count, scores.Length);
             SERubricRowScore score = FindRubricRowScore(scores, s.Id, rr.Id, pl, scorer.Id);
             Assert.IsNotNull(score);
             return score;
         }

         [Test]
         public void RubricRowScore()
         {
             SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
             SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             SEEvalSession s1 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher.Id);
             SEEvalSession s2 = Fixture.CreateTestTeacherEvalSession("S2", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id, teacher.Id);

             SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
             Assert.IsNotNull(stateFramework);

             SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
             SERubricRow[] rrows = c1Node.RubricRows;
             SERubricRow rr1c = Fixture.FindRubricRowTitleStartWith(rrows, "2b");
 
             SERubricRowScore score = RubricRowScoreInner(s1, principal, rr1c, SERubricPerformanceLevel.PL1, 1);
             Assert.AreEqual(((IDbObject)score).Id, score.Id);
             Assert.AreEqual(principal.Id, score.UserId);
             Assert.AreEqual("", score.DisplayName);

             RubricRowScoreInner(s2, principal, rr1c, SERubricPerformanceLevel.PL1, 1);
             RubricRowScoreInner(s1, principal, rr1c, SERubricPerformanceLevel.PL2, 1);
             RubricRowScoreInner(s2, principal, rr1c, SERubricPerformanceLevel.PL2, 1);
             RubricRowScoreInner(s1, principal, rr1c, SERubricPerformanceLevel.PL3, 1);
             RubricRowScoreInner(s1, principal, rr1c, SERubricPerformanceLevel.PL4, 1);
             RubricRowScoreInner(s1, principal, rr1c, SERubricPerformanceLevel.UNDEFINED, 1);

             SEFrameworkNode c4Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C4");
             rrows = c4Node.RubricRows;
             SERubricRow rr1e = Fixture.FindRubricRowTitleStartWith(rrows, "1e");

             RubricRowScoreInner(s1, principal, rr1e, SERubricPerformanceLevel.PL1, 2);
             RubricRowScoreInner(s2, principal, rr1e, SERubricPerformanceLevel.PL1, 2);
             RubricRowScoreInner(s1, principal, rr1e, SERubricPerformanceLevel.PL2, 2);
             RubricRowScoreInner(s2, principal, rr1e, SERubricPerformanceLevel.PL2, 2);
             RubricRowScoreInner(s1, principal, rr1e, SERubricPerformanceLevel.PL3, 2);
             RubricRowScoreInner(s1, principal, rr1e, SERubricPerformanceLevel.PL4, 2);
             RubricRowScoreInner(s1, principal, rr1e, SERubricPerformanceLevel.UNDEFINED, 2);

             SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
             Assert.IsNotNull(instructFramework);

             SEFrameworkNode d1Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D1");
             rrows = d1Node.RubricRows;
             SERubricRow rr1a = Fixture.FindRubricRowTitleStartWith(rrows, "1a");

             RubricRowScoreInner(s1, principal, rr1a, SERubricPerformanceLevel.PL1, 3);
             RubricRowScoreInner(s2, principal, rr1a, SERubricPerformanceLevel.PL1, 3);
             RubricRowScoreInner(s1, principal, rr1a, SERubricPerformanceLevel.PL2, 3);
             RubricRowScoreInner(s2, principal, rr1a, SERubricPerformanceLevel.PL2, 3);
             RubricRowScoreInner(s1, principal, rr1a, SERubricPerformanceLevel.PL3, 3);
             RubricRowScoreInner(s1, principal, rr1a, SERubricPerformanceLevel.PL4, 3);
             RubricRowScoreInner(s1, principal, rr1a, SERubricPerformanceLevel.UNDEFINED, 3);

         }

        #endregion
    }
}
