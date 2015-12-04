using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class SelfAssessmentRequestModel
    {
        public long EvaluationId { get; set; }
        public long CurrentUserId { get; set; }
    }
}
