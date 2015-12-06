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
    public class RubricRowEvaluationService : BaseService
    {
        public IEnumerable<RubricRowEvaluationModel> GetRubricRowEvaluationsForEvaluation(RubricRowEvaluationsRequestModel requestModel)
        {
            IQueryable<SERubricRowEvaluation> evaluations = EvalEntities.SERubricRowEvaluations
                .Where(x => x.EvaluationID == requestModel.EvaluationId);

            if (requestModel.LinkedItemType != SELinkedItemTypeEnum.UNDEFINED)
            {
                evaluations = evaluations.Where(x => x.LinkedItemTypeID == (short)requestModel.LinkedItemType);
            }

            if (requestModel.CreatedByUserId != 0)
            {
                evaluations = evaluations.Where(x => x.CreatedByUserID == requestModel.CreatedByUserId);
            }

            if (requestModel.LinkedItemId != 0)
            {
                switch (requestModel.LinkedItemType)
                {
                    case SELinkedItemTypeEnum.OBSERVATION:
                        evaluations = evaluations.Where(x => x.LinkedObservationID == requestModel.LinkedItemId);
                        break;
                    case SELinkedItemTypeEnum.STUDENT_GROWTH_GOAL:
                        evaluations = evaluations.Where(x => x.LinkedStudentGrowthGoalBundleID == requestModel.LinkedItemId);
                        break;
                }
            }

            if (requestModel.RubricRowId != 0)
            {
                evaluations = evaluations.Where(x => x.RubricRowID == requestModel.RubricRowId);
            }

            return evaluations.ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities));
        }

        public IEnumerable<RubricRowEvaluationModel> GetRubricRowEvaluationForObjectTypeForEvaluation(long evaluationId, SELinkedItemTypeEnum linkedItemType)
        {
            IQueryable<SERubricRowEvaluation> evaluations = EvalEntities.SERubricRowEvaluations
                .Where(x=>x.LinkedItemTypeID == (short)linkedItemType && x.EvaluationID==evaluationId);
            
            return evaluations.ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities));
        }

        // used for testing
        public RubricRowEvaluationModel GetRubricRowEvaluationForObject(SELinkedItemTypeEnum objectType, long objectId, long rubricRowId)
        {
            SERubricRowEvaluation evaluation = null;

            switch (objectType)
            {
                case SELinkedItemTypeEnum.OBSERVATION:
                    evaluation = EvalEntities.SERubricRowEvaluations.FirstOrDefault(
                                            x => x.LinkedObservationID == objectId && x.RubricRowID == rubricRowId);
                    break;
                case SELinkedItemTypeEnum.STUDENT_GROWTH_GOAL:
                    evaluation = EvalEntities.SERubricRowEvaluations.FirstOrDefault(
                                            x => x.LinkedStudentGrowthGoalBundleID == objectId && x.RubricRowID == rubricRowId);
                    break;
                case SELinkedItemTypeEnum.SELF_ASSESSMENT:
                    evaluation = EvalEntities.SERubricRowEvaluations.FirstOrDefault(
                                            x => x.LinkedSelfAssessmentID == objectId && x.RubricRowID == rubricRowId);
                    break;
                default:
                    evaluation = null;
                    break;

            }

            if (evaluation != null)
            {
                return evaluation.MaptoRubricRowEvaluationModel(EvalEntities);
            }

            return null;
        }

        public void LoadObjectSummaries(List<RubricRowEvaluationModel> evaluationModels)
        {
            evaluationModels.ForEach(x =>
            {
                RubricRowEvaluationObjectSummaryModel objectSummary = null;
                SEUser createdByUser = null;
                switch ((SELinkedItemTypeEnum)x.LinkedItemType)
                {
                    case SELinkedItemTypeEnum.ARTIFACT:
                        createdByUser = EvalEntities.SEUsers.FirstOrDefault(y => y.SEUserID == x.CreatedByUserId);
                        objectSummary = new RubricRowEvaluationObjectSummaryModel("Other Evidence", createdByUser.FirstName + " " + createdByUser.LastName,
                                                                            x.CreatedByUserDisplayName);
                        x.ObjectSummary = objectSummary;
                        break;
                    case SELinkedItemTypeEnum.OBSERVATION:
                        SEEvalSession observation = EvalEntities.SEEvalSessions.FirstOrDefault(y => y.EvalSessionID == x.LinkedObservationId);
                        createdByUser = EvalEntities.SEUsers.FirstOrDefault(y => y.SEUserID == observation.EvaluatorUserID);
                        objectSummary = new RubricRowEvaluationObjectSummaryModel(observation.Title, createdByUser.FirstName + " " + createdByUser.LastName,
                                                                            x.CreatedByUserDisplayName);
                        x.ObjectSummary = objectSummary;
                        break;
                    case SELinkedItemTypeEnum.STUDENT_GROWTH_GOAL:
                        SEStudentGrowthGoalBundle goalBundle = EvalEntities.SEStudentGrowthGoalBundles.FirstOrDefault(y => y.StudentGrowthGoalBundleID == x.LinkedStudentGrowthGoalBundleId);
                        SEEvaluation eval = EvalEntities.SEEvaluations.FirstOrDefault(y => y.EvaluationID == goalBundle.EvaluationID);
                        createdByUser = eval.SEUser;
                        objectSummary = new RubricRowEvaluationObjectSummaryModel(goalBundle.Title, createdByUser.FirstName + " " + createdByUser.LastName,
                                                                            x.CreatedByUserDisplayName);
                        x.ObjectSummary = objectSummary;
                        break;

                    default:
                        x.ObjectSummary = null;
                        break;
                }

            });
        }


        IEnumerable<RubricRowEvaluationModel> GetRubricRowEvaluationsForTorTee(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly, short evalType, string roleName)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.SEUserLocationRoles.Any(r => r.RoleName == roleName && r.DistrictCode == districtCode && r.SchoolCode == schoolCode))
                .Where(u => u.SEEvaluations.Any(e => e.EvaluateeID == u.SEUserID
                                                && e.SchoolYear == schoolYear
                                                && e.EvaluationTypeID == evalType
                                                && e.DistrictCode == districtCode
                                                && (!assignedOnly || e.EvaluatorID == evaluatorId)))
                .Where(u => u.SEUserID != evaluatorId);

            IQueryable<SEEvaluation> seEvals = EvalEntities.SEEvaluations
                .Where(x => x.SchoolYear == schoolYear && x.DistrictCode == districtCode && x.EvaluationTypeID==evalType)
                .Where(x => users.Select(u => u.SEUserID).Contains(x.EvaluateeID));

            IQueryable<SERubricRowEvaluation> seRREvals = EvalEntities.SERubricRowEvaluations
                .Where(x=>seEvals.Select(y=>y.EvaluationID).Contains(x.EvaluationID));

            return seRREvals.ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities));
        }

        public IEnumerable<RubricRowEvaluationModel> GetRubricRowEvaluationsForPR_TR(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly)
        {
            return GetRubricRowEvaluationsForTorTee(schoolYear, districtCode, schoolCode, evaluatorId, assignedOnly,
                                        (short)SEEvaluationTypeEnum.TEACHER, StateEval.Core.Constants.RoleName.SESchoolTeacher);
        }

        public List<RubricRowEvaluationModel> GetRubricRowEvaluationsForEvaluation(long evaluationId)
        {
            IQueryable<SERubricRowEvaluation> seEvaluations = EvalEntities.SERubricRowEvaluations.Where(
                x => x.EvaluationID == evaluationId);

            IEnumerable<RubricRowEvaluationModel> evaluations = seEvaluations.ToList().Select(x => x.MaptoRubricRowEvaluationModel(EvalEntities));
            List<RubricRowEvaluationModel> evaluationModels = evaluations.ToList();
            LoadObjectSummaries(evaluationModels);

            return evaluationModels;
        }

        public RubricRowEvaluationModel GetRubricRowEvaluationById(long id)
        {
            SERubricRowEvaluation evaluation =
                EvalEntities.SERubricRowEvaluations.FirstOrDefault(x => x.RubricRowEvaluationID == id);
            if (evaluation != null)
            {
                return evaluation.MaptoRubricRowEvaluationModel(EvalEntities);
            }

            return null;
        }

        public RubricRowEvaluationModel GetRubricRowEvaluationModelForEvalSession(int evalSessionId, int rubricRowId)
        {
            SERubricRowEvaluation evaluation =
                EvalEntities.SERubricRowEvaluations.FirstOrDefault(
                    x => x.LinkedObservationID == evalSessionId && x.RubricRowID == rubricRowId);

            if (evaluation != null)
            {
                return evaluation.MaptoRubricRowEvaluationModel(EvalEntities);
            }
            return null;
        }

        public void UpdateRubricRowEvaluation(RubricRowEvaluationModel rubricRowEvaluationModel)
        {
            SERubricRowEvaluation seRubricRowEvaluation =
                EvalEntities.SERubricRowEvaluations.FirstOrDefault(x => x.RubricRowEvaluationID == rubricRowEvaluationModel.Id);

            if (seRubricRowEvaluation != null)
            {
                rubricRowEvaluationModel.MaptoSERubricRowEvaluation(this.EvalEntities, seRubricRowEvaluation);
            }

            EvalEntities.SaveChanges();
        }


        public object CreateRubricRowEvaluation(RubricRowEvaluationModel rubricRowEvaluationModel)
        {
            SERubricRowEvaluation seRubricRowEvaluation = new SERubricRowEvaluation();
            seRubricRowEvaluation.CreationDateTime = DateTime.Now;
            rubricRowEvaluationModel.MaptoSERubricRowEvaluation(this.EvalEntities, seRubricRowEvaluation);
            EvalEntities.SERubricRowEvaluations.Add(seRubricRowEvaluation);
            EvalEntities.SaveChanges();

            return new { Id = seRubricRowEvaluation.RubricRowEvaluationID };
        }

        public void DeleteRubricRowEvaluation(long id)
        {
            SERubricRowEvaluation evaluation =
                EvalEntities.SERubricRowEvaluations.FirstOrDefault(x => x.RubricRowEvaluationID == id);

            if (evaluation != null)
            {
                EvalEntities.SEAlignedEvidences.RemoveRange(EvalEntities.SEAlignedEvidences.Where(x => x.RubricRowEvaluationID == id));
                evaluation.SEAlignedEvidences.ToList().ForEach(x => evaluation.SEAlignedEvidences.Remove(x));
                EvalEntities.SERubricRowEvaluations.Remove(evaluation);
                EvalEntities.SaveChanges();
            }
        }

        public List<RubricRowEvaluationModel> GetRubricRowEvaluationsForEvalSession(int evalSessionId)
        {
            EvidenceCollectionRequestModel collectionRequest = new EvidenceCollectionRequestModel();
            collectionRequest.CollectionType = SEEvidenceCollectionTypeEnum.OBSERVATION;
            collectionRequest.CollectionObjectId = evalSessionId;

            EvidenceCollectionService evidenceCollectionService = new EvidenceCollectionService();
            IEnumerable<RubricRowEvaluationModel> rrEvals = evidenceCollectionService.GetRubricRowEvaluationsForEvaluation(collectionRequest);

            return rrEvals.ToList();
        }
    }
}
