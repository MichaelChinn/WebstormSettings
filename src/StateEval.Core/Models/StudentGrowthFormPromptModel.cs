namespace StateEval.Core.Models
{
    public class StudentGrowthFormPromptModel
    {
        public long Id { get; set; }
        public string Prompt { get; set; }
        public bool Required { get; set; }
        public short Sequence { get; set; }       
        public string Response { get; set; }
        public long ResponseId { get; set; }
        public long UserId { get; set; }
        public string DistrictCode {get; set; }
        public short EvaluationType {get; set; }
        public short SchoolYear { get; set; }
        public short PromptType { get; set; }
    }
}



