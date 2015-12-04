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
        public static bool IsRubricRowAnnotationType(short type)
        {
            // for now we only have artifacts and different variants of annotations
            return (type != (short)SEEvidenceTypeEnum.ARTIFACT);
        }

        public static AlignedEvidenceModel MapToAlignedEvidenceModel(this SEAlignedEvidence source, StateEvalEntities evalEntities, AlignedEvidenceModel target = null)
        {
            target = target ?? new AlignedEvidenceModel();
            target.Id = source.AlignedEvidenceID;
            target.RubricRowEvaluationId = source.RubricRowEvaluationID;
            target.AvailableEvidenceId = source.AvailableEvidenceID;
            target.AdditionalInput = source.AdditionalInput;
            target.EvidenceType = (SEEvidenceTypeEnum)source.EvidenceTypeID;
            target.Data = evalEntities.SEAvailableEvidences
                    .FirstOrDefault(x => x.AvailableEvidenceID == source.AvailableEvidenceID)
                    .MapToAvailableEvidenceModel(evalEntities);

            target.AvailableEvidenceObjectId = source.AvailableEvidenceObjectID;
         
            return target;
        }

        public static SEAlignedEvidence MapToAlignedEvidenceModel(this AlignedEvidenceModel source, SEAlignedEvidence target = null)
        {
            target = target ?? new SEAlignedEvidence();
            target.AlignedEvidenceID = source.Id;
            target.EvidenceTypeID = (short) source.EvidenceType;
            target.RubricRowEvaluationID = source.RubricRowEvaluationId;
            target.AvailableEvidenceID = source.AvailableEvidenceId;
            target.AdditionalInput = source.AdditionalInput;
            target.AvailableEvidenceObjectID = source.AvailableEvidenceObjectId;

            return target;
        }
    }
}