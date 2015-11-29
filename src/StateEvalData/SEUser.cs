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
    
    public partial class SEUser
    {
        public SEUser()
        {
            this.SEEvalAssignmentRequests = new HashSet<SEEvalAssignmentRequest>();
            this.SEEvalAssignmentRequests1 = new HashSet<SEEvalAssignmentRequest>();
            this.SEEvaluationWfHistories = new HashSet<SEEvaluationWfHistory>();
            this.SELearningWalkSessionScores = new HashSet<SELearningWalkSessionScore>();
            this.SEPracticeSessionParticipants = new HashSet<SEPracticeSessionParticipant>();
            this.SETrainingProtocolPlaylists = new HashSet<SETrainingProtocolPlaylist>();
            this.SETrainingProtocolRatings = new HashSet<SETrainingProtocolRating>();
            this.SEDistrictPRViewings = new HashSet<SEDistrictPRViewing>();
            this.SEReportPrintOptionUsers = new HashSet<SEReportPrintOptionUser>();
            this.SEUserPrompts = new HashSet<SEUserPrompt>();
            this.SEUserPrompts1 = new HashSet<SEUserPrompt>();
            this.SEUserPromptResponseEntries = new HashSet<SEUserPromptResponseEntry>();
            this.SEUserPromptConferenceDefaults = new HashSet<SEUserPromptConferenceDefault>();
            this.SEArtifactLibItems = new HashSet<SEArtifactLibItem>();
            this.SECommunications = new HashSet<SECommunication>();
            this.SENotifications = new HashSet<SENotification>();
            this.SENotifications1 = new HashSet<SENotification>();
            this.SEArtifactBundleRejections = new HashSet<SEArtifactBundleRejection>();
            this.SEUserActivities = new HashSet<SEUserActivity>();
            this.SEUserDistrictSchools = new HashSet<SEUserDistrictSchool>();
            this.SEUserPromptResponses = new HashSet<SEUserPromptResponse>();
            this.SEPracticeSessions = new HashSet<SEPracticeSession>();
            this.SEPracticeSessions1 = new HashSet<SEPracticeSession>();
            this.SEEvalSessions = new HashSet<SEEvalSession>();
            this.SEEvalSessions1 = new HashSet<SEEvalSession>();
            this.SEEvaluations = new HashSet<SEEvaluation>();
            this.SEEvaluations1 = new HashSet<SEEvaluation>();
            this.SERubricRowAnnotations = new HashSet<SERubricRowAnnotation>();
            this.SEArtifactBundles = new HashSet<SEArtifactBundle>();
            this.SERubricRowEvaluations = new HashSet<SERubricRowEvaluation>();
            this.SEUserLocationRoles = new HashSet<SEUserLocationRole>();
            this.SESummativeFrameworkNodeScores = new HashSet<SESummativeFrameworkNodeScore>();
            this.SESummativeRubricRowScores = new HashSet<SESummativeRubricRowScore>();
            this.SEStudentGrowthFormPromptResponses = new HashSet<SEStudentGrowthFormPromptResponse>();
            this.SEFrameworkNodeScores = new HashSet<SEFrameworkNodeScore>();
            this.SERubricRowScores = new HashSet<SERubricRowScore>();
        }
    
        public long SEUserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string SchoolCode { get; set; }
        public string DistrictCode { get; set; }
        public Nullable<System.Guid> ASPNetUserID { get; set; }
        public bool HasMultipleBuildings { get; set; }
        public string Username { get; set; }
        public string loweredUsername { get; set; }
        public string MessageEmailOverride { get; set; }
        public string LoginName { get; set; }
        public string EmailAddressAlternate { get; set; }
        public string CertificateNumber { get; set; }
        public Nullable<System.Guid> MobileAccessKey { get; set; }
        public Nullable<long> EvaluationID { get; set; }
        public string EmailAddress { get; set; }
        public string OTPW { get; set; }
    
        public virtual ICollection<SEEvalAssignmentRequest> SEEvalAssignmentRequests { get; set; }
        public virtual ICollection<SEEvalAssignmentRequest> SEEvalAssignmentRequests1 { get; set; }
        public virtual ICollection<SEEvaluationWfHistory> SEEvaluationWfHistories { get; set; }
        public virtual ICollection<SELearningWalkSessionScore> SELearningWalkSessionScores { get; set; }
        public virtual ICollection<SEPracticeSessionParticipant> SEPracticeSessionParticipants { get; set; }
        public virtual ICollection<SETrainingProtocolPlaylist> SETrainingProtocolPlaylists { get; set; }
        public virtual ICollection<SETrainingProtocolRating> SETrainingProtocolRatings { get; set; }
        public virtual ICollection<SEDistrictPRViewing> SEDistrictPRViewings { get; set; }
        public virtual ICollection<SEReportPrintOptionUser> SEReportPrintOptionUsers { get; set; }
        public virtual ICollection<SEUserPrompt> SEUserPrompts { get; set; }
        public virtual ICollection<SEUserPrompt> SEUserPrompts1 { get; set; }
        public virtual ICollection<SEUserPromptResponseEntry> SEUserPromptResponseEntries { get; set; }
        public virtual ICollection<SEUserPromptConferenceDefault> SEUserPromptConferenceDefaults { get; set; }
        public virtual ICollection<SEArtifactLibItem> SEArtifactLibItems { get; set; }
        public virtual ICollection<SECommunication> SECommunications { get; set; }
        public virtual ICollection<SENotification> SENotifications { get; set; }
        public virtual ICollection<SENotification> SENotifications1 { get; set; }
        public virtual ICollection<SEArtifactBundleRejection> SEArtifactBundleRejections { get; set; }
        public virtual ICollection<SEUserActivity> SEUserActivities { get; set; }
        public virtual ICollection<SEUserDistrictSchool> SEUserDistrictSchools { get; set; }
        public virtual ICollection<SEUserPromptResponse> SEUserPromptResponses { get; set; }
        public virtual ICollection<SEPracticeSession> SEPracticeSessions { get; set; }
        public virtual ICollection<SEPracticeSession> SEPracticeSessions1 { get; set; }
        public virtual aspnet_Users aspnet_Users { get; set; }
        public virtual ICollection<SEEvalSession> SEEvalSessions { get; set; }
        public virtual ICollection<SEEvalSession> SEEvalSessions1 { get; set; }
        public virtual ICollection<SEEvaluation> SEEvaluations { get; set; }
        public virtual ICollection<SEEvaluation> SEEvaluations1 { get; set; }
        public virtual SEEvaluation SEEvaluation { get; set; }
        public virtual ICollection<SERubricRowAnnotation> SERubricRowAnnotations { get; set; }
        public virtual ICollection<SEArtifactBundle> SEArtifactBundles { get; set; }
        public virtual ICollection<SERubricRowEvaluation> SERubricRowEvaluations { get; set; }
        public virtual ICollection<SEUserLocationRole> SEUserLocationRoles { get; set; }
        public virtual ICollection<SESummativeFrameworkNodeScore> SESummativeFrameworkNodeScores { get; set; }
        public virtual ICollection<SESummativeRubricRowScore> SESummativeRubricRowScores { get; set; }
        public virtual ICollection<SEStudentGrowthFormPromptResponse> SEStudentGrowthFormPromptResponses { get; set; }
        public virtual ICollection<SEFrameworkNodeScore> SEFrameworkNodeScores { get; set; }
        public virtual ICollection<SERubricRowScore> SERubricRowScores { get; set; }
    }
}
