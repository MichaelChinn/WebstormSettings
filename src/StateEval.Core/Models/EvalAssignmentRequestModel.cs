using System.Collections.Generic;

using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class EvalAssignmentRequestModel
    {
        public EvalAssignmentRequestModel() { }

        public long Id { get; set; }
        public short SchoolYear { get; set; }
        public string DistrictCode { get; set; }
        public long EvaluateeId { get; set; }
        public long EvaluatorId { get; set; }
        public short EvalRequestType { get; set; }
        public short EvalRequestStatus { get; set; }
        public string TeacherDisplayName { get; set; }
        public string EvaluatorDisplayName { get; set; }
    }
}