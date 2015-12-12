using System.Collections.Generic;

namespace StateEval.Core.Models
{
    public class StudentGrowthGoalModel
    {
        public long Id { get; set; }
        public long EvaluationId { get; set;}
        public string GoalStatement { get; set; }
        public string GoalTargets { get; set; }
        public string EvidenceAll { get; set; }
        public string EvidenceMost { get; set; }
        public long FrameworkNodeId { get; set; }
        public string FrameworkNodeShortName { get; set; }
        public long ProcessRubricRowId { get; set; }
        public long ResultsRubricRowId { get; set; }
        public bool IsActive { get; set;  }

        public long GoalBundleId { get; set; }
        public string GoalBundleTitle { get; set; }

        public List<StudentGrowthFormPromptModel> Prompts { get; set; }
    }
}



