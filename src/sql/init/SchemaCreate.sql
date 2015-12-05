IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] DROP CONSTRAINT [FK_SEWfTransition_SEWfState2]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] DROP CONSTRAINT [FK_SEWfTransition_SEWfState1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_UserPromptID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]'))
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] DROP CONSTRAINT [fk_UserPromptID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]'))
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] DROP CONSTRAINT [fk_RubricRowID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponseEntry_SEUserPromptResponse]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]'))
ALTER TABLE [dbo].[SEUserPromptResponseEntry] DROP CONSTRAINT [FK_SEUserPromptResponseEntry_SEUserPromptResponse]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponseEntry_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]'))
ALTER TABLE [dbo].[SEUserPromptResponseEntry] DROP CONSTRAINT [FK_SEUserPromptResponseEntry_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SEUserPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] DROP CONSTRAINT [FK_SEUserPromptResponse_SEUserPrompt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] DROP CONSTRAINT [FK_SEUserPromptResponse_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] DROP CONSTRAINT [FK_SEUserPromptResponse_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_EvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] DROP CONSTRAINT [FK_SEUserPromptResponse_EvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUserPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] DROP CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPromptType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUserPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] DROP CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPrompt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] DROP CONSTRAINT [FKSEUserPromptConferenceDefault_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [FK_SEUserPrompt_SEWfState]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEUserPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [FK_SEUserPrompt_SEUserPromptType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [FK_SEUserPrompt_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [FK_SEUserPrompt_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [FK_SEUserPrompt_SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [FK_SEUserPrompt_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [FK_SEUserPrompt_CreatedByUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserLocationRole_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]'))
ALTER TABLE [dbo].[SEUserLocationRole] DROP CONSTRAINT [FK_SEUserLocationRole_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserLocationRole_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]'))
ALTER TABLE [dbo].[SEUserLocationRole] DROP CONSTRAINT [FK_SEUserLocationRole_aspnet_Roles]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserDistrictSchool_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserDistrictSchool]'))
ALTER TABLE [dbo].[SEUserDistrictSchool] DROP CONSTRAINT [FK_SEUserDistrictSchool_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserActivity_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserActivity]'))
ALTER TABLE [dbo].[SEUserActivity] DROP CONSTRAINT [FK_UserActivity_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUser_aspnet_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUser]'))
ALTER TABLE [dbo].[SEUser] DROP CONSTRAINT [FK_SEUser_aspnet_Users]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolRating_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]'))
ALTER TABLE [dbo].[SETrainingProtocolRating] DROP CONSTRAINT [FK_SETrainingProtocolRating_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolRating_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]'))
ALTER TABLE [dbo].[SETrainingProtocolRating] DROP CONSTRAINT [FK_SETrainingProtocolRating_SETrainingProtocol]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolPlaylist_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]'))
ALTER TABLE [dbo].[SETrainingProtocolPlaylist] DROP CONSTRAINT [FK_SETrainingProtocolPlaylist_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolPlaylist_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]'))
ALTER TABLE [dbo].[SETrainingProtocolPlaylist] DROP CONSTRAINT [FK_SETrainingProtocolPlaylist_SETrainingProtocol]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]'))
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] DROP CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabelAssignment_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]'))
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] DROP CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocol]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabel]'))
ALTER TABLE [dbo].[SETrainingProtocolLabel] DROP CONSTRAINT [FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocol_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]'))
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] DROP CONSTRAINT [FK_SETrainingProtocol_SETrainingProtocol]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocol_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]'))
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] DROP CONSTRAINT [FK_SETrainingProtocol_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] DROP CONSTRAINT [FK_SESummativeRubricRowScore_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] DROP CONSTRAINT [FK_SESummativeRubricRowScore_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] DROP CONSTRAINT [FK_SESummativeRubricRowScore_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] DROP CONSTRAINT [FK_SESummativeRubricRowScore_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] DROP CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] DROP CONSTRAINT [FK_SESummativeFrameworkNodeScore_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] DROP CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] DROP CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_Settings]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt] DROP CONSTRAINT [FK_SEStudentGrowthProcessSettings_Settings]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_FormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt] DROP CONSTRAINT [FK_SEStudentGrowthProcessSettings_FormPrompt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettings] DROP CONSTRAINT [FK_SEStudentGrowthProcessSettings_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettings] DROP CONSTRAINT [FK_SEStudentGrowthProcessSettings_SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleRubricRowAlignment_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment] DROP CONSTRAINT [FK_SEStudentGrowthGoalBundleRubricRowAlignment_SEStudentGrowthGoalBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleRubricRowAlignment_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment] DROP CONSTRAINT [FK_SEStudentGrowthGoalBundleRubricRowAlignment_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundle_SEWfState1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] DROP CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundle_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] DROP CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricRowResults]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowResults]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricRowProcess]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowProcess]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricPerformanceLevel1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [FK_SEStudentGrowthGoal_SEArtifactBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptResponse_SEStudentGrowthFormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] DROP CONSTRAINT [FK_SEStudentGrowthFormPromptResponse_SEStudentGrowthFormPrompt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFormPromptResponse_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] DROP CONSTRAINT [FK_SEFormPromptResponse_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFormPromptResponse_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] DROP CONSTRAINT [FK_SEFormPromptResponse_SEStudentGrowthGoal]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEStudentGrowthFormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] DROP CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEStudentGrowthFormPrompt]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] DROP CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] DROP CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] DROP CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPrompt_SEStudentGrowthFormPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPrompt] DROP CONSTRAINT [FK_SEStudentGrowthFormPrompt_SEStudentGrowthFormPromptType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessmentRubricRowFocus_SESelfAssessment]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]'))
ALTER TABLE [dbo].[SESelfAssessmentRubricRowFocus] DROP CONSTRAINT [FK_SESelfAssessmentRubricRowFocus_SESelfAssessment]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessmentRubricRowFocus_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]'))
ALTER TABLE [dbo].[SESelfAssessmentRubricRowFocus] DROP CONSTRAINT [FK_SESelfAssessmentRubricRowFocus_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment] DROP CONSTRAINT [FK_SESelfAssessment_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment] DROP CONSTRAINT [FK_SESelfAssessment_SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment] DROP CONSTRAINT [FK_SESelfAssessment_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] DROP CONSTRAINT [FK_SERubricRowScore_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] DROP CONSTRAINT [FK_SERubricRowScore_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] DROP CONSTRAINT [FK_SERubricRowScore_SELinkedItemType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] DROP CONSTRAINT [FK_SERubricRowScore_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_LearningWalkClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] DROP CONSTRAINT [FK_SERubricRowScore_LearningWalkClassroomID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode] DROP CONSTRAINT [FK_SERubricRowFrameworkNode_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode] DROP CONSTRAINT [FK_SERubricRowFrameworkNode_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SEStudentGrowthGoalBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SELinkedItemType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvidenceCollectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SEEvidenceCollectionType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvalSession1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] DROP CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT [FK_SERubricRowAnnotation_SEUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT [FK_SERubricRowAnnotation_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT [FK_SERubricRowAnnotation_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] DROP CONSTRAINT [FK_SERubricRowAnnotation_SEArtifactBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResourceRubricRowAlignment_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]'))
ALTER TABLE [dbo].[SEResourceRubricRowAlignment] DROP CONSTRAINT [FK_SEResourceRubricRowAlignment_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResourceRubricRowAlignment_SEResource]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]'))
ALTER TABLE [dbo].[SEResourceRubricRowAlignment] DROP CONSTRAINT [FK_SEResourceRubricRowAlignment_SEResource]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResource_ItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResource]'))
ALTER TABLE [dbo].[SEResource] DROP CONSTRAINT [FK_SEResource_ItemType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportSnapshot_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]'))
ALTER TABLE [dbo].[SEReportSnapshot] DROP CONSTRAINT [FK_SEReportSnapshot_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportSnapshot_SEReportType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]'))
ALTER TABLE [dbo].[SEReportSnapshot] DROP CONSTRAINT [FK_SEReportSnapshot_SEReportType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionUser_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionUser]'))
ALTER TABLE [dbo].[SEReportPrintOptionUser] DROP CONSTRAINT [FK_SEReportPrintOptionUser_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluation_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluation] DROP CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEReportPrintOption]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluation_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluation] DROP CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluatee_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee] DROP CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluatee_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee] DROP CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SEReportPrintOption]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvalSession_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvalSession] DROP CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEReportPrintOption]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvalSession_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvalSession] DROP CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOption_SEReportPrintOptionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOption]'))
ALTER TABLE [dbo].[SEReportPrintOption] DROP CONSTRAINT [FK_SEReportPrintOption_SEReportPrintOptionType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPullQuote_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPullQuote]'))
ALTER TABLE [dbo].[SEPullQuote] DROP CONSTRAINT [FK_SEPullQuote_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPullQuote_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPullQuote]'))
ALTER TABLE [dbo].[SEPullQuote] DROP CONSTRAINT [FK_SEPullQuote_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant] DROP CONSTRAINT [FK_SEPracticeSessionParticipant_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant] DROP CONSTRAINT [FK_SEPracticeSessionParticipant_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_PracticeSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant] DROP CONSTRAINT [FK_SEPracticeSessionParticipant_PracticeSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_TrainingProtocolID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] DROP CONSTRAINT [FK_SEPracticeSession_TrainingProtocolID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_SchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] DROP CONSTRAINT [FK_SEPracticeSession_SchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_PracticeSessionTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] DROP CONSTRAINT [FK_SEPracticeSession_PracticeSessionTypeID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_EvaluateeUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] DROP CONSTRAINT [FK_SEPracticeSession_EvaluateeUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] DROP CONSTRAINT [FK_SEPracticeSession_CreatedByUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_AnchorSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] DROP CONSTRAINT [FK_SEPracticeSession_AnchorSessionID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification] DROP CONSTRAINT [FK_SENotification_SEUser1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification] DROP CONSTRAINT [FK_SENotification_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEEvent]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification] DROP CONSTRAINT [FK_SENotification_SEEvent]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] DROP CONSTRAINT [FK_SEUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] DROP CONSTRAINT [FK_SessionID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PerformanceLevelID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] DROP CONSTRAINT [FK_PerformanceLevelID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] DROP CONSTRAINT [FK_ClassroomID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship] DROP CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship] DROP CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabel_SEPracticeSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabel]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabel] DROP CONSTRAINT [FK_SELearningWalkClassroomLabel_SEPracticeSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassRoom_PracticeSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassRoom]'))
ALTER TABLE [dbo].[SELearningWalkClassRoom] DROP CONSTRAINT [FK_SELearningWalkClassRoom_PracticeSessionID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkPerformanceLevel_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]'))
ALTER TABLE [dbo].[SEFrameworkPerformanceLevel] DROP CONSTRAINT [FK_SEFrameworkPerformanceLevel_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkPerformanceLevel_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]'))
ALTER TABLE [dbo].[SEFrameworkPerformanceLevel] DROP CONSTRAINT [FK_SEFrameworkPerformanceLevel_SEFramework]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] DROP CONSTRAINT [FK_SEFrameworkNodeScore_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] DROP CONSTRAINT [FK_SEFrameworkNodeScore_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] DROP CONSTRAINT [FK_SEFrameworkNodeScore_SELinkedItemType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] DROP CONSTRAINT [FK_SEFrameworkNodeScore_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] DROP CONSTRAINT [FK_SEFrameworkNodeScore_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_LearningWalkClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] DROP CONSTRAINT [FK_SEFrameworkNodeScore_LearningWalkClassroomID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode] DROP CONSTRAINT [FK_SEFrameworkNode_SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode] DROP CONSTRAINT [FK_SEFrameworkNode_SEFramework]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFramework_SEFrameworkContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFramework]'))
ALTER TABLE [dbo].[SEFramework] DROP CONSTRAINT [FK_SEFramework_SEFrameworkContext]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvent_SEEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvent]'))
ALTER TABLE [dbo].[SEEvent] DROP CONSTRAINT [FK_SEEvent_SEEventType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEWfTransition]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory] DROP CONSTRAINT [FK_SEEvaluationWfHistory_SEWfTransition]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory] DROP CONSTRAINT [FK_SEEvaluationWfHistory_SEUser1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory] DROP CONSTRAINT [FK_SEEvaluationWfHistory_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationTypeRole_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]'))
ALTER TABLE [dbo].[SEEvaluationTypeRole] DROP CONSTRAINT [FK_SEEvaluationTypeRole_SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationTypeRole_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]'))
ALTER TABLE [dbo].[SEEvaluationTypeRole] DROP CONSTRAINT [FK_SEEvaluationTypeRole_aspnet_Roles]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SGFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SGFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEWfState]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEUser1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEFrameworkNode4]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEFrameworkNode4]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEFrameworkNode3]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEFrameworkNode3]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluateePlanType2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType2]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluateePlanType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_FocusFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] DROP CONSTRAINT [FK_SEEvaluation_FocusFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluateeRoleEvaluationType_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]'))
ALTER TABLE [dbo].[SEEvaluateeRoleEvaluationType] DROP CONSTRAINT [FK_SEEvaluateeRoleEvaluationType_SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluateeRoleEvaluationType_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]'))
ALTER TABLE [dbo].[SEEvaluateeRoleEvaluationType] DROP CONSTRAINT [FK_SEEvaluateeRoleEvaluationType_aspnet_Roles]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_SEEvalSessionRubricRowFocus_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]'))
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] DROP CONSTRAINT [fk_SEEvalSessionRubricRowFocus_RubricRowID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_SEEvalSessionRubricRowFocus_EvalSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]'))
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] DROP CONSTRAINT [fk_SEEvalSessionRubricRowFocus_EvalSessionID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SGFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SGFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SEWfState]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SEUser1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SETrainingProtocol]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEEvaluationScoreType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SEEvaluationScoreType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEAnchorType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_SEAnchorType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_FocusFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [FK_SEEvalSession_FocusFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] DROP CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] DROP CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] DROP CONSTRAINT [FK_SEEvalAssignmentRequest_SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] DROP CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] DROP CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]'))
ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor] DROP CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictTrainingProtocolAnchor_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]'))
ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor] DROP CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDAPRViewing_SchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]'))
ALTER TABLE [dbo].[SEDistrictPRViewing] DROP CONSTRAINT [FK_SEDAPRViewing_SchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDAPRViewing_DAUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]'))
ALTER TABLE [dbo].[SEDistrictPRViewing] DROP CONSTRAINT [FK_SEDAPRViewing_DAUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictConfiguration_SEFrameworkContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictConfiguration]'))
ALTER TABLE [dbo].[SEDistrictConfiguration] DROP CONSTRAINT [FK_SEDistrictConfiguration_SEFrameworkContext]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SECommunication_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SECommunication]'))
ALTER TABLE [dbo].[SECommunication] DROP CONSTRAINT [FK_SECommunication_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] DROP CONSTRAINT [FK_SEAvailableEvidence_SEStudentGrowthGoal]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SERubricRowAnnotation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] DROP CONSTRAINT [FK_SEAvailableEvidence_SERubricRowAnnotation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] DROP CONSTRAINT [FK_SEAvailableEvidence_SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvidenceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] DROP CONSTRAINT [FK_SEAvailableEvidence_SEEvidenceType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvaluation1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] DROP CONSTRAINT [FK_SEAvailableEvidence_SEEvaluation1]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] DROP CONSTRAINT [FK_SEAvailableEvidence_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] DROP CONSTRAINT [FK_SEAvailableEvidence_SEArtifactBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactLibItem_ItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactLibItem] DROP CONSTRAINT [FK_SEArtifactLibItem_ItemType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactLibItem_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactLibItem] DROP CONSTRAINT [FK_SEArtifactLibItem_CreatedByUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleWfHistory_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleWfHistory]'))
ALTER TABLE [dbo].[SEArtifactBundleWfHistory] DROP CONSTRAINT [FK_SEArtifactBundleWfHistory_ArtifactBundleID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleStudentGrowthGoalBundle_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle] DROP CONSTRAINT [FK_SEArtifactBundleStudentGrowthGoalBundle_SEStudentGrowthGoalBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleStudentGrowthGoalBundle_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle] DROP CONSTRAINT [FK_SEArtifactBundleStudentGrowthGoalBundle_SEArtifactBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRubricRowAlignment_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment] DROP CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_RubricRowID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment] DROP CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection] DROP CONSTRAINT [FK_SEArtifactBundleRejection_SEUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection] DROP CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection] DROP CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleEvalSession_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]'))
ALTER TABLE [dbo].[SEArtifactBundleEvalSession] DROP CONSTRAINT [FK_SEArtifactBundleEvalSession_SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleEvalSession_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]'))
ALTER TABLE [dbo].[SEArtifactBundleEvalSession] DROP CONSTRAINT [FK_SEArtifactBundleEvalSession_SEArtifactBundle]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem] DROP CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem] DROP CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [FK_SEArtifactBundle_SEWfState]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [FK_SEArtifactBundle_SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEArtifactBundleRejectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [FK_SEArtifactBundle_SEArtifactBundleRejectionType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [FK_SEArtifactBundle_CreatedByUserID]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SERubricRowEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence] DROP CONSTRAINT [FK_SEAlignedEvidence_SERubricRowEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SEEvidenceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence] DROP CONSTRAINT [FK_SEAlignedEvidence_SEEvidenceType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SEAvailableEvidence]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence] DROP CONSTRAINT [FK_SEAlignedEvidence_SEAvailableEvidence]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefreshToken_ClientApp]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefreshToken]'))
ALTER TABLE [dbo].[RefreshToken] DROP CONSTRAINT [FK_RefreshToken_ClientApp]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MessageTypeRecipientConfig_MessageType]') AND parent_object_id = OBJECT_ID(N'[dbo].[MessageTypeRecipientConfig]'))
ALTER TABLE [dbo].[MessageTypeRecipientConfig] DROP CONSTRAINT [FK_MessageTypeRecipientConfig_MessageType]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EventTypeEmailRecipientConfig_SEEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[EventTypeEmailRecipientConfig]'))
ALTER TABLE [dbo].[EventTypeEmailRecipientConfig] DROP CONSTRAINT [FK_EventTypeEmailRecipientConfig_SEEventType]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Sequence]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [DF_SEUserPrompt_Sequence]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_CreatedAsAdmin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [DF_SEUserPrompt_CreatedAsAdmin]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Private]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [DF_SEUserPrompt_Private]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Retired]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [DF_SEUserPrompt_Retired]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Published]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] DROP CONSTRAINT [DF_SEUserPrompt_Published]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SETrainin__Seque__74444068]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocolLabel] DROP CONSTRAINT [DF__SETrainin__Seque__74444068]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Retired]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] DROP CONSTRAINT [DF_SETrainingProtocol_Retired]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Published]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] DROP CONSTRAINT [DF_SETrainingProtocol_Published]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Description]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] DROP CONSTRAINT [DF_SETrainingProtocol_Description]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Summary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] DROP CONSTRAINT [DF_SETrainingProtocol_Summary]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Title]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] DROP CONSTRAINT [DF_SETrainingProtocol_Title]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SESummati__State__61316BF4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] DROP CONSTRAINT [DF__SESummati__State__61316BF4]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoalBundle_Grade]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] DROP CONSTRAINT [DF_SEStudentGrowthGoalBundle_Grade]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoalBundle_Course]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] DROP CONSTRAINT [DF_SEStudentGrowthGoalBundle_Course]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoalBundle_Title]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] DROP CONSTRAINT [DF_SEStudentGrowthGoalBundle_Title]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_EvidenceMost_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [DF_SEStudentGrowthGoal_EvidenceMost_1]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_EvidenceMost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [DF_SEStudentGrowthGoal_EvidenceMost]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_GoalTargets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [DF_SEStudentGrowthGoal_GoalTargets]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_GoalStatement]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] DROP CONSTRAINT [DF_SEStudentGrowthGoal_GoalStatement]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEFormPromptResponse_Response]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] DROP CONSTRAINT [DF_SEFormPromptResponse_Response]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__Inclu__5B78929E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__Inclu__5B78929E]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__IsFoc__5A846E65]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__IsFoc__5A846E65]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEEvalSession_IsSelfAssess]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF_SEEvalSession_IsSelfAssess]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PostC__57A801BA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__PostC__57A801BA]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PostC__56B3DD81]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__PostC__56B3DD81]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__Obser__55BFB948]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__Obser__55BFB948]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__Obser__54CB950F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__Obser__54CB950F]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PreCo__53D770D6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__PreCo__53D770D6]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PreCo__52E34C9D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF__SEEvalSes__PreCo__52E34C9D]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEEvalSession_EvaluationScoreTypeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] DROP CONSTRAINT [DF_SEEvalSession_EvaluationScoreTypeID]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Comme__5C6CB6D7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundleWfHistory] DROP CONSTRAINT [DF__SEArtifac__Comme__5C6CB6D7]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__WfSta__55BFB948]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [DF__SEArtifac__WfSta__55BFB948]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Evide__54CB950F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [DF__SEArtifac__Evide__54CB950F]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Conte__53D770D6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [DF__SEArtifac__Conte__53D770D6]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Title__52E34C9D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] DROP CONSTRAINT [DF__SEArtifac__Title__52E34C9D]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__MessageTy__Email__57A801BA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MessageTypeRecipientConfig] DROP CONSTRAINT [DF__MessageTy__Email__57A801BA]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__MessageTy__Inbox__56B3DD81]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MessageTypeRecipientConfig] DROP CONSTRAINT [DF__MessageTy__Inbox__56B3DD81]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ELMAH_Error_ErrorId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ELMAH_Error] DROP CONSTRAINT [DF_ELMAH_Error_ErrorId]
END

GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateLog]') AND type in (N'U'))
DROP TABLE [dbo].[UpdateLog]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEWfTransition]') AND type in (N'U'))
DROP TABLE [dbo].[SEWfTransition]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEWfState]') AND type in (N'U'))
DROP TABLE [dbo].[SEWfState]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptType]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserPromptType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserPromptRubricRowAlignment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserPromptResponseEntry]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserPromptResponse]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserPromptConferenceDefault]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserPrompt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserLocationRole]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserDistrictSchool]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserDistrictSchool]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserActivity]') AND type in (N'U'))
DROP TABLE [dbo].[SEUserActivity]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUser]') AND type in (N'U'))
DROP TABLE [dbo].[SEUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRatingStatusType]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocolRatingStatusType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocolRating]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocolPlaylist]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelGroup]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocolLabelGroup]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocolLabelAssignment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabel]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocolLabel]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocol]') AND type in (N'U'))
DROP TABLE [dbo].[SETrainingProtocol]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]') AND type in (N'U'))
DROP TABLE [dbo].[SESummativeRubricRowScore]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]') AND type in (N'U'))
DROP TABLE [dbo].[SESummativeFrameworkNodeScore]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthProcessSettings]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthGoalBundleGoal]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthGoalBundle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthGoal]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptType]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthFormPromptType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthFormPromptResponse]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPrompt]') AND type in (N'U'))
DROP TABLE [dbo].[SEStudentGrowthFormPrompt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]') AND type in (N'U'))
DROP TABLE [dbo].[SESelfAssessmentRubricRowFocus]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]') AND type in (N'U'))
DROP TABLE [dbo].[SESelfAssessment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESchoolYear]') AND type in (N'U'))
DROP TABLE [dbo].[SESchoolYear]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESchoolConfiguration]') AND type in (N'U'))
DROP TABLE [dbo].[SESchoolConfiguration]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricRowScore]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricRowFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricRowEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricRowAnnotation]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRow]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricRow]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricPerformanceLevel]') AND type in (N'U'))
DROP TABLE [dbo].[SERubricPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResourceType]') AND type in (N'U'))
DROP TABLE [dbo].[SEResourceType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]') AND type in (N'U'))
DROP TABLE [dbo].[SEResourceRubricRowAlignment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResourceItemType]') AND type in (N'U'))
DROP TABLE [dbo].[SEResourceItemType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResource]') AND type in (N'U'))
DROP TABLE [dbo].[SEResource]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportType]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportSnapshot]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionUser]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportPrintOptionUser]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionType]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportPrintOptionType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportPrintOptionEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportPrintOptionEvaluatee]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportPrintOptionEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOption]') AND type in (N'U'))
DROP TABLE [dbo].[SEReportPrintOption]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPullQuote]') AND type in (N'U'))
DROP TABLE [dbo].[SEPullQuote]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionType]') AND type in (N'U'))
DROP TABLE [dbo].[SEPracticeSessionType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]') AND type in (N'U'))
DROP TABLE [dbo].[SEPracticeSessionParticipant]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]') AND type in (N'U'))
DROP TABLE [dbo].[SEPracticeSession]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SENotification]') AND type in (N'U'))
DROP TABLE [dbo].[SENotification]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELinkedItemType]') AND type in (N'U'))
DROP TABLE [dbo].[SELinkedItemType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]') AND type in (N'U'))
DROP TABLE [dbo].[SELearningWalkSessionScore]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]') AND type in (N'U'))
DROP TABLE [dbo].[SELearningWalkClassroomLabelRelationship]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabel]') AND type in (N'U'))
DROP TABLE [dbo].[SELearningWalkClassroomLabel]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassRoom]') AND type in (N'U'))
DROP TABLE [dbo].[SELearningWalkClassRoom]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkViewType]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkViewType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkPerformanceLevel]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkNodeScore]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkNode]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkContext]') AND type in (N'U'))
DROP TABLE [dbo].[SEFrameworkContext]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFramework]') AND type in (N'U'))
DROP TABLE [dbo].[SEFramework]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvidenceType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvidenceType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvidenceCollectionType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvidenceCollectionType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEventType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEventType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvent]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvent]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluationWfHistory]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluationTypeRole]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationScoreType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluationScoreType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluation]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluation]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluateeRoleEvaluationType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluateePlanType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvaluateePlanType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvalSessionRubricRowFocus]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalSessionLibraryVideo]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvalSessionLibraryVideo]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalSession]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequestType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvalAssignmentRequestType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequestStatusType]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvalAssignmentRequestStatusType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]') AND type in (N'U'))
DROP TABLE [dbo].[SEEvalAssignmentRequest]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]') AND type in (N'U'))
DROP TABLE [dbo].[SEDistrictTrainingProtocolAnchor]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictSchool]') AND type in (N'U'))
DROP TABLE [dbo].[SEDistrictSchool]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictResource]') AND type in (N'U'))
DROP TABLE [dbo].[SEDistrictResource]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]') AND type in (N'U'))
DROP TABLE [dbo].[SEDistrictPRViewing]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictConfiguration]') AND type in (N'U'))
DROP TABLE [dbo].[SEDistrictConfiguration]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SECommunication]') AND type in (N'U'))
DROP TABLE [dbo].[SECommunication]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]') AND type in (N'U'))
DROP TABLE [dbo].[SEAvailableEvidence]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactType]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItemType]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactLibItemType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactLibItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleWfHistory]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundleWfHistory]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundleRubricRowAlignment]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejectionType]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundleRejectionType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundleRejection]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundleEvalSession]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundleArtifactLibItem]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]') AND type in (N'U'))
DROP TABLE [dbo].[SEArtifactBundle]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEAnchorType]') AND type in (N'U'))
DROP TABLE [dbo].[SEAnchorType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]') AND type in (N'U'))
DROP TABLE [dbo].[SEAlignedEvidence]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefreshToken]') AND type in (N'U'))
DROP TABLE [dbo].[RefreshToken]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') AND type in (N'U'))
DROP TABLE [dbo].[ProtoFrameworksToLoad]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworkContextsToLoad]') AND type in (N'U'))
DROP TABLE [dbo].[ProtoFrameworkContextsToLoad]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageTypeRole]') AND type in (N'U'))
DROP TABLE [dbo].[MessageTypeRole]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageTypeRecipientConfig]') AND type in (N'U'))
DROP TABLE [dbo].[MessageTypeRecipientConfig]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageType]') AND type in (N'U'))
DROP TABLE [dbo].[MessageType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationRoleClaim]') AND type in (N'U'))
DROP TABLE [dbo].[LocationRoleClaim]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EventTypeEmailRecipientConfig]') AND type in (N'U'))
DROP TABLE [dbo].[EventTypeEmailRecipientConfig]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailDeliveryType]') AND type in (N'U'))
DROP TABLE [dbo].[EmailDeliveryType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ELMAH_Error]') AND type in (N'U'))
DROP TABLE [dbo].[ELMAH_Error]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSUsersV1]') AND type in (N'U'))
DROP TABLE [dbo].[EDSUsersV1]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eDsUsers]') AND type in (N'U'))
DROP TABLE [dbo].[eDsUsers]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSStaging]') AND type in (N'U'))
DROP TABLE [dbo].[EDSStaging]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSRolesV1]') AND type in (N'U'))
DROP TABLE [dbo].[EDSRolesV1]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eDsroles]') AND type in (N'U'))
DROP TABLE [dbo].[eDsroles]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSError]') AND type in (N'U'))
DROP TABLE [dbo].[EDSError]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientApp]') AND type in (N'U'))
DROP TABLE [dbo].[ClientApp]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientApp]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ClientApp](
	[ClientAppId] [nvarchar](50) NOT NULL,
	[Secret] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ClientAppType] [smallint] NULL,
	[IsActive] [bit] NULL,
	[RefreshTokenLifeTime] [bigint] NULL,
	[AllowedOrigin] [nvarchar](100) NULL,
 CONSTRAINT [PK_ClientApp] PRIMARY KEY CLUSTERED 
