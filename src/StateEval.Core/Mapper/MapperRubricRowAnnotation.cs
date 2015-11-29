using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {

        public static RubricRowAnnotationModel MaptoRubricRowAnnotationModel(this SERubricRowAnnotation source, RubricRowAnnotationModel target = null)
        {
            target = target ?? new RubricRowAnnotationModel();
            target.Annotation = source.Annotation;
            target.EvalSessionID = source.EvalSessionID;
            target.ArtifactBundleID = source.ArtifactBundleID;
            target.Id = source.RubricRowAnnotationID;
            target.UserID = source.UserID;
            target.RubricRowID = source.RubricRowID;
            target.AnnotationType = source.AnnotationSourceType == null
                ? SERubricRowAnnotationTypeEnum.UNDEFINED
                : (SERubricRowAnnotationTypeEnum) source.AnnotationSourceType;

            return target;
        }

        public static SERubricRowAnnotation MaptoSERubricRowAnnotationModel(this RubricRowAnnotationModel source, StateEvalEntities evalEntities, SERubricRowAnnotation target = null)
        {
            target = target ?? new SERubricRowAnnotation();
            target.EvaluationID = source.EvaluationID;
            target.EvalSessionID = source.EvalSessionID;
            target.ArtifactBundleID = source.ArtifactBundleID;
            target.StudentGrowthGoalBundleID = source.StudentGrowthGoalBundleID;
            target.LinkedItemTypeID = (short)source.LinkedItemType;
            target.Annotation = source.Annotation;
            target.RubricRowAnnotationID = source.Id;
            target.UserID = source.UserID;
            target.RubricRowID = source.RubricRowID;
            target.AnnotationSourceType = (int) source.AnnotationType;

            SEAvailableEvidence evidence = evalEntities.SEAvailableEvidences.FirstOrDefault(x => x.RubricRowAnnotationID == source.Id && x.RubricRowID == source.RubricRowID);
            if (evidence == null)
            {
                evalEntities.SEAvailableEvidences.Add(source.MapToAvailableEvidenceModel());
            }
            return target;
        }
    }
}