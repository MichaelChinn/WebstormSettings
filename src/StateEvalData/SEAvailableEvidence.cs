//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace StateEvalData
{
    using System;
    using System.Collections.Generic;
    
    public partial class SEAvailableEvidence
    {
        public SEAvailableEvidence()
        {
            this.SEAlignedEvidences = new HashSet<SEAlignedEvidence>();
        }
    
        public long AvailableEvidenceID { get; set; }
        public long EvaluationID { get; set; }
        public short EvidenceTypeID { get; set; }
        public long RubricRowID { get; set; }
        public Nullable<long> ArtifactBundleID { get; set; }
        public Nullable<long> RubricRowAnnotationID { get; set; }
        public Nullable<long> StudentGrowthGoalID { get; set; }
    
        public virtual ICollection<SEAlignedEvidence> SEAlignedEvidences { get; set; }
        public virtual SEArtifactBundle SEArtifactBundle { get; set; }
        public virtual SEEvaluation SEEvaluation { get; set; }
        public virtual SEEvaluation SEEvaluation1 { get; set; }
        public virtual SEEvidenceType SEEvidenceType { get; set; }
        public virtual SERubricRow SERubricRow { get; set; }
        public virtual SERubricRowAnnotation SERubricRowAnnotation { get; set; }
        public virtual SEStudentGrowthGoal SEStudentGrowthGoal { get; set; }
    }
}
