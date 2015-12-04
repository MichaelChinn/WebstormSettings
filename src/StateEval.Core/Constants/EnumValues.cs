using System;
using System.Collections.Generic;

namespace StateEval.Core.Constants
{
    public enum SEStudentGrowthFormPromptTypeEnum
    {
        UNDEFINED = 0,
        GOAL_SETTING,
        GOAL_MONITORING,
        GOAL_REVIEW
    }

    public enum SEEvidenceCollectionTypeEnum
    {
        OTHER_EVIDENCE = 1,
        OBSERVATION,
        SELF_ASSESSMENT,
        STUDENT_GROWTH_GOALS,
        SUMMATIVE
    }

    public enum SEEvidenceTypeEnum
    {
        UNDEFINED = 0,
        ARTIFACT,
        RR_ANNOTATION_OBSERVATION_NOTES,
        RR_ANNOTATION_PRECONF_PROMPT,
        RR_ANNOTATION_PRECONF_SUMMARY,
        RR_ANNOTATION_POSTCONF_PROMPT,
        RR_ANNOTATION_POSTCONF_SUMMARY,
        STUDENT_GROWTH_GOAL
    }

    public enum SERubricRowAnnotationTypeEnum
    {
        UNDEFINED = 0,
        OBSERVATION_NOTES,
        ARTIFACT_ALIGNMENT,
        ADDITIONAL_INPUT,
        PRE_CONF_QUESTION,
        PRE_CONF_MEETING,
        ARTIFACT_GENERAL
    }

    public enum SEArtifactBundleRejectionTypeEnum
    {
        UNDEFINED = 0,
        NON_ESSENTIAL,
        REQUEST_REFINEMENT,
        OTHER
    }

    public enum SELinkedItemTypeEnum
    {
        UNDEFINED = 0,
        ARTIFACT = 1,
        OBSERVATION,
        SELF_ASSESSMENT,
        STUDENT_GROWTH_GOAL
    }
    public enum SEStudentGrowthGoalProcessType
    {
        UNDEFINED = 0,
        DEFAULT_FORM,
        DISTRICT_INLINE_FORM,
        DISTRICT_OFFLINE_FORM
    }

    public enum SEArtifactLibItemType
    {
        UNDEFINED = 0,
        FILE = 1,
        WEB = 2,
        PROF_PRACTICE = 3
    }
    public enum SERubricEvidenceType
    {
        UNDEFINED = 0,
        DESCRIPTOR = 1,
        CRITICAL_ATTRIBUTE = 2

    }
    public enum SEViewerType
    {
        UNDEFINED = 0,
        EVALUATEE,
        ASSIGNED_EVALUATOR,
        VIEWER,
    }

    public enum SEWfTransition
    {
        UNDEFINED = 0,
        DRAFT_CONFERENCE,
        CONFERENCE_READYFORRECEIPT,
        READYFORRECEIPT_RECEIVED,
        READYFORRECEIPT_SUBMITTED,
        RECEIVED_SUBMITTED,
        CONFERENCE_DRAFT,
        READYFORRECEIPT_DRAFT,
        SUBMITTED_DRAFT,
        ARTIFACT_PRIVATE_EVIDENCE,
        PRIVATE_EVIDENCE_PUBLIC_EVIDENCE,
        GOAL_IN_PROGRESS_GOAL_SUBMITTED,
        GOAL_BUNDLE_IN_PROGRESS_GOAL_BUNDLE_SUBMITTED
    }

    public enum SEWfStateEnum
    {
        UNDEFINED = 0,
        DRAFT = 1,
        READY_FOR_CONFERENCE,
        READY_FOR_FORMAL_RECEIPT,
        RECEIVED,
        SUBMITTED = 5,

        ARTIFACT,
        ARTIFACT_REJECTED,
        ARTIFACT_SUBMITTED,
        GOAL_BUNDLE_IN_PROGRESS,
        GOAL_BUNDLE_PROCESS_SUBMITTED = 10,

        GOAL_BUNDLE_RESULTS_SUBMITTED,
        GOAL_BUNDLE_NOT_SCORED,
        GOAL_BUNDLE_PROCESS_SCORED,
        GOAL_BUNDLE_RESULTS_SCORED,
        OBS_IN_PROGRESS_TOR = 15,

        OBS_SUBMITTED_TOR,
        ARTIFACT_EVALUATED,
        GOAL_BUNDLE_EVALUATED,
        RUBRICROWEVAL_NOT_STARTED_OBSOLETE,
        RUBRICROWEVAL_IN_PROGRESS_OBSOLETE = 20,

        RUBRICROWEVAL_DONE_OBSOLELETE,
        USERPROMPT_IN_PROGRESS,
        USERPROMPT_FINALIZED,
        USERPROMPT_RETIRED,
        SG_GOAL_SETUP_IN_PROGRESS,
        SG_GOAL_SETUP_DONE
    }

    public enum SEEvaluateeSubmissionRetrievalType
    {
        Submitted = 1,
        NotSubmitted,
        All
    }

    public enum SEActiveEvaluationRole
    {
        UNDEFINED = 0,
        PR_PR,
        PR_TR,
        DE_PR,
        DTE_TR,
        DA_PR,
        SA_TR
    }

    //public class SETrainingProtocolRatingStatusTypeCompare : IComparer<SETrainingProtocolRatingStatusType>
    //{
    //    public int Compare(SETrainingProtocolRatingStatusType x, SETrainingProtocolRatingStatusType y)
    //    {
    //        return String.Compare(SETrainingProtocolRating.StatusAsString(x), SETrainingProtocolRating.StatusAsString(y));
    //    }
    //}

