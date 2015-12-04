using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static RubricRowEvaluationModel MaptoRubricRowEvaluationModel(this SERubricRowEvaluation source, StateEvalEntities evalEntities, RubricRowEvaluationModel target = null)
        {
            target = target ?? new RubricRowEvaluationModel();

            target.Id = source.RubricRowEvaluationID;
            target.RubricRowId = source.RubricRowID;
            target.EvaluationId = source.EvaluationID;
            target.EvidenceCollectionType = (SEEvidenceCollectionTypeEnum)source.EvidenceCollectionTypeID;
            target.LinkedItemType = source.LinkedItemTypeID;
            target.LinkedObservationId = source.LinkedObservationID;
            target.LinkedSelfAssessmentId = source.LinkedSelfAssessmentID;
            target.LinkedStudentGrowthGoalBundleId = source.LinkedStudentGrowthGoalBundleID;
            target.PerformanceLevel = source.PerformanceLevelID;
            target.CreatedByUserId = source.CreatedByUserID;
            target.CreationDateTime = source.CreationDateTime;
            target.CreatedByUserDisplayName = source.SEUser.FirstName + " " + source.SEUser.LastName;
            target.RubricStatement = source.RubricStatement;
            target.AdditionalInput = source.AdditionalInput;

            if (source != null && source.SEAlignedEvidences.Any())
            {
                target.AlignedEvidences = source.SEAlignedEvidences.Select(x => x.MapToAlignedEvidenceModel(evalEntities)).ToList();
            }
            else
            {
                target.AlignedEvidences = new List<AlignedEvidenceModel>();
            }

            return target;
        }

        public static SERubricRowEvaluation MaptoSERubricRowEvaluation(this RubricRowEvaluationModel source, StateEvalEntities evalEntities, SERubricRowEvaluation target = null)
        {
            target = target ?? new SERubricRowEvaluation();

            target.RubricRowEvaluationID = source.Id;
            target.RubricRowID = source.RubricRowId;
            target.EvaluationID = source.EvaluationId;
            target.EvidenceCollectionTypeID = (short)source.EvidenceCollectionType;
            target.LinkedItemTypeID = source.LinkedItemType;
            target.LinkedObservationID = source.LinkedObservationId;
            target.LinkedSelfAssessmentID = source.LinkedSelfAssessmentId;
            target.LinkedStudentGrowthGoalBundleID = source.LinkedStudentGrowthGoalBundleId;
            target.PerformanceLevelID = source.PerformanceLevel;
            target.CreatedByUserID = source.CreatedByUserId;
            target.RubricStatement = source.RubricStatement;
            target.AdditionalInput = source.AdditionalInput;

            List<SEAlignedEvidence> toRemoveAE = target.SEAlignedEvidences.Where(x => !source.AlignedEvidences.Select(y => y.Id).Contains(x.AlignedEvidenceID)).ToList();
            List<AlignedEvidenceModel> toAddAE = source.AlignedEvidences.Where(n => !target.SEAlignedEvidences.Select(db => db.AlignedEvidenceID).Contains(n.Id)).ToList();
            List<AlignedEvidenceModel> toUpdateOnlyAE = source.AlignedEvidences.Where(n => target.SEAlignedEvidences.Select(db => db.AlignedEvidenceID).Contains(n.Id)).ToList();

            toRemoveAE.ForEach(x => {
                evalEntities.SEAlignedEvidences.Remove(x);
                target.SEAlignedEvidences.Remove(x);
            });

            toUpdateOnlyAE.ForEach(x => x.MapToAlignedEvidenceModel(target.SEAlignedEvidences.FirstOrDefault(y => y.AlignedEvidenceID == x.Id)));
 
            toAddAE.ForEach(x =>
            {
                target.SEAlignedEvidences.Add(x.MapToAlignedEvidenceModel());
            });

            return target;
        }
    }
}