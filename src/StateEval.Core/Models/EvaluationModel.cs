namespace StateEval.Core.Models
{
    public class EvaluationModel
    {
        public long Id { get; set; }
        public long EvaluateeId { get; set; }
        public long? EvaluatorId { get; set; }
        public short SchoolYear { get; set; }
        public short EvalType { get; set; }
        public short? PlanType { get; set; }
        public string DistrictCode { get; set; }
        public short WfState { get; set; }
        public long? FocusFrameworkNodeId { get; set; }
        public long? FocusSGFrameworkNodeId { get; set; }
    }
}

