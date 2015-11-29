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
    class tTrainingProtocol : tBase
    {
        SETrainingProtocol TrainingProtocol { get; set; }

        SETrainingProtocol GetPublicProtocolByTitle(string title)
        {
            SETrainingProtocol[] protocols = Fixture.SEMgr.PublicSiteTrainingProtocols;
            foreach (SETrainingProtocol p in protocols)
            {
                if (p.Title == title)
                {
                    return p;
                }
            }

            return null;
        }

        SETrainingProtocol GetVideoLibraryProtocolByTitle(string title)
        {
            SETrainingProtocol[] protocols = Fixture.SEMgr.VideoLibraryTrainingProtocols;
            foreach (SETrainingProtocol p in protocols)
            {
                if (p.Title == title)
                {
                    return p;
                }
            }

            return null;
        }

        SEFrameworkNode GetFrameworkNodeByShortName(SEFrameworkNode[] nodes, string shortName)
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
        public void PublicTrainingProtocol_TestProperties()
        {
            TrainingProtocol = GetPublicProtocolByTitle("Primary: Constructing Meaning Through Reading");
            Assert.True(TrainingProtocol.VideoSrc.Contains("blob.core"));
            Assert.AreEqual("5:10", TrainingProtocol.VideoLength);
            Assert.AreEqual("Video96.pdf", TrainingProtocol.DocName);
            Assert.IsFalse(TrainingProtocol.Retired);
            Assert.IsTrue(TrainingProtocol.Published);
            Assert.AreEqual(0, TrainingProtocol.AvgRating);
            Assert.AreEqual(0, TrainingProtocol.NumRatings);

            SEFrameworkNode[] nodes = TrainingProtocol.StateAlignedFrameworkNodes;
            Assert.IsNotNull(GetFrameworkNodeByShortName(nodes, "C2"));
            Assert.IsNotNull(GetFrameworkNodeByShortName(nodes, "C4"));
            Assert.IsNotNull(GetFrameworkNodeByShortName(nodes, "C5"));

            nodes = TrainingProtocol.HEFTFAlignedFrameworkNodes;
            Assert.IsNotNull(GetFrameworkNodeByShortName(nodes, "H7"));

        }

        [Test]
        public void Ratings()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            TrainingProtocol = GetPublicProtocolByTitle("Primary: Constructing Meaning Through Reading");
     
            TrainingProtocol.AddRating(pr.Id, Convert.ToDecimal(2.0), "Low", false);
            SETrainingProtocolRating[] ratings = TrainingProtocol.Ratings;
            Assert.AreEqual(0, ratings.Length);

            TrainingProtocol.AddRating(pr.Id, Convert.ToDecimal(4.0), "High", false);
            ratings = TrainingProtocol.Ratings;
            Assert.AreEqual(0, ratings.Length);

            ratings = SEMgr.Instance.TrainingProtocolRatings(SETrainingProtocolRatingStatusType.INREVIEW);
            Assert.AreEqual(2, ratings.Length);
            foreach (SETrainingProtocolRating r in ratings)
            {
                SEMgr.Instance.UpdateTrainingProtocolRatingStatus(TrainingProtocol.Id, r.Id, SETrainingProtocolRatingStatusType.APPROVED);
            }

            ratings = SEMgr.Instance.TrainingProtocolRatings(SETrainingProtocolRatingStatusType.INREVIEW);
            Assert.AreEqual(0, ratings.Length);
 
            ratings = TrainingProtocol.Ratings;
            Assert.AreEqual(2, ratings.Length);

            // They are returning in most-recent order
            Assert.AreEqual("High", ratings[0].Comments);
            Assert.AreEqual(Convert.ToDecimal(4.0), ratings[0].Rating);

            TrainingProtocol = GetPublicProtocolByTitle("Primary: Constructing Meaning Through Reading");
            Assert.AreEqual(Convert.ToDecimal(3.0), TrainingProtocol.AvgRating);
        }

        [Test]
        public void PlayList()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            TrainingProtocol = GetVideoLibraryProtocolByTitle("Allison King - Grade 4 Social Studies Post Part1");
            TrainingProtocol.AddToPlaylist(pr.Id);

            SETrainingProtocol[] protocols = SEMgr.Instance.TrainingProtocolPlaylist(pr.Id);
            Assert.AreEqual(1, protocols.Length);
            Assert.IsTrue(protocols[0].IsOnPlaylist(pr.Id));

            TrainingProtocol.RemoveFromPlaylist(pr.Id);

            protocols = SEMgr.Instance.TrainingProtocolPlaylist(pr.Id);
            Assert.AreEqual(0, protocols.Length);
        }

        [Test]
        public void CreatePracticeSession()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            TrainingProtocol = GetVideoLibraryProtocolByTitle("Allison King - Grade 4 Social Studies Post Part1");

            long sessionId = TrainingProtocol.CreateVideoPracticeSession(pr, "Test Practice Session #1", Fixture.CurrentSchoolYear, false);
            SEEvalSession s = Fixture.SEMgr.EvalSession(sessionId);
            SEPracticeSession ps = SEMgr.Instance.PracticeSessionFromEvalSessionId(sessionId);
            Assert.IsNotNull(ps);

            Assert.AreEqual(ps.CreateByUser.Id, s.EvaluatorId);
            Assert.AreEqual(SEPracticeSessionType.VIDEO, ps.SessionType);
            Assert.AreEqual(1, ps.Participants.Length);
            Assert.AreEqual(s.DistrictCode, ps.DistrictCode);
            Assert.AreEqual(SEEvaluationType.TEACHER_OBSERVATION, s.EvaluationType);
            Assert.AreEqual(SEEvaluationScoreType.DRIFT_DETECT, s.EvaluationScoreType);
            Assert.AreEqual(TrainingProtocol.Id, ps.TrainingProtocolId);
            Assert.AreEqual(TrainingProtocol.Id, s.TrainingProtocolId);
            Assert.AreEqual(ps.SchoolYear, s.SchoolYear);
 
        }

        [Test]
        public void RandomDigits()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            TrainingProtocol = GetVideoLibraryProtocolByTitle("Allison King - Grade 4 Social Studies Post Part1");

            long sessionId = TrainingProtocol.CreateVideoPracticeSession(pr, "Test Practice Session #1", Fixture.CurrentSchoolYear, false);
            SEPracticeSession ps = SEMgr.Instance.PracticeSessionFromEvalSessionId(sessionId);
            short randomDigits = ps.RandomDigits;

            SEPracticeSession ps2 = SEMgr.Instance.PracticeSession(ps.Id, randomDigits);
            Assert.AreEqual(ps.Id, ps2.Id);
        }

        [Test]
        public void AddParticipant()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            TrainingProtocol = GetVideoLibraryProtocolByTitle("Allison King - Grade 4 Social Studies Post Part1");

            long sessionId = TrainingProtocol.CreateVideoPracticeSession(pr, "Test Practice Session #1", Fixture.CurrentSchoolYear, false);
            SEPracticeSession ps = SEMgr.Instance.PracticeSessionFromEvalSessionId(sessionId);

            SEEvalSession s = ps.AddParticipant(SEMgr.Instance.SEUser(t1.UserName));

            Assert.AreEqual(2, ps.Participants.Length);
        }

        [Test]
        public void SetAnchor()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            TrainingProtocol = GetVideoLibraryProtocolByTitle("Allison King - Grade 4 Social Studies Post Part1");

            long sessionId = TrainingProtocol.CreateVideoPracticeSession(pr, "Test Practice Session #1", Fixture.CurrentSchoolYear, false);
            SEPracticeSession ps = SEMgr.Instance.PracticeSessionFromEvalSessionId(sessionId);

            SEEvalSession s = ps.AddParticipant(SEMgr.Instance.SEUser(t1.UserName));

            Assert.AreEqual(-1, ps.AnchorEvalSessionId);

            ps.UpdateAnchorEvalSession(s.Id);
            Assert.AreEqual(s.Id, ps.AnchorEvalSessionId);

            ps.UpdateAnchorEvalSession(-1);
            Assert.AreEqual(-1, ps.AnchorEvalSessionId);
        }
    }
}
