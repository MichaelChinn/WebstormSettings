using System;
using System.Collections.Generic;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class SelfAssessmentModel
    {
        public long Id { get; set; }
        public string ShortName { get; set; }
        public string Title { get; set; }
        public DateTime CreationDateTime { get; set; }
        public long EvaluateeId { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
        public bool Focused { get; set; }
        public short PerformanceLevel { get; set; }
        public long EvaluationId { get; set; }
        public bool IncludeInFinalReport { get; set; }
        public bool IsSharedWithEvaluator { get; set; }
        public Nullable<long> FocusedFrameworkNodeId { get; set; }
        public Nullable<long> FocusedSGFrameworkNodeId { get; set; }

        public List<RubricRowModel> AlignedRubricRows { get; set; }

    }
}