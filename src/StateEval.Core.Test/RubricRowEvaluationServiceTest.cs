using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEval.Core.Services;
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Test
{
    [TestClass]
    public class RubricRowEvaluationServiceTest
    {
        // Create one using an artifact as the aligned evidence, make sure it is persisted to db
        // Make sure artifact can't be deleted when used as aligned evidence
        // Make sure rubricrowevaluation can be deleted with artifact aligned.
        [TestMethod]
        public void CreateDeleteRubricRowEvaluationArtifact()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                RubricRowEvaluationModel rrEvalModel = TestHelper.CreateRubricRowEvaluationWithAlignedArtifact();
                RubricRowEvaluationService rrEvalService = new RubricRowEvaluationService();
                List<RubricRowEvaluationModel> rrEvals = rrEvalService.GetRubricRowEvaluationsForEvaluation(DefaultTeacher.EvaluationId);
                Assert.AreEqual(1, rrEvals.Count);
                rrEvalModel = rrEvals[0];

                rrEvalModel.AdditionalInput = "AdditionalInput";
                rrEvalService.UpdateRubricRowEvaluation(rrEvalModel);
                rrEvalModel = rrEvalService.GetRubricRowEvaluationById(rrEvalModel.Id);
                Assert.AreEqual("AdditionalInput", rrEvalModel.AdditionalInput);


                List<ArtifactBundleModel> artifacts = TestHelper.GetArtifactBundlesForEvaluation(DefaultTeacher.EvaluationId, DefaultTeacher.UserId);
                Assert.AreEqual(1, artifacts.Count);

                List<AlignedEvidenceModel> alignedEvidences = rrEvalModel.AlignedEvidences;
                Assert.AreEqual(1, alignedEvidences.Count);
                Assert.AreEqual(artifacts[0].Id, alignedEvidences[0].AvailableEvidenceObjectId);
                Assert.AreEqual(SEEvidenceTypeEnum.ARTIFACT, alignedEvidences[0].EvidenceType);

                AlignedEvidenceModel alignedEvidence = alignedEvidences[0];
                alignedEvidence.AdditionalInput = "AlignedEvidenceAdditionalInput";
                rrEvalService.UpdateRubricRowEvaluation(rrEvalModel);
                rrEvalModel = rrEvalService.GetRubricRowEvaluationById(rrEvalModel.Id);
                Assert.AreEqual("AlignedEvidenceAdditionalInput", rrEvalModel.AlignedEvidences[0].AdditionalInput);

                ArtifactBundleService artifactBundleService = new ArtifactBundleService();
                try
                {
                    artifactBundleService.DeleteArtifactBundle(artifacts[0].Id);
                }
                catch (Exception e)
                {
                    Assert.AreEqual("This artifact is in use as evidence and cannot be deleted.", e.Message);
                }

                Assert.IsNotNull(artifactBundleService.GetArtifactBundleById(artifacts[0].Id));

                rrEvalService.DeleteRubricRowEvaluation(rrEvalModel.Id);
                rrEvalService = new RubricRowEvaluationService();
                rrEvalModel = rrEvalService.GetRubricRowEvaluationById(rrEvalModel.Id);
                Assert.IsNull(rrEvalModel);

                transaction.Dispose();
            }
        }

        // Create one using a sg goal as the aligned evidence, make sure it is persisted to db
        // Make sure goal can't be deleted when used as aligned evidence
        // Make sure rubricrowevaluation can be deleted with goal aligned.
        [TestMethod]
        public void CreateDeleteRubricRowEvaluationSGGoal()
        {
            using (TransactionScope transaction = new TransactionScope())
            {
                RubricRowEvaluationModel rrEvalModel = TestHelper.CreateRubricRowEvaluationWithAlignedStudentGrowthGoal();
                RubricRowEvaluationService rrEvalService = new RubricRowEvaluationService();
                List<RubricRowEvaluationModel> rrEvals = rrEvalService.GetRubricRowEvaluationsForEvaluation(DefaultTeacher.EvaluationId);
                Assert.AreEqual(1, rrEvals.Count);

                StudentGrowthGoalBundleService studentGrowthGoalBundleService = new StudentGrowthGoalBundleService();
                List<StudentGrowthGoalBundleModel> goalBundles = studentGrowthGoalBundleService.GetStudentGrowthGoalBundlesForEvaluation(DefaultTeacher.EvaluationId).ToList();
                Assert.AreEqual(1, goalBundles.Count);

                List<AlignedEvidenceModel> alignedEvidence = rrEvals[0].AlignedEvidences;
                Assert.AreEqual(1, alignedEvidence.Count);
                Assert.AreEqual(goalBundles[0].Goals[0].Id, alignedEvidence[0].AvailableEvidenceObjectId);
                Assert.AreEqual(SEEvidenceTypeEnum.STUDENT_GROWTH_GOAL, alignedEvidence[0].EvidenceType);

                studentGrowthGoalBundleService = new StudentGrowthGoalBundleService();
                try
                {
                    studentGrowthGoalBundleService.DeleteStudentGrowthGoalBundle(goalBundles[0].Id);
                }
                catch (Exception e)
                {
                    Assert.AreEqual("This goal is in use as evidence and cannot be deleted.", e.Message);
                }

                studentGrowthGoalBundleService = new StudentGrowthGoalBundleService();
                Assert.IsNotNull(studentGrowthGoalBundleService.GetStudentGrowthGoalBundleById(goalBundles[0].Id));

                rrEvalService.DeleteRubricRowEvaluation(rrEvalModel.Id);
                rrEvalService = new RubricRowEvaluationService();
                rrEvalModel = rrEvalService.GetRubricRowEvaluationById(rrEvalModel.Id);
                Assert.IsNull(rrEvalModel);

                transaction.Dispose();
            }
        }

    }
}
