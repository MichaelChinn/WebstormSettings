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
using StateEval.Security;

namespace StateEval.tests.objectModel
{
     [TestFixture]
    class tUserPrompt : tBase
    {
         int SequenceOf(long userPromptId)
         {
             SqlParameter[] aParams = new SqlParameter[]
             {
                 new SqlParameter ("@pSqlCmd", "select sequence from seUserPrompt where userPromptId = " + userPromptId.ToString())
             };
             return Convert.ToInt16(Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
         }
         [Test]
         public void ChangeSequenceNumber()
         {
             SqlParameter[] aParams = new SqlParameter[]
             {
                 new SqlParameter ("@pSqlCmd", "select sequence from seUserPrompt where userPromptId = 3")
             };
             int initialSequence = SequenceOf(4);


             //set sequence to three
             List<long> theList = new List<long>(){0, 0, 3};
             Fixture.SEMgr.ResequenceUserPrompts(theList);
             Assert.AreEqual(3, SequenceOf(3));

             //set sequence to 5
             theList = new List<long>() { 0, 0, 0, 0, 3 };
             Fixture.SEMgr.ResequenceUserPrompts(theList);
             Assert.AreEqual(5, SequenceOf(3));


             //set sequence to 7
             theList = new List<long>() { 0, 0, 0, 0, 0, 0, 7 };
             Fixture.SEMgr.ResequenceUserPrompts(theList);
             Assert.AreEqual(5, SequenceOf(3));

             //make sure you haven't changed anything else!!!
             Assert.AreEqual(initialSequence, SequenceOf(4));
             Assert.AreNotEqual(initialSequence, 7);

         }
    }
}
