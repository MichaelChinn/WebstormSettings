using System;
using System.Collections.Generic;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class ArtifactBundleModel
    {
        public long Id { get; set; }
        public long EvaluationId { get; set;}
        public long CreatedByUserId { get; set; }
        public string CreatedByDisplayName { get; set; }
        public string Title { get; set; }
        public DateTime CreationDateTime { get; set; }
        public string Context { get; set; }
        public string Evidence { get; set; }
        public long WfState { get; set; }
        public short ArtifactType { get; set; }
        public DateTime? SubmitDateTime { get; set; }
        public DateTime? RejectDateTime { get; set; }
        public string LinkedToObjectTitle { get; set; }
        public short? RejectionType { get; set; }

        public List<ArtifactLibItemModel> LibItems { get; set; }
        public List<RubricRowModel> AlignedRubricRows { get; set; }


        // only set when saving an artifact
        public List<EvalSessionModel> LinkedObservations { get; set; }
        public List<StudentGrowthGoalBundleModel> LinkedStudentGrowthGoalBundles { get; set; }
    }
}



