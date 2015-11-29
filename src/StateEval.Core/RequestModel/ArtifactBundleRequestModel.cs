using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class ArtifactBundleRequestModel
    {
        public long EvaluationId { get; set; }
        public long WfState { get; set; }
        public long CreatedByUserId { get; set; }
        public long CurrentUserId { get; set; }
        public SEArtifactTypeEnum ArtifactType { get; set; }
        public long RubricRowId { get; set; }
        public long LinkedItemId { get; set; }
    }
}
