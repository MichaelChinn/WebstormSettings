using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static AvailableEvidenceModel MapToAvailableEvidenceModel(this SEAvailableEvidence source, StateEvalEntities entities, AvailableEvidenceModel target = null)
        {
            target = target ?? new AvailableEvidenceModel();
            target.Id = source.AvailableEvidenceID;
            target.EvidenceType = (SEEvidenceTypeEnum)source.EvidenceTypeID;
            target.ArtifactBundleId = source.ArtifactBundleID;
            target.RubricRowAnnotationId = source.RubricRowAnnotationID;
            target.EvaluationId= source.EvaluationID;
            target.RubricRowId = source.RubricRowID;
            switch (target.EvidenceType) { 
                case SEEvidenceTypeEnum.ARTIFACT:
                    target.ArtifactBundle = entities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == source.ArtifactBundleID).MaptoArtifactBundleModel(entities);
                    break;
                case SEEvidenceTypeEnum.STUDENT_GROWTH_GOAL:
                    target.StudentGrowthGoal = entities.SEStudentGrowthGoals.FirstOrDefault(x => x.StudentGrowthGoalID == source.StudentGrowthGoalID).MaptoStudentGrowthGoalModel(0, "");
                    break;
                case SEEvidenceTypeEnum.RR_ANNOTATION_OBSERVATION_NOTES:
                    target.RubricRowAnnotation = entities.SERubricRowAnnotations.FirstOrDefault(x => x.RubricRowAnnotationID == source.RubricRowAnnotationID).MaptoRubricRowAnnotationModel();
                    break;
                //TODO: handle rest of cases
            }
         
            return target;
        }

        public static SEAvailableEvidence MapToAvailableEvidence(this StudentGrowthGoalModel source, long rubricRowId, SEAvailableEvidence target = null)
        {
            target = target ?? new SEAvailableEvidence();
            target.StudentGrowthGoalID = source.Id;
            target.RubricRowID = rubricRowId;
            target.EvidenceTypeID = (short)SEEvidenceTypeEnum.STUDENT_GROWTH_GOAL;
            target.EvaluationID = source.EvaluationId;

            return target;
        }

        public static SEAvailableEvidence MapToAvailableEvidence(this SEStudentGrowthGoal source, long rubricRowId, SEAvailableEvidence target = null)
        {
            target = target ?? new SEAvailableEvidence();
            target.StudentGrowthGoalID = source.StudentGrowthGoalID;
            target.RubricRowID = rubricRowId;
            target.EvidenceTypeID = (short)SEEvidenceTypeEnum.STUDENT_GROWTH_GOAL;
            target.EvaluationID = source.EvaluationID;

            return target;
        }

        public static SEAvailableEvidence MapToAvailableEvidence(this ArtifactBundleModel source, long rubricRowId, SEAvailableEvidence target = null)
        {
            target = target ?? new SEAvailableEvidence();
            target.ArtifactBundleID = source.Id;
            target.EvidenceTypeID = (short)SEEvidenceTypeEnum.ARTIFACT;
            target.RubricRowID = rubricRowId;
            target.EvaluationID = source.EvaluationId;

            return target;
        }

        static SEEvidenceTypeEnum MapAnnotationTypeToEvidenceType(SERubricRowAnnotationTypeEnum annotationType)
        {
            switch (annotationType)
            {
                case SERubricRowAnnotationTypeEnum.OBSERVATION_NOTES:
                    return SEEvidenceTypeEnum.RR_ANNOTATION_OBSERVATION_NOTES;
                case SERubricRowAnnotationTypeEnum.PRE_CONF_QUESTION:
                    return SEEvidenceTypeEnum.RR_ANNOTATION_PRECONF_PROMPT;
                case SERubricRowAnnotationTypeEnum.PRE_CONF_MEETING:
                    return SEEvidenceTypeEnum.RR_ANNOTATION_PRECONF_SUMMARY;
            }

            return SEEvidenceTypeEnum.UNDEFINED;
        }


        public static SEAvailableEvidence MapToAvailableEvidenceModel(this RubricRowAnnotationModel source, SEAvailableEvidence target = null)
        {
            target = target ?? new SEAvailableEvidence();
            target.RubricRowAnnotationID = source.Id;
            target.EvidenceTypeID = (short)MapAnnotationTypeToEvidenceType(source.AnnotationType);
            target.RubricRowID = source.RubricRowID;
            target.EvaluationID = source.EvaluationID;

            return target;
        }
     
    }
}