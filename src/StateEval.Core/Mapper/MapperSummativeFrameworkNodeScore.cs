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
        public static SESummativeFrameworkNodeScore MaptoSESummativeFrameworkNodeScore(
            this SummativeFrameworkNodeScoreModel source, SESummativeFrameworkNodeScore target = null)
        {
            target = target ?? new SESummativeFrameworkNodeScore();

            target.SummativeFrameworkNodeScoreID = source.Id;
            target.EvaluationID = source.EvaluationId;
            target.PerformanceLevelID = source.PerformanceLevel;
            target.FrameworkNodeID = source.FrameworkNodeId;
            target.CreatedByUserID = source.CreatedByUserId;
            target.StatementOfPerformance = source.StatementOfPerformance;

            return target;
        }

        public static SummativeFrameworkNodeScoreModel MaptoSummativeFrameworkNodeScoreModel(
            this SESummativeFrameworkNodeScore source, SummativeFrameworkNodeScoreModel target = null)
        {
            target = target ?? new SummativeFrameworkNodeScoreModel();

            target.Id = source.SummativeFrameworkNodeScoreID;
            target.EvaluationId = source.EvaluationID;
            target.PerformanceLevel = source.PerformanceLevelID;
            target.FrameworkNodeId = source.FrameworkNodeID;
            target.CreatedByUserId = source.CreatedByUserID;
            target.StatementOfPerformance = source.StatementOfPerformance;


            return target;
        }
    }
}