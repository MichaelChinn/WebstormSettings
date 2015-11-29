using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;
using StateEval.Core.Constants;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EvalAssignmentRequestModel MapToEvalAssignmentRequestModel(this SEEvalAssignmentRequest source, StateEvalEntities evalEntities, EvalAssignmentRequestModel target = null)
        {
            target = target ?? new EvalAssignmentRequestModel();
            target.Id = source.EvalAssignmentRequestID;
            target.DistrictCode = source.DistrictCode;
            target.EvaluateeId = source.EvaluateeID;
            target.EvaluatorId = source.EvaluatorID;
            target.SchoolYear = (short)source.SchoolYear;
            target.EvalRequestType = source.RequestTypeID;
            target.EvalRequestStatus = source.Status;
            SEUser seUser = evalEntities.SEUsers.FirstOrDefault(x => x.SEUserID == source.EvaluateeID);
            target.TeacherDisplayName = seUser.FirstName + " " + seUser.LastName;
            seUser = evalEntities.SEUsers.FirstOrDefault(x => x.SEUserID == source.EvaluatorID);
            target.EvaluatorDisplayName = seUser.FirstName + " " + seUser.LastName;
            return target;
        }

        public static SEEvalAssignmentRequest MapToEvalAssignmentRequestModel(this EvalAssignmentRequestModel source, SEEvalAssignmentRequest target = null)
        {
            target = target ?? new SEEvalAssignmentRequest();
            target.EvalAssignmentRequestID = source.Id;
            target.DistrictCode = source.DistrictCode;
            target.EvaluateeID = source.EvaluateeId;
            target.EvaluatorID = source.EvaluatorId;
            target.SchoolYear = source.SchoolYear;
            target.RequestTypeID = source.EvalRequestType;
            target.Status = source.EvalRequestStatus;
            return target;
        }
    }
}