using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class RubricRowEvaluationsRequestModel
    {
        public long EvaluationId { get; set; }
        public SELinkedItemTypeEnum LinkedItemType { get; set; }
        public long LinkedItemId { get; set; }
        public long RubricRowId { get; set; }
        public long CreatedByUserId { get; set; }
    }

}
