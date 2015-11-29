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
    class tRubricEvidence : tBase
    {
        void Compare(SERubricEvidence e1, SERubricEvidence e2)
        {
            Assert.AreEqual(e1.Id, e2.Id);
            Assert.AreEqual(e1.RubricRowId, e2.RubricRowId);
            Assert.AreEqual(e1.RubricDescriptorText, e2.RubricDescriptorText);
            Assert.AreEqual(e1.SupportingEvidenceText, e2.SupportingEvidenceText);
            Assert.AreEqual(e1.EvidenceType, e2.EvidenceType);
            Assert.AreEqual(e1.SchoolYear, e2.SchoolYear);
            Assert.AreEqual(e1.CreationDateTime.Year, e2.CreationDateTime.Year);
            Assert.AreEqual(e1.CreationDateTime.Day, e2.CreationDateTime.Day);
            Assert.AreEqual(e1.CreationDateTime.Minute, e2.CreationDateTime.Minute);
            Assert.AreEqual(e1.EvaluateeId, e2.EvaluateeId);
            Assert.AreEqual(e1.CreatedByUserId, e2.CreatedByUserId);
            Assert.AreEqual(e1.EvaluationType, e2.EvaluationType);
            Assert.AreEqual(e1.EvalSessionId, e2.EvalSessionId);
            Assert.AreEqual(e1.IsPublic, e2.IsPublic);

        }

        [Test]
        public void CreateDeleteUpdateRubricEvidence()
        {

            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            SERubricRow[] rrows = Fixture.GetRubricRowsForFrameworkNode(PilotDistricts.NorthThurston, SEFrameworkType.TSTATE, "C1");
            long rrId = Fixture.FindRubricRowTitleStartWith(rrows, "2b").Id;

            SEEvalSession session = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                                                       principal.Id, teacher.Id);
            SERubricEvidence e1 = SERubricEvidence.Create(SERubricPerformanceLevel.PL1, "This is the rubric test", "This is the supporting evidence",
                                rrId, SERubricEvidenceType.DESCRIPTOR, SESchoolYear.SY_2015, teacher.Id, principal.Id, SEEvaluationType.TEACHER_OBSERVATION,
                                session.Id, true);

            e1.Save();

            SERubricEvidence e2 = SERubricEvidence.Get(e1.Id);
            Compare(e1, e2);

            rrId = Fixture.FindRubricRowTitleStartWith(rrows, "3a").Id;
            e1.PerformanceLevel = SERubricPerformanceLevel.PL2;
            e1.RubricDescriptorText = "new text";
            e1.SupportingEvidenceText = "new supporting text";
            e1.RubricRowId = rrId;
            e1.EvidenceType = SERubricEvidenceType.CRITICAL_ATTRIBUTE;
            e1.SchoolYear = SESchoolYear.SY_2016;
            e1.EvaluateeId = principal.Id;
            e1.CreatedByUserId = teacher.Id;

            e1.EvaluationType = SEEvaluationType.PRINCIPAL_OBSERVATION;
            e1.EvalSessionId = session.Id;
            e1.IsPublic = false;
            e1.Save();

            e2 = SERubricEvidence.Get(e1.Id);

            Compare(e1, e2);


            e1.Delete();

            Assert.IsNull(SERubricEvidence.Get(e1.Id));
        }
            
     }
}
