using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class EvidenceCollectionService : BaseService
    {
        public object ScoreSummativeRubricRow(SummativeRubricRowScoreModel rubricRowScoreModel)
        {
            SESummativeRubricRowScore score = null;

            if (rubricRowScoreModel.Id == 0)
            {
                score = new SESummativeRubricRowScore();
                rubricRowScoreModel.MaptoSESummativeRubricRowScore(score);
                EvalEntities.SESummativeRubricRowScores.Add(score);
            }
            else
            {
                score = EvalEntities.SESummativeRubricRowScores.FirstOrDefault(x => x.SummativeRubricRowScoreID == rubricRowScoreModel.Id);
                rubricRowScoreModel.MaptoSESummativeRubricRowScore(score);
            }
            EvalEntities.SaveChanges();


            return new { Id = score.SummativeRubricRowScoreID };
        }

        public object ScoreSummativeFrameworkNode(SummativeFrameworkNodeScoreModel frameworkNodeScoreModel)
        {
            SESummativeFrameworkNodeScore score = null;

            if (frameworkNodeScoreModel.Id == 0)
            {
                score = new SESummativeFrameworkNodeScore();
                frameworkNodeScoreModel.MaptoSESummativeFrameworkNodeScore(score);
                EvalEntities.SESummativeFrameworkNodeScores.Add(score);
            }
            else
            {
                score = EvalEntities.SESummativeFrameworkNodeScores.FirstOrDefault(x => x.SummativeFrameworkNodeScoreID == frameworkNodeScoreModel.Id);
                frameworkNodeScoreModel.MaptoSESummativeFrameworkNodeScore(score);
            }
            EvalEntities.SaveChanges();

            return new { Id = score.SummativeFrameworkNodeScoreID };
        }


        public object ScoreRubricRow(RubricRowScoreModel rubricRowScoreModel)
        {
            SERubricRowScore score = null;

            if (rubricRowScoreModel.Id == 0) {
                score = new SERubricRowScore();
                rubricRowScoreModel.MaptoSERubricRowScore(score);
                EvalEntities.SERubricRowScores.Add(score);
            }
            else {
                score = EvalEntities.SERubricRowScores.FirstOrDefault(x => x.RubricRowScoreID == rubricRowScoreModel.Id);
                rubricRowScoreModel.MaptoSERubricRowScore(score);
            }
            EvalEntities.SaveChanges();
            return new { Id = score.RubricRowScoreID };
        }

        public object ScoreFrameworkNode(FrameworkNodeScoreModel frameworkNodeScoreModel)
        {
            SEFrameworkNodeScore score = null;

            if (frameworkNodeScoreModel.Id == 0)
            {
                score = new SEFrameworkNodeScore();
                frameworkNodeScoreModel.MaptoSEFrameworkNodeScore(score);
                EvalEntities.SEFrameworkNodeScores.Add(score);
            }
            else
            {
                score = EvalEntities.SEFrameworkNodeScores.FirstOrDefault(x => x.FrameworkNodeScoreID == frameworkNodeScoreModel.Id);
                frameworkNodeScoreModel.MaptoSEFrameworkNodeScore(score);
            }
            EvalEntities.SaveChanges();
            return new { Id = score.FrameworkNodeScoreID };
        }
    
        public List<RubricRowEvaluationModel> GetRubricRowEvaluationsForEvaluation(EvidenceCollectionRequestModel requestModel)
        {
            List<RubricRowEvaluationModel> evaluations = new List<RubricRowEvaluationModel>();

            // Either we return ones associated with a particular collection or the entire evaluation
            if (requestModel.CollectionObjectId != 0)
            {
                switch (requestModel.CollectionType)
                {
                    case SEEvidenceCollectionTypeEnum.OBSERVATION:
                        evaluations = EvalEntities.SERubricRowEvaluations
                            .Where(x => x.LinkedObservationID == requestModel.CollectionObjectId)
                            .ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities)).ToList();
                        break;
                    case SEEvidenceCollectionTypeEnum.SELF_ASSESSMENT:
                         evaluations = EvalEntities.SERubricRowEvaluations
                            .Where(x => x.LinkedSelfAssessmentID == requestModel.CollectionObjectId)
                            .ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities)).ToList();
                        break;
                    case SEEvidenceCollectionTypeEnum.STUDENT_GROWTH_GOALS:
                        evaluations = EvalEntities.SERubricRowEvaluations
                            .Where(x => x.LinkedStudentGrowthGoalBundleID == requestModel.CollectionObjectId)
                            .ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities)).ToList();
                        break;
                }
            }
            else if (requestModel.CollectionType == SEEvidenceCollectionTypeEnum.SUMMATIVE)
            {
                evaluations = EvalEntities.SERubricRowEvaluations
                    .Where(x => x.EvaluationID == requestModel.EvaluationId)
                    .ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities)).ToList();
            }
            else if (requestModel.CollectionType == SEEvidenceCollectionTypeEnum.OTHER_EVIDENCE)
            {
                // TODO: filter out artifacts that are attached to other objects?
                evaluations = EvalEntities.SERubricRowEvaluations
                    .Where(x => x.EvaluationID == requestModel.EvaluationId && x.LinkedItemTypeID == (short)SELinkedItemTypeEnum.ARTIFACT)
                    .ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities)).ToList();
            }

            if (requestModel.CurrentUserId != 0)
            {
                evaluations = evaluations.Where(x => x.CreatedByUserId == requestModel.CurrentUserId).ToList();
            }

            return evaluations;
        }   

        public List<AvailableEvidenceModel> GetAvailableEvidencesForEvaluation(EvidenceCollectionRequestModel requestModel)
        {
            List<AvailableEvidenceModel> evidences = new List<AvailableEvidenceModel>();

            List<SEAvailableEvidence> evalEvidences = EvalEntities.SEAvailableEvidences
                    .Where(x => x.EvaluationID == requestModel.EvaluationId)
                    .ToList();
 
            SEStudentGrowthGoalBundle goalBundle;

            // Either we return ones associated with a particular collection or the entire evaluation
            if (requestModel.CollectionObjectId != 0)
            {
                evalEvidences.ForEach(x => {
                        switch ((SEEvidenceTypeEnum)x.EvidenceTypeID) {
                            case SEEvidenceTypeEnum.RR_ANNOTATION_OBSERVATION_NOTES:
                                if (x.SERubricRowAnnotation.EvalSessionID == requestModel.CollectionObjectId)
                                {
                                    evidences.Add(x.MapToAvailableEvidenceModel(EvalEntities));
                                }
                                break;
                            case SEEvidenceTypeEnum.ARTIFACT:
                                SEArtifactBundle artifact = EvalEntities.SEArtifactBundles.FirstOrDefault(y => y.ArtifactBundleID == x.ArtifactBundleID);
                                if (requestModel.CollectionType == SEEvidenceCollectionTypeEnum.OBSERVATION || requestModel.CollectionType == SEEvidenceCollectionTypeEnum.SELF_ASSESSMENT)
                                {
                                    SEEvalSession session = artifact.SEEvalSessions.FirstOrDefault(s => s.EvalSessionID == requestModel.CollectionObjectId);
                                    if (session != null)
                                    {
                                        evidences.Add(x.MapToAvailableEvidenceModel(EvalEntities));
                                    }
                                }
                                else if (requestModel.CollectionType == SEEvidenceCollectionTypeEnum.STUDENT_GROWTH_GOALS)
                                {
                                    goalBundle = artifact.SEStudentGrowthGoalBundles.FirstOrDefault(s => s.StudentGrowthGoalBundleID == requestModel.CollectionObjectId);
                                    if (goalBundle != null)
                                    {
                                        evidences.Add(x.MapToAvailableEvidenceModel(EvalEntities));
                                    }
                                }
                                break;
                            case SEEvidenceTypeEnum.STUDENT_GROWTH_GOAL:
                                if (requestModel.CollectionType == SEEvidenceCollectionTypeEnum.STUDENT_GROWTH_GOALS)
                                {
                                    goalBundle = EvalEntities.SEStudentGrowthGoalBundles.FirstOrDefault(y => y.StudentGrowthGoalBundleID == requestModel.CollectionObjectId);
                                    if (goalBundle.SEStudentGrowthGoals.Select(y => y.StudentGrowthGoalID).Contains((long)x.StudentGrowthGoalID))
                                    {
                                        evidences.Add(x.MapToAvailableEvidenceModel(EvalEntities));
                                    }
                                }
                        
                                break;
                        }
                    });
            }
            else if (requestModel.CollectionType == SEEvidenceCollectionTypeEnum.OTHER_EVIDENCE)
            {
                evalEvidences.ForEach(x =>
                {
                    // TODO: filter out ones that are attached to other objects???
                    if (x.EvidenceTypeID == (short)SEEvidenceTypeEnum.ARTIFACT)
                    {
                        SEArtifactBundle artifact = EvalEntities.SEArtifactBundles.FirstOrDefault(y => y.ArtifactBundleID == x.ArtifactBundleID);
                        evidences.Add(x.MapToAvailableEvidenceModel(EvalEntities));
                    }
                });
            }

            return evidences;
        }


        public IEnumerable<SummativeRubricRowScoreModel> GetSummativeRubricRowScoresForEvaluation(EvidenceCollectionRequestModel requestModel)
        {
            IQueryable<SESummativeRubricRowScore> scores = EvalEntities.SESummativeRubricRowScores
                .Where(x => x.EvaluationID == requestModel.EvaluationId);

            if (requestModel.CurrentUserId != 0)
            {
                scores = scores.Where(x => x.CreatedByUserID == requestModel.CurrentUserId);
            }

            return scores.ToList().Select(x => x.MaptoSummativeRubricRowScoreModel());
        }

        public IEnumerable<SummativeFrameworkNodeScoreModel> GetSummativeFrameworkNodeScoresForEvaluation(EvidenceCollectionRequestModel requestModel)
        {
            IQueryable<SESummativeFrameworkNodeScore> scores = EvalEntities.SESummativeFrameworkNodeScores
                .Where(x => x.EvaluationID == requestModel.EvaluationId);

            if (requestModel.CurrentUserId != 0)
            {
                scores = scores.Where(x => x.CreatedByUserID == requestModel.CurrentUserId);
            }

            return scores.ToList().Select(x => x.MaptoSummativeFrameworkNodeScoreModel());
        }


        public List<RubricRowScoreModel> GetRubricRowScoresForEvaluation(EvidenceCollectionRequestModel requestModel)
        {
            List<RubricRowScoreModel> scores = new List<RubricRowScoreModel>();

            // Either we return ones associated with a particular collection or the entire evaluation
            if (requestModel.CollectionObjectId != 0)
            {
                switch (requestModel.CollectionType)
                {
                    case SEEvidenceCollectionTypeEnum.OBSERVATION:
                    case SEEvidenceCollectionTypeEnum.SELF_ASSESSMENT:
                    case SEEvidenceCollectionTypeEnum.STUDENT_GROWTH_GOALS:
                        scores = EvalEntities.SERubricRowScores
                            .Where(x => x.LinkedItemTypeID == requestModel.CollectionObjectId)
                            .ToList().Select(x => x.MaptoRubricRowScoreModel()).ToList();
                        break;
                }
            }
            else
            {
                scores = EvalEntities.SERubricRowScores
                    .Where(x => x.EvaluationID == requestModel.EvaluationId)
                    .ToList().Select(x => x.MaptoRubricRowScoreModel()).ToList();
            }

            if (requestModel.CurrentUserId != 0)
            {
                scores = scores.Where(x => x.CreatedByUserId == requestModel.CurrentUserId).ToList();
            }

            return scores;
        }

        public List<FrameworkNodeScoreModel> GetFrameworkNodeScoresForEvaluation(EvidenceCollectionRequestModel requestModel)
        {
            List<FrameworkNodeScoreModel> scores = new List<FrameworkNodeScoreModel>();

            // Either we return ones associated with a particular collection or the entire evaluation
            if (requestModel.CollectionObjectId != 0)
            {
                // only observations and self-assessments have frameworknode scores
                switch (requestModel.CollectionType)
                {
                    case SEEvidenceCollectionTypeEnum.OBSERVATION:
                    case SEEvidenceCollectionTypeEnum.SELF_ASSESSMENT:
                        scores = EvalEntities.SEFrameworkNodeScores
                            .Where(x => x.LinkedItemID == requestModel.CollectionObjectId)
                            .ToList().Select(x => x.MaptoFrameworkNodeScoreModel()).ToList();
                        break;
                }
            }
            else
            {
                scores = EvalEntities.SEFrameworkNodeScores
                    .Where(x => x.EvaluationID == requestModel.EvaluationId)
                    .ToList().Select(x => x.MaptoFrameworkNodeScoreModel()).ToList();
            }

            if (requestModel.CurrentUserId != 0)
            {
                scores = scores.Where(x => x.CreatedByUserId == requestModel.CurrentUserId).ToList();
            }

            return scores;
        }
   
        public EvidenceCollectionModel GetEvidenceCollection(EvidenceCollectionRequestModel collectionRequest)
        {
            RubricRowEvaluationService rrEvalService = new RubricRowEvaluationService();

            EvidenceCollectionModel collectionModel = new EvidenceCollectionModel();
            collectionModel.CollectionType = collectionRequest.CollectionType;
            collectionModel.CollectionObjectId = collectionRequest.CollectionObjectId;

            collectionModel.RubricRowEvaluations = GetRubricRowEvaluationsForEvaluation(collectionRequest);

            if (collectionRequest.CollectionType == SEEvidenceCollectionTypeEnum.SUMMATIVE)
            {
                IEnumerable<SummativeRubricRowScoreModel> sumRRScores = GetSummativeRubricRowScoresForEvaluation(collectionRequest);
                collectionModel.SummativeRubricRowScores = sumRRScores.ToList();

                IEnumerable<SummativeFrameworkNodeScoreModel> sumFNScores = GetSummativeFrameworkNodeScoresForEvaluation(collectionRequest);
                collectionModel.SummativeFrameworkNodeScores = sumFNScores.ToList();

                collectionModel.Observations = EvalEntities.SEEvalSessions
                    .Where(x => x.EvaluationID == collectionRequest.EvaluationId && x.IsSelfAssess == false)
                    .ToList().Select(x => x.MaptoEvalSessionModel(EvalEntities)).ToList();

                collectionModel.StudentGrowthGoalBundles = EvalEntities.SEStudentGrowthGoalBundles
                    .Where(x => x.EvaluationID == collectionRequest.EvaluationId)
                    .ToList().Select(x => x.MaptoStudentGrowthGoalBundleModel()).ToList();                            
            }
            else
            {
                collectionModel.SummativeRubricRowScores = new List<SummativeRubricRowScoreModel>();
                collectionModel.SummativeFrameworkNodeScores = new List<SummativeFrameworkNodeScoreModel>();
                collectionModel.Observations = new List<EvalSessionModel>();
                collectionModel.StudentGrowthGoalBundles = new List<StudentGrowthGoalBundleModel>();
            }

            if (collectionRequest.CollectionType == SEEvidenceCollectionTypeEnum.OBSERVATION ||
                collectionRequest.CollectionType == SEEvidenceCollectionTypeEnum.SELF_ASSESSMENT ||
                collectionRequest.CollectionType == SEEvidenceCollectionTypeEnum.SUMMATIVE)
            {
                collectionModel.RubricRowScores = GetRubricRowScoresForEvaluation(collectionRequest);
                collectionModel.FrameworkNodeScores = GetFrameworkNodeScoresForEvaluation(collectionRequest);
            }
            else
            {
                collectionModel.RubricRowScores = new List<RubricRowScoreModel>();
                collectionModel.FrameworkNodeScores = new List<FrameworkNodeScoreModel>();
            }

            if (collectionRequest.CollectionType != SEEvidenceCollectionTypeEnum.SUMMATIVE)
            {
                collectionModel.AvailableEvidence = GetAvailableEvidencesForEvaluation(collectionRequest).ToList();
            }
            if (collectionRequest.CollectionType == SEEvidenceCollectionTypeEnum.OBSERVATION)
            {
                SEEvalSession session = EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == collectionRequest.CollectionObjectId);
                collectionModel.Observation = session.MaptoEvalSessionModel(EvalEntities);
            } 

            return collectionModel;
        }
    }
}