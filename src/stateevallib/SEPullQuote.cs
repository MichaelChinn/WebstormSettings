using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;

using DbUtils;

namespace StateEval
{
    public class SEPullQuote : SEDbObject, IDbObject
    {
        public SEPullQuote() { }

		long IDbObject.Id { get { return m_nId; } }

		void IDbObject.Load(IDataReader reader, object o)
		{
			Load(reader, o);
		}

        protected void Load(IDataReader reader, object o)
        {
            Init(o);
            m_nId = (long)reader["PullQuoteId"];
            SessionId = GetLongProperty(reader, "EvalSessionID", -1);
            FrameworkNodeId = GetLongProperty(reader, "FrameworkNodeID", -1);
            Text = GetStringProperty(reader, "Quote", "");
            NodeShortName = GetStringProperty(reader, "NodeShortName", "");
            IsImportant = GetBooleanProperty(reader, "IsImportant", false);
            Guid = (Guid)reader["Guid"];

            try
            {
                SessionStartTime = GetDateProperty(reader, "ObserveStartTime", DateTime.MinValue);
                SessionTitle = GetStringProperty(reader, "SessionTitle", "");
                EvaluatorDisplayName = (string)reader["EvaluatorDisplayName"];
                EvaluationType = (SEEvaluationType)Convert.ToInt32(reader["EvaluationTypeID"]);
                IsSelfAssess = GetBooleanProperty(reader, "IsSelfAssess", false);
                int key = GetInt16Property(reader, "SessionKey", 1);

                SESchoolYear schoolYear = (SESchoolYear)GetInt32Property(reader, "SchoolYear", 0);
                SessionKey = Utils.CreateSessionKeyFromInt(key, schoolYear);
            }
            catch { }
        }

        public string EvaluatorDisplayName { get; protected set; }
        public string SessionTitle { get; protected set; }
        public DateTime SessionStartTime { get; protected set; }
        public string Text { get; protected set; }
        public string NodeShortName { get; protected set; }
        public long SessionId { get; protected set; }
        public long FrameworkNodeId { get; protected set; }
        public bool IsImportant { get; protected set; }
        public Guid Guid { get; protected set; }
        public bool IsSelfAssess { get; protected set; }
        public SEEvaluationType EvaluationType { get; protected set; }
        public string SessionKey { get; protected set; }

        public void UpdateImportant(bool isImportant)
        {
            SEMgr.UpdatePullQuoteImportant(Id, isImportant);
        }

        public string EvalSessionDisplayTitle
        {
            get
            {
                string date = (SessionStartTime == DateTime.MinValue) ? "Not scheduled" : SessionStartTime.ToShortDateString();
                return EvaluatorDisplayName + " - " + SessionTitle + " - " + date;
            }
        }
    }
}
