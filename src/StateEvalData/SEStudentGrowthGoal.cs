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
    
    public partial class SEStudentGrowthGoal
    {
        public SEStudentGrowthGoal()
        {
            this.SEStudentGrowthGoalBundles = new HashSet<SEStudentGrowthGoalBundle>();
            this.SEAvailableEvidences = new HashSet<SEAvailableEvidence>();
            this.SEStudentGrowthFormPromptResponses = new HashSet<SEStudentGrowthFormPromptResponse>();
        }
    
        public long StudentGrowthGoalID { get; set; }
        public long GoalBundleID { get; set; }
        public long EvaluationID { get; set; }
        public long FrameworkNodeID { get; set; }
        public long ProcessRubricRowID { get; set; }
        public Nullable<long> ResultsRubricRowID { get; set; }
        public string GoalStatement { get; set; }
        public string GoalTargets { get; set; }
        public string EvidenceAll { get; set; }
        public string EvidenceMost { get; set; }
        public Nullable<short> ProcessPerformanceLevelID { get; set; }
        public Nullable<short> ResultsPerformanceLevelID { get; set; }
        public short ProcessTypeID { get; set; }
        public Nullable<long> ProcessArtifactBundleID { get; set; }
        public Nullable<long> ProcessFormID { get; set; }
        public bool IsActive { get; set; }
    
        public virtual SEFrameworkNode SEFrameworkNode { get; set; }
        public virtual SERubricPerformanceLevel SERubricPerformanceLevel { get; set; }
        public virtual SERubricPerformanceLevel SERubricPerformanceLevel1 { get; set; }
        public virtual SERubricRow SERubricRow { get; set; }
        public virtual SERubricRow SERubricRow1 { get; set; }
        public virtual SEStudentGrowthGoalBundle SEStudentGrowthGoalBundle { get; set; }
        public virtual ICollection<SEStudentGrowthGoalBundle> SEStudentGrowthGoalBundles { get; set; }
        public virtual SEEvaluation SEEvaluation { get; set; }
        public virtual SEArtifactBundle SEArtifactBundle { get; set; }
        public virtual ICollection<SEAvailableEvidence> SEAvailableEvidences { get; set; }
        public virtual ICollection<SEStudentGrowthFormPromptResponse> SEStudentGrowthFormPromptResponses { get; set; }
    }
}
