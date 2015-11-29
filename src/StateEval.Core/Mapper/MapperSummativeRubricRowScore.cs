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
        public static SESummativeRubricRowScore MaptoSESummativeRubricRowScore(
            this SummativeRubricRowScoreModel source, SESummativeRubricRowScore target = null)
        {
            target = target ?? new SESummativeRubricRowScore();

            target.SummativeRubricRowScoreID = source.Id;
            target.EvaluationID = source.EvaluationId;
            target.PerformanceLevelID = source.PerformanceLevel;
            target.RubricRowID = source.RubricRowId;
            target.CreatedByUserID = source.CreatedByUserId;

            return target;
        }

        public static SummativeRubricRowScoreModel MaptoSummativeRubricRowScoreModel(
            this SESummativeRubricRowScore source, SummativeRubricRowScoreModel target = null)
        {
            target = target ?? new SummativeRubricRowScoreModel();

            target.Id = source.SummativeRubricRowScoreID;
            target.EvaluationId = source.EvaluationID;
            target.PerformanceLevel = source.PerformanceLevelID;
            target.RubricRowId = source.RubricRowID;
            target.CreatedByUserId = source.CreatedByUserID;

            return target;
        }
    }
}