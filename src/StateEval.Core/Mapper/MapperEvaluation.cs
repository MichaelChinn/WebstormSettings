using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EvaluationModel MapToEvaluationModel(this SEEvaluation source, EvaluationModel target = null)
        {
            target = target ?? new EvaluationModel();
            target.Id = source.EvaluationID;
            target.EvaluateeId = source.EvaluateeID;
            target.EvaluatorId = source.EvaluatorID;
            target.EvalType = Convert.ToInt16(source.EvaluationTypeID);
            target.PlanType = Convert.ToInt16(source.EvaluateePlanTypeID);
            target.DistrictCode = source.DistrictCode;
            target.SchoolYear = Convert.ToInt16(source.SchoolYear);
            target.WfState = Convert.ToInt16(source.WfStateID);
            target.FocusFrameworkNodeId = source.FocusedFrameworkNodeID;
            target.FocusSGFrameworkNodeId = source.FocusedSGFrameworkNodeID;
            return target;
        }
    }
}