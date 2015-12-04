using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class ArtifactBundleRequestModel
    {
        public long EvaluationId { get; set; }
        public long WfState { get; set; }
        public long CreatedByUserId { get; set; }
        public long CurrentUserId { get; set; }
        public long RubricRowId { get; set; }
    }
}
