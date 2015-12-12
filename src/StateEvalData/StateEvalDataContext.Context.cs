﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class StateEvalEntities : DbContext
    {
        public StateEvalEntities()
            : base("name=StateEvalEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<EmailDeliveryType> EmailDeliveryTypes { get; set; }
        public virtual DbSet<MessageType> MessageTypes { get; set; }
        public virtual DbSet<MessageTypeRecipientConfig> MessageTypeRecipientConfigs { get; set; }
        public virtual DbSet<SEAnchorType> SEAnchorTypes { get; set; }
        public virtual DbSet<SEArtifactLibItemType> SEArtifactLibItemTypes { get; set; }
        public virtual DbSet<SEArtifactType> SEArtifactTypes { get; set; }
        public virtual DbSet<SEDistrictResource> SEDistrictResources { get; set; }
        public virtual DbSet<SEDistrictSchool> SEDistrictSchools { get; set; }
        public virtual DbSet<SEDistrictTrainingProtocolAnchor> SEDistrictTrainingProtocolAnchors { get; set; }
        public virtual DbSet<SEEvalAssignmentRequest> SEEvalAssignmentRequests { get; set; }
        public virtual DbSet<SEEvalAssignmentRequestStatusType> SEEvalAssignmentRequestStatusTypes { get; set; }
        public virtual DbSet<SEEvalAssignmentRequestType> SEEvalAssignmentRequestTypes { get; set; }
        public virtual DbSet<SEEvalSessionLibraryVideo> SEEvalSessionLibraryVideos { get; set; }
        public virtual DbSet<SEEvaluateePlanType> SEEvaluateePlanTypes { get; set; }
        public virtual DbSet<SEEvaluationScoreType> SEEvaluationScoreTypes { get; set; }
        public virtual DbSet<SEEvaluationType> SEEvaluationTypes { get; set; }
        public virtual DbSet<SEEvaluationWfHistory> SEEvaluationWfHistories { get; set; }
        public virtual DbSet<SEFrameworkNode> SEFrameworkNodes { get; set; }
        public virtual DbSet<SEFrameworkViewType> SEFrameworkViewTypes { get; set; }
        public virtual DbSet<SELearningWalkClassRoom> SELearningWalkClassRooms { get; set; }
        public virtual DbSet<SELearningWalkClassroomLabel> SELearningWalkClassroomLabels { get; set; }
        public virtual DbSet<SELearningWalkSessionScore> SELearningWalkSessionScores { get; set; }
        public virtual DbSet<SEPracticeSessionParticipant> SEPracticeSessionParticipants { get; set; }
        public virtual DbSet<SEPracticeSessionType> SEPracticeSessionTypes { get; set; }
        public virtual DbSet<SEPullQuote> SEPullQuotes { get; set; }
        public virtual DbSet<SEReportPrintOption> SEReportPrintOptions { get; set; }
        public virtual DbSet<SEReportPrintOptionEvalSession> SEReportPrintOptionEvalSessions { get; set; }
        public virtual DbSet<SEReportPrintOptionEvaluatee> SEReportPrintOptionEvaluatees { get; set; }
        public virtual DbSet<SEReportPrintOptionEvaluation> SEReportPrintOptionEvaluations { get; set; }
        public virtual DbSet<SEReportPrintOptionType> SEReportPrintOptionTypes { get; set; }
        public virtual DbSet<SEReportSnapshot> SEReportSnapshots { get; set; }
        public virtual DbSet<SEReportType> SEReportTypes { get; set; }
        public virtual DbSet<SEResourceType> SEResourceTypes { get; set; }
        public virtual DbSet<SERubricRowFrameworkNode> SERubricRowFrameworkNodes { get; set; }
        public virtual DbSet<SESchoolConfiguration> SESchoolConfigurations { get; set; }
        public virtual DbSet<SESchoolYear> SESchoolYears { get; set; }
        public virtual DbSet<SETrainingProtocol> SETrainingProtocols { get; set; }
        public virtual DbSet<SETrainingProtocolLabel> SETrainingProtocolLabels { get; set; }
        public virtual DbSet<SETrainingProtocolLabelGroup> SETrainingProtocolLabelGroups { get; set; }
        public virtual DbSet<SETrainingProtocolPlaylist> SETrainingProtocolPlaylists { get; set; }
        public virtual DbSet<SETrainingProtocolRating> SETrainingProtocolRatings { get; set; }
        public virtual DbSet<SETrainingProtocolRatingStatusType> SETrainingProtocolRatingStatusTypes { get; set; }
        public virtual DbSet<SEUserPrompt> SEUserPrompts { get; set; }
        public virtual DbSet<SEUserPromptConferenceDefault> SEUserPromptConferenceDefaults { get; set; }
        public virtual DbSet<SEUserPromptResponseEntry> SEUserPromptResponseEntries { get; set; }
        public virtual DbSet<SEUserPromptType> SEUserPromptTypes { get; set; }
        public virtual DbSet<SEWfTransition> SEWfTransitions { get; set; }
        public virtual DbSet<UpdateLog> UpdateLogs { get; set; }
        public virtual DbSet<EDSStaging> EDSStagings { get; set; }
        public virtual DbSet<LocationRoleClaim> LocationRoleClaims { get; set; }
        public virtual DbSet<MessageTypeRole> MessageTypeRoles { get; set; }
        public virtual DbSet<ProtoFrameworksToLoad> ProtoFrameworksToLoads { get; set; }
        public virtual DbSet<SEDistrictPRViewing> SEDistrictPRViewings { get; set; }
        public virtual DbSet<SEReportPrintOptionUser> SEReportPrintOptionUsers { get; set; }
        public virtual DbSet<SEStudentGrowthProcessSetting> SEStudentGrowthProcessSettings { get; set; }
        public virtual DbSet<SEStudentGrowthProcessSettingsFormPrompt> SEStudentGrowthProcessSettingsFormPrompts { get; set; }
        public virtual DbSet<SEArtifactBundleWfHistory> SEArtifactBundleWfHistories { get; set; }
        public virtual DbSet<SEArtifactLibItem> SEArtifactLibItems { get; set; }
        public virtual DbSet<SEStudentGrowthGoal> SEStudentGrowthGoals { get; set; }
        public virtual DbSet<SEEventType> SEEventTypes { get; set; }
        public virtual DbSet<SEEvent> SEEvents { get; set; }
        public virtual DbSet<EDSError> EDSErrors { get; set; }
        public virtual DbSet<EDSRolesV1> EDSRolesV1 { get; set; }
        public virtual DbSet<EDSUsersV1> EDSUsersV1 { get; set; }
        public virtual DbSet<SEArtifactBundleRejection> SEArtifactBundleRejections { get; set; }
        public virtual DbSet<SEArtifactBundleRejectionType> SEArtifactBundleRejectionTypes { get; set; }
        public virtual DbSet<SECommunication> SECommunications { get; set; }
        public virtual DbSet<SEResourceItemType> SEResourceItemTypes { get; set; }
        public virtual DbSet<SEResource> SEResources { get; set; }
        public virtual DbSet<SENotification> SENotifications { get; set; }
        public virtual DbSet<SEUserActivity> SEUserActivities { get; set; }
        public virtual DbSet<SERubricPerformanceLevel> SERubricPerformanceLevels { get; set; }
        public virtual DbSet<SEUserPromptResponse> SEUserPromptResponses { get; set; }
        public virtual DbSet<SEPracticeSession> SEPracticeSessions { get; set; }
        public virtual DbSet<SEWfState> SEWfStates { get; set; }
        public virtual DbSet<SEFrameworkPerformanceLevel> SEFrameworkPerformanceLevels { get; set; }
        public virtual DbSet<ProtoFrameworkContextsToLoad> ProtoFrameworkContextsToLoads { get; set; }
        public virtual DbSet<SEDistrictConfiguration> SEDistrictConfigurations { get; set; }
        public virtual DbSet<SEFrameworkContext> SEFrameworkContexts { get; set; }
        public virtual DbSet<SEFramework> SEFrameworks { get; set; }
        public virtual DbSet<vPrototypeFrameworkContext> vPrototypeFrameworkContexts { get; set; }
        public virtual DbSet<ELMAH_Error> ELMAH_Error { get; set; }
        public virtual DbSet<SERubricRow> SERubricRows { get; set; }
        public virtual DbSet<SEStudentGrowthGoalBundle> SEStudentGrowthGoalBundles { get; set; }
        public virtual DbSet<aspnet_Roles> aspnet_Roles { get; set; }
        public virtual DbSet<aspnet_Users> aspnet_Users { get; set; }
        public virtual DbSet<RefreshToken> RefreshTokens { get; set; }
        public virtual DbSet<ClientApp> ClientApps { get; set; }
        public virtual DbSet<SEEvaluation> SEEvaluations { get; set; }
        public virtual DbSet<SERubricRowAnnotation> SERubricRowAnnotations { get; set; }
        public virtual DbSet<SEArtifactBundle> SEArtifactBundles { get; set; }
        public virtual DbSet<EventTypeEmailRecipientConfig> EventTypeEmailRecipientConfigs { get; set; }
        public virtual DbSet<SEUserLocationRole> SEUserLocationRoles { get; set; }
        public virtual DbSet<SESummativeFrameworkNodeScore> SESummativeFrameworkNodeScores { get; set; }
        public virtual DbSet<SESummativeRubricRowScore> SESummativeRubricRowScores { get; set; }
        public virtual DbSet<SEEvidenceCollectionType> SEEvidenceCollectionTypes { get; set; }
        public virtual DbSet<SEEvidenceType> SEEvidenceTypes { get; set; }
        public virtual DbSet<SEStudentGrowthFormPromptResponse> SEStudentGrowthFormPromptResponses { get; set; }
        public virtual DbSet<SEStudentGrowthFormPromptFrameworkNode> SEStudentGrowthFormPromptFrameworkNodes { get; set; }
        public virtual DbSet<SEStudentGrowthFormPromptType> SEStudentGrowthFormPromptTypes { get; set; }
        public virtual DbSet<SEStudentGrowthFormPrompt> SEStudentGrowthFormPrompts { get; set; }
        public virtual DbSet<SEFrameworkNodeScore> SEFrameworkNodeScores { get; set; }
        public virtual DbSet<SERubricRowScore> SERubricRowScores { get; set; }
        public virtual DbSet<SEEvalSession> SEEvalSessions { get; set; }
        public virtual DbSet<SELinkedItemType> SELinkedItemTypes { get; set; }
        public virtual DbSet<SERubricRowEvaluation> SERubricRowEvaluations { get; set; }
        public virtual DbSet<SEAlignedEvidence> SEAlignedEvidences { get; set; }
        public virtual DbSet<SEAvailableEvidence> SEAvailableEvidences { get; set; }
        public virtual DbSet<SEUser> SEUsers { get; set; }
        public virtual DbSet<vUserOrientation> vUserOrientations { get; set; }
        public virtual DbSet<SESelfAssessment> SESelfAssessments { get; set; }
        public virtual DbSet<SETrainingProtocolCriteria> SETrainingProtocolCriterias { get; set; }
        public virtual DbSet<SETrainingProtocolHighLeveragePractice> SETrainingProtocolHighLeveragePractices { get; set; }
    }
}
