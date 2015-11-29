namespace StateEval.Core.Models
{
    public class RubricRowEvaluationEvidenceModel
    {
        public long Id { get; set; }
        public long RubricRowEvaluationId { get; set; }
        public string RubricStatement { get; set; }
        public string Evidence { get; set; }
        public short StatementPerformanceLevel { get; set; }
        public long RubricRowId { get; set; }
        public long EvaluationId { get; set; }
    }
}



