using System;
using System.Collections.Generic;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class RubricRowEvaluationObjectSummaryModel
    {
        public RubricRowEvaluationObjectSummaryModel(string title, string createdByDisplayName, string evaluatedByDisplayName)
        {
            Title = title;
            CreatedByDisplayName = createdByDisplayName;
            EvaluatedByDisplayName = evaluatedByDisplayName;
        }

        public string Title { get; set; }
        public string CreatedByDisplayName { get; set; }
        public string EvaluatedByDisplayName { get; set; }
    }
                                            
    public class RubricRowEvaluationModel
    {
        public long Id { get; set; }
        public long RubricRowId { get; set; }
        public long EvaluationId { get; set; }
        public SEEvidenceCollectionTypeEnum EvidenceCollectionType { get; set; }

        public short? PerformanceLevel { get; set; }
        public string RubricStatement { get; set; }
        public string AdditionalInput { get; set; }

        public short LinkedItemType { get; set; }
        public long? LinkedObservationId { get; set; }
        public long? LinkedArtifactBundleId { get; set; }
        public long? LinkedStudentGrowthGoalBundleId { get; set; }
        public long? LinkedSelfAssessmentId { get; set; }
        public long CreatedByUserId { get; set; }

        public string CreatedByUserDisplayName { get; set; }
        public SEWfStateEnum WfState { get; set; }
        public DateTime CreationDateTime { get; set; }

        public List<AlignedEvidenceModel> AlignedEvidences { get; set; }

        public RubricRowEvaluationObjectSummaryModel ObjectSummary { get; set; }
    }
}



