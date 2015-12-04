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
    
    public partial class SEEvaluation
    {
        public SEEvaluation()
        {
            this.SEEvaluationWfHistories = new HashSet<SEEvaluationWfHistory>();
            this.SEReportPrintOptionEvaluations = new HashSet<SEReportPrintOptionEvaluation>();
            this.SEStudentGrowthGoals = new HashSet<SEStudentGrowthGoal>();
            this.SEUsers = new HashSet<SEUser>();
            this.SEArtifactBundles = new HashSet<SEArtifactBundle>();
            this.SESummativeFrameworkNodeScores = new HashSet<SESummativeFrameworkNodeScore>();
            this.SESummativeRubricRowScores = new HashSet<SESummativeRubricRowScore>();
            this.SEFrameworkNodeScores = new HashSet<SEFrameworkNodeScore>();
            this.SERubricRowScores = new HashSet<SERubricRowScore>();
            this.SEEvalSessions = new HashSet<SEEvalSession>();
            this.SESelfAssessments = new HashSet<SESelfAssessment>();
            this.SERubricRowEvaluations = new HashSet<SERubricRowEvaluation>();
            this.SEAvailableEvidences = new HashSet<SEAvailableEvidence>();
            this.SEAvailableEvidences1 = new HashSet<SEAvailableEvidence>();
        }
    
        public long EvaluationID { get; set; }
        public long EvaluateeID { get; set; }
        public Nullable<long> EvaluatorID { get; set; }
        public short EvaluationTypeID { get; set; }
        public Nullable<short> PerformanceLevelID { get; set; }
        public bool HasBeenSubmitted { get; set; }
        public Nullable<System.DateTime> SubmissionDate { get; set; }
        public short SchoolYear { get; set; }
        public bool Complete { get; set; }
        public System.DateTime CreateDate { get; set; }
        public Nullable<short> EvaluateePlanTypeID { get; set; }
        public string DistrictCode { get; set; }
        public Nullable<long> FocusedFrameworkNodeID { get; set; }
        public Nullable<long> FocusedSGFrameworkNodeID { get; set; }
        public Nullable<long> WfStateID { get; set; }
        public Nullable<short> NextYearEvaluateePlanTypeID { get; set; }
        public Nullable<long> NextYearFocusedFrameworkNodeID { get; set; }
        public Nullable<long> NextYearFocusedSGFrameworkNodeID { get; set; }
        public Nullable<bool> ByPassSGScores { get; set; }
        public string SGScoreOverrideComment { get; set; }
        public Nullable<bool> VisibleToEvaluatee { get; set; }
        public Nullable<bool> AutoSubmitAfterReceipt { get; set; }
        public Nullable<bool> ByPassReceipt { get; set; }
        public string ByPassReceiptOverrideComment { get; set; }
        public Nullable<bool> DropToPaper { get; set; }
        public string DropToPaperOverrideComment { get; set; }
        public Nullable<System.DateTime> MarkedFinalDateTime { get; set; }
        public Nullable<long> FinalReportRepositoryItemID { get; set; }
        public string EvaluateeReflections { get; set; }
        public string EvaluatorRecommendations { get; set; }
        public Nullable<bool> EvaluateeReflectionsIsPublic { get; set; }
        public Nullable<short> SubmissionCount { get; set; }
    
        public virtual SEEvaluateePlanType SEEvaluateePlanType { get; set; }
        public virtual SEEvaluateePlanType SEEvaluateePlanType1 { get; set; }
        public virtual SEFrameworkNode SEFrameworkNode { get; set; }
        public virtual SEEvaluationType SEEvaluationType { get; set; }
        public virtual SEFrameworkNode SEFrameworkNode1 { get; set; }
        public virtual SEFrameworkNode SEFrameworkNode2 { get; set; }
        public virtual SERubricPerformanceLevel SERubricPerformanceLevel { get; set; }
        public virtual SESchoolYear SESchoolYear { get; set; }
        public virtual SEUser SEUser { get; set; }
        public virtual SEUser SEUser1 { get; set; }
        public virtual SEWfState SEWfState { get; set; }
        public virtual SEFrameworkNode SEFrameworkNode3 { get; set; }
        public virtual ICollection<SEEvaluationWfHistory> SEEvaluationWfHistories { get; set; }
        public virtual ICollection<SEReportPrintOptionEvaluation> SEReportPrintOptionEvaluations { get; set; }
        public virtual ICollection<SEStudentGrowthGoal> SEStudentGrowthGoals { get; set; }
        public virtual ICollection<SEUser> SEUsers { get; set; }
        public virtual ICollection<SEArtifactBundle> SEArtifactBundles { get; set; }
        public virtual ICollection<SESummativeFrameworkNodeScore> SESummativeFrameworkNodeScores { get; set; }
        public virtual ICollection<SESummativeRubricRowScore> SESummativeRubricRowScores { get; set; }
        public virtual ICollection<SEFrameworkNodeScore> SEFrameworkNodeScores { get; set; }
        public virtual ICollection<SERubricRowScore> SERubricRowScores { get; set; }
        public virtual ICollection<SEEvalSession> SEEvalSessions { get; set; }
        public virtual ICollection<SESelfAssessment> SESelfAssessments { get; set; }
        public virtual ICollection<SERubricRowEvaluation> SERubricRowEvaluations { get; set; }
        public virtual ICollection<SEAvailableEvidence> SEAvailableEvidences { get; set; }
        public virtual ICollection<SEAvailableEvidence> SEAvailableEvidences1 { get; set; }
    }
}