    public enum SETrainingProtocolRatingStatusType
    {
        UNDEFINED = 0,
        INREVIEW,
        APPROVED,
        INAPPROPRIATE_CONTENT
    }

    public enum SETrainingProtocolLabelGroupType
    {
        UNDEFINED = 0,
        SUBJECT_AREA,
        GRADE_LEVEL,
        STRATEGY_AREA,
        PROVIDED_BY
    }

    public enum EmailDeliveryType
    {
        UNDEFINED = 0,
        NONE,
        INDIVIDUAL,
        NIGHTLY_DIGEST,
        WEEKLY_DIGEST,
    }

    public enum SENotesEditorToolbarFlag
    {
        UNDEFINED = 0,
        SHOW_STATE_CRITERIA,
        SHOW_INSTRUCTIONAL_CRITERIA,
    }

    public enum SEReportPrintOptionType
    {
        UNDEFINED = 0,
        FINAL_OBSERVATION,
        FINAL_SELF_ASSESSMENT,
        FINAL_EVALUATION,
        FINAL_GLOBAL,
        DISCREPANCY_OBSERVATION,
        DISCREPANCY_SELF_ASSESSMENT,
        DISCREPANCY_GLOBAL,
        OBSERVATION_OBSERVATION,
        OBSERVATION_GLOBAL,
        SELFASSESS_ASSESS,
        SELFASSESS_GLOBAL,
        ARTIFACT_GLOBAL,
        STUDENT_GROWTH_GLOBAL,
        PROF_DEV_GLOBAL,
    }

    public enum SEReportType
    {
        UNDEFINED = 0,
        FINAL,
        OBSERVATION,
        SELF_ASSESSMENT,
        DISCREPANCY,
        ARTIFACT,
        STUDENT_GROWTH,
        PROF_DEV,
        SUMMATIVE_SCORE,
        DISTRICT_SUMMATIVE_SCORE
    }

    public enum SEEvalRequestTypeEnum
    {
        UNDEFINED = 0,
        OBSERVATION_ONLY,
        ASSIGNED_EVALUATOR
    }

    public enum SEEvalRequestStatusEnum
    {
        UNDEFINED = 0,
        PENDING,
        ACCEPTED,
        REJECTED,
    }

    public enum SESchoolYearEnum
    {
        UNDEFINED = 0,
        SY_2012 = 2012,
        SY_2013 = 2013,
        SY_2014 = 2014,
        SY_2015 = 2015,
        SY_2016 = 2016
    }
        
	public enum SEFinalPerformanceLevel
	{
		UNDEFINED = 0,
		L1,
		L2,
		L3,
		L4
	}

    public enum SERubricPerformanceLevelEnum
	{
		UNDEFINED = 0,
		PL1,
		PL2,
		PL3,
		PL4
	}

	public enum SEFrameworkViewTypeEnum
	{
		UNDEFINED = 0,
		STATE_FRAMEWORK_ONLY,
		STATE_FRAMEWORK_DEFAULT,
		INSTRUCTIONAL_FRAMEWORK_DEFAULT,
        INSTRUCTION_FRAMEWORK_ONLY
	}

	public enum SEEvaluationTypeEnum
	{
		UNDEFINED = 0,
		PRINCIPAL,
		TEACHER
	}

	public enum SEEvaluationScoreType
	{
		UNDEFINED = 0,
		STANDARD,
		ANCHOR,
		DRIFT_DETECT
	}

	public enum SEAnchorType
	{
		UNDEFINED = 0,
		LIVE,
		LIBRARY_CLIENT,
	}

    public enum SEPracticeSessionType
    {
        UNDEFINED = 0,
        LIVE,
        VIDEO,
        LEARNING_WALK
    }

	public enum SEReflectionType
	{
		UNDEFINED = 0,
		TEACHER_PRE_CONFERENCE,
		TEACHER_EVALUATEE,
		PRINCIPAL_PRE_CONFERENCE,
		PRINCIPAL_EVALUATEE
	}

    public enum SEResourceType
    {
        UNDEFINED = 0,
        GENERAL,
        GOAL,
        PRE_CONFERENCE,
        POST_CONFERENCE
    }

	public enum SEEvaluationRoleEnum
	{
		UNDEFINED = 0,
		EVALUATOR,
		EVALUATEE
	}

    public enum SEUserPromptTypeEnum
    {
        UNKNOWN = 0,
        PRE_CONFERENCE,
        POST_CONFERENCE,
        REFLECTION,
        EVALUATOR_GOAL,
        EVALUATEE_GOAL,
        COMMENTS
    }

    public enum SEEvalSessionLockState
    {
        Undefined = 0,
        Unlocked = 1,
        Locked,
        Unlock_Requested_Evaluator,
        Unlock_Requested_Evaluatee
    }

    public enum SEEvaluateePlanTypeEnum
    {
        UNDEFINED = 0,
        COMPREHENSIVE,
        FOCUSED
    }

    public enum EventTypeEnum
    {
        ObservationCreated = 1,
        ArtifactSubmitted,
        ArtifactRejected,
        SelfAssessmentShared
    }

    public enum SEClientApplicationTypes
    {
        JavaScript = 0,
        NativeConfidential = 1
    };

    public enum PreConfPromptStateEnum
    {
        PromptCreated = 1,
        WaitingForEvaluateeResponse = 2,
        ReadyForEvaluatorCoding = 3,
        UpdateRequested = 4
    }
}
