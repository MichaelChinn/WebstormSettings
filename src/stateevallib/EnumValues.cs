using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace StateEval
{
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

    public enum SEWfState
    {
        UNDEFINED = 0,
        DRAFT,
        READY_FOR_CONFERENCE,
        READY_FOR_FORMAL_RECEIPT,
        RECEIVED,
        SUBMITTED,
        ARTIFACT,
        PRIVATE_EVIDENCE,
        PUBLIC_EVIDENCE,
        GOAL_IN_PROGRESS,
        GOAL_SUBMITTED,
        GOAL_BUNDLE_IN_PROGRESS,
        GOAL_BUNDLE_SUBMITTED
    }

    public enum SEGoalProcessStepType
    {
        UNDEFINED = 0,

        SG_Q1_PR_2015_SG_3_5,
        SG_Q2_PR_2015_SG_3_5,
        SG_Q3_PR_2015_SG_3_5,
        SG_Q4_PR_2015_SG_3_5,

        SG_Q1_PR_2015_SG_5_5,
        SG_Q2_PR_2015_SG_5_5,
        SG_Q3_PR_2015_SG_5_5,
        SG_Q4_PR_2015_SG_5_5,
        SG_Q5_PR_2015_SG_5_5,
        SG_Q6_PR_2015_SG_5_5,

        SG_Q1_PR_2015_SG_8_3,
        SG_Q2_PR_2015_SG_8_3,
        SG_Q3_PR_2015_SG_8_3,
        SG_Q4_PR_2015_SG_8_3,

        SG_Q1_TR_2015,
        SG_Q2_TR_2015,
        SG_Q3_TR_2015,
        SG_Q4_TR_2015,
        SG_Q5_TR_2015,

        PD_Q1_PR_2015,
        PD_Q2_PR_2015,
        PD_Q3_PR_2015,
        PD_Q4_PR_2015,
        PD_Q5_PR_2015,
        PD_Q6_PR_2015,

        PD_Q1_TR_2015,
        PD_Q2_TR_2015,
        PD_Q3_TR_2015,
        PD_Q4_TR_2015,
        PD_Q5_TR_2015,
        PD_Q6_TR_2015,

        SG_Q1_PR_2016_SG_3_5,
        SG_Q2_PR_2016_SG_3_5,
        SG_Q3_PR_2016_SG_3_5,
        SG_Q4_PR_2016_SG_3_5,

        SG_Q1_PR_2016_SG_5_5,
        SG_Q2_PR_2016_SG_5_5,
        SG_Q3_PR_2016_SG_5_5,
        SG_Q4_PR_2016_SG_5_5,
        SG_Q5_PR_2016_SG_5_5,
        SG_Q6_PR_2016_SG_5_5,

        SG_Q1_PR_2016_SG_8_3,
        SG_Q2_PR_2016_SG_8_3,
        SG_Q3_PR_2016_SG_8_3,
        SG_Q4_PR_2016_SG_8_3,

        SG_Q1_TR_2016,
        SG_Q2_TR_2016,
        SG_Q3_TR_2016,
        SG_Q4_TR_2016,
        SG_Q5_TR_2016,

        PD_Q1_PR_2016,
        PD_Q2_PR_2016,
        PD_Q3_PR_2016,
        PD_Q4_PR_2016,
        PD_Q5_PR_2016,
        PD_Q6_PR_2016,

        PD_Q1_TR_2016,
        PD_Q2_TR_2016,
        PD_Q3_TR_2016,
        PD_Q4_TR_2016,
        PD_Q5_TR_2016,
        PD_Q6_TR_2016,
    }

    public enum SEGoalTemplateType
    {
        UNDEFINED = 0,
        STUDENT_GROWTH_PR_2015,
        STUDENT_GROWTH_TR_2015,
        PROFESSIONAL_GROWTH_PR_2015,
        PROFESSIONAL_GROWTH_TR_2015,
        STUDENT_GROWTH_PR_2016,
        STUDENT_GROWTH_TR_2016,
        PROFESSIONAL_GROWTH_PR_2016,
        PROFESSIONAL_GROWTH_TR_2016,
    }

    public enum SEEvaluateeSubmissionRetrievalType
    {
        Submitted = 1,
        NotSubmitted,
        All
    }

    public enum SEActiveEvaluatorRole
    {
        UNDEFINED = 0,
        PR_PR,
        PR_TR,
        DE_PR,
        DTE_TR,
        DA_PR,
        SA_TR
    }
/*
    public class SETrainingProtocolRatingStatusTypeCompare : IComparer<SETrainingProtocolRatingStatusType>
    {
        public int Compare(SETrainingProtocolRatingStatusType x, SETrainingProtocolRatingStatusType y)
        {
            return String.Compare(SETrainingProtocolRating.StatusAsString(x), SETrainingProtocolRating.StatusAsString(y));
        }
    }
    */
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

    public enum DerivedFromFrameworkType
    {
        UNDEFINED = 0,

        // 2013
        FW_STATE_DAN_TR_2013 = 34,
        FW_INST_DAN_TR_2013 = 35,

        FW_STATE_CEL_TR_2013 = 36,
        FW_INST_CEL_TR_2013 = 37,

        FW_STATE_MAR_TR_2013 = 38,
        FW_INST_MAR_TR_2013 = 41,

        FW_STATE_PR_2013 = 39,

        FW_STATE_WENATCHEE_PR_2013 = 40,

        FW_STATE_MAR_PR_2013 = 42,
        FW_INST_MAR_PR_2013 = 43,

        // 2014
        FW_STATE_DAN_TR_2014 = 44,
        FW_INST_DAN_TR_2014 = 45,

        FW_STATE_CEL_TR_2014 = 46,
        FW_INST_CEL_TR_2014 = 47,

        FW_STATE_MAR_TR_2014 = 48,
        FW_INST_MAR_TR_2014 = 51,

        FW_STATE_PR_2014 = 49,

        FW_STATE_WENATCHEE_PR_2014 = 50,

        FW_STATE_MAR_PR_2014 = 52,
        FW_INST_MAR_PR_2014 = 53,

        // 2015
        FW_STATE_DAN_TR_2015 = 54,
        FW_INST_DAN_TR_2015 = 55,

        FW_STATE_CEL_TR_2015 = 56,
        FW_INST_CEL_TR_2015 = 57,

        FW_STATE_MAR_TR_2015 = 58,
        FW_INST_MAR_TR_2015 = 61,

        FW_STATE_PR_2015 = 59,

        FW_STATE_WENATCHEE_PR_2015 = 60,

        FW_STATE_MAR_PR_2015 = 62,
        FW_INST_MAR_PR_2015 = 63,

        // 2016
        FW_STATE_DAN_TR_2016 = 64,
        FW_INST_DAN_TR_2016 = 65,

        FW_STATE_CEL_TR_2016 = 66,
        FW_INST_CEL_TR_2016 = 67,

        FW_STATE_MAR_TR_2016 = 68,
        FW_INST_MAR_TR_2016 = 71,

        FW_STATE_PR_2016 = 69,

        FW_STATE_WENATCHEE_PR_2016 = 70,

        FW_STATE_MAR_PR_2016 = 72,
        FW_INST_MAR_PR_2016 = 73,


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

    public enum SEEvalRequestType
    {
        UNDEFINED = 0,
        OBSERVATION_ONLY,
        ASSIGNED_EVALUATOR
    }

    public enum SEEvalRequestStatus
    {
        UNDEFINED = 0,
        PENDING,
        ACCEPTED,
        REJECTED,
    }

    public enum SESchoolYear
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

	public enum SEEvaluationVisiblityArea
	{
		UNDEFINED = 0,
		FINAL_SCORE,
		FN_SUMMATIVE_SCORES,
		FN_EXCERPTS,
		RR_SUMMATIVE_SCORES,
		OBSERVATIONS,
		EVAL_COMMENTS,
		EVAL_EXCERPTS,
		RR_ANNOTATIONS,
        EVAL_RECOMMENDATIONS,
        REPORT_SNAPSHOTS
	}

	public enum SEFinalReportVisiblityArea
	{
		UNDEFINED = 0,
		SESSION_EXCERPTS,
		SESSION_ANNOTATIONS,
		FINAL_EVALUATION_NOTES,
		FINAL_PRIORITIZED_EXCERPTS,
		FINAL_REFLECTIONS,
		INSTRUCTIONAL_FRAMEWORK,
		ADDITIONAL_MEASURES,
        FINAL_EVALUATION_RECOMMENDATIONS,
        SESSION_PRECONF_NOTES,
        SESSION_POSTCONT_NOTES,
        SESSION_ALIGNMENT,
        SESSION_PRECONF_PROMPTS,
        SESSION_POSTCONF_PROMPTS,
        SESSION_NOTES,
        SESSION_FRAMEWORK_NOTES,
        SESSION_FRAMEWORK_RECOMMENDATIONS,
        SESSION_SG_NOTES,
        SESSION_SG_RECOMMENDATIONS
	}

	public enum PQColors
	{
		c1 = 0xff9980
		,
		c2 = 0xbfd6ff
			,
		c3 = 0x80ffc9
			,
		c4 = 0xf8bfff
			,
		c5 = 0xefff80
			,
		c6 = 0xffe680
			,
		c7 = 0xff80df
			,
		c8 = 0x809fff
			,
		d1 = 0xf5f32c
			,
		d2 = 0xe07bc2
			,
		d3 = 0xffe680
			,
		d4 = 0xbfd6ff
			,
		k1 = 0xf8c8bd
			,
		k2 = 0xd7dbe3
			,
		k3 = 0xa0d5be
			,
		k4 = 0xbca4bf
			,
		k5 = 0xf5f32c
			,
		k6 = 0xfab050
			,
		k7 = 0x49e3d6
			, k8 = 0xd5f3c0
	}
	public enum EntityType
	{
		UNDEFINED = 0,
		STATE,
		DISTRICT,
		SCHOOL
	}

	public enum SERubricPerformanceLevel
	{
		UNDEFINED = 0,
		PL1,
		PL2,
		PL3,
		PL4
	}

	public enum SEFrameworkType
	{
		UNDEFINED = 0,
		TSTATE,
		TINSTRUCTIONAL,
		PSTATE,
		PINSTRUCTIONAL,
		TSSTATE,
		TSINSTRUCTIONAL,
		PSSTATE,
		PSINSTRUCTIONAL,
        HEFTF
	}

	public enum SEFrameworkViewType
	{
		UNDEFINED = 0,
		STATE_FRAMEWORK_ONLY,
		STATE_FRAMEWORK_DEFAULT,
		INSTRUCTIONAL_FRAMEWORK_DEFAULT,
        INSTRUCTION_FRAMEWORK_ONLY
	}

	public enum SEEvaluationType
	{
		UNDEFINED = 0,
		PRINCIPAL_OBSERVATION,
		TEACHER_OBSERVATION
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

	public enum SEArtifactType
	{
		UNDEFINED = 0,
		TR_PARENT_COMM,
		PROF_DEV,
		TR_INSTRUCTIONAL_PLANNING,
		OTHER,
        PROMPT_EVALUATOR_GOAL,
        PROMPT_EVALUATEE_GOAL,
        PROMPT_PRE_CONFERENCE,
        PROMPT_POST_CONFERENCE,
        PROMPT_REFLECTION,
        PR_COMMUNICATIONS,
        PR_SCHOOL_IMPROVEMENT,
        PR_SCHOOL_SAFETY,
        PR_COLLABORATIVE_TEAMS,
        PR_DATA,
        STUDENT_GROWTH_GOALS,
        PR_CLOSING_THE_ACHIEVEMENT_GAP,
        PR_MONITORING,
        PR_TEACHER_LEADERSHIP,
        PR_PARENT_AND_COMMUNITY_GROUPS,
        PR_INTERVENTIONS,
        PROFESSIONAL_COLLABORATION,
        PR_PLANNING,
        STUDENT_GROWTH_MEASURES,
        TR_CLASSROOM_MANAGEMENT,
        PROFESSIONAL_GROWTH_GOALS,
        PRE_CONFERENCE,
        POST_CONFERENCE,
        TR_STUDENT_ENGAGEMENT,
        OBSERVATION,
        LINKED_TO_OBSERVATION,
        LINKED_TO_SELFASSESSMENT,
        LINKED_TO_VIDEO,
        DISTRICT_GOAL_FORM,
        LINKED_TO_GOAL,
        EVALUATOR_ARTIFACT,
        MOBILE_TRANSFER
	}

	public enum SEEvaluationRole
	{
		UNDEFINED = 0,
		EVALUATOR,
		EVALUATEE
	}

    public enum SEUserPromptType
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

    public enum SEEvaluateePlanType
    {
        UNDEFINED = 0,
        COMPREHENSIVE,
        FOCUSED
    }
}
