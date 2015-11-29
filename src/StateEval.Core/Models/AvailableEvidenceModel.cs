using System;
using System.Collections.Generic;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class AvailableEvidenceModel
    {
        public long Id { get; set; }
        public SEEvidenceTypeEnum EvidenceType { get; set; }
        public long EvaluationId { get; set; }
        public long RubricRowId { get; set; }
        public Nullable<long> ArtifactBundleId { get; set; }
        public Nullable<long> RubricRowAnnotationId { get; set; }
        public Nullable<long> StudentGrowthGoalId { get; set; }
        public ArtifactBundleModel ArtifactBundle { get; set; }
        public RubricRowAnnotationModel RubricRowAnnotation { get; set; }
        public StudentGrowthGoalModel StudentGrowthGoal { get; set; }
    }
}
