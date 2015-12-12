namespace StateEval.Core.Models
{
    public class StudentGrowthFormPromptFrameworkNodeModel
    {
        public long Id { get; set; }
        public string DistrictCode { get; set; }
        public short EvaluationType { get; set; }
        public short SchoolYear { get; set; }
        public long FormPromptId { get; set; }
        public long FrameworkNodeId { get; set; }
        public StudentGrowthFormPromptModel FormPrompt { get; set; }

    }
}



