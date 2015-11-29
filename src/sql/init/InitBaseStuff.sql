-- select 'INSERT EmailDeliveryType(Name) VALUE(''' + Name + ''')' from emaildeliverytype

INSERT SEStudentGrowthFormPromptType(Name) VALUES('Goal Setting')
INSERT SEStudentGrowthFormPromptType(Name) VALUES('Goal Monitoring')
INSERT SEStudentGrowthFormPromptType(Name) VALUES('Goal Review')

INSERT SEEvidenceCollectionType(Name) VALUES('Other Evidence')
INSERT SEEvidenceCollectionType(Name) VALUES('Observation')
INSERT SEEvidenceCollectionType(Name) VALUES('Self-Assessment')
INSERT SEEvidenceCollectionType(Name) VALUES('Student Growth Goals')
INSERT SEEvidenceCollectionType(Name) VALUES('Summative')

INSERT SEEvidenceType(Name) VALUES('Artifact')
INSERT SEEvidenceType(Name) VALUES('Observation Notes')
INSERT SEEvidenceType(Name) VALUES('Pre-Conference Prompt')
INSERT SEEvidenceType(Name) VALUES('Pre-Conference Summary')
INSERT SEEvidenceType(Name) VALUES('Post-Conference Prompt')
INSERT SEEvidenceType(Name) VALUES('Post-Conference Summary')
INSERT SEEvidenceType(Name) VALUES('Student Growh Goal')

INSERT EmailDeliveryType(Name) VALUES('None')
INSERT EmailDeliveryType(Name) VALUES('Individual')
INSERT EmailDeliveryType(Name) VALUES('Nightly Digest')
INSERT EmailDeliveryType(Name) VALUES('Weekly Digest')

-- select 'INSERT SEAnchorType(Name) VALUES(''' + Name + ''')' from SEAnchorType

INSERT SEAnchorType (Name) VALUES('Live')
INSERT SEAnchorTYpe (Name) VALUES('Library Client')
INSERT SEAnchorTYpe (Name) VALUES('Library')

-- select 'INSERT SEArtifactBundleRejectionType(Name) VALUES(''' + Name + ''')' from SEArtifactBundleRejectionType

INSERT SEArtifactBundleRejectionType(Name) VALUES('NON_ESSENTIAL')
INSERT SEArtifactBundleRejectionType(Name) VALUES('REQUEST_REFINEMENT')
INSERT SEArtifactBundleRejectionType(Name) VALUES('OTHER')

-- select 'INSERT SEArtifactLibItemType(Name) VALUES(''' + Name + ''')' from SEArtifactLibItemType

INSERT SEArtifactLibItemType(Name) VALUES('FILE')
INSERT SEArtifactLibItemType(Name) VALUES('WEB')
INSERT SEArtifactLibItemType(Name) VALUES('PROF-PRACTICE')

-- select 'INSERT SEArtifactType(Name) VALUES(''' + Name + ''')' from SEArtifactType

INSERT SEArtifactType(Name) VALUES('STANDARD')
INSERT SEArtifactType(Name) VALUES('STUDENT_GROWTH_GOAL')
INSERT SEArtifactType(Name) VALUES('OBSERVATION')

-- select 'INSERT SEEvalAssignmentRequestStatusType(Name) VALUES(''' + Name + ''')' from SEEvalAssignmentRequestStatusType

INSERT SEEvalAssignmentRequestStatusType(Name) VALUES('Pending')
INSERT SEEvalAssignmentRequestStatusType(Name) VALUES('Accepted')
INSERT SEEvalAssignmentRequestStatusType(Name) VALUES('Rejected')

-- select 'INSERT SEEvalAssignmentRequestType(Name) VALUES(''' + Name + ''')' from SEEvalAssignmentRequestType

INSERT SEEvalAssignmentRequestType(Name) VALUES('Observations Only')
INSERT SEEvalAssignmentRequestType(Name) VALUES('Assigned Evaluator')

-- select 'INSERT SEEvaluateePlanType(Name) VALUES(''' + Name + ''')' from SEEvaluateePlanType

INSERT SEEvaluateePlanType(Name) VALUES('Comprehensive')
INSERT SEEvaluateePlanType(Name) VALUES('Focused')

-- select 'INSERT SEEvaluationScoreType(Name) VALUES(''' + Name + ''')' from SEEvaluationScoreType

INSERT SEEvaluationScoreType(Name) VALUES('Standard')
INSERT SEEvaluationScoreType(Name) VALUES('Anchor')
INSERT SEEvaluationScoreType(Name) VALUES('DriftDetect')

-- select 'INSERT SEEvaluationType(Name) VALUES(''' + Name + ''')' from SEEvaluationType

INSERT SEEvaluationType(Name) VALUES('Principal')
INSERT SEEvaluationType(Name) VALUES('Teacher')

-- select 'INSERT SEEventType(Name) VALUES(''' + Name + ''')' from SEEventType
INSERT SEEventType(Name) VALUES('Observation Created')
INSERT SEEventType(Name) VALUES('Artifact Submitted')
INSERT SEEventType(Name) VALUES('Artifact Rejected')

--select * from SERubricPerformanceLevel

INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Unsatisfactory', '', 1)
INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Basic', '', 2)
INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Proficient', '', 3)
INSERT SERubricPerformanceLevel(Name, Description, Sequence) VALUES('Distinguished', '', 4)

-- select 'INSERT SEFrameworkViewType(Name) VALUES(''' + Name + ''')' from SEFrameworkViewType
INSERT SEFrameworkViewType(Name) VALUES('State Framework Only')
INSERT SEFrameworkViewType(Name) VALUES('State Framework Default')
INSERT SEFrameworkViewType(Name) VALUES('Instructional Framework Default')
INSERT SEFrameworkViewType(Name) VALUES('Instructional Framework Only')

-- select 'INSERT SELinkedItemType(Name) VALUES(''' + Name + ''')' from SELinkedItemType
INSERT SELinkedItemType(Name) VALUES('ARTIFACT')
INSERT SELinkedItemType(Name) VALUES('OBSERVATION')
INSERT SELinkedItemType(Name) VALUES('SELF_ASSESSMENT')
INSERT SELinkedItemType(Name) VALUES('STUDENT_GROWTH_GOAL')

-- select 'INSERT SEPracticeSessionType(Name) VALUES(''' + Name + ''')' from SEPracticeSessionType
INSERT SEPracticeSessionType(Name) VALUES('Learning Walks')
INSERT SEPracticeSessionType(Name) VALUES('LIVE')
INSERT SEPracticeSessionType(Name) VALUES('VIDEO')

-- select 'INSERT SEReportPrintOptionType(Name) VALUES(''' + Name + ''')' from SEReportPrintOptionType
INSERT SEReportPrintOptionType(Name) VALUES('FINAL_OBSERVATION')
INSERT SEReportPrintOptionType(Name) VALUES('FINAL_SELF_ASSESSMENT')
INSERT SEReportPrintOptionType(Name) VALUES('FINAL_FINAL')
INSERT SEReportPrintOptionType(Name) VALUES('FINAL_GLOBAL')
INSERT SEReportPrintOptionType(Name) VALUES('DISCREPANCY_OBSERVATION')
INSERT SEReportPrintOptionType(Name) VALUES('DISCREPANCY_SELF_ASSESSMENT')
INSERT SEReportPrintOptionType(Name) VALUES('DISCREPANCY_GLOBAL')
INSERT SEReportPrintOptionType(Name) VALUES('OBSERVATION_OBSERVATION')
INSERT SEReportPrintOptionType(Name) VALUES('OBSERVATION_GLOBAL')
INSERT SEReportPrintOptionType(Name) VALUES('SELFASSESS_ASSESS')
INSERT SEReportPrintOptionType(Name) VALUES('SELFASSESS_GLOBAL')
INSERT SEReportPrintOptionType(Name) VALUES('ARTIFACTS_GLOBAL')
INSERT SEReportPrintOptionType(Name) VALUES('STUDENT_GROWTH_GLOBAL')
INSERT SEReportPrintOptionType(Name) VALUES('PROF_DEV_GLOBAL')

-- select 'INSERT SEReportType(Name) VALUES(''' + Name + ''')' from SEReportType
INSERT SEReportType(Name) VALUES('Final')
INSERT SEReportType(Name) VALUES('Observation')
INSERT SEReportType(Name) VALUES('SelfAssessment')
INSERT SEReportType(Name) VALUES('Discrepancy')

-- select 'INSERT SEResourceItemType(Name) VALUES(''' + Name + ''')' from SEResourceItemType
INSERT SEResourceItemType(Name) VALUES('FILE')
INSERT SEResourceItemType(Name) VALUES('WEB')

INSERT SESchoolYear(SchoolYear, Description, YearRange) VALUES(2015, '2014-2015 School Year', '2014-2015')
INSERT SESchoolYear(SchoolYear, Description, YearRange) VALUES(2016, '2015-2016 School Year', '2015-2016')

-- select 'INSERT SETrainingProtocolRatingStatusType(Name) VALUES(''' + Name + ''')' from SETrainingProtocolRatingStatusType
INSERT SETrainingProtocolRatingStatusType(Name) VALUES('InReview')
INSERT SETrainingProtocolRatingStatusType(Name) VALUES('Approved')
INSERT SETrainingProtocolRatingStatusType(Name) VALUES('Inappropriate')

-- select 'INSERT SEUserPromptType(Name) VALUES(''' + Name + ''')' from SEUserPromptType
INSERT SEUserPromptType(Name) VALUES('Pre-Conference')
INSERT SEUserPromptType(Name) VALUES('Post-Conference')

-- select 'INSERT SEWfState(Name) VALUES(''' + ShortName + ''')' from SEWfState


INSERT SEWfState(Name) VALUES('DRAFT')
INSERT SEWfState(Name) VALUES('READY_FOR_CONFERENCE')
INSERT SEWfState(Name) VALUES('READY_FOR_FORMAL_RECEIPT')
INSERT SEWfState(Name) VALUES('RECEIVED')
INSERT SEWfState(Name) VALUES('SUBMITTED')

INSERT SEWfState(Name) VALUES('ARTIFACT')
INSERT SEWfState(Name) VALUES('ARTIFACT REJECTED')
INSERT SEWfState(Name) VALUES('ARTIFACT SUBMITTED')
INSERT SEWfState(Name) VALUES('GOAL_BUNDLE_IN_PROGRESS')
INSERT SEWfState(Name) VALUES('GOAL_BUNDLE_PROCESS_SUBMITTED')

INSERT SEWfState(Name) VALUES('GOAL_BUNDLE_RESULTS_SUBMITTED')
INSERT SEWfState(Name) VALUES('GOAL_BUNDLE_NOT_SCORED')
INSERT SEWfState(Name) VALUES('GOAL_BUNDLE_PROCESS_SCORED')
INSERT SEWfState(Name) VALUES('GOAL_BUNDLE_RESULTS_SCORED')
INSERT SEWfState(Name) VALUES('OBS IN-PROGRESS TOR')

INSERT SEWfState(Name) VALUES('OBS SUBMITTED TOR')
INSERT SEWfState(Name) VALUES('ARTIFACT_EVALUATED')
INSERT SEWfState(Name) VALUES('UNUSED')
INSERT SEWfState(Name) VALUES('RREVAL_NOT_STARTED')
INSERT SEWfState(Name) VALUES('RREVAL_IN_PROGRESS')

INSERT SEWfState(Name) VALUES('RREVAL_DONE')
INSERT SEWfState(Name) VALUES('USERPROMPT_IN_PROGRESS')
INSERT SEWfState(Name) VALUES('USERPROMPT_FINALIZED')
INSERT SEWfState(Name) VALUES('USERPROMPT_RETIRED')
INSERT SEWfState(Name) VALUES('SG_GOAL_SETUP_IN_PROGRESS')
INSERT SEWfState(Name) VALUES('SG_GOAL_SETUP_DONE')

--select 'INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(' + CONVERT(VARCHAR, StartStateID)  + ', ' + CONVERT(VARCHAR, EndStateID) + ')' from SEWfTransition

INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(6, 7, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(14, 15, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(15, 14, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(9, 10, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(10, 9, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(10, 12, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(11, 9, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(12, 9, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(1, 2, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(2, 3, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(3, 4, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(3, 5, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(4, 5, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(2, 1, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(3, 1, '')
INSERT SEWfTransition(StartStateID, EndStateID, Description) VALUES(5, 1, '')


 

