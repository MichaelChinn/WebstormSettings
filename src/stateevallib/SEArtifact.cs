using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections.Generic;

using DbUtils;
using RepositoryLib;

namespace StateEval
{
    public class ArtifactTypeCompare : IComparer<SEArtifactType>
    {
        public int Compare(SEArtifactType x, SEArtifactType y)
        {
            return String.Compare(SEArtifact.MapArtifactTypeToString(x), SEArtifact.MapArtifactTypeToString(y));
        }
    }

	public class SEArtifact : SEDbObject, IDbObject
	{
        public short SchoolYear { get; private set; }
        public string DistrictCode { get; private set; }
        public long RepositoryItemId { get; private set; }
        public string ItemName { get; private set; }
        public string Description { get; private set; }
        public long OwnerId { get; private set; }
        public long BitStreamId { get; private set; }
        public string Url { get; private set; }
        public string FileExt { get; private set; }
        public string FileName { get; private set; }
        public string ContentType { get; private set; }
        public DateTime InitialUpload { get; private set; }
        public DateTime LastUpload { get; private set; }

        public bool IsFile { get; set; }
        public SEArtifactType ArtifactType { get; set; }
        public string Comments { get; set; }
        public bool IsPublic { get; set; }
        public string ContextPromptResponse { get; set; }
        public string AlignmentPromptResponse { get; set; }
        public string ReflectionPromptResponse { get; set; }
        public long UserId { get; set; }
        public long EvalSessionId { get; set; }
        public string SessionTitle { get; set; }
        public string OwnerDisplayName { get; set; }

        public string TitleWithSession 
        { 
            get 
            {
                if (EvalSessionId == -1)
                    return ItemName;
                else 
                    return ItemName + " (" + SessionTitle + ")";
            } 
        }

        public string ArtifactTypeAsString { get { return MapArtifactTypeToString(ArtifactType); } }

        public SEArtifact() { }

		long IDbObject.Id { get { return m_nId; } }

		void IDbObject.Load(IDataReader reader, object o)
		{
			Load(reader, o);
		}

		protected void Load(IDataReader reader, object o)
		{
			Init(o);
			m_nId = (long)reader["ArtifactID"];
            RepositoryItemId = (long)reader["RepositoryItemID"];
            SchoolYear = (short)reader["SchoolYear"];
            DistrictCode = GetStringProperty(reader, "DistrictCode", "");
            ArtifactType = (SEArtifactType)GetInt32Property(reader, "ArtifactTypeID", 0);
            ItemName = (string)reader["ItemName"];
            Description = (string)reader["Description"];
            OwnerId = (long)reader["SEUserID"];
            BitStreamId = (long)reader["BitStreamID"];
            Url = GetStringProperty(reader, "URL", "");
            FileExt = GetStringProperty(reader, "Ext", "");
            FileName = GetStringProperty(reader, "FileName", "");
            ContentType = GetStringProperty(reader, "ContentType", "");
            InitialUpload = GetDateProperty(reader, "InitialUpload", DateTime.MinValue);
            LastUpload = GetDateProperty(reader, "LastUpload", DateTime.MinValue);
            IsFile = GetBooleanProperty(reader, "IsFile", true);
            Comments = GetStringProperty(reader, "Comments", "");
            IsPublic = GetBooleanProperty(reader, "IsPublic", false);
            ContextPromptResponse = GetStringProperty(reader, "ContextPromptResponse", "");
            AlignmentPromptResponse = GetStringProperty(reader, "AlignmentPromptResponse", "");
            ReflectionPromptResponse = GetStringProperty(reader, "ReflectionPromptResponse", "");
            UserId = GetLongProperty(reader, "UserID", -1);
            EvalSessionId = GetLongProperty(reader, "EvalSessionID", -1);

            // Needed for GetArtifactsUserForSummaryScreen
            if (EvalSessionId != -1)
            {
                try
                {
                    SessionTitle = GetStringProperty(reader, "SessionTitle", "");
                }
                catch { }
            }

            try
            {
                OwnerDisplayName = GetStringProperty(reader, "OwnerDisplayName", "");
            }
            catch { }
		}

