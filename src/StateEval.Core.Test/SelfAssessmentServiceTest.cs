using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEval.Core.RequestModel;
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Test
{
    [TestClass]
    public class SelfAssessmentServiceTest
    {
        // Create a self-assessment, and make sure it persisted in db.
        [TestMethod]
        public void CreateSelfAssessment()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var selfAssessmentService = new SelfAssessmentService();
                SelfAssessmentModel selfAssessmentModel = TestHelper.CreateSelfAssessment("SA1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId, SEEvaluationTypeEnum.TEACHER);

                selfAssessmentService = new SelfAssessmentService();
                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                Assert.IsNotNull(selfAssessmentModel);

                transaction.Dispose();
            }
        }

        // Create a self-assessment, make changes, update and make sure changes are persisted to db.
        [TestMethod]
        public void UpdateSelfAssessment()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var selfAssessmentService = new SelfAssessmentService();
                SelfAssessmentModel selfAssessmentModel = TestHelper.CreateSelfAssessment("SA1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId, SEEvaluationTypeEnum.TEACHER);

                selfAssessmentService = new SelfAssessmentService();
                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                Assert.IsNotNull(selfAssessmentModel);

                selfAssessmentModel.IncludeInFinalReport = true;
                selfAssessmentModel.IsSharedWithEvaluator = true;
                selfAssessmentModel.PerformanceLevel = (short)SERubricPerformanceLevelEnum.PL1;
                selfAssessmentModel.Title = "NewTitle";
                selfAssessmentModel.Focused = true;
                selfAssessmentModel.FocusedFrameworkNodeId = 1;
                selfAssessmentModel.FocusedSGFrameworkNodeId = 1;

                selfAssessmentService.UpdateSelfAssessment(selfAssessmentModel);
                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                Assert.IsTrue(selfAssessmentModel.IncludeInFinalReport);
                Assert.IsTrue(selfAssessmentModel.IsSharedWithEvaluator);
                Assert.AreEqual((short)SERubricPerformanceLevelEnum.PL1, selfAssessmentModel.PerformanceLevel);
                Assert.AreEqual("NewTitle", selfAssessmentModel.Title);
                Assert.AreEqual(1, selfAssessmentModel.FocusedFrameworkNodeId);
                Assert.AreEqual(1, selfAssessmentModel.FocusedSGFrameworkNodeId);

                transaction.Dispose();
            }
        }

        // Create an assessment add/remove the aligned rubric rows with updates
        // after each change verifying that the expected list is persisted after each update
        [TestMethod]
        public void UpdateAssessment_ChangeRubricRowAlignment()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                var selfAssessmentService = new SelfAssessmentService();
                List<RubricRowModel> rubricRows = new List<RubricRowModel>();
                FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
                FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

                RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");
                RubricRowModel rr1b = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1b");
                RubricRowModel rr1c = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1c");


                SelfAssessmentModel selfAssessmentModel = TestHelper.CreateSelfAssessment("SA1", DefaultTeacher.EvaluationId, DefaultTeacher.UserId, SEEvaluationTypeEnum.TEACHER);
                selfAssessmentModel.AlignedRubricRows.Add(rr1a);
                selfAssessmentService.UpdateSelfAssessment(selfAssessmentModel);

                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                Assert.IsTrue(selfAssessmentModel.AlignedRubricRows.Count == 1);
                Assert.IsNotNull(selfAssessmentModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1a"));


                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                selfAssessmentModel.AlignedRubricRows.Clear();
                selfAssessmentModel.AlignedRubricRows.Add(rr1b);
                selfAssessmentService.UpdateSelfAssessment(selfAssessmentModel);

                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                Assert.IsTrue(selfAssessmentModel.AlignedRubricRows.Count == 1);
                Assert.IsNotNull(selfAssessmentModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1b"));


                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                selfAssessmentModel.AlignedRubricRows.Add(rr1a);
                selfAssessmentModel.AlignedRubricRows.Add(rr1c);
                selfAssessmentService.UpdateSelfAssessment(selfAssessmentModel);

                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                Assert.IsTrue(selfAssessmentModel.AlignedRubricRows.Count == 3);
                Assert.IsNotNull(selfAssessmentModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1a"));
                Assert.IsNotNull(selfAssessmentModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1b"));
                Assert.IsNotNull(selfAssessmentModel.AlignedRubricRows.FirstOrDefault(x => x.ShortName == "1c"));


                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                selfAssessmentModel.AlignedRubricRows.Clear();
                selfAssessmentService.UpdateSelfAssessment(selfAssessmentModel);

                selfAssessmentModel = selfAssessmentService.GetSelfAssessmentById(selfAssessmentModel.Id);
                Assert.IsTrue(selfAssessmentModel.AlignedRubricRows.Count == 0);

                transaction.Dispose();
            }

        }

    }
}
