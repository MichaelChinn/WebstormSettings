using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StateEval.Core.Constants;

namespace webAPI.Models
{
    public class AssignmentRequestModel
    {
        public SESchoolYearEnum SchoolYear { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
        public SEEvaluateePlanTypeEnum EvaluateePlanType { get; set; }
        public long EvaluateeId { get; set; }
        public long? EvaluatorId { get; set; }
        public Nullable<long> FocusFrameworkNodeId { get; set; }
        public Nullable<long> SGFocusFrameworkNodeId { get; set; }
        public SEEvalRequestTypeEnum EvalRequestType { get; set;}
        public SEEvalRequestStatusEnum EvalRequestStatus { get; set;}
        public bool DelegateTeacherAssignments { get; set; }
    }
}