        public static string MapArtifactTypeToString(SEArtifactType type)
        {
            switch (type)
            {
                case SEArtifactType.PROMPT_EVALUATEE_GOAL:
                    return "Evaluatee Goal";
                case SEArtifactType.PROMPT_EVALUATOR_GOAL:
                    return "Evaluator Goal";
                case SEArtifactType.OTHER:
                    return "Other";
                case SEArtifactType.PROMPT_POST_CONFERENCE:
                    return "Post-Conference";
                case SEArtifactType.PR_CLOSING_THE_ACHIEVEMENT_GAP:
                    return "Closing the Achievement Gap";
                case SEArtifactType.PROFESSIONAL_COLLABORATION:
                    return "Professional Collaboration";
                case SEArtifactType.PR_COLLABORATIVE_TEAMS:
                    return "Collaborative Teams";
                case SEArtifactType.PR_COMMUNICATIONS:
                    return "Communications";
                case SEArtifactType.PR_DATA:
                    return "Data";
                case SEArtifactType.PR_INTERVENTIONS:
                    return "Interventions";
                case SEArtifactType.PR_MONITORING:
                    return "Monitoring";
                case SEArtifactType.PR_PARENT_AND_COMMUNITY_GROUPS:
                    return "Parent and Community Groups";
                case SEArtifactType.PR_PLANNING:
                    return "Planning";
                case SEArtifactType.PR_SCHOOL_IMPROVEMENT:
                    return "School Improvement";
                case SEArtifactType.PR_SCHOOL_SAFETY:
                    return "School Safety";
                case SEArtifactType.PR_TEACHER_LEADERSHIP:
                    return "Teacher Leadership";
                case SEArtifactType.PROMPT_PRE_CONFERENCE:
                    return "Pre-Conference";
                case SEArtifactType.PROF_DEV:
                    return "Professional Development";
                case SEArtifactType.PROMPT_REFLECTION:
                    return "Reflection";
                case SEArtifactType.STUDENT_GROWTH_GOALS:
                    return "Student Growth Goals";
                case SEArtifactType.TR_INSTRUCTIONAL_PLANNING:
                    return "Instructional Planning";
                case SEArtifactType.TR_PARENT_COMM:
                    return "Parent Communication";
                case SEArtifactType.UNDEFINED:
                    return "UNDEFINED";
                case SEArtifactType.STUDENT_GROWTH_MEASURES:
                    return "Student Growth Measures";
                case SEArtifactType.TR_CLASSROOM_MANAGEMENT:
                    return "Classroom Management";
                case SEArtifactType.PROFESSIONAL_GROWTH_GOALS:
                    return "Professional Growth Goals";
                case SEArtifactType.PRE_CONFERENCE:
                    return "Pre-Conference";
                case SEArtifactType.POST_CONFERENCE:
                    return "Post-Conference";
                case SEArtifactType.TR_STUDENT_ENGAGEMENT:
                    return "Student Engagement";
                case SEArtifactType.OBSERVATION:
                    return "Observation";
                case SEArtifactType.LINKED_TO_OBSERVATION:
                    return "Linked to Observation";
                case SEArtifactType.LINKED_TO_SELFASSESSMENT:
                    return "Linked to Self-Assessment";
                case SEArtifactType.LINKED_TO_VIDEO:
                    return "Linked to Video";
                case SEArtifactType.DISTRICT_GOAL_FORM:
                    return "District Goal Form";
                case SEArtifactType.LINKED_TO_GOAL:
                    return "Linked to Goal";
                case SEArtifactType.EVALUATOR_ARTIFACT:
                    return "Evaluator Uploaded Artifact";
                case SEArtifactType.MOBILE_TRANSFER:
                    return "Mobile Transfer";
                default:
                    throw new Exception("Unknown artifact type: " + type);
            }
        }

        public void Save()
        {
            SEMgr.UpdateArtifact(Id, Comments, IsPublic, ArtifactType, ContextPromptResponse, AlignmentPromptResponse, ReflectionPromptResponse);
        }

        public void Delete(RepositoryMgr repoMgr)
        {
            repoMgr.DeleteRepositoryItem(RepositoryItemId);

            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pArtifactID", Id)
				};

            DbConnector.ExecuteNonQuery("RemoveArtifact", aParams);
        }

        public SEUserPromptResponse UserPromptResponse(long userPromptId, long evaluateeId)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pArtifactID", Id)
                ,new SqlParameter("@pUserPromptID", userPromptId)
                ,new SqlParameter("@pEvaluateeID", evaluateeId)
			};

            return (SEUserPromptResponse)DbConnector.GetObjectOfType("GetArtifactUserPromptResponse", aParams, typeof(SEUserPromptResponse), this);
        }
	}
}
