using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using StateEval;
using System.Xml;
using System.Xml.Schema;

using NUnit.Framework;

namespace StateEval.tests
{
    [TestFixture]
    class TraceTest:tBase
    {
        [Test]
        public void RandomCommentWithTic()
        {
            Fixture.SEMgr.Trace("aKey", "a random comment with a tic... that is... '");
        }
    }
}
