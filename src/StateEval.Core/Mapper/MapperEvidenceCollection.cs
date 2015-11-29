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
        public static EvidenceCollectionModel MapToEvidenceCollectionModel(this SEEvidenceCollection source, EvidenceCollectionModel target = null)
        {
            target = target ?? new EvidenceCollectionModel();
            target.Id = source.EvidenceCollectionID;
            target.CollectionType = (SEEvidenceCollectionTypeEnum)source.EvidenceCollectionTypeID;
            target.CollectionObjectId = source.CollectionObjectID;

            if (source != null && source.SERubricRowEvaluations.Any())
            {
                target.RubricRowEvaluations = source.SERubricRowEvaluations.Select(x => x.MaptoRubricRowEvaluationModel()).ToList();
            }
            else
            {
                target.RubricRowEvaluations = new List<RubricRowEvaluationModel>();
            }

            if (source != null && source.SEAvailableEvidences.Any())
            {
                target.AvailableEvidence = source.SEAvailableEvidences.Select(x => x.MapToAvailableEvidenceModel()).ToList();
            }
            else
            {
                target.AvailableEvidence = new List<AvailableEvidenceModel>();
            }

            return target;
        }

        public static SEEvidenceCollection MaptoSEEvidenceCollection(
                this EvidenceCollectionModel source, SEEvidenceCollection target = null)
        {
            target = target ?? new SEEvidenceCollection();
            target.EvidenceCollectionID = source.Id;
            target.EvidenceCollectionTypeID = (short)source.CollectionType;
            target.CollectionObjectID = source.CollectionObjectId;

            return target;
        }

    }
}