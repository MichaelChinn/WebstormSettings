using System;
using System.Collections.Generic;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class EvalSessionModel
    {
        public long Id { get; set; }
        public string ShortName { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public string Title { get; set; }
        public DateTime? ObserveStartTime { get; set; }
        public long? EvaluatorId { get; set; }
        public long? EvaluateeId { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
        public SESchoolYearEnum SchoolYear { get; set; }
        public bool Focused { get; set; }
        public string ObserveNotes { get; set; }
        public int EvaluationScoreTypeID { get; set; }
        public int? Duration { get; set; }
        public string EvaluatorNotes { get; set; }
        public short WfState { get; set; }        
        public long EvaluationId { get; set; }
        public string CreatedByDisplayName { get; set; }

        public string RubricRowNames { get; set; }
        public Nullable<bool> PreConfIsPublic { get; set; }
        public Nullable<bool> PreConfIsComplete { get; set; }
        public Nullable<System.DateTime> PreConfStartTime { get; set; }
        public Nullable<System.DateTime> PostConfStartTime { get; set; }
        public Nullable<System.DateTime> PreConfEndTime { get; set; }

        public List<RubricRowModel> RubricRows { get; set; }
        public string EvaluatorPreConNotes { get; set; }
        public string EvaluateePreConNotes { get; set; }
        public Nullable<bool> IsSharedWithEvaluatee { get; set; }

        // TODO: needed for scoring
        public List<RubricRowModel> AlignedRubricRows { get; set; }

        public int? PreConfPromptState { get; set; }
    }
}