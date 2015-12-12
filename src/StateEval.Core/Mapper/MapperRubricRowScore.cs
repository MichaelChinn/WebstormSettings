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
        public static SERubricRowScore MaptoSERubricRowScore(
            this RubricRowScoreModel source, SERubricRowScore target = null)
        {
            target = target ?? new SERubricRowScore();

            target.RubricRowScoreID = source.Id;
            target.EvaluationID = source.EvaluationId;
            target.PerformanceLevelID = source.PerformanceLevel;
            target.RubricRowID = source.RubricRowId;
            target.CreatedByUserID = source.CreatedByUserId;
            target.LinkedItemTypeID = (short)source.LinkedItemType;
            target.LinkedItemID = source.LinkedItemId;

            return target;
        }

        public static RubricRowScoreModel MaptoRubricRowScoreModel(
            this SERubricRowScore source, RubricRowScoreModel target = null)
        {
            target = target ?? new RubricRowScoreModel();

            target.Id = source.RubricRowScoreID;
            target.EvaluationId = source.EvaluationID;
            target.PerformanceLevel = source.PerformanceLevelID;
            target.RubricRowId = source.RubricRowID;
            target.CreatedByUserId = source.CreatedByUserID;
            target.LinkedItemType = (SELinkedItemTypeEnum)source.LinkedItemTypeID;
            target.LinkedItemId = source.LinkedItemID;

            return target;
        }
    }
}