(
	[ClientAppId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSError]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EDSError](
	[stagingId] [bigint] NULL,
	[personID] [bigint] NULL,
	[locationCode] [varchar](20) NULL,
	[locationName] [varchar](200) NULL,
	[roleString] [varchar](max) NULL,
	[rawRoleString] [varchar](max) NULL,
	[districtCode] [varchar](10) NULL,
	[schoolCode] [varchar](10) NULL,
	[seEvaluationTypeID] [smallint] NULL,
	[cAspnetUsers] [varchar](200) NULL,
	[cAspnetUIR] [varchar](200) NULL,
	[cInsertEval] [varchar](200) NULL,
	[isNew] [bit] NULL,
	[firstEntry] [bit] NULL,
	[errorMsg] [varchar](200) NULL,
	[PrevousPersonId] [varchar](4000) NULL,
	[EDSErrorID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_EDSError] PRIMARY KEY CLUSTERED 
(
	[EDSErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eDsroles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[eDsroles](
	[PersonId] [bigint] NULL,
	[OrganizationName] [varchar](200) NULL,
	[OSPILegacyCode] [varchar](20) NULL,
	[OrganizationRoleName] [varchar](6000) NULL,
	[OSPIDistrictCode] [varchar](10) NULL,
	[DistrictName] [varchar](200) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSRolesV1]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EDSRolesV1](
	[PersonId] [bigint] NULL,
	[OrganizationName] [varchar](200) NULL,
	[OSPILegacyCode] [varchar](20) NULL,
	[OrganizationRoleName] [varchar](4000) NULL,
	[EDSRolesID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_EDSRolesV1] PRIMARY KEY CLUSTERED 
(
	[EDSRolesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSStaging]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EDSStaging](
	[stagingId] [bigint] IDENTITY(1,1) NOT NULL,
	[personID] [bigint] NULL,
	[locationCode] [varchar](20) NULL,
	[locationName] [varchar](200) NULL,
	[roleString] [varchar](max) NULL,
	[rawRoleString] [varchar](max) NULL,
	[districtCode] [varchar](10) NULL,
	[schoolCode] [varchar](10) NULL,
	[seEvaluationTypeID] [smallint] NULL,
	[cAspnetUsers] [varchar](200) NULL,
	[cAspnetUIR] [varchar](200) NULL,
	[cInsertEval] [varchar](200) NULL,
	[isNew] [bit] NULL,
	[firstEntry] [bit] NULL,
	[PrevousPersonId] [varchar](4000) NULL,
 CONSTRAINT [PK_EDSStaging] PRIMARY KEY CLUSTERED 
(
	[stagingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eDsUsers]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[eDsUsers](
	[PersonId] [bigint] NULL,
	[FirstName] [varchar](200) NULL,
	[LastName] [varchar](200) NULL,
	[Email] [varchar](6000) NULL,
	[PrevousPersonId] [varchar](4000) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDSUsersV1]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EDSUsersV1](
	[PersonId] [bigint] NULL,
	[FirstName] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[Email] [varchar](4000) NULL,
	[PreviousPersonId] [varchar](4000) NULL,
	[LoginName] [varchar](256) NULL,
	[EmailAddressAlternate] [varchar](256) NULL,
	[CertificateNumber] [varchar](20) NULL,
	[EDSUsersID] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_EDSUsersV1] PRIMARY KEY CLUSTERED 
(
	[EDSUsersID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ELMAH_Error]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ELMAH_Error](
	[ErrorId] [uniqueidentifier] NOT NULL,
	[Application] [nvarchar](60) NOT NULL,
	[Host] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](100) NOT NULL,
	[Source] [nvarchar](60) NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[User] [nvarchar](50) NOT NULL,
	[StatusCode] [int] NOT NULL,
	[TimeUtc] [datetime] NOT NULL,
	[Sequence] [int] IDENTITY(1,1) NOT NULL,
	[AllXml] [ntext] NOT NULL,
 CONSTRAINT [PK_ELMAH_Error] PRIMARY KEY NONCLUSTERED 
(
	[ErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EmailDeliveryType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EmailDeliveryType](
	[EmailDeliveryTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EmailDeliveryType] PRIMARY KEY CLUSTERED 
(
	[EmailDeliveryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EventTypeEmailRecipientConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EventTypeEmailRecipientConfig](
	[EventTypeEmailRecipientConfigID] [bigint] IDENTITY(1,1) NOT NULL,
	[RecipientID] [bigint] NOT NULL,
	[EventTypeID] [int] NOT NULL,
	[Inbox] [bit] NOT NULL,
	[EmailDeliveryTypeID] [smallint] NULL,
 CONSTRAINT [PK_EventTypeEmailRecipientConfig] PRIMARY KEY CLUSTERED 
(
	[EventTypeEmailRecipientConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationRoleClaim]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LocationRoleClaim](
	[LocationRoleClaimID] [bigint] IDENTITY(1,1) NOT NULL,
	[userName] [nvarchar](256) NOT NULL,
	[LocationRoleClaim] [varchar](3000) NULL,
	[Location] [varchar](600) NULL,
	[LocationCode] [varchar](20) NULL,
	[RoleString] [varchar](6000) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MessageType](
	[MessageTypeID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_MessageType] PRIMARY KEY CLUSTERED 
(
	[MessageTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageTypeRecipientConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MessageTypeRecipientConfig](
	[MessageTypeRecipientConfigID] [bigint] IDENTITY(1,1) NOT NULL,
	[RecipientID] [bigint] NOT NULL,
	[MessageTypeID] [int] NOT NULL,
	[Inbox] [bit] NOT NULL,
	[EmailDeliveryTypeID] [smallint] NULL,
 CONSTRAINT [PK_MessageTypeRecipientConfig] PRIMARY KEY CLUSTERED 
(
	[MessageTypeRecipientConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MessageTypeRole]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MessageTypeRole](
	[MessageTypeID] [smallint] NOT NULL,
	[RoleName] [varchar](50) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworkContextsToLoad]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProtoFrameworkContextsToLoad](
	[FrameworkContextID] [bigint] NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[nTeachers] [smallint] NOT NULL,
	[PlaceName] [varchar](200) NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProtoFrameworksToLoad]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ProtoFrameworksToLoad](
	[dest] [varchar](10) NOT NULL,
	[src] [varchar](10) NOT NULL,
	[PlaceName] [varchar](200) NOT NULL,
	[SchoolYear] [int] NOT NULL,
	[nTeachers] [int] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefreshToken]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RefreshToken](
	[RefreshTokenId] [nvarchar](200) NOT NULL,
	[Subject] [nvarchar](50) NOT NULL,
	[ClientAppId] [nvarchar](50) NOT NULL,
	[IssuedUtc] [datetime] NULL,
	[ExpiresUtc] [datetime] NULL,
	[ProtectedTicket] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_RefreshToken] PRIMARY KEY CLUSTERED 
(
	[RefreshTokenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEAlignedEvidence](
	[AlignedEvidenceID] [bigint] IDENTITY(1,1) NOT NULL,
	[AvailableEvidenceID] [bigint] NOT NULL,
	[EvidenceTypeID] [smallint] NOT NULL,
	[AdditionalInput] [varchar](max) NULL,
	[RubricRowEvaluationID] [bigint] NOT NULL,
	[AvailableEvidenceObjectID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEAlignedEvidence] PRIMARY KEY CLUSTERED 
(
	[AlignedEvidenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEAnchorType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEAnchorType](
	[AnchorTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEAnchorType] PRIMARY KEY CLUSTERED 
(
	[AnchorTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundle](
	[ArtifactBundleID] [bigint] IDENTITY(1,1) NOT NULL,
	[ShortName] [varchar](25) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[Context] [varchar](max) NULL,
	[Evidence] [varchar](max) NULL,
	[WfStateID] [bigint] NOT NULL,
	[SubmitDateTime] [datetime] NULL,
	[RejectDateTime] [datetime] NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[RejectionTypeID] [smallint] NULL,
 CONSTRAINT [PK_SEArtifactBundle] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundleArtifactLibItem](
	[ArtifactBundleID] [bigint] NOT NULL,
	[ArtifactLibItemID] [bigint] NOT NULL,
 CONSTRAINT [PK_ArtifactBundleArtifactLibItem] PRIMARY KEY NONCLUSTERED 
(
	[ArtifactBundleID] ASC,
	[ArtifactLibItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundleEvalSession](
	[ArtifactBundleID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEArtifactBundleEvalSession] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleID] ASC,
	[EvalSessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundleRejection](
	[ArtifactBundleRejectionID] [bigint] IDENTITY(1,1) NOT NULL,
	[ArtifactBundleID] [bigint] NOT NULL,
	[RejectionTypeID] [smallint] NOT NULL,
	[CommunicationSessionKey] [uniqueidentifier] NOT NULL,
	[CreatedByUserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEArtifactBundleRejection] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleRejectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejectionType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundleRejectionType](
	[ArtifactBundleRejectionTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEArtifactBundleRejectionType] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleRejectionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundleRubricRowAlignment](
	[ArtifactBundleID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [PK_ArtifactBundleRubricRow] PRIMARY KEY NONCLUSTERED 
(
	[ArtifactBundleID] ASC,
	[RubricRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle](
	[ArtifactBundleID] [bigint] NOT NULL,
	[StudentGrowthGoalBundleID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEArtifactBundleStudentGrowthGoalBundle] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleID] ASC,
	[StudentGrowthGoalBundleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleWfHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactBundleWfHistory](
	[ArtifactBundleWfHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[ArtifactBundleID] [bigint] NOT NULL,
	[TransitionID] [bigint] NOT NULL,
	[Comments] [varchar](max) NULL,
	[TimeStamp] [datetime] NOT NULL,
	[UserID] [bigint] NULL,
 CONSTRAINT [PK_SEArtifactBundleWfHistory] PRIMARY KEY CLUSTERED 
(
	[ArtifactBundleWfHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactLibItem](
	[ArtifactLibItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemTypeID] [smallint] NOT NULL,
	[FileUUID] [uniqueidentifier] NULL,
	[WebUrl] [varchar](max) NULL,
	[ProfPracticeNotes] [varchar](max) NULL,
	[EvaluationID] [bigint] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Comments] [varchar](max) NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[FileName] [varchar](255) NULL,
	[CreatedByUserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEArtifactLibItem] PRIMARY KEY CLUSTERED 
(
	[ArtifactLibItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItemType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactLibItemType](
	[ArtifactLibItemTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEArtifactLibItemType] PRIMARY KEY CLUSTERED 
(
	[ArtifactLibItemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEArtifactType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEArtifactType](
	[ArtifactTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEArtifactType] PRIMARY KEY CLUSTERED 
(
	[ArtifactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEAvailableEvidence](
	[AvailableEvidenceID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[EvidenceTypeID] [smallint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[ArtifactBundleID] [bigint] NULL,
	[RubricRowAnnotationID] [bigint] NULL,
	[StudentGrowthGoalID] [bigint] NULL,
 CONSTRAINT [PK_SEAvailableEvidence] PRIMARY KEY CLUSTERED 
(
	[AvailableEvidenceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SECommunication]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SECommunication](
	[CommunicationID] [bigint] IDENTITY(1,1) NOT NULL,
	[CommunicationSessionKey] [uniqueidentifier] NOT NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[Message] [varchar](max) NOT NULL,
 CONSTRAINT [PK_SECommunication] PRIMARY KEY CLUSTERED 
(
	[CommunicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictConfiguration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEDistrictConfiguration](
	[DistrictConfigurationID] [bigint] IDENTITY(1,1) NOT NULL,
	[FrameworkContextID] [bigint] NOT NULL,
	[FinalReportTitle] [varchar](200) NULL CONSTRAINT [DF__SEDistric__Final__03F0984C]  DEFAULT ('eVAL Final Report'),
	[ObservationReportTitle] [varchar](200) NULL CONSTRAINT [DF__SEDistric__Obser__04E4BC85]  DEFAULT ('eVAL Observation Report'),
	[SelfAssessReportTitle] [varchar](200) NULL CONSTRAINT [DF__SEDistric__SelfA__05D8E0BE]  DEFAULT ('eVAL Self-Assessment Report'),
	[StatementOfPerformanceIsRequired] [bit] NULL CONSTRAINT [DF__SEDistric__State__06CD04F7]  DEFAULT ((1)),
	[NextYearEvalCycleIsRequired] [bit] NULL CONSTRAINT [DF__SEDistric__NextY__07C12930]  DEFAULT ((1)),
	[StudentGrowthGoalSetupWfStateID] [bigint] NULL,
 CONSTRAINT [PK_SEDistrictConfiguration] PRIMARY KEY CLUSTERED 
(
	[DistrictConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEDistrictPRViewing](
	[DistrictUserID] [bigint] NOT NULL,
	[SchoolCode] [varchar](20) NOT NULL,
	[SchoolYear] [smallint] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictResource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEDistrictResource](
	[DistrictResourceID] [bigint] IDENTITY(1,1) NOT NULL,
	[RepositoryItemID] [bigint] NULL,
	[Comments] [varchar](max) NULL,
	[DistrictCode] [varchar](20) NULL,
 CONSTRAINT [PK_SEDistrictResource] PRIMARY KEY CLUSTERED 
(
	[DistrictResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictSchool]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEDistrictSchool](
	[districtCode] [varchar](10) NOT NULL,
	[schoolCode] [varchar](10) NOT NULL,
	[districtSchoolName] [varchar](100) NULL,
	[isSchool] [bit] NOT NULL,
	[isSecondary] [bit] NULL,
 CONSTRAINT [PK_SEDistrictSchool] PRIMARY KEY CLUSTERED 
(
	[schoolCode] ASC,
	[districtCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEDistrictTrainingProtocolAnchor](
	[DistrictTrainingProtocolAnchorID] [bigint] IDENTITY(1,1) NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[TrainingProtocolID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
 CONSTRAINT [PK_SEDistrictTrainingProtocolAnchor] PRIMARY KEY CLUSTERED 
(
	[DistrictTrainingProtocolAnchorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvalAssignmentRequest](
	[EvalAssignmentRequestID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[EvaluatorID] [bigint] NOT NULL,
	[RequestTypeID] [smallint] NOT NULL,
	[Status] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
 CONSTRAINT [PK_SEEvalAssignmentRequest] PRIMARY KEY CLUSTERED 
(
	[EvalAssignmentRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequestStatusType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvalAssignmentRequestStatusType](
	[EvalAssignmentRequestStatusTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEEvalAssignmentRequestStatusType] PRIMARY KEY CLUSTERED 
(
	[EvalAssignmentRequestStatusTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequestType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvalAssignmentRequestType](
	[EvalAssignmentRequestTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEEvalAssignmentRequestType] PRIMARY KEY CLUSTERED 
(
	[EvalAssignmentRequestTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvalSession](
	[EvalSessionID] [bigint] IDENTITY(1,1) NOT NULL,
	[SchoolCode] [varchar](20) NULL,
	[DistrictCode] [varchar](20) NULL,
	[EvaluatorUserID] [bigint] NULL,
	[EvaluateeUserID] [bigint] NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[Title] [varchar](250) NULL,
	[EvaluatorPreConNotes] [varchar](max) NULL,
	[EvaluateePreConNotes] [varchar](max) NULL,
	[ObserveNotes] [varchar](max) NULL,
	[EvaluationScoreTypeID] [smallint] NULL,
	[AnchorTypeID] [smallint] NULL,
	[PerformanceLevelID] [smallint] NULL,
	[PreConfIsPublic] [bit] NULL,
	[PreConfIsComplete] [bit] NULL,
	[PreConfStartTime] [datetime] NULL,
	[PreConfEndTime] [datetime] NULL,
	[PreConfLocation] [varchar](200) NULL,
	[ObserveIsPublic] [bit] NULL,
	[ObserveIsComplete] [bit] NULL,
	[ObserveStartTime] [datetime] NULL,
	[ObserveEndTime] [datetime] NULL,
	[ObserveLocation] [varchar](200) NULL,
	[PostConfStartTime] [datetime] NULL,
	[PostConfEndTime] [datetime] NULL,
	[PostConfLocation] [varchar](200) NULL,
	[PostConfIsPublic] [bit] NULL,
	[PostConfIsComplete] [bit] NULL,
	[IsSelfAssess] [bit] NOT NULL,
	[SchoolYear] [smallint] NULL,
	[IsFocused] [bit] NULL,
	[FocusedFrameworkNodeID] [bigint] NULL,
	[FocusedSGFrameworkNodeID] [bigint] NULL,
	[TrainingProtocolID] [bigint] NULL,
	[ShortName] [varchar](25) NOT NULL,
	[IncludeInFinalReport] [bit] NULL,
	[LockDateTime] [datetime] NULL,
	[isFormalObs] [bit] NULL,
	[Duration] [int] NULL,
	[EvaluatorNotes] [varchar](max) NULL,
	[EvaluationID] [bigint] NOT NULL,
	[WfStateID] [bigint] NOT NULL,
	[IsSharedWithEvaluatee] [bit] NULL,
	[PreConfPromptState] [int] NULL,
	[CreationDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_TeacherEvalSession] PRIMARY KEY CLUSTERED 
(
	[EvalSessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalSessionLibraryVideo]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvalSessionLibraryVideo](
	[EvalSessionLibraryVideoID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
	[VideoName] [varchar](100) NOT NULL,
	[Retired] [bit] NOT NULL,
 CONSTRAINT [PK_SEEvalSessionLibraryVideo] PRIMARY KEY CLUSTERED 
(
	[EvalSessionLibraryVideoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvalSessionRubricRowFocus](
	[EvalSessionID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [pk_SEEvalSessionRubricRowFocus_EvalSessionID_RubricRowID] PRIMARY KEY CLUSTERED 
(
	[EvalSessionID] ASC,
	[RubricRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluateePlanType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluateePlanType](
	[EvaluateePlanTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEEvaluateePlanType] PRIMARY KEY CLUSTERED 
(
	[EvaluateePlanTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluateeRoleEvaluationType](
	[SEEvaluateeRoleEvaluationType] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK_SEEvaluateeRoleEvaluationType] PRIMARY KEY CLUSTERED 
(
	[SEEvaluateeRoleEvaluationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluation](
	[EvaluationID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[EvaluatorID] [bigint] NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[HasBeenSubmitted] [bit] NOT NULL CONSTRAINT [DF__SEEvaluat__HasBe__2EDAF651]  DEFAULT ((0)),
	[SubmissionDate] [datetime] NULL,
	[SchoolYear] [smallint] NOT NULL,
	[Complete] [bit] NOT NULL CONSTRAINT [DF__SEEvaluat__Compl__2FCF1A8A]  DEFAULT ((0)),
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF__SEEvaluat__Creat__30C33EC3]  DEFAULT (getutcdate()),
	[EvaluateePlanTypeID] [smallint] NULL CONSTRAINT [DF_SEEvaluation_EvaluateePlanTypeID]  DEFAULT ((1)),
	[DistrictCode] [varchar](20) NOT NULL,
	[FocusedFrameworkNodeID] [bigint] NULL,
	[FocusedSGFrameworkNodeID] [bigint] NULL,
	[WfStateID] [bigint] NULL,
	[NextYearEvaluateePlanTypeID] [smallint] NULL,
	[NextYearFocusedFrameworkNodeID] [bigint] NULL,
	[NextYearFocusedSGFrameworkNodeID] [bigint] NULL,
	[ByPassSGScores] [bit] NULL CONSTRAINT [DF__SEEvaluat__ByPas__32AB8735]  DEFAULT ((0)),
	[SGScoreOverrideComment] [varchar](200) NULL CONSTRAINT [DF__SEEvaluat__SGSco__339FAB6E]  DEFAULT (''),
	[VisibleToEvaluatee] [bit] NULL CONSTRAINT [DF__SEEvaluat__Visib__3493CFA7]  DEFAULT ((0)),
	[AutoSubmitAfterReceipt] [bit] NULL CONSTRAINT [DF__SEEvaluat__AutoS__3587F3E0]  DEFAULT ((1)),
	[ByPassReceipt] [bit] NULL CONSTRAINT [DF__SEEvaluat__ByPas__367C1819]  DEFAULT ((0)),
	[ByPassReceiptOverrideComment] [varchar](200) NULL CONSTRAINT [DF__SEEvaluat__ByPas__37703C52]  DEFAULT (''),
	[DropToPaper] [bit] NULL CONSTRAINT [DF__SEEvaluat__DropT__3864608B]  DEFAULT ((0)),
	[DropToPaperOverrideComment] [varchar](200) NULL CONSTRAINT [DF__SEEvaluat__DropT__395884C4]  DEFAULT (''),
	[MarkedFinalDateTime] [datetime] NULL,
	[FinalReportRepositoryItemID] [bigint] NULL,
	[EvaluateeReflections] [varchar](max) NULL CONSTRAINT [DF__SEEvaluat__Evalu__3A4CA8FD]  DEFAULT (''),
	[EvaluatorRecommendations] [varchar](max) NULL CONSTRAINT [DF__SEEvaluat__Evalu__3B40CD36]  DEFAULT (''),
	[EvaluateeReflectionsIsPublic] [bit] NULL CONSTRAINT [DF__SEEvaluat__Evalu__3C34F16F]  DEFAULT ((0)),
	[SubmissionCount] [smallint] NULL CONSTRAINT [DF__SEEvaluat__Submi__3D2915A8]  DEFAULT ((0)),
 CONSTRAINT [PK_SEEvaluation] PRIMARY KEY CLUSTERED 
(
	[EvaluationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationScoreType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluationScoreType](
	[EvaluationScoreTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEEvaluationScoreType] PRIMARY KEY CLUSTERED 
(
	[EvaluationScoreTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluationType](
	[EvaluationTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EvaluatorType] PRIMARY KEY CLUSTERED 
(
	[EvaluationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluationTypeRole](
	[EvaluationTypeID] [smallint] NOT NULL,
	[RoleID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SEEvaluationTypeRoleRoleID] PRIMARY KEY NONCLUSTERED 
(
	[EvaluationTypeID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvaluationWfHistory](
	[EvaluationWfHistoryID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[WfTransitionID] [bigint] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[Comment] [text] NULL,
 CONSTRAINT [PK_SEEvaluationWfHistory] PRIMARY KEY CLUSTERED 
(
	[EvaluationWfHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvent](
	[EventId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[Name] [nvarchar](300) NOT NULL,
	[Detail] [nvarchar](500) NULL,
	[Url] [nvarchar](50) NULL,
	[CreateDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[Note] [nvarchar](500) NULL,
	[ObjectId] [bigint] NULL,
 CONSTRAINT [PK_SEEvent] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEventType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEventType](
	[EventTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_EventType] PRIMARY KEY CLUSTERED 
(
	[EventTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvidenceCollectionType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvidenceCollectionType](
	[EvidenceCollectionTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEEvidenceCollectionType] PRIMARY KEY CLUSTERED 
(
	[EvidenceCollectionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEEvidenceType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEEvidenceType](
	[EvidenceTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EvidenceType] PRIMARY KEY CLUSTERED 
(
	[EvidenceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFramework]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFramework](
	[FrameworkID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[FrameworkContextID] [bigint] NOT NULL,
	[PrototypeFrameworkID] [bigint] NOT NULL,
	[XferId] [uniqueidentifier] NULL,
	[StickyID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Framework] PRIMARY KEY CLUSTERED 
(
	[FrameworkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkContext]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkContext](
	[FrameworkContextID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[StateFrameworkID] [bigint] NULL,
	[InstructionalFrameworkID] [bigint] NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[LoadDateTime] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[PrototypeFrameworkContextID] [bigint] NOT NULL,
	[FrameworkViewTypeID] [smallint] NULL,
 CONSTRAINT [PK_SEFrameworkContext] PRIMARY KEY CLUSTERED 
(
	[FrameworkContextID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkNode](
	[FrameworkNodeID] [bigint] IDENTITY(1,1) NOT NULL,
	[FrameworkID] [bigint] NOT NULL,
	[ParentNodeID] [bigint] NULL,
	[Title] [varchar](600) NOT NULL,
	[ShortName] [varchar](50) NOT NULL,
	[Description] [varchar](8000) NOT NULL,
	[IsStateFramework] [bit] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[IsLeafNode] [bit] NOT NULL,
	[XferID] [uniqueidentifier] NULL,
	[StickyID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_SEFrameworkNode] PRIMARY KEY CLUSTERED 
(
	[FrameworkNodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkNodeScore](
	[FrameworkNodeScoreID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
	[LinkedItemTypeID] [smallint] NOT NULL,
	[LinkedItemID] [bigint] NOT NULL,
	[LearningWalkClassRoomID] [bigint] NULL,
 CONSTRAINT [PK_SEFrameworkNodeScore] PRIMARY KEY CLUSTERED 
(
	[FrameworkNodeScoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkPerformanceLevel](
	[FrameworkPerformanceLevelID] [bigint] IDENTITY(1,1) NOT NULL,
	[FrameworkID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NOT NULL,
	[ShortName] [varchar](3) NOT NULL,
	[FullName] [varchar](20) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_SEFrameworkPerformanceLevel] PRIMARY KEY CLUSTERED 
(
	[FrameworkPerformanceLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEFrameworkViewType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEFrameworkViewType](
	[FrameworkViewTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEFrameworkViewType] PRIMARY KEY CLUSTERED 
(
	[FrameworkViewTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassRoom]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SELearningWalkClassRoom](
	[LearningWalkClassRoomID] [bigint] IDENTITY(1,1) NOT NULL,
	[PracticeSessionID] [bigint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SELearningWalkClassRoom] PRIMARY KEY CLUSTERED 
(
	[LearningWalkClassRoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SELearningWalkClassroomLabel](
	[LabelID] [bigint] IDENTITY(1,1) NOT NULL,
	[Label] [varchar](50) NULL,
	[PracticeSessionID] [bigint] NOT NULL,
 CONSTRAINT [PK_SELearningWalkClassroomLabel] PRIMARY KEY CLUSTERED 
(
	[LabelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SELearningWalkClassroomLabelRelationship](
	[ClassroomID] [bigint] NOT NULL,
	[LabelID] [bigint] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SELearningWalkSessionScore](
	[LearningWalkSessionScoreID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClassroomID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NOT NULL,
	[SEUserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SELearningWalkSessionScore] PRIMARY KEY CLUSTERED 
(
	[LearningWalkSessionScoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SELinkedItemType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SELinkedItemType](
	[LinkedItemTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SELinkedItemType] PRIMARY KEY CLUSTERED 
(
	[LinkedItemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SENotification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SENotification](
	[NotificationId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NULL,
	[Title] [nvarchar](500) NULL,
	[Description] [nvarchar](max) NULL,
	[ReceiverUserId] [bigint] NULL,
	[ReceiverRoleId] [int] NULL,
	[IsViewed] [bit] NULL,
	[AlignedTo] [nvarchar](100) NULL,
	[ViewedDateTime] [datetime] NULL,
	[EmailSentForNotification] [bit] NULL,
	[NotificationType] [int] NULL,
	[CreatedByUserId] [bigint] NULL,
	[CreateDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedDateTime] [datetime] NULL,
 CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEPracticeSession](
	[PracticeSessionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[AnchorSessionID] [bigint] NULL,
	[TrainingProtocolID] [bigint] NULL,
	[PracticeSessionTypeID] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[EvaluateeUserID] [bigint] NULL,
	[IsPrivate] [bit] NOT NULL,
	[RandomDigits] [smallint] NOT NULL,
 CONSTRAINT [PK_SEPracticeSession] PRIMARY KEY CLUSTERED 
(
	[PracticeSessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEPracticeSessionParticipant](
	[PracticeSessionParticipantID] [bigint] IDENTITY(1,1) NOT NULL,
	[PracticeSessionID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEPracticeSessionParticipant] PRIMARY KEY CLUSTERED 
(
	[PracticeSessionParticipantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEPracticeSessionType](
	[PracticeSessionTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEPracticeSessionType] PRIMARY KEY CLUSTERED 
(
	[PracticeSessionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPullQuote]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEPullQuote](
	[PullQuoteID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
	[Quote] [varchar](max) NOT NULL,
	[IsImportant] [bit] NULL,
	[GUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_SEPullQuote] PRIMARY KEY CLUSTERED 
(
	[PullQuoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOption]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportPrintOption](
	[ReportPrintOptionID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionTypeID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ParentReportOptionID] [bigint] NULL,
 CONSTRAINT [PK_SEReportPrintOption] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportPrintOptionEvalSession](
	[ReportPrintOptionEvalSessionID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NULL,
 CONSTRAINT [PK_SEReportPrintOptionEvalSession] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionEvalSessionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportPrintOptionEvaluatee](
	[ReportPrintOptionEvaluateeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionID] [bigint] NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
 CONSTRAINT [PK_SEReportPrintOptionEvaluatee] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionEvaluateeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportPrintOptionEvaluation](
	[ReportPrintOptionEvaluationID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionID] [bigint] NOT NULL,
	[EvaluationID] [bigint] NULL,
 CONSTRAINT [PK_SEReportPrintOptionEvaluation] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionEvaluationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportPrintOptionType](
	[ReportPrintOptionTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEReportPrintOptionType] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportPrintOptionUser](
	[ReportPrintOptionID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportSnapshot](
	[ReportSnapshotID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [smallint] NOT NULL,
	[RepositoryItemID] [bigint] NULL,
	[SchoolYear] [smallint] NOT NULL,
	[IsPublic] [bit] NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
 CONSTRAINT [PK_SEReportSnapshot] PRIMARY KEY CLUSTERED 
(
	[ReportSnapshotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEReportType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEReportType](
	[ReportTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEReportType] PRIMARY KEY CLUSTERED 
(
	[ReportTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEResource](
	[ResourceId] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemTypeID] [smallint] NOT NULL,
	[FileUUID] [uniqueidentifier] NULL,
	[WebUrl] [varchar](max) NULL,
	[SchoolCode] [varchar](20) NULL,
	[DistrictCode] [varchar](20) NULL,
	[Title] [varchar](200) NOT NULL,
	[Comments] [varchar](max) NULL,
	[FileName] [varchar](255) NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[ResourceType] [smallint] NOT NULL,
 CONSTRAINT [PK_SEResource] PRIMARY KEY CLUSTERED 
(
	[ResourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResourceItemType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEResourceItemType](
	[ResourceItemTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEResourceItemType] PRIMARY KEY CLUSTERED 
(
	[ResourceItemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEResourceRubricRowAlignment](
	[ResourceId] [bigint] NOT NULL,
	[RubricRowId] [bigint] NOT NULL,
 CONSTRAINT [PK_SEResourceRubricRowAlignment] PRIMARY KEY CLUSTERED 
(
	[ResourceId] ASC,
	[RubricRowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEResourceType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEResourceType](
	[ResourceTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEResourceType] PRIMARY KEY CLUSTERED 
(
	[ResourceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricPerformanceLevel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricPerformanceLevel](
	[PerformanceLevelID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Sequence] [smallint] NOT NULL,
 CONSTRAINT [PK_PerformanceLevel] PRIMARY KEY CLUSTERED 
(
	[PerformanceLevelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRow]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricRow](
	[RubricRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](500) NULL,
	[Description] [varchar](max) NOT NULL,
	[PL4Descriptor] [varchar](max) NOT NULL,
	[PL3Descriptor] [varchar](max) NOT NULL,
	[PL2Descriptor] [varchar](max) NOT NULL,
	[PL1Descriptor] [varchar](max) NOT NULL,
	[XferID] [uniqueidentifier] NULL,
	[IsStateAligned] [bit] NULL,
	[BelongsToDistrict] [varchar](10) NULL,
	[IsStudentGrowthAligned] [bit] NULL CONSTRAINT [DF__SERubricR__IsStu__09746778]  DEFAULT ((0)),
	[TitleToolTip] [varchar](max) NULL,
	[ShortName] [varchar](50) NULL CONSTRAINT [DF__SERubricR__Short__0A688BB1]  DEFAULT (''),
	[StickyID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Element] PRIMARY KEY CLUSTERED 
(
	[RubricRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricRowAnnotation](
	[RubricRowAnnotationID] [bigint] IDENTITY(1,1) NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[Annotation] [varchar](max) NULL,
	[UserID] [bigint] NULL,
	[ArtifactBundleID] [bigint] NULL,
	[EvalSessionID] [bigint] NULL,
	[StudentGrowthGoalBundleID] [bigint] NULL,
	[AnnotationSourceType] [int] NULL,
	[EvaluationID] [bigint] NOT NULL,
	[LinkedItemTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK__SERubric__1E96B6D67B4643B2] PRIMARY KEY CLUSTERED 
(
	[RubricRowAnnotationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricRowEvaluation](
	[RubricRowEvaluationID] [bigint] IDENTITY(1,1) NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[EvidenceCollectionTypeID] [smallint] NOT NULL,
	[LinkedItemTypeID] [smallint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[LinkedObservationID] [bigint] NULL,
	[LinkedStudentGrowthGoalBundleID] [bigint] NULL,
	[LinkedSelfAssessmentID] [bigint] NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[RubricStatement] [varchar](max) NOT NULL,
	[AdditionalInput] [varchar](max) NULL,
 CONSTRAINT [PK_SERubricRowEvaluation] PRIMARY KEY CLUSTERED 
(
	[RubricRowEvaluationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricRowFrameworkNode](
	[FrameworkNodeID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[Sequence] [smallint] NOT NULL,
 CONSTRAINT [PK_SERubricRowFrameworkNode] PRIMARY KEY CLUSTERED 
(
	[FrameworkNodeID] ASC,
	[RubricRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SERubricRowScore](
	[RubricRowScoreID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[LinkedItemTypeID] [smallint] NOT NULL,
	[LinkedItemID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[LearningWalkClassRoomID] [bigint] NULL,
 CONSTRAINT [PK_SERubricRowScore] PRIMARY KEY CLUSTERED 
(
	[RubricRowScoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESchoolConfiguration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SESchoolConfiguration](
	[SchoolConfigurationID] [bigint] IDENTITY(1,1) NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[SchoolCode] [varchar](20) NOT NULL,
	[HasBeenSubmittedToDistrictTE] [bit] NOT NULL CONSTRAINT [DF_SESchoolConfiguration_HasBeenSubmittedToDistrictTE]  DEFAULT ((0)),
	[SubmissionToDistrictDateTE] [datetime] NULL,
	[IsPrincipalAssignmentDelegated] [bit] NOT NULL CONSTRAINT [DF_SESchoolConfiguration_IsPrincipalAssignmentDelegated]  DEFAULT ((0)),
	[SchoolYear] [smallint] NULL,
	[PK_SESchoolConfiguration] [bigint] NULL,
	[IsStudentGrowthProcessSettingsDelegated] [bit] NOT NULL DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[SchoolConfigurationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESchoolYear]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SESchoolYear](
	[SchoolYear] [smallint] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[YearRange] [varchar](255) NULL,
 CONSTRAINT [PK_SESchoolYear] PRIMARY KEY CLUSTERED 
(
	[SchoolYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SESelfAssessment](
	[SelfAssessmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[ShortName] [varchar](25) NOT NULL,
	[Title] [varchar](250) NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[IsSharedWithEvaluator] [bit] NOT NULL,
	[IsFocused] [bit] NOT NULL,
	[FocusedFrameworkNodeID] [bigint] NULL,
	[FocusedSGFrameworkNodeID] [bigint] NULL,
	[IncludeInFinalReport] [bit] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SESelfAssessment] PRIMARY KEY CLUSTERED 
(
	[SelfAssessmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SESelfAssessmentRubricRowFocus](
	[SelfAssessmentID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [PK_SESelfAssessmentRubricRowFocus] PRIMARY KEY CLUSTERED 
(
	[SelfAssessmentID] ASC,
	[RubricRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPrompt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthFormPrompt](
	[StudentGrowthFormPromptID] [bigint] IDENTITY(1,1) NOT NULL,
	[Prompt] [varchar](max) NOT NULL CONSTRAINT [DF_SEFormPrompt_Prompt]  DEFAULT (''),
	[DistrictCode] [varchar](20) NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[FormPromptTypeID] [smallint] NOT NULL,
 CONSTRAINT [PK_SEFormPrompt] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthFormPromptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode](
	[StudentGrowthFormPromptFrameworkNodeID] [bigint] IDENTITY(1,1) NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[FormPromptID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthFormPromptFrameworkNode] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthFormPromptFrameworkNodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthFormPromptResponse](
	[FormPromptResponseID] [bigint] IDENTITY(1,1) NOT NULL,
	[FormPromptID] [bigint] NOT NULL,
	[Response] [varchar](max) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[StudentGrowthGoalID] [bigint] NULL,
 CONSTRAINT [PK_SEFormPromptResponse] PRIMARY KEY CLUSTERED 
(
	[FormPromptResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthFormPromptType](
	[StudentGrowthFormPromptTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthFormPromptType] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthFormPromptTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthGoal](
	[StudentGrowthGoalID] [bigint] IDENTITY(1,1) NOT NULL,
	[GoalBundleID] [bigint] NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
	[ProcessRubricRowID] [bigint] NOT NULL,
	[ResultsRubricRowID] [bigint] NULL,
	[GoalStatement] [varchar](max) NOT NULL,
	[GoalTargets] [varchar](max) NOT NULL,
	[EvidenceAll] [varchar](max) NOT NULL,
	[EvidenceMost] [varchar](max) NOT NULL,
	[ProcessPerformanceLevelID] [smallint] NULL,
	[ResultsPerformanceLevelID] [smallint] NULL,
	[ProcessTypeID] [smallint] NOT NULL,
	[ProcessArtifactBundleID] [bigint] NULL,
	[ProcessFormID] [bigint] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthGoal] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthGoalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthGoalBundle](
	[StudentGrowthGoalBundleID] [bigint] IDENTITY(1,1) NOT NULL,
	[ShortName] [varchar](25) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Comments] [varchar](max) NULL,
	[Course] [varchar](200) NULL,
	[Grade] [varchar](20) NULL,
	[WfStateID] [bigint] NOT NULL,
	[EvalWfStateID] [bigint] NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthGoalBundle] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthGoalBundleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthGoalBundleGoal](
	[BundleID] [bigint] NOT NULL,
	[GoalID] [bigint] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment](
	[StudentGrowthGoalBundleID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [PK_StudentGrowthBundleRubricRow] PRIMARY KEY NONCLUSTERED 
(
	[StudentGrowthGoalBundleID] ASC,
	[RubricRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthProcessSettings](
	[StudentGrowthProcessSettingsID] [bigint] IDENTITY(1,1) NOT NULL,
	[DistrictCode] [varchar](20) NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[FrameworkNodeShortName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthSettings] PRIMARY KEY CLUSTERED 
(
	[StudentGrowthProcessSettingsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt](
	[ProcessSettingsFormPromptID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProcessSettingsID] [bigint] NOT NULL,
	[FormPromptID] [bigint] NOT NULL,
	[Required] [bit] NOT NULL,
	[Sequence] [smallint] NOT NULL,
 CONSTRAINT [PK_SEStudentGrowthProcessSettingsFormPrompt] PRIMARY KEY CLUSTERED 
(
	[ProcessSettingsFormPromptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SESummativeFrameworkNodeScore](
	[SummativeFrameworkNodeScoreID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
	[StatementOfPerformance] [varchar](max) NULL,
 CONSTRAINT [PK_SESummativeFrameworkNodeScore] PRIMARY KEY CLUSTERED 
(
	[SummativeFrameworkNodeScoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SESummativeRubricRowScore](
	[SummativeRubricRowScoreID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [PK_SESummativeRubricRowScore] PRIMARY KEY CLUSTERED 
(
	[SummativeRubricRowScoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocol]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocol](
	[TrainingProtocolID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[Summary] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[DocName] [varchar](max) NOT NULL,
	[Length] [varchar](200) NOT NULL,
	[Published] [bit] NOT NULL,
	[PublishedDate] [datetime] NULL,
	[Retired] [bit] NOT NULL,
	[IncludeInPublicSite] [bit] NULL,
	[IncludeInVideoLibrary] [bit] NULL,
	[VideoPoster] [varchar](max) NULL,
	[VideoSrc] [varchar](max) NULL,
	[ImageName] [varchar](500) NULL,
	[AvgRating] [smallint] NULL,
	[NumRatings] [smallint] NULL,
 CONSTRAINT [PK_SETrainingProtocol] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment](
	[TrainingProtocolID] [bigint] NOT NULL,
	[FrameworkNodeID] [bigint] NOT NULL,
	[IsStateAlignment] [bit] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocolLabel](
	[TrainingProtocolLabelID] [smallint] IDENTITY(1,1) NOT NULL,
	[TrainingProtocolLabelGroupID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Sequence] [smallint] NULL,
 CONSTRAINT [PK_SETrainingProtocolLabel] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolLabelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocolLabelAssignment](
	[TrainingProtocolID] [bigint] NOT NULL,
	[TrainingProtocolLabelID] [smallint] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocolLabelGroup](
	[TrainingProtocolLabelGroupID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolLabelGroup] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolLabelGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocolPlaylist](
	[TrainingProtocolPlaylistID] [bigint] IDENTITY(1,1) NOT NULL,
	[TrainingProtocolID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolPlaylist] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolPlaylistID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocolRating](
	[TrainingProtocolRatingID] [bigint] IDENTITY(1,1) NOT NULL,
	[TrainingProtocolID] [bigint] NOT NULL,
	[UserID] [bigint] NOT NULL,
	[Rating] [smallint] NOT NULL,
	[Comments] [varchar](max) NULL,
	[CreationDate] [datetime] NULL,
	[IsAnnonymous] [bit] NOT NULL,
	[Status] [smallint] NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolRating] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolRatingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRatingStatusType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SETrainingProtocolRatingStatusType](
	[TrainingProtocolRatingStatusTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SETrainingProtocolRatingStatusType] PRIMARY KEY CLUSTERED 
(
	[TrainingProtocolRatingStatusTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUser]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUser](
	[SEUserID] [bigint] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NULL,
	[SchoolCode] [varchar](20) NULL,
	[DistrictCode] [varchar](20) NULL,
	[ASPNetUserID] [uniqueidentifier] NULL,
	[HasMultipleBuildings] [bit] NOT NULL CONSTRAINT [DF__SEUser__HasMulti__2CF50FE4]  DEFAULT ((0)),
	[Username] [nvarchar](256) NULL,
	[loweredUsername] [nvarchar](256) NULL,
	[MessageEmailOverride] [varchar](200) NULL,
	[LoginName] [varchar](256) NULL,
	[EmailAddressAlternate] [varchar](256) NULL,
	[CertificateNumber] [varchar](20) NULL,
	[MobileAccessKey] [uniqueidentifier] NULL CONSTRAINT [DF_T_SEUser_MobileAccessKey]  DEFAULT (newid()),
	[EmailAddress] [varchar](256) NOT NULL,
	[OTPW] [varchar](1000) NULL,
 CONSTRAINT [PK_SEUser] PRIMARY KEY CLUSTERED 
(
	[SEUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserActivity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserActivity](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Name] [nvarchar](200) NULL,
	[Type] [nvarchar](100) NULL,
	[Title] [nvarchar](1000) NULL,
	[Detail] [nvarchar](2000) NULL,
	[CreateDate] [datetime] NULL,
	[IsViewed] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[Url] [nvarchar](1000) NULL,
	[Param] [nvarchar](1000) NULL,
	[ObjectId] [bigint] NULL,
	[ObjectType] [nvarchar](500) NULL,
	[ActivityData] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserActivity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserDistrictSchool]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserDistrictSchool](
	[UserDistrictSchoolID] [bigint] IDENTITY(1,1) NOT NULL,
	[SEUserID] [bigint] NOT NULL,
	[SchoolCode] [varchar](50) NOT NULL,
	[DistrictCode] [varchar](50) NOT NULL,
	[SchoolName] [varchar](100) NULL,
	[DistrictName] [varchar](100) NULL,
	[IsPrimary] [bit] NOT NULL,
 CONSTRAINT [PK_SEUserDistrictSchool] PRIMARY KEY CLUSTERED 
(
	[UserDistrictSchoolID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserLocationRole](
	[UserLocationRoleID] [bigint] IDENTITY(1,1) NOT NULL,
	[SEUserId] [bigint] NULL,
	[UserName] [nvarchar](255) NOT NULL,
	[RoleName] [nvarchar](255) NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[DistrictCode] [nvarchar](25) NOT NULL,
	[SchoolCode] [nvarchar](25) NULL,
	[LastActiveRole] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SEUserLocationROle] PRIMARY KEY CLUSTERED 
(
	[UserLocationRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserPrompt](
	[UserPromptID] [bigint] IDENTITY(1,1) NOT NULL,
	[PromptTypeID] [smallint] NOT NULL,
	[Title] [varchar](200) NOT NULL,
	[Prompt] [varchar](max) NOT NULL,
	[DistrictCode] [varchar](10) NOT NULL,
	[SchoolCode] [varchar](10) NULL,
	[CreatedByUserID] [bigint] NOT NULL,
	[Published] [bit] NOT NULL,
	[PublishedDate] [datetime] NULL,
	[Retired] [bit] NOT NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[Private] [bit] NOT NULL,
	[EvaluateeID] [bigint] NULL,
	[EvalSessionID] [bigint] NULL,
	[CreatedAsAdmin] [bit] NOT NULL,
	[Sequence] [smallint] NULL,
	[SchoolYear] [smallint] NOT NULL,
	[GUID] [uniqueidentifier] NULL,
	[WfStateID] [bigint] NULL,
 CONSTRAINT [PK_SEUserPrompt] PRIMARY KEY CLUSTERED 
(
	[UserPromptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserPromptConferenceDefault](
	[SEUserPromptConferenceDefaultID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserPromptID] [bigint] NOT NULL,
	[UserPromptTypeID] [smallint] NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[DistrictCode] [varchar](20) NOT NULL,
	[PK_SEUserPromptConferenceDefault] [bigint] NULL,
 CONSTRAINT [PK__SEUserPr__AD56DF00758D6A5C] PRIMARY KEY CLUSTERED 
(
	[SEUserPromptConferenceDefaultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserPromptResponse](
	[UserPromptResponseID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserPromptID] [bigint] NOT NULL,
	[EvaluateeID] [bigint] NULL,
	[EvalSessionID] [bigint] NULL,
	[SchoolYear] [smallint] NULL,
	[ArtifactID] [bigint] NULL,
	[DistrictCode] [varchar](20) NOT NULL,
 CONSTRAINT [PK_SEUserPromptResponse] PRIMARY KEY CLUSTERED 
(
	[UserPromptResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserPromptResponseEntry](
	[UserPromptResponseEntryID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserPromptResponseID] [bigint] NOT NULL,
	[Response] [varchar](max) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[CreationDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_SEUserPromptResponseEntry] PRIMARY KEY CLUSTERED 
(
	[UserPromptResponseEntryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserPromptRubricRowAlignment](
	[UserPromptID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
 CONSTRAINT [pk_UserPromptID_RubricRowID] PRIMARY KEY CLUSTERED 
(
	[UserPromptID] ASC,
	[RubricRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEUserPromptType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEUserPromptType](
	[UserPromptTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEUserPromptType] PRIMARY KEY CLUSTERED 
(
	[UserPromptTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEWfState]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEWfState](
	[WfStateID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SEWfState] PRIMARY KEY CLUSTERED 
(
	[WfStateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEWfTransition]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SEWfTransition](
	[WfTransitionID] [bigint] IDENTITY(1,1) NOT NULL,
	[StartStateID] [bigint] NOT NULL,
	[EndStateID] [bigint] NOT NULL,
	[Description] [varchar](200) NULL,
 CONSTRAINT [PK_SEWfTransition] PRIMARY KEY CLUSTERED 
(
	[WfTransitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UpdateLog](
	[UpdateLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[BugNumber] [bigint] NOT NULL,
	[UpdateName] [varchar](100) NOT NULL,
	[Comment] [varchar](200) NOT NULL,
	[timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_UpdateLog] PRIMARY KEY CLUSTERED 
(
	[UpdateLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_ELMAH_Error_ErrorId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ELMAH_Error] ADD  CONSTRAINT [DF_ELMAH_Error_ErrorId]  DEFAULT (newid()) FOR [ErrorId]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__MessageTy__Inbox__56B3DD81]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MessageTypeRecipientConfig] ADD  DEFAULT ((0)) FOR [Inbox]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__MessageTy__Email__57A801BA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MessageTypeRecipientConfig] ADD  DEFAULT ((1)) FOR [EmailDeliveryTypeID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Title__52E34C9D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] ADD  CONSTRAINT [DF__SEArtifac__Title__52E34C9D]  DEFAULT ('') FOR [Title]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Conte__53D770D6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] ADD  CONSTRAINT [DF__SEArtifac__Conte__53D770D6]  DEFAULT ('') FOR [Context]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Evide__54CB950F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] ADD  CONSTRAINT [DF__SEArtifac__Evide__54CB950F]  DEFAULT ('') FOR [Evidence]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__WfSta__55BFB948]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundle] ADD  CONSTRAINT [DF__SEArtifac__WfSta__55BFB948]  DEFAULT ((6)) FOR [WfStateID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEArtifac__Comme__5C6CB6D7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEArtifactBundleWfHistory] ADD  DEFAULT ('') FOR [Comments]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEEvalSession_EvaluationScoreTypeID]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF_SEEvalSession_EvaluationScoreTypeID]  DEFAULT ((1)) FOR [EvaluationScoreTypeID]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PreCo__52E34C9D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__PreCo__52E34C9D]  DEFAULT ((0)) FOR [PreConfIsPublic]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PreCo__53D770D6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__PreCo__53D770D6]  DEFAULT ((0)) FOR [PreConfIsComplete]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__Obser__54CB950F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__Obser__54CB950F]  DEFAULT ((0)) FOR [ObserveIsPublic]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__Obser__55BFB948]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__Obser__55BFB948]  DEFAULT ('') FOR [ObserveLocation]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PostC__56B3DD81]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__PostC__56B3DD81]  DEFAULT ('') FOR [PostConfLocation]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__PostC__57A801BA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__PostC__57A801BA]  DEFAULT ((0)) FOR [PostConfIsPublic]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEEvalSession_IsSelfAssess]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF_SEEvalSession_IsSelfAssess]  DEFAULT ((0)) FOR [IsSelfAssess]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__IsFoc__5A846E65]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__IsFoc__5A846E65]  DEFAULT ((0)) FOR [IsFocused]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SEEvalSes__Inclu__5B78929E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEEvalSession] ADD  CONSTRAINT [DF__SEEvalSes__Inclu__5B78929E]  DEFAULT ((0)) FOR [IncludeInFinalReport]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEFormPromptResponse_Response]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] ADD  CONSTRAINT [DF_SEFormPromptResponse_Response]  DEFAULT ('') FOR [Response]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_GoalStatement]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_GoalStatement]  DEFAULT ('') FOR [GoalStatement]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_GoalTargets]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_GoalTargets]  DEFAULT ('') FOR [GoalTargets]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_EvidenceMost]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_EvidenceMost]  DEFAULT ('') FOR [EvidenceAll]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoal_EvidenceMost_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoal] ADD  CONSTRAINT [DF_SEStudentGrowthGoal_EvidenceMost_1]  DEFAULT ('') FOR [EvidenceMost]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoalBundle_Title]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] ADD  CONSTRAINT [DF_SEStudentGrowthGoalBundle_Title]  DEFAULT ('') FOR [Title]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoalBundle_Course]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] ADD  CONSTRAINT [DF_SEStudentGrowthGoalBundle_Course]  DEFAULT ('') FOR [Course]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEStudentGrowthGoalBundle_Grade]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] ADD  CONSTRAINT [DF_SEStudentGrowthGoalBundle_Grade]  DEFAULT ('') FOR [Grade]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SESummati__State__61316BF4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] ADD  CONSTRAINT [DF__SESummati__State__61316BF4]  DEFAULT ('') FOR [StatementOfPerformance]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Title]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Title]  DEFAULT ('') FOR [Title]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Summary]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Summary]  DEFAULT ('') FOR [Summary]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Description]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Description]  DEFAULT ('') FOR [Description]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Published]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Published]  DEFAULT ((0)) FOR [Published]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SETrainingProtocol_Retired]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Retired]  DEFAULT ((0)) FOR [Retired]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SETrainin__Seque__74444068]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SETrainingProtocolLabel] ADD  DEFAULT ((0)) FOR [Sequence]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Published]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Published]  DEFAULT ((0)) FOR [Published]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Retired]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Retired]  DEFAULT ((0)) FOR [Retired]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Private]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Private]  DEFAULT ((0)) FOR [Private]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_CreatedAsAdmin]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_CreatedAsAdmin]  DEFAULT ((1)) FOR [CreatedAsAdmin]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_SEUserPrompt_Sequence]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SEUserPrompt] ADD  CONSTRAINT [DF_SEUserPrompt_Sequence]  DEFAULT ((1)) FOR [Sequence]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EventTypeEmailRecipientConfig_SEEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[EventTypeEmailRecipientConfig]'))
ALTER TABLE [dbo].[EventTypeEmailRecipientConfig]  WITH CHECK ADD  CONSTRAINT [FK_EventTypeEmailRecipientConfig_SEEventType] FOREIGN KEY([EventTypeID])
REFERENCES [dbo].[SEEventType] ([EventTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_EventTypeEmailRecipientConfig_SEEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[EventTypeEmailRecipientConfig]'))
ALTER TABLE [dbo].[EventTypeEmailRecipientConfig] CHECK CONSTRAINT [FK_EventTypeEmailRecipientConfig_SEEventType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MessageTypeRecipientConfig_MessageType]') AND parent_object_id = OBJECT_ID(N'[dbo].[MessageTypeRecipientConfig]'))
ALTER TABLE [dbo].[MessageTypeRecipientConfig]  WITH CHECK ADD  CONSTRAINT [FK_MessageTypeRecipientConfig_MessageType] FOREIGN KEY([MessageTypeID])
REFERENCES [dbo].[MessageType] ([MessageTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_MessageTypeRecipientConfig_MessageType]') AND parent_object_id = OBJECT_ID(N'[dbo].[MessageTypeRecipientConfig]'))
ALTER TABLE [dbo].[MessageTypeRecipientConfig] CHECK CONSTRAINT [FK_MessageTypeRecipientConfig_MessageType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefreshToken_ClientApp]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefreshToken]'))
ALTER TABLE [dbo].[RefreshToken]  WITH CHECK ADD  CONSTRAINT [FK_RefreshToken_ClientApp] FOREIGN KEY([ClientAppId])
REFERENCES [dbo].[ClientApp] ([ClientAppId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_RefreshToken_ClientApp]') AND parent_object_id = OBJECT_ID(N'[dbo].[RefreshToken]'))
ALTER TABLE [dbo].[RefreshToken] CHECK CONSTRAINT [FK_RefreshToken_ClientApp]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SEAvailableEvidence]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAlignedEvidence_SEAvailableEvidence] FOREIGN KEY([AvailableEvidenceID])
REFERENCES [dbo].[SEAvailableEvidence] ([AvailableEvidenceID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SEAvailableEvidence]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence] CHECK CONSTRAINT [FK_SEAlignedEvidence_SEAvailableEvidence]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SEEvidenceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAlignedEvidence_SEEvidenceType] FOREIGN KEY([EvidenceTypeID])
REFERENCES [dbo].[SEEvidenceType] ([EvidenceTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SEEvidenceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence] CHECK CONSTRAINT [FK_SEAlignedEvidence_SEEvidenceType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SERubricRowEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAlignedEvidence_SERubricRowEvaluation] FOREIGN KEY([RubricRowEvaluationID])
REFERENCES [dbo].[SERubricRowEvaluation] ([RubricRowEvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAlignedEvidence_SERubricRowEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAlignedEvidence]'))
ALTER TABLE [dbo].[SEAlignedEvidence] CHECK CONSTRAINT [FK_SEAlignedEvidence_SERubricRowEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_CreatedByUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEArtifactBundleRejectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEArtifactBundleRejectionType] FOREIGN KEY([RejectionTypeID])
REFERENCES [dbo].[SEArtifactBundleRejectionType] ([ArtifactBundleRejectionTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEArtifactBundleRejectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEArtifactBundleRejectionType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundle_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundle_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundle]'))
ALTER TABLE [dbo].[SEArtifactBundle] CHECK CONSTRAINT [FK_SEArtifactBundle_SEWfState]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactBundleID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID] FOREIGN KEY([ArtifactLibItemID])
REFERENCES [dbo].[SEArtifactLibItem] ([ArtifactLibItemID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactBundleArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactBundleArtifactLibItem_ArtifactLibItemID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleEvalSession_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]'))
ALTER TABLE [dbo].[SEArtifactBundleEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleEvalSession_SEArtifactBundle] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleEvalSession_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]'))
ALTER TABLE [dbo].[SEArtifactBundleEvalSession] CHECK CONSTRAINT [FK_SEArtifactBundleEvalSession_SEArtifactBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleEvalSession_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]'))
ALTER TABLE [dbo].[SEArtifactBundleEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleEvalSession_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleEvalSession_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleEvalSession]'))
ALTER TABLE [dbo].[SEArtifactBundleEvalSession] CHECK CONSTRAINT [FK_SEArtifactBundleEvalSession_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundle] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection] CHECK CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType] FOREIGN KEY([RejectionTypeID])
REFERENCES [dbo].[SEArtifactBundleRejectionType] ([ArtifactBundleRejectionTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection] CHECK CONSTRAINT [FK_SEArtifactBundleRejection_SEArtifactBundleRejectionType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRejection_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRejection_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRejection]'))
ALTER TABLE [dbo].[SEArtifactBundleRejection] CHECK CONSTRAINT [FK_SEArtifactBundleRejection_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment] CHECK CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_ArtifactBundleID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRubricRowAlignment_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_RubricRowID] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleRubricRowAlignment_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEArtifactBundleRubricRowAlignment] CHECK CONSTRAINT [FK_SEArtifactBundleRubricRowAlignment_RubricRowID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleStudentGrowthGoalBundle_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleStudentGrowthGoalBundle_SEArtifactBundle] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleStudentGrowthGoalBundle_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle] CHECK CONSTRAINT [FK_SEArtifactBundleStudentGrowthGoalBundle_SEArtifactBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleStudentGrowthGoalBundle_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleStudentGrowthGoalBundle_SEStudentGrowthGoalBundle] FOREIGN KEY([StudentGrowthGoalBundleID])
REFERENCES [dbo].[SEStudentGrowthGoalBundle] ([StudentGrowthGoalBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleStudentGrowthGoalBundle_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEArtifactBundleStudentGrowthGoalBundle] CHECK CONSTRAINT [FK_SEArtifactBundleStudentGrowthGoalBundle_SEStudentGrowthGoalBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleWfHistory_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleWfHistory]'))
ALTER TABLE [dbo].[SEArtifactBundleWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactBundleWfHistory_ArtifactBundleID] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactBundleWfHistory_ArtifactBundleID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactBundleWfHistory]'))
ALTER TABLE [dbo].[SEArtifactBundleWfHistory] CHECK CONSTRAINT [FK_SEArtifactBundleWfHistory_ArtifactBundleID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactLibItem_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactLibItem_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactLibItem_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactLibItem_CreatedByUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactLibItem_ItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactLibItem]  WITH CHECK ADD  CONSTRAINT [FK_SEArtifactLibItem_ItemType] FOREIGN KEY([ItemTypeID])
REFERENCES [dbo].[SEArtifactLibItemType] ([ArtifactLibItemTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEArtifactLibItem_ItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEArtifactLibItem]'))
ALTER TABLE [dbo].[SEArtifactLibItem] CHECK CONSTRAINT [FK_SEArtifactLibItem_ItemType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAvailableEvidence_SEArtifactBundle] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] CHECK CONSTRAINT [FK_SEAvailableEvidence_SEArtifactBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAvailableEvidence_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] CHECK CONSTRAINT [FK_SEAvailableEvidence_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvaluation1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAvailableEvidence_SEEvaluation1] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvaluation1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] CHECK CONSTRAINT [FK_SEAvailableEvidence_SEEvaluation1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvidenceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAvailableEvidence_SEEvidenceType] FOREIGN KEY([EvidenceTypeID])
REFERENCES [dbo].[SEEvidenceType] ([EvidenceTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEEvidenceType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] CHECK CONSTRAINT [FK_SEAvailableEvidence_SEEvidenceType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAvailableEvidence_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] CHECK CONSTRAINT [FK_SEAvailableEvidence_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SERubricRowAnnotation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAvailableEvidence_SERubricRowAnnotation] FOREIGN KEY([RubricRowAnnotationID])
REFERENCES [dbo].[SERubricRowAnnotation] ([RubricRowAnnotationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SERubricRowAnnotation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] CHECK CONSTRAINT [FK_SEAvailableEvidence_SERubricRowAnnotation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence]  WITH CHECK ADD  CONSTRAINT [FK_SEAvailableEvidence_SEStudentGrowthGoal] FOREIGN KEY([StudentGrowthGoalID])
REFERENCES [dbo].[SEStudentGrowthGoal] ([StudentGrowthGoalID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEAvailableEvidence_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEAvailableEvidence]'))
ALTER TABLE [dbo].[SEAvailableEvidence] CHECK CONSTRAINT [FK_SEAvailableEvidence_SEStudentGrowthGoal]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SECommunication_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SECommunication]'))
ALTER TABLE [dbo].[SECommunication]  WITH CHECK ADD  CONSTRAINT [FK_SECommunication_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SECommunication_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SECommunication]'))
ALTER TABLE [dbo].[SECommunication] CHECK CONSTRAINT [FK_SECommunication_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictConfiguration_SEFrameworkContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictConfiguration]'))
ALTER TABLE [dbo].[SEDistrictConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_SEDistrictConfiguration_SEFrameworkContext] FOREIGN KEY([FrameworkContextID])
REFERENCES [dbo].[SEFrameworkContext] ([FrameworkContextID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictConfiguration_SEFrameworkContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictConfiguration]'))
ALTER TABLE [dbo].[SEDistrictConfiguration] CHECK CONSTRAINT [FK_SEDistrictConfiguration_SEFrameworkContext]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDAPRViewing_DAUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]'))
ALTER TABLE [dbo].[SEDistrictPRViewing]  WITH CHECK ADD  CONSTRAINT [FK_SEDAPRViewing_DAUserID] FOREIGN KEY([DistrictUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDAPRViewing_DAUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]'))
ALTER TABLE [dbo].[SEDistrictPRViewing] CHECK CONSTRAINT [FK_SEDAPRViewing_DAUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDAPRViewing_SchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]'))
ALTER TABLE [dbo].[SEDistrictPRViewing]  WITH CHECK ADD  CONSTRAINT [FK_SEDAPRViewing_SchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDAPRViewing_SchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictPRViewing]'))
ALTER TABLE [dbo].[SEDistrictPRViewing] CHECK CONSTRAINT [FK_SEDAPRViewing_SchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictTrainingProtocolAnchor_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]'))
ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor]  WITH CHECK ADD  CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictTrainingProtocolAnchor_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]'))
ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor] CHECK CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]'))
ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor]  WITH CHECK ADD  CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEDistrictTrainingProtocolAnchor]'))
ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor] CHECK CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType] FOREIGN KEY([Status])
REFERENCES [dbo].[SEEvalAssignmentRequestStatusType] ([EvalAssignmentRequestStatusTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestStatusType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType] FOREIGN KEY([RequestTypeID])
REFERENCES [dbo].[SEEvalAssignmentRequestType] ([EvalAssignmentRequestTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEEvalAssignmentRequestType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser] FOREIGN KEY([EvaluatorID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser1] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalAssignmentRequest_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalAssignmentRequest]'))
ALTER TABLE [dbo].[SEEvalAssignmentRequest] CHECK CONSTRAINT [FK_SEEvalAssignmentRequest_SEUser1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_FocusFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_FocusFrameworkNode] FOREIGN KEY([FocusedFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_FocusFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_FocusFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEAnchorType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SEAnchorType] FOREIGN KEY([AnchorTypeID])
REFERENCES [dbo].[SEAnchorType] ([AnchorTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEAnchorType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SEAnchorType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEEvaluationScoreType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SEEvaluationScoreType] FOREIGN KEY([EvaluationScoreTypeID])
REFERENCES [dbo].[SEEvaluationScoreType] ([EvaluationScoreTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEEvaluationScoreType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SEEvaluationScoreType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SETrainingProtocol]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SEUser] FOREIGN KEY([EvaluateeUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SEUser1] FOREIGN KEY([EvaluatorUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SEUser1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SEWfState]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SGFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SGFrameworkNode] FOREIGN KEY([FocusedSGFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvalSession_SGFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSession]'))
ALTER TABLE [dbo].[SEEvalSession] CHECK CONSTRAINT [FK_SEEvalSession_SGFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_SEEvalSessionRubricRowFocus_EvalSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]'))
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus]  WITH CHECK ADD  CONSTRAINT [fk_SEEvalSessionRubricRowFocus_EvalSessionID] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_SEEvalSessionRubricRowFocus_EvalSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]'))
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] CHECK CONSTRAINT [fk_SEEvalSessionRubricRowFocus_EvalSessionID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_SEEvalSessionRubricRowFocus_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]'))
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus]  WITH CHECK ADD  CONSTRAINT [fk_SEEvalSessionRubricRowFocus_RubricRowID] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_SEEvalSessionRubricRowFocus_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvalSessionRubricRowFocus]'))
ALTER TABLE [dbo].[SEEvalSessionRubricRowFocus] CHECK CONSTRAINT [fk_SEEvalSessionRubricRowFocus_RubricRowID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluateeRoleEvaluationType_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]'))
ALTER TABLE [dbo].[SEEvaluateeRoleEvaluationType]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluateeRoleEvaluationType_aspnet_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[aspnet_Roles] ([RoleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluateeRoleEvaluationType_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]'))
ALTER TABLE [dbo].[SEEvaluateeRoleEvaluationType] CHECK CONSTRAINT [FK_SEEvaluateeRoleEvaluationType_aspnet_Roles]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluateeRoleEvaluationType_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]'))
ALTER TABLE [dbo].[SEEvaluateeRoleEvaluationType]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluateeRoleEvaluationType_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluateeRoleEvaluationType_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluateeRoleEvaluationType]'))
ALTER TABLE [dbo].[SEEvaluateeRoleEvaluationType] CHECK CONSTRAINT [FK_SEEvaluateeRoleEvaluationType_SEEvaluationType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_FocusFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_FocusFrameworkNode] FOREIGN KEY([FocusedFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_FocusFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_FocusFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluateePlanType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType] FOREIGN KEY([EvaluateePlanTypeID])
REFERENCES [dbo].[SEEvaluateePlanType] ([EvaluateePlanTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluateePlanType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluateePlanType2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType2] FOREIGN KEY([NextYearEvaluateePlanTypeID])
REFERENCES [dbo].[SEEvaluateePlanType] ([EvaluateePlanTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluateePlanType2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType2]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEEvaluationType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEFrameworkNode3]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEFrameworkNode3] FOREIGN KEY([NextYearFocusedFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEFrameworkNode3]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEFrameworkNode3]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEFrameworkNode4]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEFrameworkNode4] FOREIGN KEY([NextYearFocusedSGFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEFrameworkNode4]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEFrameworkNode4]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEUser1] FOREIGN KEY([EvaluatorID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEUser1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEWfState]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SGFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SGFrameworkNode] FOREIGN KEY([FocusedSGFrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluation_SGFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluation]'))
ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SGFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationTypeRole_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]'))
ALTER TABLE [dbo].[SEEvaluationTypeRole]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationTypeRole_aspnet_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[aspnet_Roles] ([RoleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationTypeRole_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]'))
ALTER TABLE [dbo].[SEEvaluationTypeRole] CHECK CONSTRAINT [FK_SEEvaluationTypeRole_aspnet_Roles]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationTypeRole_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]'))
ALTER TABLE [dbo].[SEEvaluationTypeRole]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationTypeRole_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationTypeRole_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationTypeRole]'))
ALTER TABLE [dbo].[SEEvaluationTypeRole] CHECK CONSTRAINT [FK_SEEvaluationTypeRole_SEEvaluationType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationWfHistory_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory] CHECK CONSTRAINT [FK_SEEvaluationWfHistory_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationWfHistory_SEUser1] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory] CHECK CONSTRAINT [FK_SEEvaluationWfHistory_SEUser1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEWfTransition]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluationWfHistory_SEWfTransition] FOREIGN KEY([WfTransitionID])
REFERENCES [dbo].[SEWfTransition] ([WfTransitionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvaluationWfHistory_SEWfTransition]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvaluationWfHistory]'))
ALTER TABLE [dbo].[SEEvaluationWfHistory] CHECK CONSTRAINT [FK_SEEvaluationWfHistory_SEWfTransition]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvent_SEEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvent]'))
ALTER TABLE [dbo].[SEEvent]  WITH CHECK ADD  CONSTRAINT [FK_SEEvent_SEEventType] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[SEEventType] ([EventTypeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEEvent_SEEventType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEEvent]'))
ALTER TABLE [dbo].[SEEvent] CHECK CONSTRAINT [FK_SEEvent_SEEventType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFramework_SEFrameworkContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFramework]'))
ALTER TABLE [dbo].[SEFramework]  WITH CHECK ADD  CONSTRAINT [FK_SEFramework_SEFrameworkContext] FOREIGN KEY([FrameworkContextID])
REFERENCES [dbo].[SEFrameworkContext] ([FrameworkContextID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFramework_SEFrameworkContext]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFramework]'))
ALTER TABLE [dbo].[SEFramework] CHECK CONSTRAINT [FK_SEFramework_SEFrameworkContext]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNode_SEFramework] FOREIGN KEY([FrameworkID])
REFERENCES [dbo].[SEFramework] ([FrameworkID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode] CHECK CONSTRAINT [FK_SEFrameworkNode_SEFramework]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNode_SEFrameworkNode] FOREIGN KEY([ParentNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNode]'))
ALTER TABLE [dbo].[SEFrameworkNode] CHECK CONSTRAINT [FK_SEFrameworkNode_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_LearningWalkClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNodeScore_LearningWalkClassroomID] FOREIGN KEY([LearningWalkClassRoomID])
REFERENCES [dbo].[SELearningWalkClassRoom] ([LearningWalkClassRoomID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_LearningWalkClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] CHECK CONSTRAINT [FK_SEFrameworkNodeScore_LearningWalkClassroomID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNodeScore_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] CHECK CONSTRAINT [FK_SEFrameworkNodeScore_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNodeScore_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] CHECK CONSTRAINT [FK_SEFrameworkNodeScore_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNodeScore_SELinkedItemType] FOREIGN KEY([LinkedItemTypeID])
REFERENCES [dbo].[SELinkedItemType] ([LinkedItemTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] CHECK CONSTRAINT [FK_SEFrameworkNodeScore_SELinkedItemType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNodeScore_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] CHECK CONSTRAINT [FK_SEFrameworkNodeScore_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkNodeScore_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkNodeScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkNodeScore]'))
ALTER TABLE [dbo].[SEFrameworkNodeScore] CHECK CONSTRAINT [FK_SEFrameworkNodeScore_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkPerformanceLevel_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]'))
ALTER TABLE [dbo].[SEFrameworkPerformanceLevel]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkPerformanceLevel_SEFramework] FOREIGN KEY([FrameworkID])
REFERENCES [dbo].[SEFramework] ([FrameworkID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkPerformanceLevel_SEFramework]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]'))
ALTER TABLE [dbo].[SEFrameworkPerformanceLevel] CHECK CONSTRAINT [FK_SEFrameworkPerformanceLevel_SEFramework]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkPerformanceLevel_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]'))
ALTER TABLE [dbo].[SEFrameworkPerformanceLevel]  WITH CHECK ADD  CONSTRAINT [FK_SEFrameworkPerformanceLevel_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFrameworkPerformanceLevel_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEFrameworkPerformanceLevel]'))
ALTER TABLE [dbo].[SEFrameworkPerformanceLevel] CHECK CONSTRAINT [FK_SEFrameworkPerformanceLevel_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassRoom_PracticeSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassRoom]'))
ALTER TABLE [dbo].[SELearningWalkClassRoom]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassRoom_PracticeSessionID] FOREIGN KEY([PracticeSessionID])
REFERENCES [dbo].[SEPracticeSession] ([PracticeSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassRoom_PracticeSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassRoom]'))
ALTER TABLE [dbo].[SELearningWalkClassRoom] CHECK CONSTRAINT [FK_SELearningWalkClassRoom_PracticeSessionID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabel_SEPracticeSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabel]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabel]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassroomLabel_SEPracticeSession] FOREIGN KEY([PracticeSessionID])
REFERENCES [dbo].[SEPracticeSession] ([PracticeSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabel_SEPracticeSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabel]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabel] CHECK CONSTRAINT [FK_SELearningWalkClassroomLabel_SEPracticeSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom] FOREIGN KEY([ClassroomID])
REFERENCES [dbo].[SELearningWalkClassRoom] ([LearningWalkClassRoomID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship] CHECK CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassRoom]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship]  WITH CHECK ADD  CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel] FOREIGN KEY([LabelID])
REFERENCES [dbo].[SELearningWalkClassroomLabel] ([LabelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkClassroomLabelRelationship]'))
ALTER TABLE [dbo].[SELearningWalkClassroomLabelRelationship] CHECK CONSTRAINT [FK_SELearningWalkClassroomLabelRelationship_SELearningWalkClassroomLabel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_ClassroomID] FOREIGN KEY([ClassroomID])
REFERENCES [dbo].[SELearningWalkClassRoom] ([LearningWalkClassRoomID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_ClassroomID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PerformanceLevelID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_PerformanceLevelID] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PerformanceLevelID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_PerformanceLevelID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_SessionID] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_SessionID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore]  WITH CHECK ADD  CONSTRAINT [FK_SEUserID] FOREIGN KEY([SEUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SELearningWalkSessionScore]'))
ALTER TABLE [dbo].[SELearningWalkSessionScore] CHECK CONSTRAINT [FK_SEUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEEvent]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification]  WITH CHECK ADD  CONSTRAINT [FK_SENotification_SEEvent] FOREIGN KEY([EventId])
REFERENCES [dbo].[SEEvent] ([EventId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEEvent]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification] CHECK CONSTRAINT [FK_SENotification_SEEvent]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification]  WITH CHECK ADD  CONSTRAINT [FK_SENotification_SEUser] FOREIGN KEY([ReceiverUserId])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification] CHECK CONSTRAINT [FK_SENotification_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification]  WITH CHECK ADD  CONSTRAINT [FK_SENotification_SEUser1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SENotification_SEUser1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SENotification]'))
ALTER TABLE [dbo].[SENotification] CHECK CONSTRAINT [FK_SENotification_SEUser1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_AnchorSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_AnchorSessionID] FOREIGN KEY([AnchorSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_AnchorSessionID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] CHECK CONSTRAINT [FK_SEPracticeSession_AnchorSessionID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] CHECK CONSTRAINT [FK_SEPracticeSession_CreatedByUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_EvaluateeUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_EvaluateeUserID] FOREIGN KEY([EvaluateeUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_EvaluateeUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] CHECK CONSTRAINT [FK_SEPracticeSession_EvaluateeUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_PracticeSessionTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_PracticeSessionTypeID] FOREIGN KEY([PracticeSessionTypeID])
REFERENCES [dbo].[SEPracticeSessionType] ([PracticeSessionTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_PracticeSessionTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] CHECK CONSTRAINT [FK_SEPracticeSession_PracticeSessionTypeID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_SchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_SchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_SchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] CHECK CONSTRAINT [FK_SEPracticeSession_SchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_TrainingProtocolID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSession_TrainingProtocolID] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSession_TrainingProtocolID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSession]'))
ALTER TABLE [dbo].[SEPracticeSession] CHECK CONSTRAINT [FK_SEPracticeSession_TrainingProtocolID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_PracticeSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSessionParticipant_PracticeSession] FOREIGN KEY([PracticeSessionID])
REFERENCES [dbo].[SEPracticeSession] ([PracticeSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_PracticeSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant] CHECK CONSTRAINT [FK_SEPracticeSessionParticipant_PracticeSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSessionParticipant_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant] CHECK CONSTRAINT [FK_SEPracticeSessionParticipant_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant]  WITH CHECK ADD  CONSTRAINT [FK_SEPracticeSessionParticipant_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPracticeSessionParticipant_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPracticeSessionParticipant]'))
ALTER TABLE [dbo].[SEPracticeSessionParticipant] CHECK CONSTRAINT [FK_SEPracticeSessionParticipant_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPullQuote_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPullQuote]'))
ALTER TABLE [dbo].[SEPullQuote]  WITH CHECK ADD  CONSTRAINT [FK_SEPullQuote_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPullQuote_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPullQuote]'))
ALTER TABLE [dbo].[SEPullQuote] CHECK CONSTRAINT [FK_SEPullQuote_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPullQuote_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPullQuote]'))
ALTER TABLE [dbo].[SEPullQuote]  WITH CHECK ADD  CONSTRAINT [FK_SEPullQuote_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPullQuote_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPullQuote]'))
ALTER TABLE [dbo].[SEPullQuote] CHECK CONSTRAINT [FK_SEPullQuote_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOption_SEReportPrintOptionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOption]'))
ALTER TABLE [dbo].[SEReportPrintOption]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOption_SEReportPrintOptionType] FOREIGN KEY([ReportPrintOptionTypeID])
REFERENCES [dbo].[SEReportPrintOptionType] ([ReportPrintOptionTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOption_SEReportPrintOptionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOption]'))
ALTER TABLE [dbo].[SEReportPrintOption] CHECK CONSTRAINT [FK_SEReportPrintOption_SEReportPrintOptionType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvalSession_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvalSession_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvalSession] CHECK CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvalSession_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEReportPrintOption] FOREIGN KEY([ReportPrintOptionID])
REFERENCES [dbo].[SEReportPrintOption] ([ReportPrintOptionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvalSession_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvalSession]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvalSession] CHECK CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEReportPrintOption]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluatee_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SEReportPrintOption] FOREIGN KEY([ReportPrintOptionID])
REFERENCES [dbo].[SEReportPrintOption] ([ReportPrintOptionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluatee_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee] CHECK CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SEReportPrintOption]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluatee_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluatee_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluatee]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee] CHECK CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluation_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluation_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluation] CHECK CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluation_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEReportPrintOption] FOREIGN KEY([ReportPrintOptionID])
REFERENCES [dbo].[SEReportPrintOption] ([ReportPrintOptionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionEvaluation_SEReportPrintOption]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionEvaluation]'))
ALTER TABLE [dbo].[SEReportPrintOptionEvaluation] CHECK CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEReportPrintOption]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionUser_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionUser]'))
ALTER TABLE [dbo].[SEReportPrintOptionUser]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionUser_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportPrintOptionUser_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportPrintOptionUser]'))
ALTER TABLE [dbo].[SEReportPrintOptionUser] CHECK CONSTRAINT [FK_SEReportPrintOptionUser_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportSnapshot_SEReportType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]'))
ALTER TABLE [dbo].[SEReportSnapshot]  WITH CHECK ADD  CONSTRAINT [FK_SEReportSnapshot_SEReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[SEReportType] ([ReportTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportSnapshot_SEReportType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]'))
ALTER TABLE [dbo].[SEReportSnapshot] CHECK CONSTRAINT [FK_SEReportSnapshot_SEReportType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportSnapshot_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]'))
ALTER TABLE [dbo].[SEReportSnapshot]  WITH CHECK ADD  CONSTRAINT [FK_SEReportSnapshot_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEReportSnapshot_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEReportSnapshot]'))
ALTER TABLE [dbo].[SEReportSnapshot] CHECK CONSTRAINT [FK_SEReportSnapshot_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResource_ItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResource]'))
ALTER TABLE [dbo].[SEResource]  WITH CHECK ADD  CONSTRAINT [FK_SEResource_ItemType] FOREIGN KEY([ItemTypeID])
REFERENCES [dbo].[SEResourceItemType] ([ResourceItemTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResource_ItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResource]'))
ALTER TABLE [dbo].[SEResource] CHECK CONSTRAINT [FK_SEResource_ItemType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResourceRubricRowAlignment_SEResource]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]'))
ALTER TABLE [dbo].[SEResourceRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEResourceRubricRowAlignment_SEResource] FOREIGN KEY([ResourceId])
REFERENCES [dbo].[SEResource] ([ResourceId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResourceRubricRowAlignment_SEResource]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]'))
ALTER TABLE [dbo].[SEResourceRubricRowAlignment] CHECK CONSTRAINT [FK_SEResourceRubricRowAlignment_SEResource]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResourceRubricRowAlignment_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]'))
ALTER TABLE [dbo].[SEResourceRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEResourceRubricRowAlignment_SERubricRow] FOREIGN KEY([RubricRowId])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEResourceRubricRowAlignment_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEResourceRubricRowAlignment]'))
ALTER TABLE [dbo].[SEResourceRubricRowAlignment] CHECK CONSTRAINT [FK_SEResourceRubricRowAlignment_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowAnnotation_SEArtifactBundle] FOREIGN KEY([ArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] CHECK CONSTRAINT [FK_SERubricRowAnnotation_SEArtifactBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowAnnotation_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] CHECK CONSTRAINT [FK_SERubricRowAnnotation_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowAnnotation_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] CHECK CONSTRAINT [FK_SERubricRowAnnotation_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowAnnotation_SEUserID] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowAnnotation_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowAnnotation]'))
ALTER TABLE [dbo].[SERubricRowAnnotation] CHECK CONSTRAINT [FK_SERubricRowAnnotation_SEUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession] FOREIGN KEY([LinkedObservationID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvalSession1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession1] FOREIGN KEY([LinkedSelfAssessmentID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvalSession1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEEvalSession1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvidenceCollectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEEvidenceCollectionType] FOREIGN KEY([EvidenceCollectionTypeID])
REFERENCES [dbo].[SEEvidenceCollectionType] ([EvidenceCollectionTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEEvidenceCollectionType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEEvidenceCollectionType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SELinkedItemType] FOREIGN KEY([LinkedItemTypeID])
REFERENCES [dbo].[SELinkedItemType] ([LinkedItemTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SELinkedItemType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEStudentGrowthGoalBundle] FOREIGN KEY([LinkedStudentGrowthGoalBundleID])
REFERENCES [dbo].[SEStudentGrowthGoalBundle] ([StudentGrowthGoalBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEStudentGrowthGoalBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowEvaluation_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowEvaluation_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowEvaluation]'))
ALTER TABLE [dbo].[SERubricRowEvaluation] CHECK CONSTRAINT [FK_SERubricRowEvaluation_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowFrameworkNode_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode] CHECK CONSTRAINT [FK_SERubricRowFrameworkNode_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowFrameworkNode_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowFrameworkNode_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowFrameworkNode]'))
ALTER TABLE [dbo].[SERubricRowFrameworkNode] CHECK CONSTRAINT [FK_SERubricRowFrameworkNode_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_LearningWalkClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowScore_LearningWalkClassroomID] FOREIGN KEY([LearningWalkClassRoomID])
REFERENCES [dbo].[SELearningWalkClassRoom] ([LearningWalkClassRoomID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_LearningWalkClassroomID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] CHECK CONSTRAINT [FK_SERubricRowScore_LearningWalkClassroomID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowScore_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] CHECK CONSTRAINT [FK_SERubricRowScore_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowScore_SELinkedItemType] FOREIGN KEY([LinkedItemTypeID])
REFERENCES [dbo].[SELinkedItemType] ([LinkedItemTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SELinkedItemType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] CHECK CONSTRAINT [FK_SERubricRowScore_SELinkedItemType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowScore_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] CHECK CONSTRAINT [FK_SERubricRowScore_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SERubricRowScore_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SERubricRowScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SERubricRowScore]'))
ALTER TABLE [dbo].[SERubricRowScore] CHECK CONSTRAINT [FK_SERubricRowScore_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment]  WITH CHECK ADD  CONSTRAINT [FK_SESelfAssessment_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment] CHECK CONSTRAINT [FK_SESelfAssessment_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment]  WITH CHECK ADD  CONSTRAINT [FK_SESelfAssessment_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment] CHECK CONSTRAINT [FK_SESelfAssessment_SEEvaluationType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment]  WITH CHECK ADD  CONSTRAINT [FK_SESelfAssessment_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessment_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessment]'))
ALTER TABLE [dbo].[SESelfAssessment] CHECK CONSTRAINT [FK_SESelfAssessment_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessmentRubricRowFocus_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]'))
ALTER TABLE [dbo].[SESelfAssessmentRubricRowFocus]  WITH CHECK ADD  CONSTRAINT [FK_SESelfAssessmentRubricRowFocus_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessmentRubricRowFocus_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]'))
ALTER TABLE [dbo].[SESelfAssessmentRubricRowFocus] CHECK CONSTRAINT [FK_SESelfAssessmentRubricRowFocus_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessmentRubricRowFocus_SESelfAssessment]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]'))
ALTER TABLE [dbo].[SESelfAssessmentRubricRowFocus]  WITH CHECK ADD  CONSTRAINT [FK_SESelfAssessmentRubricRowFocus_SESelfAssessment] FOREIGN KEY([SelfAssessmentID])
REFERENCES [dbo].[SESelfAssessment] ([SelfAssessmentID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESelfAssessmentRubricRowFocus_SESelfAssessment]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESelfAssessmentRubricRowFocus]'))
ALTER TABLE [dbo].[SESelfAssessmentRubricRowFocus] CHECK CONSTRAINT [FK_SESelfAssessmentRubricRowFocus_SESelfAssessment]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPrompt_SEStudentGrowthFormPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthFormPrompt_SEStudentGrowthFormPromptType] FOREIGN KEY([FormPromptTypeID])
REFERENCES [dbo].[SEStudentGrowthFormPromptType] ([StudentGrowthFormPromptTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPrompt_SEStudentGrowthFormPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPrompt] CHECK CONSTRAINT [FK_SEStudentGrowthFormPrompt_SEStudentGrowthFormPromptType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] CHECK CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEEvaluationType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] CHECK CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] CHECK CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEStudentGrowthFormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEStudentGrowthFormPrompt] FOREIGN KEY([FormPromptID])
REFERENCES [dbo].[SEStudentGrowthFormPrompt] ([StudentGrowthFormPromptID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptFrameworkNode_SEStudentGrowthFormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptFrameworkNode]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptFrameworkNode] CHECK CONSTRAINT [FK_SEStudentGrowthFormPromptFrameworkNode_SEStudentGrowthFormPrompt]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFormPromptResponse_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEFormPromptResponse_SEStudentGrowthGoal] FOREIGN KEY([StudentGrowthGoalID])
REFERENCES [dbo].[SEStudentGrowthGoal] ([StudentGrowthGoalID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFormPromptResponse_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] CHECK CONSTRAINT [FK_SEFormPromptResponse_SEStudentGrowthGoal]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFormPromptResponse_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEFormPromptResponse_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEFormPromptResponse_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] CHECK CONSTRAINT [FK_SEFormPromptResponse_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptResponse_SEStudentGrowthFormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthFormPromptResponse_SEStudentGrowthFormPrompt] FOREIGN KEY([FormPromptID])
REFERENCES [dbo].[SEStudentGrowthFormPrompt] ([StudentGrowthFormPromptID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthFormPromptResponse_SEStudentGrowthFormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthFormPromptResponse]'))
ALTER TABLE [dbo].[SEStudentGrowthFormPromptResponse] CHECK CONSTRAINT [FK_SEStudentGrowthFormPromptResponse_SEStudentGrowthFormPrompt]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEArtifactBundle] FOREIGN KEY([ProcessArtifactBundleID])
REFERENCES [dbo].[SEArtifactBundle] ([ArtifactBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEArtifactBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEArtifactBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel] FOREIGN KEY([ProcessPerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricPerformanceLevel1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel1] FOREIGN KEY([ResultsPerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricPerformanceLevel1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricPerformanceLevel1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricRowProcess]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowProcess] FOREIGN KEY([ProcessRubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricRowProcess]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowProcess]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricRowResults]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowResults] FOREIGN KEY([ResultsRubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SERubricRowResults]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SERubricRowResults]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle] FOREIGN KEY([GoalBundleID])
REFERENCES [dbo].[SEStudentGrowthGoalBundle] ([StudentGrowthGoalBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoal_SEStudentGrowthGoalBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundle_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundle_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundle_SEWfState1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState1] FOREIGN KEY([EvalWfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundle_SEWfState1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundle]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundle] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundle_SEWfState1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal] FOREIGN KEY([GoalID])
REFERENCES [dbo].[SEStudentGrowthGoal] ([StudentGrowthGoalID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoal]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle] FOREIGN KEY([BundleID])
REFERENCES [dbo].[SEStudentGrowthGoalBundle] ([StudentGrowthGoalBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleGoal]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleGoal] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundleGoal_SEStudentGrowthGoalBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleRubricRowAlignment_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundleRubricRowAlignment_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleRubricRowAlignment_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundleRubricRowAlignment_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleRubricRowAlignment_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthGoalBundleRubricRowAlignment_SEStudentGrowthGoalBundle] FOREIGN KEY([StudentGrowthGoalBundleID])
REFERENCES [dbo].[SEStudentGrowthGoalBundle] ([StudentGrowthGoalBundleID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthGoalBundleRubricRowAlignment_SEStudentGrowthGoalBundle]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthGoalBundleRubricRowAlignment]'))
ALTER TABLE [dbo].[SEStudentGrowthGoalBundleRubricRowAlignment] CHECK CONSTRAINT [FK_SEStudentGrowthGoalBundleRubricRowAlignment_SEStudentGrowthGoalBundle]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettings]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettings] CHECK CONSTRAINT [FK_SEStudentGrowthProcessSettings_SEEvaluationType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettings]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettings]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettings] CHECK CONSTRAINT [FK_SEStudentGrowthProcessSettings_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_FormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_FormPrompt] FOREIGN KEY([FormPromptID])
REFERENCES [dbo].[SEStudentGrowthFormPrompt] ([StudentGrowthFormPromptID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_FormPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt] CHECK CONSTRAINT [FK_SEStudentGrowthProcessSettings_FormPrompt]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_Settings]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEStudentGrowthProcessSettings_Settings] FOREIGN KEY([ProcessSettingsID])
REFERENCES [dbo].[SEStudentGrowthProcessSettings] ([StudentGrowthProcessSettingsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEStudentGrowthProcessSettings_Settings]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEStudentGrowthProcessSettingsFormPrompt]'))
ALTER TABLE [dbo].[SEStudentGrowthProcessSettingsFormPrompt] CHECK CONSTRAINT [FK_SEStudentGrowthProcessSettings_Settings]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] CHECK CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] CHECK CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeFrameworkNodeScore_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] CHECK CONSTRAINT [FK_SESummativeFrameworkNodeScore_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeFrameworkNodeScore_SEUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeFrameworkNodeScore]'))
ALTER TABLE [dbo].[SESummativeFrameworkNodeScore] CHECK CONSTRAINT [FK_SESummativeFrameworkNodeScore_SEUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeRubricRowScore_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SEEvaluation]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] CHECK CONSTRAINT [FK_SESummativeRubricRowScore_SEEvaluation]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeRubricRowScore_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] CHECK CONSTRAINT [FK_SESummativeRubricRowScore_SERubricPerformanceLevel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeRubricRowScore_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] CHECK CONSTRAINT [FK_SESummativeRubricRowScore_SERubricRow]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore]  WITH CHECK ADD  CONSTRAINT [FK_SESummativeRubricRowScore_SEUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SESummativeRubricRowScore_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SESummativeRubricRowScore]'))
ALTER TABLE [dbo].[SESummativeRubricRowScore] CHECK CONSTRAINT [FK_SESummativeRubricRowScore_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocol_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]'))
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocol_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
REFERENCES [dbo].[SEFrameworkNode] ([FrameworkNodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocol_SEFrameworkNode]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]'))
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] CHECK CONSTRAINT [FK_SETrainingProtocol_SEFrameworkNode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocol_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]'))
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocol_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocol_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolFrameworkNodeAlignment]'))
ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] CHECK CONSTRAINT [FK_SETrainingProtocol_SETrainingProtocol]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabel]'))
ALTER TABLE [dbo].[SETrainingProtocolLabel]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup] FOREIGN KEY([TrainingProtocolLabelGroupID])
REFERENCES [dbo].[SETrainingProtocolLabelGroup] ([TrainingProtocolLabelGroupID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabel]'))
ALTER TABLE [dbo].[SETrainingProtocolLabel] CHECK CONSTRAINT [FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabelAssignment_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]'))
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabelAssignment_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]'))
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] CHECK CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocol]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]'))
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel] FOREIGN KEY([TrainingProtocolLabelID])
REFERENCES [dbo].[SETrainingProtocolLabel] ([TrainingProtocolLabelID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolLabelAssignment]'))
ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] CHECK CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolPlaylist_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]'))
ALTER TABLE [dbo].[SETrainingProtocolPlaylist]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolPlaylist_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolPlaylist_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]'))
ALTER TABLE [dbo].[SETrainingProtocolPlaylist] CHECK CONSTRAINT [FK_SETrainingProtocolPlaylist_SETrainingProtocol]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolPlaylist_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]'))
ALTER TABLE [dbo].[SETrainingProtocolPlaylist]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolPlaylist_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolPlaylist_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolPlaylist]'))
ALTER TABLE [dbo].[SETrainingProtocolPlaylist] CHECK CONSTRAINT [FK_SETrainingProtocolPlaylist_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolRating_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]'))
ALTER TABLE [dbo].[SETrainingProtocolRating]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolRating_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolRating_SETrainingProtocol]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]'))
ALTER TABLE [dbo].[SETrainingProtocolRating] CHECK CONSTRAINT [FK_SETrainingProtocolRating_SETrainingProtocol]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolRating_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]'))
ALTER TABLE [dbo].[SETrainingProtocolRating]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolRating_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SETrainingProtocolRating_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SETrainingProtocolRating]'))
ALTER TABLE [dbo].[SETrainingProtocolRating] CHECK CONSTRAINT [FK_SETrainingProtocolRating_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUser_aspnet_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUser]'))
ALTER TABLE [dbo].[SEUser]  WITH CHECK ADD  CONSTRAINT [FK_SEUser_aspnet_Users] FOREIGN KEY([ASPNetUserID])
REFERENCES [dbo].[aspnet_Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUser_aspnet_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUser]'))
ALTER TABLE [dbo].[SEUser] CHECK CONSTRAINT [FK_SEUser_aspnet_Users]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserActivity_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserActivity]'))
ALTER TABLE [dbo].[SEUserActivity]  WITH CHECK ADD  CONSTRAINT [FK_UserActivity_SEUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserActivity_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserActivity]'))
ALTER TABLE [dbo].[SEUserActivity] CHECK CONSTRAINT [FK_UserActivity_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserDistrictSchool_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserDistrictSchool]'))
ALTER TABLE [dbo].[SEUserDistrictSchool]  WITH CHECK ADD  CONSTRAINT [FK_SEUserDistrictSchool_SEUser] FOREIGN KEY([SEUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserDistrictSchool_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserDistrictSchool]'))
ALTER TABLE [dbo].[SEUserDistrictSchool] CHECK CONSTRAINT [FK_SEUserDistrictSchool_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserLocationRole_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]'))
ALTER TABLE [dbo].[SEUserLocationRole]  WITH CHECK ADD  CONSTRAINT [FK_SEUserLocationRole_aspnet_Roles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[aspnet_Roles] ([RoleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserLocationRole_aspnet_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]'))
ALTER TABLE [dbo].[SEUserLocationRole] CHECK CONSTRAINT [FK_SEUserLocationRole_aspnet_Roles]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserLocationRole_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]'))
ALTER TABLE [dbo].[SEUserLocationRole]  WITH CHECK ADD  CONSTRAINT [FK_SEUserLocationRole_SEUser] FOREIGN KEY([SEUserId])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserLocationRole_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserLocationRole]'))
ALTER TABLE [dbo].[SEUserLocationRole] CHECK CONSTRAINT [FK_SEUserLocationRole_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt]  WITH NOCHECK ADD  CONSTRAINT [FK_SEUserPrompt_CreatedByUserID] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_CreatedByUserID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_CreatedByUserID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SEEvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEEvaluationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SEEvaluationType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEUserPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEUserPromptType] FOREIGN KEY([PromptTypeID])
REFERENCES [dbo].[SEUserPromptType] ([UserPromptTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEUserPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SEUserPromptType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPrompt_SEWfState] FOREIGN KEY([WfStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPrompt_SEWfState]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPrompt]'))
ALTER TABLE [dbo].[SEUserPrompt] CHECK CONSTRAINT [FK_SEUserPrompt_SEWfState]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault]  WITH CHECK ADD  CONSTRAINT [FKSEUserPromptConferenceDefault_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] CHECK CONSTRAINT [FKSEUserPromptConferenceDefault_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUserPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault]  WITH CHECK ADD  CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPrompt] FOREIGN KEY([UserPromptID])
REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUserPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] CHECK CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPrompt]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUserPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault]  WITH CHECK ADD  CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPromptType] FOREIGN KEY([UserPromptTypeID])
REFERENCES [dbo].[SEUserPromptType] ([UserPromptTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FKSEUserPromptConferenceDefault_SEUserPromptType]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptConferenceDefault]'))
ALTER TABLE [dbo].[SEUserPromptConferenceDefault] CHECK CONSTRAINT [FKSEUserPromptConferenceDefault_SEUserPromptType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_EvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_EvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_EvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_EvalSession]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SESchoolYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_SESchoolYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SEUserPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponse_SEUserPrompt] FOREIGN KEY([UserPromptID])
REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponse_SEUserPrompt]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponse]'))
ALTER TABLE [dbo].[SEUserPromptResponse] CHECK CONSTRAINT [FK_SEUserPromptResponse_SEUserPrompt]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponseEntry_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]'))
ALTER TABLE [dbo].[SEUserPromptResponseEntry]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponseEntry_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponseEntry_SEUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]'))
ALTER TABLE [dbo].[SEUserPromptResponseEntry] CHECK CONSTRAINT [FK_SEUserPromptResponseEntry_SEUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponseEntry_SEUserPromptResponse]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]'))
ALTER TABLE [dbo].[SEUserPromptResponseEntry]  WITH CHECK ADD  CONSTRAINT [FK_SEUserPromptResponseEntry_SEUserPromptResponse] FOREIGN KEY([UserPromptResponseID])
REFERENCES [dbo].[SEUserPromptResponse] ([UserPromptResponseID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEUserPromptResponseEntry_SEUserPromptResponse]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptResponseEntry]'))
ALTER TABLE [dbo].[SEUserPromptResponseEntry] CHECK CONSTRAINT [FK_SEUserPromptResponseEntry_SEUserPromptResponse]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]'))
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [fk_RubricRowID] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_RubricRowID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]'))
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] CHECK CONSTRAINT [fk_RubricRowID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_UserPromptID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]'))
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment]  WITH CHECK ADD  CONSTRAINT [fk_UserPromptID] FOREIGN KEY([UserPromptID])
REFERENCES [dbo].[SEUserPrompt] ([UserPromptID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_UserPromptID]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEUserPromptRubricRowAlignment]'))
ALTER TABLE [dbo].[SEUserPromptRubricRowAlignment] CHECK CONSTRAINT [fk_UserPromptID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition]  WITH CHECK ADD  CONSTRAINT [FK_SEWfTransition_SEWfState1] FOREIGN KEY([StartStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState1]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] CHECK CONSTRAINT [FK_SEWfTransition_SEWfState1]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition]  WITH CHECK ADD  CONSTRAINT [FK_SEWfTransition_SEWfState2] FOREIGN KEY([EndStateID])
REFERENCES [dbo].[SEWfState] ([WfStateID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEWfTransition_SEWfState2]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEWfTransition]'))
ALTER TABLE [dbo].[SEWfTransition] CHECK CONSTRAINT [FK_SEWfTransition_SEWfState2]
GO
