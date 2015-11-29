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
    
    public partial class SEEvalSession
    {
        public SEEvalSession()
        {
            this.SEDistrictTrainingProtocolAnchors = new HashSet<SEDistrictTrainingProtocolAnchor>();
            this.SEPracticeSessions = new HashSet<SEPracticeSession>();
            this.SEPracticeSessionParticipants = new HashSet<SEPracticeSessionParticipant>();
            this.SEPullQuotes = new HashSet<SEPullQuote>();
            this.SEReportPrintOptionEvalSessions = new HashSet<SEReportPrintOptionEvalSession>();
            this.SELearningWalkSessionScores = new HashSet<SELearningWalkSessionScore>();
            this.SEUserPrompts = new HashSet<SEUserPrompt>();
            this.SEUserPromptResponses = new HashSet<SEUserPromptResponse>();
            this.SERubricRows = new HashSet<SERubricRow>();
            this.SERubricRowAnnotations = new HashSet<SERubricRowAnnotation>();
            this.SEArtifactBundles = new HashSet<SEArtifactBundle>();
            this.SERubricRowEvaluations = new HashSet<SERubricRowEvaluation>();
            this.SERubricRowEvaluations1 = new HashSet<SERubricRowEvaluation>();
        }
    
        public long EvalSessionID { get; set; }
        public string SchoolCode { get; set; }
        public string DistrictCode { get; set; }
        public Nullable<long> EvaluatorUserID { get; set; }
        public Nullable<long> EvaluateeUserID { get; set; }
        public short EvaluationTypeID { get; set; }
        public string Title { get; set; }
        public string EvaluatorPreConNotes { get; set; }
        public string EvaluateePreConNotes { get; set; }
        public string ObserveNotes { get; set; }
        public Nullable<short> EvaluationScoreTypeID { get; set; }
        public Nullable<short> AnchorTypeID { get; set; }
        public Nullable<short> PerformanceLevelID { get; set; }
        public Nullable<bool> PreConfIsPublic { get; set; }
        public Nullable<bool> PreConfIsComplete { get; set; }
        public Nullable<System.DateTime> PreConfStartTime { get; set; }
        public Nullable<System.DateTime> PreConfEndTime { get; set; }
        public string PreConfLocation { get; set; }
        public Nullable<bool> ObserveIsPublic { get; set; }
        public Nullable<bool> ObserveIsComplete { get; set; }
        public Nullable<System.DateTime> ObserveStartTime { get; set; }
        public Nullable<System.DateTime> ObserveEndTime { get; set; }
        public string ObserveLocation { get; set; }
        public Nullable<System.DateTime> PostConfStartTime { get; set; }
        public Nullable<System.DateTime> PostConfEndTime { get; set; }
        public string PostConfLocation { get; set; }
        public Nullable<bool> PostConfIsPublic { get; set; }
        public Nullable<bool> PostConfIsComplete { get; set; }
        public bool IsSelfAssess { get; set; }
        public Nullable<short> SchoolYear { get; set; }
        public Nullable<bool> IsFocused { get; set; }
        public Nullable<long> FocusedFrameworkNodeID { get; set; }
        public Nullable<long> FocusedSGFrameworkNodeID { get; set; }
        public Nullable<long> TrainingProtocolID { get; set; }
        public Nullable<short> SessionKey { get; set; }
        public Nullable<bool> IncludeInFinalReport { get; set; }
        public Nullable<System.DateTime> LockDateTime { get; set; }
        public Nullable<bool> isFormalObs { get; set; }
        public Nullable<int> Duration { get; set; }
        public string EvaluatorNotes { get; set; }
        public long EvaluationID { get; set; }
        public long WfStateID { get; set; }
        public Nullable<bool> IsSharedWithEvaluatee { get; set; }
        public Nullable<int> PreConfPromptState { get; set; }
    
        public virtual SEAnchorType SEAnchorType { get; set; }
        public virtual ICollection<SEDistrictTrainingProtocolAnchor> SEDistrictTrainingProtocolAnchors { get; set; }
        public virtual SEFrameworkNode SEFrameworkNode { get; set; }
        public virtual SEEvaluationScoreType SEEvaluationScoreType { get; set; }
        public virtual SERubricPerformanceLevel SERubricPerformanceLevel { get; set; }
        public virtual SESchoolYear SESchoolYear { get; set; }
        public virtual SETrainingProtocol SETrainingProtocol { get; set; }
        public virtual SEUser SEUser { get; set; }
        public virtual SEUser SEUser1 { get; set; }
        public virtual SEWfState SEWfState { get; set; }
        public virtual SEFrameworkNode SEFrameworkNode1 { get; set; }
        public virtual ICollection<SEPracticeSession> SEPracticeSessions { get; set; }
        public virtual ICollection<SEPracticeSessionParticipant> SEPracticeSessionParticipants { get; set; }
        public virtual ICollection<SEPullQuote> SEPullQuotes { get; set; }
        public virtual ICollection<SEReportPrintOptionEvalSession> SEReportPrintOptionEvalSessions { get; set; }
        public virtual ICollection<SELearningWalkSessionScore> SELearningWalkSessionScores { get; set; }
        public virtual ICollection<SEUserPrompt> SEUserPrompts { get; set; }
        public virtual ICollection<SEUserPromptResponse> SEUserPromptResponses { get; set; }
        public virtual ICollection<SERubricRow> SERubricRows { get; set; }
        public virtual SEEvaluation SEEvaluation { get; set; }
        public virtual ICollection<SERubricRowAnnotation> SERubricRowAnnotations { get; set; }
        public virtual ICollection<SEArtifactBundle> SEArtifactBundles { get; set; }
        public virtual ICollection<SERubricRowEvaluation> SERubricRowEvaluations { get; set; }
        public virtual ICollection<SERubricRowEvaluation> SERubricRowEvaluations1 { get; set; }
    }
}
