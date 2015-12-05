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
    
    public partial class SERubricRowEvaluation
    {
        public SERubricRowEvaluation()
        {
            this.SEAlignedEvidences = new HashSet<SEAlignedEvidence>();
        }
    
        public long RubricRowEvaluationID { get; set; }
        public long RubricRowID { get; set; }
        public long EvaluationID { get; set; }
        public short EvidenceCollectionTypeID { get; set; }
        public short LinkedItemTypeID { get; set; }
        public Nullable<short> PerformanceLevelID { get; set; }
        public Nullable<long> LinkedObservationID { get; set; }
        public Nullable<long> LinkedStudentGrowthGoalBundleID { get; set; }
        public Nullable<long> LinkedSelfAssessmentID { get; set; }
        public long CreatedByUserID { get; set; }
        public System.DateTime CreationDateTime { get; set; }
        public string RubricStatement { get; set; }
        public string AdditionalInput { get; set; }
    
        public virtual SEEvalSession SEEvalSession { get; set; }
        public virtual SEEvalSession SEEvalSession1 { get; set; }
        public virtual SEEvaluation SEEvaluation { get; set; }
        public virtual SEEvidenceCollectionType SEEvidenceCollectionType { get; set; }
        public virtual SELinkedItemType SELinkedItemType { get; set; }
        public virtual SERubricPerformanceLevel SERubricPerformanceLevel { get; set; }
        public virtual SERubricRow SERubricRow { get; set; }
        public virtual SEStudentGrowthGoalBundle SEStudentGrowthGoalBundle { get; set; }
        public virtual ICollection<SEAlignedEvidence> SEAlignedEvidences { get; set; }
        public virtual SEUser SEUser { get; set; }
        public virtual SESelfAssessment SESelfAssessment { get; set; }
    }
}
