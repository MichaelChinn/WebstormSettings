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
    class tPracticeSession : tBase
    {
        const string title = "Practice 1";
        const long trainingProtocolId = 1;

        SEEvalSession EvalSession { get; set; }
        SEPracticeSession PracticeSession { get; set; }

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

        protected SEFrameworkNodeScore FindFrameworkNodeScore(SEFrameworkNodeScore[] scores, SEEvalSession s, long nodeId, SERubricPerformanceLevel pl)
        {
            foreach (SEFrameworkNodeScore score in scores)
            {
                if (score.EvalSessionId == s.Id && score.FrameworkNodeId == nodeId && score.PerformanceLevel == pl && score.UserId == s.EvaluatorId)
                {
                    return score;
                }
            }
            return null;
        }

        void CreateVideoSession()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SETrainingProtocol p = Fixture.SEMgr.TrainingProtocol(1);
            long evalSessionId = p.CreateVideoPracticeSession(pr, title, Fixture.CurrentSchoolYear, false);
            Assert.IsTrue(evalSessionId > 0);
            EvalSession = Fixture.SEMgr.EvalSession(evalSessionId);
            Assert.NotNull(EvalSession);
            PracticeSession = Fixture.SEMgr.PracticeSession(EvalSession);
            Assert.NotNull(PracticeSession);
        }

        [Test]
        public void CreateVideoSession_TestProperties()
        {
            CreateVideoSession();
 
            SEEvalSession[] participantSessions = PracticeSession.ParticipantEvalSessions;

            Assert.AreEqual(SEPracticeSessionType.VIDEO, PracticeSession.SessionType);
            Assert.AreEqual(Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR).Id, PracticeSession.CreatedByUserId);
            Assert.AreEqual(1, participantSessions.Length);
            Assert.AreEqual(EvalSession.Id, participantSessions[0].Id);
            Assert.AreEqual(-1, PracticeSession.AnchorEvalSessionId);
            Assert.AreEqual(title, PracticeSession.Title);
            Assert.AreEqual(PracticeSession.SchoolYear, Fixture.CurrentSchoolYear);
            Assert.AreEqual(PracticeSession.TrainingProtocolId, trainingProtocolId);
            Assert.AreEqual(PracticeSession.LockState, SEEvalSessionLockState.Unlocked);
        }

        [Test]
        public void JoinPracticeSession()
        {
            CreateVideoSession();
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvalSession s = PracticeSession.AddParticipant(t1);
            Assert.AreEqual(s.EvaluatorId, t1.Id);
            SEEvalSession[] participantSessions = PracticeSession.ParticipantEvalSessions;
            Assert.AreEqual(2, participantSessions.Length);

            string newTitle = "New Title";
            PracticeSession.UpdateTitle(newTitle);
            PracticeSession.UpdateLockState(SEEvalSessionLockState.Locked);

            participantSessions = PracticeSession.ParticipantEvalSessions;
            foreach (SEEvalSession p in participantSessions)
            {
                Assert.AreEqual(newTitle, p.Title);
                Assert.AreEqual(SEEvalSessionLockState.Locked, p.LockState);
            }

            PracticeSession.UpdateAnchorEvalSession(s.Id);
            Assert.AreEqual(PracticeSession.AnchorEvalSessionId, s.Id);
            Assert.AreNotEqual(EvalSession.Id, s.Id);
        }

        [Test]
        public void DeletePracticeSession()
        {
            CreateVideoSession();
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvalSession s = PracticeSession.AddParticipant(t1);
            Fixture.SEMgr.RemovePracticeSession(PracticeSession.Id);
            Assert.IsNull(Fixture.SEMgr.PracticeSession(PracticeSession.Id));
            Assert.IsNull(Fixture.SEMgr.EvalSession(EvalSession.Id));
        }

        protected void PracticeSessionScoreInner(SEEvalSession anchorSession, SERubricPerformanceLevel anchorPL,
                                         SEEvalSession s1Session, SERubricPerformanceLevel s1PL,
                                         SEEvalSession s2Session, SERubricPerformanceLevel s2PL)
        {
            anchorSession.ScoreSession(anchorPL);
            s1Session.ScoreSession(s1PL);
            s2Session.ScoreSession(s2PL);

            SEEvalSession s = Fixture.SEMgr.EvalSession(anchorSession.Id);
            Assert.AreEqual(anchorPL, s.Score);

            s = Fixture.SEMgr.EvalSession(s1Session.Id);
            Assert.AreEqual(s1PL, s.Score);

            s = Fixture.SEMgr.EvalSession(s2Session.Id);
            Assert.AreEqual(s2PL, s.Score);
        }

        public void PracticeSessionScore(SEEvalSession anchorSession, SEEvalSession s1Session, SEEvalSession s2Session)
        {
            PracticeSessionScoreInner(anchorSession, SERubricPerformanceLevel.PL1,
                                      s1Session, SERubricPerformanceLevel.PL2,
                                      s2Session, SERubricPerformanceLevel.PL3);
        }

        protected void PracticeSessionFrameworkNodeScoreInner(SEEvalSession anchorSession, SEFrameworkNode anchorNode, SERubricPerformanceLevel anchorPL,
                                                            SEEvalSession s1Session, SEFrameworkNode s1Node, SERubricPerformanceLevel s1PL,
                                                            SEEvalSession s2Session, SEFrameworkNode s2Node, SERubricPerformanceLevel s2PL)
        {
            anchorSession.ScoreFrameworkNode(anchorSession.EvaluatorId, anchorNode.Id, anchorPL);
            s1Session.ScoreFrameworkNode(s1Session.EvaluatorId, s1Node.Id, s1PL);
            s2Session.ScoreFrameworkNode(s2Session.EvaluatorId, s2Node.Id, s2PL);
            
            Assert.IsNotNull(FindFrameworkNodeScore(anchorSession.FrameworkNodeScores, anchorSession, anchorNode.Id, anchorPL));
            Assert.IsNotNull(FindFrameworkNodeScore(s1Session.FrameworkNodeScores, s1Session, s1Node.Id, s1PL));
            Assert.IsNotNull(FindFrameworkNodeScore(s2Session.FrameworkNodeScores, s2Session, s2Node.Id, s2PL));
        }

        public void PracticeSessionFrameworkNodeScore( SEEvalSession anchorSession, SEEvalSession s1Session, SEEvalSession s2Session)
        {
            SEFrameworkNode c1Node = Fixture.GetFrameworkNodeForDistrict(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE, "C1");
            SEFrameworkNode c2Node = Fixture.GetFrameworkNodeForDistrict(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE, "C2");
            PracticeSessionFrameworkNodeScoreInner(anchorSession, c1Node, SERubricPerformanceLevel.PL1,
                                                    s1Session, c1Node, SERubricPerformanceLevel.PL2,
                                                    s2Session, c2Node, SERubricPerformanceLevel.PL3);

            SEFrameworkNodeScore[] scores = PracticeSession.GetFrameworkNodeScoresForPracticeSession(c1Node);
            Assert.AreEqual(2, scores.Length);

            scores = PracticeSession.GetFrameworkNodeScoresForPracticeSession(c2Node);
            Assert.AreEqual(1, scores.Length);

        }

        protected void PracticeSessionRubricRowScoreInner(SEEvalSession anchorSession, SERubricRow anchorRow, SERubricPerformanceLevel anchorPL,
                                                        SEEvalSession s1Session, SERubricRow s1Row, SERubricPerformanceLevel s1PL,
                                                        SEEvalSession s2Session, SERubricRow s2Row, SERubricPerformanceLevel s2PL)
        {
            anchorSession.ScoreRubricRow(anchorSession.EvaluatorId, anchorRow.Id, anchorPL);
            s1Session.ScoreRubricRow(s1Session.EvaluatorId, s1Row.Id, s1PL);
            s2Session.ScoreRubricRow(s2Session.EvaluatorId, s2Row.Id, s2PL);

            Assert.IsNotNull(FindRubricRowScore(anchorSession.AllRubricRowScores, anchorSession.Id, anchorRow.Id, anchorPL, anchorSession.EvaluatorId));
            Assert.IsNotNull(FindRubricRowScore(s1Session.AllRubricRowScores, s1Session.Id, s1Row.Id, s1PL, s1Session.EvaluatorId));
            Assert.IsNotNull(FindRubricRowScore(s2Session.AllRubricRowScores, s2Session.Id, s2Row.Id, s2PL, s2Session.EvaluatorId));

            SERubricRowScore[] scores = PracticeSession.GetRubricRowScoresForPracticeSession(anchorRow);
            Assert.AreEqual(2, scores.Length);

            Assert.IsNotNull(FindRubricRowScore(scores, anchorSession.Id, anchorRow.Id, anchorPL, anchorSession.EvaluatorId));
        }

        public void PracticeSessionRubricRowScore(SEEvalSession anchorSession, SEEvalSession s1Session, SEEvalSession s2Session)
        {
            SEFrameworkNode c1Node = Fixture.GetFrameworkNodeForDistrict(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE, "C1");
            SERubricRow[] rrows = c1Node.RubricRows;

            SERubricRow rr2b = Fixture.FindRubricRowTitleStartWith(rrows, "2b");
            SERubricRow rr3a = Fixture.FindRubricRowTitleStartWith(rrows, "3a");

            PracticeSessionRubricRowScoreInner(anchorSession, rr2b, SERubricPerformanceLevel.PL1,
                                           s1Session, rr3a, SERubricPerformanceLevel.PL2,
                                           s2Session, rr2b, SERubricPerformanceLevel.PL3);
        }

        [Test]
        public void Scoring()
        {
            CreateVideoSession();
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvalSession s1 = PracticeSession.AddParticipant(t1);
            SEUser t2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEEvalSession s2 = PracticeSession.AddParticipant(t2);
            PracticeSession.UpdateAnchorEvalSession(EvalSession.Id);

            SEEvalSession[] participantSessions = PracticeSession.ParticipantEvalSessions;

            PracticeSessionScore(EvalSession, s1, s2);
            PracticeSessionFrameworkNodeScore(EvalSession, s1, s2);
            PracticeSessionRubricRowScore(EvalSession, s1, s2);
        }

        [Test]
        public void CalibrationElement()
        {
            SEFramework f = Fixture.GetFrameworkForDistrict(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            SEFrameworkNode[] nodes = f.AllNodes;
            SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(nodes, "C1");
            SERubricRow[] rrows = c1Node.RubricRows;

            ICalibrationScoreElement[] calibrationElementRRows = (ICalibrationScoreElement[])c1Node.RubricRows;
            Assert.AreEqual(rrows[0].Title, calibrationElementRRows[0].Title);
            Assert.AreEqual(rrows[0].Id.ToString(), calibrationElementRRows[0].Field);
            Assert.AreEqual(rrows[0].Id.ToString(), calibrationElementRRows[0].Id);

            ICalibrationScoreElement calibrationElementRRow = calibrationElementRRows[0];
            Assert.AreEqual(rrows[0].Title, calibrationElementRRow.Title);
            Assert.AreEqual(rrows[0].Id.ToString(), calibrationElementRRow.Field);
            Assert.AreEqual(rrows[0].Id.ToString(), calibrationElementRRow.Id);
            Assert.AreEqual(SECalibrationScoreElementType.RubricRow, calibrationElementRRow.ElementType);

            ICalibrationScoreElement[] calibrationElementNodes = (ICalibrationScoreElement[])nodes;
            Assert.AreEqual(nodes[0].ShortName, calibrationElementNodes[0].Title);
            Assert.AreEqual(nodes[0].ShortName, calibrationElementNodes[0].Field);
            Assert.AreEqual(nodes[0].Id.ToString(), calibrationElementNodes[0].Id);

            ICalibrationScoreElement calibrationElementNode = calibrationElementNodes[0];
            Assert.AreEqual(nodes[0].ShortName, calibrationElementNode.Title);
            Assert.AreEqual(nodes[0].ShortName, calibrationElementNode.Field);
            Assert.AreEqual(nodes[0].Id.ToString(), calibrationElementNode.Id);
            Assert.AreEqual(SECalibrationScoreElementType.FrameworkNode, calibrationElementNode.ElementType);
        }

        private void AddFrameworkScore(SEFrameworkNode[] nodes, SEEvalSession es, SERubricPerformanceLevel[] scores)
        {
            int i = 1;
            foreach (SEFrameworkNode fn in nodes)
            {
                foreach (SERubricRow rr in fn.RubricRows)
                {
                    es.ScoreRubricRow(es.EvaluatorId, rr.Id, scores[i]);
                }
                es.ScoreFrameworkNode(es.EvaluatorId, fn.Id, scores[i++]);
            }
        }

        private void ReportingStateFramework(SERubricPerformanceLevel[] aState, SERubricPerformanceLevel[] s1State,SERubricPerformanceLevel[] s2State,
            SERubricPerformanceLevel[] aInst, SERubricPerformanceLevel[] s1Inst, SERubricPerformanceLevel[] s2Inst)
        {
            CreateVideoSession();
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEEvalSession s1 = PracticeSession.AddParticipant(t1);
            SEUser t2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEEvalSession s2 = PracticeSession.AddParticipant(t2);
            PracticeSession.UpdateAnchorEvalSession(EvalSession.Id);

            SEEvalSession[] participantSessions = PracticeSession.ParticipantEvalSessions;
            Assert.AreEqual(3, participantSessions.Length);

            // Score for observation
            EvalSession.ScoreSession(aState[0]);
            s1.ScoreSession(s1State[0]);
            s2.ScoreSession(s2State[0]);

            // State Framework score
            SEFramework stateFramework = Fixture.SEMgr.Framework(PracticeSession.DistrictCode, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            Assert.IsNotNull(stateFramework);
            Assert.AreEqual(8, stateFramework.AllNodes.Length);

            // Anchor
            AddFrameworkScore(stateFramework.AllNodes, EvalSession, aState);
            // S1 Framework score
            AddFrameworkScore(stateFramework.AllNodes, s1, s1State);
            // S2 Framework score
            AddFrameworkScore(stateFramework.AllNodes, s2, s2State);

            // Verify Level 1 & Level 2 report - State Framework
            {
                VerifyReportLevel1(stateFramework, participantSessions, t1, t2, aState, s1State, s2State);

                int position = 1;
                foreach (SEFrameworkNode fn in stateFramework.AllNodes)
                {
                    VerifyReportLevel2(stateFramework, participantSessions, t1, t2, aState, s1State, s2State, fn, position++);
                }
            }

            // Instructional Framework score
            SEFramework instructionalFramework = Fixture.SEMgr.Framework(PracticeSession.DistrictCode, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
            Assert.IsNotNull(instructionalFramework);
            Assert.AreEqual(4, instructionalFramework.AllNodes.Length);

            // Anchor
            AddFrameworkScore(instructionalFramework.AllNodes, EvalSession, aInst);
            // S1 Framework score
            AddFrameworkScore(instructionalFramework.AllNodes, s1, s1Inst);
            // S2 Framework score
            AddFrameworkScore(instructionalFramework.AllNodes, s2, s2Inst);

            // Verify Level 1 & Level 2 report - Instructional Framework
            {
                VerifyReportLevel1(instructionalFramework, participantSessions, t1, t2, aInst, s1Inst, s2Inst);

                int position = 1;
                foreach (SEFrameworkNode fn in instructionalFramework.AllNodes)
                {
                    VerifyReportLevel2(instructionalFramework, participantSessions, t1, t2, aInst, s1Inst, s2Inst, fn, position++);
                }
            }
        }

        private void VerifyReportLevel1(SEFramework stateFramework, 
            SEEvalSession[] participantSessions,
            SEUser t1,
            SEUser t2,
            SERubricPerformanceLevel[] anchorScores,
            SERubricPerformanceLevel[] s1Scores,
            SERubricPerformanceLevel[] s2Scores)
        {
            int[] expected_EXACT = new int[anchorScores.Length];
            int[] expected_ADJACENT = new int[anchorScores.Length];
            int[] expected_ADJACENT_HIGH = new int[anchorScores.Length];
            int[] expected_ADJACENT_LOW = new int[anchorScores.Length];
            int[] expected_NON_ADJACENT = new int[anchorScores.Length];
            int[] expected_NON_ADJACENT_HIGH = new int[anchorScores.Length];
            int[] expected_NON_ADJACENT_LOW = new int[anchorScores.Length];

            for (int k = 0; k < anchorScores.Length; k++)
            {
                {
                    int exact = 0;
                    if (s1Scores[k] == anchorScores[k])
                        exact++;
                    if (s2Scores[k] == anchorScores[k])
                        exact++;
                    expected_EXACT[k] = exact;
                }

                {
                    int adjacent = 0;
                    if (Math.Abs(s1Scores[k] - anchorScores[k]) == 1)
                        adjacent++;
                    if (Math.Abs(s2Scores[k] - anchorScores[k]) == 1)
                        adjacent++;
                    expected_ADJACENT[k] = adjacent;
                }

                {
                    int adjacent_high = 0;
                    if ((s1Scores[k] - anchorScores[k]) == 1)
                        adjacent_high++;
                    if ((s2Scores[k] - anchorScores[k]) == 1)
                        adjacent_high++;
                    expected_ADJACENT_HIGH[k] = adjacent_high;
                }

                {
                    int adjacent_low = 0;
                    if ((anchorScores[k] - s1Scores[k]) == 1)
                        adjacent_low++;
                    if ((anchorScores[k] - s2Scores[k]) == 1)
                        adjacent_low++;
                    expected_ADJACENT_LOW[k] = adjacent_low;
                }

                // non
                {
                    int non_adjacent = 0;
                    if (Math.Abs(s1Scores[k] - anchorScores[k]) > 1)
                        non_adjacent++;
                    if (Math.Abs(s2Scores[k] - anchorScores[k]) > 1)
                        non_adjacent++;
                    expected_NON_ADJACENT[k] = non_adjacent;
                }

                {
                    int non_adjacent_high = 0;
                    if ((s1Scores[k] - anchorScores[k]) > 1)
                        non_adjacent_high++;
                    if ((s2Scores[k] - anchorScores[k]) > 1)
                        non_adjacent_high++;
                    expected_NON_ADJACENT_HIGH[k] = non_adjacent_high;
                }

                {
                    int non_adjacent_low = 0;
                    if ((anchorScores[k] - s1Scores[k]) > 1)
                        non_adjacent_low++;
                    if ((anchorScores[k] - s2Scores[k]) > 1)
                        non_adjacent_low++;
                    expected_NON_ADJACENT_LOW[k] = non_adjacent_low;
                }
            }

            string sproc = "GetPracticeFNScoringData";
            string field = "ShortName";
            ScorerComparisonDataByFNShortName d = new ScorerComparisonDataByFNShortName(Fixture.SEMgr.DbConnector, sproc, field,
                                                                                        PracticeSession.Id,
                                                                                        stateFramework, null, stateFramework.AllNodes);
            d.LoadData(Fixture.SEMgr.DbConnector);

            // Anchor score verify
            Assert.AreEqual(anchorScores[0], d.Score("SUMANCHORSCORE"));

            int i = 1;
            foreach (SEFrameworkNode fn in stateFramework.AllNodes)
            {
                Assert.AreEqual(anchorScores[i++], d.Score(fn.ShortName + "AnchorScore"));
            }

            // Scorers score verify
            Assert.AreEqual((participantSessions.Length - 1), d.ScorerIds.Count);

            Assert.AreEqual(s1Scores[0], d.ScoreForScorer(t1.Id, "SUM"));
            Assert.AreEqual(s2Scores[0], d.ScoreForScorer(t2.Id, "SUM"));

            foreach (long scorersId in d.ScorerIds)
            {
                i = 1;
                foreach (SEFrameworkNode fn in stateFramework.AllNodes)
                {
                    if (t1.Id == scorersId)
                        Assert.AreEqual(s1Scores[i++], d.ScoreForScorer(scorersId, fn.ShortName));
                    else if (t2.Id == scorersId)
                        Assert.AreEqual(s2Scores[i++], d.ScoreForScorer(scorersId, fn.ShortName));
                    else
                        Assert.Fail("Invalid scorer found!");
                }
            }

            // OBSERVATION Column
            // EXACT
            Assert.AreEqual(expected_EXACT[0], d.ScoreAsInt("SUMEXACTCOUNT"));

            // ADJACENT, ADJACENT HIGH, ADJACENT LOW
            Assert.AreEqual(expected_ADJACENT[0], d.ScoreAsInt("SUMADJACENTCOUNT"));
            Assert.AreEqual(expected_ADJACENT_HIGH[0], d.ScoreAsInt("SUMADJACENTHIGHCOUNT"));
            Assert.AreEqual(expected_ADJACENT_LOW[0], d.ScoreAsInt("SUMADJACENTLOWCOUNT"));

            // NON ADJACENT, NON ADJACENT HIGH, NON ADJACENT LOW
            Assert.AreEqual(expected_NON_ADJACENT[0], d.ScoreAsInt("SUMNONADJACENTCOUNT"));
            Assert.AreEqual(expected_NON_ADJACENT_HIGH[0], d.ScoreAsInt("SUMNONADJACENTHIGHCOUNT"));
            Assert.AreEqual(expected_NON_ADJACENT_LOW[0], d.ScoreAsInt("SUMNONADJACENTLOWCOUNT"));

            // All Famework Nodes
            i = 1;

            foreach (SEFrameworkNode fn in stateFramework.AllNodes)
            {
                // EXACT
                Assert.AreEqual(expected_EXACT[i], d.ScoreAsInt(fn.ShortName + "EXACTCOUNT"));

                // ADJACENT, ADJACENT HIGH, ADJACENT LOW
                Assert.AreEqual(expected_ADJACENT[i], d.ScoreAsInt(fn.ShortName + "ADJACENTCOUNT"));
                Assert.AreEqual(expected_ADJACENT_HIGH[i], d.ScoreAsInt(fn.ShortName + "ADJACENTHIGHCOUNT"));
                Assert.AreEqual(expected_ADJACENT_LOW[i], d.ScoreAsInt(fn.ShortName + "ADJACENTLOWCOUNT"));

                // NON ADJACENT, NON ADJACENT HIGH, NON ADJACENT LOW
                Assert.AreEqual(expected_NON_ADJACENT[i], d.ScoreAsInt(fn.ShortName + "NONADJACENTCOUNT"));
                Assert.AreEqual(expected_NON_ADJACENT_HIGH[i], d.ScoreAsInt(fn.ShortName + "NONADJACENTHIGHCOUNT"));
                Assert.AreEqual(expected_NON_ADJACENT_LOW[i++], d.ScoreAsInt(fn.ShortName + "NONADJACENTLOWCOUNT"));
            }

            Assert.AreEqual((stateFramework.AllNodes.Length + 1) * (participantSessions.Length - 1), d.ScoreAsInt("TOTALCOUNT"));
        }

        private void VerifyReportLevel2(SEFramework stateFramework,
            SEEvalSession[] participantSessions,
            SEUser t1,
            SEUser t2,
            SERubricPerformanceLevel[] anchorScores,
            SERubricPerformanceLevel[] s1Scores,
            SERubricPerformanceLevel[] s2Scores,
            SEFrameworkNode node,
            int position)
        {
            int[] expected_EXACT = new int[node.RubricRows.Length];
            int[] expected_ADJACENT = new int[node.RubricRows.Length];
            int[] expected_ADJACENT_HIGH = new int[node.RubricRows.Length];
            int[] expected_ADJACENT_LOW = new int[node.RubricRows.Length];
            int[] expected_NON_ADJACENT = new int[node.RubricRows.Length];
            int[] expected_NON_ADJACENT_HIGH = new int[node.RubricRows.Length];
            int[] expected_NON_ADJACENT_LOW = new int[node.RubricRows.Length];

            for (int k = 0; k < node.RubricRows.Length; k++)
            {
                {
                    int exact = 0;
                    if (s1Scores[position] == anchorScores[position])
                        exact++;
                    if (s2Scores[position] == anchorScores[position])
                        exact++;
                    expected_EXACT[k] = exact;
                }

                {
                    int adjacent = 0;
                    if (Math.Abs(s1Scores[position] - anchorScores[position]) == 1)
                        adjacent++;
                    if (Math.Abs(s2Scores[position] - anchorScores[position]) == 1)
                        adjacent++;
                    expected_ADJACENT[k] = adjacent;
                }

                {
                    int adjacent_high = 0;
                    if ((s1Scores[position] - anchorScores[position]) == 1)
                        adjacent_high++;
                    if ((s2Scores[position] - anchorScores[position]) == 1)
                        adjacent_high++;
                    expected_ADJACENT_HIGH[k] = adjacent_high;
                }

                {
                    int adjacent_low = 0;
                    if ((anchorScores[position] - s1Scores[position]) == 1)
                        adjacent_low++;
                    if ((anchorScores[position] - s2Scores[position]) == 1)
                        adjacent_low++;
                    expected_ADJACENT_LOW[k] = adjacent_low;
                }

                // non
                {
                    int non_adjacent = 0;
                    if (Math.Abs(s1Scores[position] - anchorScores[position]) > 1)
                        non_adjacent++;
                    if (Math.Abs(s2Scores[position] - anchorScores[position]) > 1)
                        non_adjacent++;
                    expected_NON_ADJACENT[k] = non_adjacent;
                }

                {
                    int non_adjacent_high = 0;
                    if ((s1Scores[position] - anchorScores[position]) > 1)
                        non_adjacent_high++;
                    if ((s2Scores[position] - anchorScores[position]) > 1)
                        non_adjacent_high++;
                    expected_NON_ADJACENT_HIGH[k] = non_adjacent_high;
                }

                {
                    int non_adjacent_low = 0;
                    if ((anchorScores[position] - s1Scores[position]) > 1)
                        non_adjacent_low++;
                    if ((anchorScores[position] - s2Scores[position]) > 1)
                        non_adjacent_low++;
                    expected_NON_ADJACENT_LOW[k] = non_adjacent_low;
                }
            }

            string sproc = "GetPracticeRRScoringData";
            string field = "RubricRowID";
            ScorerComparisonDataByFNShortName d = new ScorerComparisonDataByFNShortName(Fixture.SEMgr.DbConnector, sproc, field,
                                                                                        PracticeSession.Id,
                                                                                        stateFramework, node, node.RubricRows);
            d.LoadData(Fixture.SEMgr.DbConnector);

            // Anchor score verify
            Assert.AreEqual(anchorScores[position], d.Score("SUMANCHORSCORE"));

            
            foreach (SERubricRow rr in node.RubricRows)
            {
                Assert.AreEqual(anchorScores[position], d.Score(rr.Id + "AnchorScore"), position.ToString() + ":" + rr.Id.ToString());
            }

            // Scorers score verify
            Assert.AreEqual((participantSessions.Length - 1), d.ScorerIds.Count);

            Assert.AreEqual(s1Scores[position], d.ScoreForScorer(t1.Id, "SUM"));
            Assert.AreEqual(s2Scores[position], d.ScoreForScorer(t2.Id, "SUM"));

            foreach (long scorersId in d.ScorerIds)
            {
                foreach (SERubricRow rr in node.RubricRows)
                {
                    if (t1.Id == scorersId)
                        Assert.AreEqual(s1Scores[position], d.ScoreForScorer(scorersId, rr.Id.ToString()));
                    else if (t2.Id == scorersId)
                        Assert.AreEqual(s2Scores[position], d.ScoreForScorer(scorersId, rr.Id.ToString()));
                    else
                        Assert.Fail("Invalid scorer found!");
                }
            }

            // All Rubric Rows
            int i = 0;
            foreach (SERubricRow rr in node.RubricRows)
            {
                // EXACT
                Assert.AreEqual(expected_EXACT[i], d.ScoreAsInt(rr.Id.ToString() + "EXACTCOUNT"));

                // ADJACENT, ADJACENT HIGH, ADJACENT LOW
                Assert.AreEqual(expected_ADJACENT[i], d.ScoreAsInt(rr.Id.ToString() + "ADJACENTCOUNT"));
                Assert.AreEqual(expected_ADJACENT_HIGH[i], d.ScoreAsInt(rr.Id.ToString() + "ADJACENTHIGHCOUNT"));
                Assert.AreEqual(expected_ADJACENT_LOW[i], d.ScoreAsInt(rr.Id.ToString() + "ADJACENTLOWCOUNT"));

                // NON ADJACENT, NON ADJACENT HIGH, NON ADJACENT LOW
                Assert.AreEqual(expected_NON_ADJACENT[i], d.ScoreAsInt(rr.Id.ToString() + "NONADJACENTCOUNT"));
                Assert.AreEqual(expected_NON_ADJACENT_HIGH[i], d.ScoreAsInt(rr.Id.ToString() + "NONADJACENTHIGHCOUNT"));
                Assert.AreEqual(expected_NON_ADJACENT_LOW[i++], d.ScoreAsInt(rr.Id.ToString() + "NONADJACENTLOWCOUNT"));
            }

            Assert.AreEqual((node.RubricRows.Length + 1) * (participantSessions.Length - 1), d.ScoreAsInt("TOTALCOUNT"));
        }

        [Test]
        public void ReportingExample1()
        {
            /*
             * State Framework
             * 
             * SCORE SUMMARY	                OBSERVATION	    C1	    C2	    C3	    C4	    C5	    C6	    C7	    C8
             * CONSENSUS SCORE                  1               4       4       4       4       4       4       4       4
             * NorthThurstonHSUserName_T1       2               3       3       3       3       3       3       3       3
             * NorthThurstonHSUserName_T2       3               1       1       1       1       1       1       1       1
             * 
             * 
             * Instructional Framework                          D1      D2      D3      D4
             * CONSENSUS SCORE                                  3       4       1       4       
             * NorthThurstonHSUserName_T1                       4       3       3       4       
             * NorthThurstonHSUserName_T2                       1       1       1       1       
             * 
             * Verify Level 1 and Level 2 Reports
             * 
             * EXACT                                   
             * 
             * ADJACENT                                
             * ADJACENT HIGH                           
             * ADJACENT LOW                            
             * 
             * NON ADJACENT                            
             * NON ADJACENT HIGH                       
             * NON ADJACENT LOW                        
             */

            SERubricPerformanceLevel[] anchorScoresState = { SERubricPerformanceLevel.PL1, 
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4,
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s1ScoresState = { SERubricPerformanceLevel.PL2, 
                SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3,
                SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3 };
            SERubricPerformanceLevel[] s2ScoresState = { SERubricPerformanceLevel.PL3, 
                SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1,
                SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1 };

            SERubricPerformanceLevel[] anchorScoresInst = { SERubricPerformanceLevel.PL1,
                                                              SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s1ScoresInst = { SERubricPerformanceLevel.PL2, 
                                                          SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3, 
                                                            SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s2ScoresInst = { SERubricPerformanceLevel.PL3,
                                                          SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1 };

            ReportingStateFramework(anchorScoresState, s1ScoresState, s2ScoresState,
                anchorScoresInst, s1ScoresInst, s2ScoresInst);
        }

        [Test]
        public void ReportingExample2()
        {
            /*
             * SCORE SUMMARY	                OBSERVATION	    C1	    C2	    C3	    C4	    C5	    C6	    C7	    C8
             * CONSENSUS SCORE                  3               4       4       4       4       4       4       4       4
             * NorthThurstonHSUserName_T1       3               4       4       4       4       4       4       4       4
             * NorthThurstonHSUserName_T2       3               4       4       4       4       4       4       4       4
             * 
             * 
             * Instructional Framework                          D1      D2      D3      D4
             * CONSENSUS SCORE                                  3       4       1       4       
             * NorthThurstonHSUserName_T1                       4       3       3       4       
             * NorthThurstonHSUserName_T2                       1       1       1       1       
             * Verify Level 1 and Level 2 Reports
             * 
             * EXACT                                   
             * 
             * ADJACENT                                
             * ADJACENT HIGH                           
             * ADJACENT LOW                            
             * 
             * NON ADJACENT                            
             * NON ADJACENT HIGH                       
             * NON ADJACENT LOW       
             */

            SERubricPerformanceLevel[] anchorScoresState = { SERubricPerformanceLevel.PL3, 
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4,
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4 };

            SERubricPerformanceLevel[] s1ScoresState = { SERubricPerformanceLevel.PL3, 
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4,
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4 };

            SERubricPerformanceLevel[] s2ScoresState = { SERubricPerformanceLevel.PL3, 
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4,
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4 };

            SERubricPerformanceLevel[] anchorScoresInst = { SERubricPerformanceLevel.PL3,
                                                              SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s1ScoresInst = { SERubricPerformanceLevel.PL3,
                                                          SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3, 
                                                              SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s2ScoresInst = { SERubricPerformanceLevel.PL3,
                                                          SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1 };

            ReportingStateFramework(anchorScoresState, s1ScoresState, s2ScoresState,
                anchorScoresInst, s1ScoresInst, s2ScoresInst);
        }

        [Test]
        public void ReportingExample3()
        {
            /*
             * SCORE SUMMARY	                OBSERVATION	    C1	    C2	    C3	    C4	    C5	    C6	    C7	    C8
             * CONSENSUS SCORE                  4               2       2       2       2       2       2       2       2
             * NorthThurstonHSUserName_T1       4               4       4       4       4       4       4       4       4
             * NorthThurstonHSUserName_T2       3               2       2       2       2       2       2       2       2
             * 
             * 
             * Instructional Framework                          D1      D2      D3      D4
             * CONSENSUS SCORE                                  3       4       1       4       
             * NorthThurstonHSUserName_T1                       4       3       3       4       
             * NorthThurstonHSUserName_T2                       1       1       1       1        
             * Verify Level 1 and Level 2 Reports
             * 
             * EXACT                                   
             * 
             * ADJACENT                                
             * ADJACENT HIGH                           
             * ADJACENT LOW                            
             * 
             * NON ADJACENT                            
             * NON ADJACENT HIGH                       
             * NON ADJACENT LOW       
             */

            SERubricPerformanceLevel[] anchorScoresState = { SERubricPerformanceLevel.PL4, 
                SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2,
                SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2 };

            SERubricPerformanceLevel[] s1ScoresState = { SERubricPerformanceLevel.PL4, 
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4,
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL4 };

            SERubricPerformanceLevel[] s2ScoresState = { SERubricPerformanceLevel.PL3, 
                SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2,
                SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2 };

            SERubricPerformanceLevel[] anchorScoresInst = { SERubricPerformanceLevel.PL4,
                                                              SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s1ScoresInst = { SERubricPerformanceLevel.PL4,
                                                          SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3, 
                                                              SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s2ScoresInst = { SERubricPerformanceLevel.PL3,SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1 };

            ReportingStateFramework(anchorScoresState, s1ScoresState, s2ScoresState,
                anchorScoresInst, s1ScoresInst, s2ScoresInst);
        }

        [Test]
        public void ReportingExample4()
        {
            /*
             * SCORE SUMMARY	                OBSERVATION	    C1	    C2	    C3	    C4	    C5	    C6	    C7	    C8
             * CONSENSUS SCORE                  1               4       3       1       1       4       3       4       3
             * NorthThurstonHSUserName_T1       4               1       4       2       2       4       3       3       1
             * NorthThurstonHSUserName_T2       3               2       3       4       2       3       3       1       4
             * 
             * 
             * Instructional Framework                          D1      D2      D3      D4
             * CONSENSUS SCORE                                  3       4       1       4       
             * NorthThurstonHSUserName_T1                       4       3       3       4       
             * NorthThurstonHSUserName_T2                       1       1       1       1       
             * Verify Level 1 and Level 2 Reports
             * 
             * EXACT                                   
             * 
             * ADJACENT                                
             * ADJACENT HIGH                           
             * ADJACENT LOW                            
             * 
             * NON ADJACENT                            
             * NON ADJACENT HIGH                       
             * NON ADJACENT LOW
             * 
             */

            SERubricPerformanceLevel[] anchorScoresState = { SERubricPerformanceLevel.PL1, 
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1,
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3 };

            SERubricPerformanceLevel[] s1ScoresState = { SERubricPerformanceLevel.PL4, 
                SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL2,
                SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL1 };

            SERubricPerformanceLevel[] s2ScoresState = { SERubricPerformanceLevel.PL3, 
                SERubricPerformanceLevel.PL2, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL2,
                SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL4 };

            SERubricPerformanceLevel[] anchorScoresInst = { SERubricPerformanceLevel.PL1,
                                                              SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s1ScoresInst = { SERubricPerformanceLevel.PL4,
                                                          SERubricPerformanceLevel.PL4, SERubricPerformanceLevel.PL3, 
                                                              SERubricPerformanceLevel.PL3, SERubricPerformanceLevel.PL4 };
            SERubricPerformanceLevel[] s2ScoresInst = { SERubricPerformanceLevel.PL3,
                                                          SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1, 
                                                              SERubricPerformanceLevel.PL1, SERubricPerformanceLevel.PL1 };

            ReportingStateFramework(anchorScoresState, s1ScoresState, s2ScoresState,
                anchorScoresInst, s1ScoresInst, s2ScoresInst);
        }
    }
}
