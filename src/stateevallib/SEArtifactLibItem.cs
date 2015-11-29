using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections;
using System.Collections.Generic;

using DbUtils;

namespace StateEval
{
	public class SEArtifactLibItem : SEDbObject, IDbObject
	{
        public long EvaluationId { get; set; }
        public string Title {get; set;}
        public string Comments { get; set; }
        public DateTime CreationDateTime { get; set; }
        public SEArtifactLibItemType ItemType { get; set; }
        public Guid? FileUUID { get; set;}
        public string WebUrl { get; set; }
        public string ProfPracticeNotes { get; set; }

        public SEArtifactLibItem() 
        { 
            m_nId = -1;
            EvaluationId = -1;
            Title = "";
            Comments = "";
            ItemType = SEArtifactLibItemType.UNDEFINED;
            FileUUID = Guid.Empty;
            WebUrl = "";
            ProfPracticeNotes = "";
        }

		long IDbObject.Id { get { return m_nId; } }

		void IDbObject.Load(IDataReader reader, object o)
		{
			Load(reader, o);
		}

		protected void Load(IDataReader reader, object o)
		{
			Init(o);
			m_nId = (long)reader["ArtifactLibItemId"];
            EvaluationId = GetLongProperty(reader, "EvaluationId", -1);
            Title = GetStringProperty(reader, "Title", "");
            Comments = GetStringProperty(reader, "Comments", "");
            CreationDateTime = GetDateProperty(reader, "CreationDateTime", DateTime.MinValue);
            ItemType = (SEArtifactLibItemType)GetInt32Property(reader, "ItemTypeID", 0);
            FileUUID = GetGuidProperty(reader, "FileUUID", Guid.Empty);
            WebUrl = GetStringProperty(reader, "WebUrl", "");
            ProfPracticeNotes = GetStringProperty(reader, "ProfPracticeNotes", "");
        }

        public static SEArtifactLibItem Create(long evaluationId, string title, string comments)
        {
            SEArtifactLibItem a = new SEArtifactLibItem();
            a.EvaluationId = evaluationId;
            a.Title = title;
            a.Comments = comments;
            a.ItemType = SEArtifactLibItemType.UNDEFINED;
            return a;
        }

        void AddItemParams(List<SqlParameter> paramList)
        {
            paramList.Add(new SqlParameter("@pTitle", Title));
            paramList.Add(new SqlParameter("@pComments", Comments));
            paramList.Add(new SqlParameter("@pItemTypeID", ItemType));

            if (ItemType == SEArtifactLibItemType.FILE)
            {
                paramList.Add(new SqlParameter("@pFileUUID", FileUUID));
            }
            else if (ItemType == SEArtifactLibItemType.WEB)
            {
                paramList.Add(new SqlParameter("@pWebUrl", WebUrl));
            }
            else if (ItemType == SEArtifactLibItemType.PROF_PRACTICE)
            {
                paramList.Add(new SqlParameter("@pProfPracticeNotes", ProfPracticeNotes));
            }
        }

        public void Save()
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            if (m_nId == -1)
            {
                paramList.Add(new SqlParameter("@pEvaluationID", EvaluationId));
                AddItemParams(paramList);

                m_nId = Convert.ToInt64(SEMgr.Instance.DbConnector.ExecuteScalar("InsertArtifactLibItem", paramList));
                CreationDateTime = DateTime.Now;
            }
            else
            {
                paramList.Add(new SqlParameter("@pArtifactLibItemID", Id));
                AddItemParams(paramList);
               
                SEMgr.Instance.DbConnector.ExecuteNonQuery("UpdateArtifactLibItem", paramList);
            }
        }

        public void Delete()
        {
            List<SqlParameter> paramList = new List<SqlParameter>();
            paramList.Add(new SqlParameter("@pArtifactLibItemID", Id));
            SEMgr.Instance.DbConnector.ExecuteNonQuery("DeleteArtifactLibItem", paramList);
        }

        public static SEArtifactLibItem Get(long id)
        {
           SqlParameter[] aParams = new SqlParameter[] {
               new SqlParameter("@pArtifactLibItemId", id)
           };

           return (SEArtifactLibItem)SEMgr.Instance.DbConnector.GetObjectOfType("GetArtifactLibItemById", aParams, typeof(SEArtifactLibItem), SEMgr.Instance);
        }

        public static List<SEArtifactLibItem> GetItemsForEvaluation(long evaluationId)
        {
            SqlParameter[] aParams = new SqlParameter[] {
               new SqlParameter("@pEvaluationId", evaluationId)
           };

            return (List<SEArtifactLibItem>)SEMgr.Instance.DbConnector.GetListOfType("GetArtifactLibItemsForEvaluation", aParams, typeof(SEArtifactLibItem), SEMgr.Instance);
        }


	}
}
