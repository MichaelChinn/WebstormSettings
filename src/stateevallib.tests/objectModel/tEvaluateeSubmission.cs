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
    class tEvaluateeSubmission:tBase 
    {
        [Test]
        public void Submission()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEEvaluation teacherEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);

            try
            {
                Fixture.SEMgr.SubmitFinalScore(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
            }
            catch (Exception e)
            {
                Assert.IsTrue(e.Message.Contains("must have a final score"));
            }

            teacherEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);

            Assert.IsFalse(teacherEvalData.HasBeenSubmitted);
            Fixture.SEMgr.ScoreFinalScore(principal.Id, teacher1.Id, SERubricPerformanceLevel.PL3, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
            Fixture.SEMgr.SubmitFinalScore(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
            teacherEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
            Assert.IsTrue(teacherEvalData.HasBeenSubmitted);
        }

    }
}
