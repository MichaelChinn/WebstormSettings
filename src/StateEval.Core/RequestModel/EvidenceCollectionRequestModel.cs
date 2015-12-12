using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class EvidenceCollectionRequestModel
    {
        public long EvaluationId { get; set; }
        public SEEvidenceCollectionTypeEnum CollectionType { get; set; }
        public long CollectionObjectId { get; set; }
        public long FrameworkNodeId { get; set; }
        public long RubricRowId { get; set; }
        public long CurrentUserId { get; set; }
    }

}
