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
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Test
{
    [TestClass]
    public class RubricRowEvaluationServiceTest
    {
        // Create one, and make sure it persisted in db.
        [TestMethod]
        public void CreateRubricRowEvaluationArtifact()
        {
            FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

            RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var rubricRowEvaluationService = new RubricRowEvaluationService();

                ArtifactBundleModel artifactModel = TestHelper.CreateArtifactBundle("A1");

                RubricRowEvaluationModel rrModel = TestHelper.CreateRubricRowEvaluation(artifactModel, rr1a.Id);
                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNotNull(rrModel);

                transaction.Dispose();
            }
        }

        // Create and then delete
        [TestMethod]
        public void DeleteRubricRowEvaluation()
        {
            FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

            RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var rubricRowEvaluationService = new RubricRowEvaluationService();

                ArtifactBundleModel artifactModel = TestHelper.CreateArtifactBundle("A1");

                RubricRowEvaluationModel rrModel = TestHelper.CreateRubricRowEvaluation(artifactModel, rr1a.Id);
                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNotNull(rrModel);

                rubricRowEvaluationService.DeleteRubricRowEvaluation(rrModel.Id);
                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNull(rrModel);

                StateEvalEntities evalEntities = new StateEvalEntities();
                Assert.AreEqual(0, evalEntities.SERubricRowEvaluations.ToList().Count());

                transaction.Dispose();
            }
        }

        // Check to make sure each of the scalar properties are getting persisted
        [TestMethod]
        public void CreateRubricRowEvaluation_SetGetScalarProperties()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                // properties that can't be checked for equal value, 
                // such as dates, or 
                // read-only, such as LinkedToObservationTitle
                // require initialization with other objects, such as collections and objectID properties.

                List<string> ignoreList = new List<string>(){"LinkedObservationID", "LinkedArtifactBundleID", "EvaluationID", "RubricRowID",
                                    "LinkedStudentGrowthGoalID", "LinkedSelfAssessmntID", "Evidence", "CreatedByUserDisplayName",
                                    "CreationDateTime"};

                var rubricRowEvaluationService = new RubricRowEvaluationService();

                RubricRowEvaluationModel rrModel = new RubricRowEvaluationModel
                {
                    RubricRowId = 1,
                    EvaluationId = 1,
                    LinkedItemType = Convert.ToInt16(SELinkedItemTypeEnum.ARTIFACT),
                    WfState = SEWfStateEnum.RUBRICROWEVAL_IN_PROGRESS,
                    PerformanceLevel = Convert.ToInt16(SERubricPerformanceLevelEnum.PL3)
                };


                // Makes sure all the basic properties have been set and have the same value when retrieved.
                ArtifactBundleModel artifactBundleModel = TestHelper.CreateArtifactBundle("A1");
                RubricRowEvaluationModel rrModel1 = TestHelper.CreateRubricRowEvaluation(artifactBundleModel, 1);
                RubricRowEvaluationModel rrModel2 = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel1.Id);

                TestHelper.ComparePropertyValues(rrModel1, rrModel2, ignoreList);
                // Update the basic properties and make sure they come back with the changed values after update.
                rrModel2.EvaluationId = 2;
                rrModel2.RubricRowId = 2;
                rrModel2.PerformanceLevel = Convert.ToInt16(SERubricPerformanceLevelEnum.PL4);

                rubricRowEvaluationService.UpdateRubricRowEvaluation(rrModel2);
                RubricRowEvaluationModel rrModel3 = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel2.Id);

                TestHelper.ComparePropertyValues(rrModel2, rrModel3, ignoreList);
            }
        }


        // Make sure an evidence added to evaluation before creation persists
        [TestMethod]
        public void CreateRubricRowEvaluationWithNewEvidence_DuringCreate()
        {
            FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

            RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var rubricRowEvaluationService = new RubricRowEvaluationService();

                ArtifactBundleModel artifactModel = TestHelper.CreateArtifactBundle("A1");

                RubricRowEvaluationEvidenceModel evidenceModel = TestHelper.CreateRubricRowEvaluationEvidenceModel("S1", rr1a.Id);
                RubricRowEvaluationModel rrModel = TestHelper.CreateRubricRowEvaluationModel(artifactModel, rr1a.Id);
                rrModel.Evidence.Add(evidenceModel);
                rrModel = TestHelper.CreateRubricRowEvaluation(rrModel);

                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNotNull(rrModel);

                Assert.AreEqual(1, rrModel.Evidence.Count);
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.Evidence == "This is the evidence"));

                transaction.Dispose();
            }
        }

        // Create an evaluation linked to an artifact and look it up based on the artifact
        [TestMethod]
        public void CreateRubricRowEvaluation_LookupFromArtifact()
        {
            FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

            RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var rubricRowEvaluationService = new RubricRowEvaluationService();

                ArtifactBundleModel artifactModel = TestHelper.CreateArtifactBundle("A1");

                RubricRowEvaluationEvidenceModel evidenceModel = TestHelper.CreateRubricRowEvaluationEvidenceModel("S1", rr1a.Id);
                RubricRowEvaluationModel rrModel = TestHelper.CreateRubricRowEvaluationModel(artifactModel, rr1a.Id);
                rrModel.Evidence.Add(evidenceModel);
                rrModel = TestHelper.CreateRubricRowEvaluation(rrModel);

                RubricRowEvaluationModel eval = rubricRowEvaluationService.GetRubricRowEvaluationForObject(SELinkedItemTypeEnum.ARTIFACT,
                                                                artifactModel.Id, rr1a.Id);
                Assert.IsNotNull(eval);
                Assert.AreEqual(Convert.ToInt16(SELinkedItemTypeEnum.ARTIFACT), eval.LinkedItemType);
                Assert.AreEqual(artifactModel.Id, eval.LinkedArtifactBundleId);

                transaction.Dispose();
            }
        }



        // Make sure an evidence update is persisted
        [TestMethod]
        public void UpdateRubricRowEvaluationEvidence()
        {
            FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

            RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var rubricRowEvaluationService = new RubricRowEvaluationService();

                RubricRowEvaluationModel rrModel = TestHelper.CreateRubricRowEvaluation(rr1a.Id);
                RubricRowEvaluationEvidenceModel evidenceModel1 = TestHelper.CreateRubricRowEvaluationEvidenceModel("S1", rr1a.Id);
                RubricRowEvaluationEvidenceModel evidenceModel2 = TestHelper.CreateRubricRowEvaluationEvidenceModel("S2", rr1a.Id);
                RubricRowEvaluationEvidenceModel evidenceModel3 = TestHelper.CreateRubricRowEvaluationEvidenceModel("S3", rr1a.Id);
                
                rrModel.Evidence.Add(evidenceModel1);
                rrModel.Evidence.Add(evidenceModel2);
                rubricRowEvaluationService.UpdateRubricRowEvaluation(rrModel);

                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNotNull(rrModel);

                Assert.IsTrue(rrModel.Evidence.Count == 2);
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S1"));
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S2"));

                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                rrModel.Evidence.Clear();
                rrModel.Evidence.Add(evidenceModel2);
                rrModel.Evidence.Add(evidenceModel3);
                rubricRowEvaluationService.UpdateRubricRowEvaluation(rrModel);
                
                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNotNull(rrModel);

                Assert.IsTrue(rrModel.Evidence.Count == 2);
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S2"));
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S3"));

                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                rrModel.Evidence.Clear();
                rrModel.Evidence.Add(evidenceModel1);
                rrModel.Evidence.Add(evidenceModel2);
                rrModel.Evidence.Add(evidenceModel3);
                rubricRowEvaluationService.UpdateRubricRowEvaluation(rrModel);

                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNotNull(rrModel);

                Assert.IsTrue(rrModel.Evidence.Count == 3);
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S1"));
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S2"));
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S3"));
                
                transaction.Dispose();
            }
        }

        [TestMethod]
        public void DeleteRubricRowEvaluationWithEvidence()
        {
            FrameworkModel framework = TestHelper.GetInstructionalFramework(SEEvaluationTypeEnum.TEACHER);
            FrameworkNodeModel frameworkNode = framework.FrameworkNodes.FirstOrDefault(x => x.ShortName == "D1");

            RubricRowModel rr1a = frameworkNode.RubricRows.FirstOrDefault(x => x.ShortName == "1a");

            using (TransactionScope transaction = new TransactionScope())
            {
                var artifactBundleService = new ArtifactBundleService();
                var rubricRowEvaluationService = new RubricRowEvaluationService();

                RubricRowEvaluationModel rrModel = TestHelper.CreateRubricRowEvaluation(rr1a.Id);
                RubricRowEvaluationEvidenceModel evidenceModel1 = TestHelper.CreateRubricRowEvaluationEvidenceModel("S1", rr1a.Id);
                RubricRowEvaluationEvidenceModel evidenceModel2 = TestHelper.CreateRubricRowEvaluationEvidenceModel("S2", rr1a.Id);

                rrModel.Evidence.Add(evidenceModel1);
                rrModel.Evidence.Add(evidenceModel2);
                rubricRowEvaluationService.UpdateRubricRowEvaluation(rrModel);

                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);
                Assert.IsNotNull(rrModel);

                Assert.IsTrue(rrModel.Evidence.Count == 2);
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S1"));
                Assert.IsNotNull(rrModel.Evidence.FirstOrDefault(x => x.RubricStatement == "S2"));

                rrModel = rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id);

                rubricRowEvaluationService.DeleteRubricRowEvaluation(rrModel.Id);

                Assert.IsNull(rubricRowEvaluationService.GetRubricRowEvaluationById(rrModel.Id));
              
                transaction.Dispose();
            }
        }

    }
}
