using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections;
using System.Collections.Generic;

using DbUtils;

namespace StateEval
{
	public class SEArtifactBundle : SEDbObject, IDbObject
	{
        public long EvaluationId { get; set; }
        public string Title {get; set;}
        public string Comments { get; set; }
        public DateTime CreationDateTime { get; set; }
        public long? EvalSessionId { get; set; }
        public string Reflection { get; set;}
        public string LibItemIdList { get; set; }
        public string AlignmentRRIdList { get; set; }
        public SEWfState WfState { get; set; }


        public SEArtifactBundle() 
        { 
            m_nId = -1;
            EvaluationId = -1;
            Title = "";
            Comments = "";
            Reflection = "";
            EvalSessionId = -1;
            LibItemIdList = "";
            AlignmentRRIdList = "";
            WfState = SEWfState.ARTIFACT;
        }

		long IDbObject.Id { get { return m_nId; } }

		void IDbObject.Load(IDataReader reader, object o)
		{
			Load(reader, o);
		}

		protected void Load(IDataReader reader, object o)
		{
			Init(o);
			m_nId = (long)reader["ArtifactBundleId"];
            EvaluationId = GetLongProperty(reader, "EvaluationId", -1);
            Title = GetStringProperty(reader, "Title", "");
            Comments = GetStringProperty(reader, "Comments", "");
            CreationDateTime = GetDateProperty(reader, "CreationDateTime", DateTime.MinValue);
            EvalSessionId = GetLongProperty(reader, "EvalSessionId", -1);
            Reflection = GetStringProperty(reader, "Reflection", "");
            LibItemIdList = GetStringProperty(reader, "LibItemIdList", "");
            AlignmentRRIdList = GetStringProperty(reader, "AlignmentRRIdList", "");
            WfState = (SEWfState)GetInt16Property(reader, "WfStateID", Convert.ToInt16(SEWfState.ARTIFACT));
        }

        public static SEArtifactBundle Create(long evaluationId, string title, string comments)
        {
            SEArtifactBundle a = new SEArtifactBundle();
            a.EvaluationId = evaluationId;
            a.Title = title;
            a.Comments = comments;
            a.Reflection = "";
            a.EvalSessionId = -1;
            a.LibItemIdList = "";
            a.AlignmentRRIdList = "";
            a.WfState = SEWfState.ARTIFACT;
            return a;
        }

        void AddUpdateSqlParams(List<SqlParameter> paramList)
        {
            paramList.Add(new SqlParameter("@pTitle", Title));
            paramList.Add(new SqlParameter("@pReflection", Reflection));
            paramList.Add(new SqlParameter("@pComments", Comments));
            paramList.Add(new SqlParameter("@pWfStateID", WfState));
            paramList.Add(new SqlParameter("@pLibItemIdList", LibItemIdList));
            paramList.Add(new SqlParameter("@pAlignmentRRIdList", AlignmentRRIdList));
        }

        public void Save()
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            if (m_nId == -1)
            {
                paramList.Add(new SqlParameter("@pEvaluationID", EvaluationId));
                AddUpdateSqlParams(paramList);
                m_nId = Convert.ToInt64(SEMgr.Instance.DbConnector.ExecuteScalar("InsertArtifactBundle", paramList));
                CreationDateTime = DateTime.Now;
            }
            else
            {
                paramList.Add(new SqlParameter("@pArtifactBundleID", Id));
                AddUpdateSqlParams(paramList);
                paramList.Add(new SqlParameter("@pFlushLibItems", 1));
                SEMgr.Instance.DbConnector.ExecuteNonQuery("UpdateArtifactBundle", paramList);
            }

            string[] stringSeparators = new string[] { ";" };
            string[] ids = LibItemIdList.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);

            foreach (string id in ids)
            {
                SEArtifactLibItem i = SEArtifactLibItem.Get(Convert.ToInt64(id));
                AddLibItem(i);
            }
        }

        public void Delete()
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            paramList.Add(new SqlParameter("@pArtifactBundleID", Id));
            SEMgr.Instance.DbConnector.ExecuteNonQuery("DeleteArtifactBundle", paramList);
        }

        public static SEArtifactBundle Get(long id)
        {
           SqlParameter[] aParams = new SqlParameter[] {
               new SqlParameter("@pArtifactBundleId", id)
           };

            return (SEArtifactBundle)SEMgr.Instance.DbConnector.GetObjectOfType("GetArtifactBundleById", aParams, typeof(SEArtifactBundle), SEMgr.Instance);
        }

        public static List<SEArtifactBundle> GetBundlesForEvaluation(long evaluationId, SEWfState wfState)
        {
            SqlParameter[] aParams = new SqlParameter[] {
               new SqlParameter("@pEvaluationId", evaluationId),
               new SqlParameter("@pWfStateId", wfState)
           };

            return (List<SEArtifactBundle>)SEMgr.Instance.DbConnector.GetListOfType("GetArtifactBundlesForEvaluation", aParams, typeof(SEArtifactBundle), SEMgr.Instance);
        }

        public void AddLibItem(SEArtifactLibItem item)
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            paramList.Add(new SqlParameter("@pArtifactBundleID", Id));
            paramList.Add(new SqlParameter("@pArtifactLibItemID", item.Id));
            SEMgr.Instance.DbConnector.ExecuteNonQuery("RelateArtifactBundleToArtifactLibItem", paramList);
        }

        public void RemoveLibItem(SEArtifactLibItem item)
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            paramList.Add(new SqlParameter("@pArtifactBundleID", Id));
            paramList.Add(new SqlParameter("@pArtifactLibItemID", item.Id));
            SEMgr.Instance.DbConnector.ExecuteNonQuery("UnrelateArtifactBundleToArtifactLibItem", paramList);
        }

        public List<SEArtifactLibItem> LibItems
        {
            get
            {
                List<SqlParameter> paramList = new List<SqlParameter>();
                paramList.Add(new SqlParameter("@pArtifactBundleID", Id));
                return (List<SEArtifactLibItem>) SEMgr.Instance.DbConnector.GetListOfType("GetArtifactLibItemsForArtifactBundle", paramList, typeof(SEArtifactLibItem), SEMgr.Instance);
            }
        }
	}
}
