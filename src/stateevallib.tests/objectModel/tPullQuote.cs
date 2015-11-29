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
    class tPullQuote : tBase
    {
        protected void VerifyPullQuoteLoad(SEPullQuote pq, SEEvalSession s, SEFrameworkNode fn, string quote, bool important, Guid guid, bool verifySessionTitle)
        {
            if (verifySessionTitle)
            {
                Assert.AreEqual(s.Title, pq.SessionTitle);
            }
            else
            {
                Assert.AreEqual("", pq.SessionTitle);
                Assert.AreEqual(DateTime.MinValue, pq.SessionStartTime);
            }

            Assert.AreEqual(fn.Id, pq.FrameworkNodeId);
            Assert.AreEqual(important, pq.IsImportant);
            Assert.AreEqual(guid, pq.Guid);
            Assert.AreEqual(quote, pq.Text);
            Assert.AreEqual(s.Id, pq.SessionId);
            Assert.AreEqual(pq.Id, ((IDbObject)pq).Id);
            Assert.AreEqual(fn.ShortName, pq.NodeShortName);
        }

        protected SEPullQuote FindPullQuoteWithId(SEPullQuote[] quotes, long id)
        {
            foreach (SEPullQuote pq in quotes)
            {
                if (pq.Id == id)
                    return pq;
            }

            return null;
        }

        [Test]
        public void Load()
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

            Guid S2C1Q1 = new Guid();
            SEPullQuote PQS2C1Q1 = s2.PutQuote(c1Node.Id, "S2C1Q1", S2C1Q1);

            Guid S1C2Q1 = new Guid();
            SEPullQuote PQS1C2Q1 = s1.PutQuote(c2Node.Id, "S1C2Q1", S1C2Q1);

            Guid S2C2Q1 = new Guid();
            SEPullQuote PQS2C2Q1 = s2.PutQuote(c2Node.Id, "S2C2Q1", S2C2Q1);


            SEPullQuote[] s1Quotes = s1.PullQuotes;

            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS1C1Q1.Id), s1, c1Node, "S1C1Q1", false, S1C1Q1, false);
            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS2C1Q1.Id), s2, c1Node, "S2C1Q1", false, S2C1Q1, false);
            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS1C2Q1.Id), s1, c2Node, "S1C2Q1", false, S1C2Q1, false);
            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS2C2Q1.Id), s2, c2Node, "S2C2Q1", false, S2C2Q1, false);

            s1Quotes = Fixture.SEMgr.GetPullQuotesForFrameworkNodeForEvaluatee(s1.EvaluateeId, c1Node.Id, false);
            Assert.AreEqual(0, s1Quotes.Length, "Expected zero pullquotes because they are not public");

            s1.UpdateIsPublic(true, true, true);

            s1Quotes = Fixture.SEMgr.GetPullQuotesForFrameworkNodeForEvaluatee(s1.EvaluateeId, c1Node.Id, false);
            Assert.AreEqual(1, s1Quotes.Length, "Expected one pullquote because the session is public");

            s1Quotes = Fixture.SEMgr.GetPullQuotesForFrameworkNodeForEvaluatee(s1.EvaluateeId, c1Node.Id, true);
            Assert.AreEqual(2, s1Quotes.Length, "Expected two pullquotes because the session is public and private quotes are included");

            DateTime now = DateTime.Now;
            s1.UpdateObserveSchedule(now, now.AddHours(1));

            s1Quotes = Fixture.SEMgr.GetPullQuotesForFrameworkNodeForEvaluatee(s1.EvaluateeId, c1Node.Id, true);
            VerifyPullQuoteLoad(FindPullQuoteWithId(s1Quotes, PQS1C1Q1.Id), s1, c1Node, "S1C1Q1", false, S1C1Q1, true);

            // These session settings are only returned from GetPullQuotesForFrameworkNodeForEvaluatee
            Assert.AreEqual(s1.Title, FindPullQuoteWithId(s1Quotes, PQS1C1Q1.Id).SessionTitle);
            Assert.AreEqual(now.ToShortDateString(), FindPullQuoteWithId(s1Quotes, PQS1C1Q1.Id).SessionStartTime.ToShortDateString());
 
            PQS1C1Q1.UpdateImportant(true);
            PQS2C1Q1.UpdateImportant(true);
            PQS1C2Q1.UpdateImportant(true);
            PQS2C2Q1.UpdateImportant(true);

            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS1C1Q1.Id), s1, c1Node, "S1C1Q1", true, S1C1Q1, false);
            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS2C1Q1.Id), s2, c1Node, "S2C1Q1", true, S2C1Q1, false);
            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS1C2Q1.Id), s1, c2Node, "S1C2Q1", true, S1C2Q1, false);
            VerifyPullQuoteLoad(Fixture.SEMgr.PullQuote(PQS2C2Q1.Id), s2, c2Node, "S2C2Q1", true, S2C2Q1, false);
        }
    }
}
