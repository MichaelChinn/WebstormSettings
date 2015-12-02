using System;
using System.Collections.Generic;

namespace StateEval.Core.Models
{
    public class StudentGrowthGoalBundleModel
    {
        public long Id { get; set; }
        public string ShortName { get; set; }
        public long EvaluationId { get; set;}
        public string Title { get; set; }
        public string Comments { get; set; }
        public DateTime CreationDateTime { get; set; }
        public string Course { get; set; }
        public string Grade { get; set; }
        public short WfState { get; set; }
        public short EvalWfState { get; set; }
        public List<RubricRowModel> AlignedRubricRows { get; set; }
        public List<StudentGrowthGoalModel> Goals { get; set; }

    }
}



