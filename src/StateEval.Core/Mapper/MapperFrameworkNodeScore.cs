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
        public static SEFrameworkNodeScore MaptoSEFrameworkNodeScore(
            this FrameworkNodeScoreModel source, SEFrameworkNodeScore target = null)
        {
            target = target ?? new SEFrameworkNodeScore();

            target.FrameworkNodeScoreID = source.Id;
            target.EvaluationID = source.EvaluationId;
            target.PerformanceLevelID = source.PerformanceLevel;
            target.FrameworkNodeID = source.FrameworkNodeId;
            target.CreatedByUserID = source.CreatedByUserId;
            target.LinkedItemTypeID = (short)source.LinkedItemType;
            target.LinkedItemID = source.LinkedItemId;

            return target;
        }

        public static FrameworkNodeScoreModel MaptoFrameworkNodeScoreModel(
            this SEFrameworkNodeScore source, FrameworkNodeScoreModel target = null)
        {
            target = target ?? new FrameworkNodeScoreModel();

            target.Id = source.FrameworkNodeScoreID;
            target.EvaluationId = source.EvaluationID;
            target.PerformanceLevel = source.PerformanceLevelID;
            target.FrameworkNodeId = source.FrameworkNodeID;
            target.CreatedByUserId = source.CreatedByUserID;
            target.LinkedItemType = (SELinkedItemTypeEnum)source.LinkedItemTypeID;
            target.LinkedItemId = source.LinkedItemID;

            return target;
        }
    }
}