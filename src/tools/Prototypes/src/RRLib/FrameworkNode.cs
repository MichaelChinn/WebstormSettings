using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;

using DbUtils;
namespace RRLib
{
    public class FrameworkNode : RRDbObject, IDbObject
    {
        long _frameworkNodeId;
        long _parentNodeId;
        int _frameworkId;
        string _title;
        string _shortName;
        string _description;
        int _sequence;
        bool _isLeafNode;
        
        public int FrameworkId { get { return _frameworkId; } set { _frameworkId = value; } }
        public long ParentNodeId { get { return _parentNodeId; } set { _parentNodeId = value; } }
        public string Title { get { return _title; } set { _title = value; } }
        public string ShortName { get { return _shortName; } set { _shortName = value; } }
        public string Description { get { return _description; } set { _description = value; } }
        public int Sequence { get { return _sequence; } set { _sequence = value; } }
        public bool IsLeafNode { get { return _isLeafNode; } }

        void IDbObject.Load(IDataReader oReader, object o)
        {
            Init(o);
            m_nId = GetLongProperty(oReader, "FrameworkNodeID", 0);
            _parentNodeId = GetLongProperty(oReader, "parentNodeID", 0);
            _frameworkId = GetInt32Property(oReader, "FrameworkID", 0);
            _title = GetStringProperty(oReader, "Title", "");
            _shortName = GetStringProperty(oReader, "ShortName", "");
            _description = GetStringProperty(oReader, "Description", "");
            _sequence = GetInt32Property(oReader, "Sequence", 0);
            _isLeafNode = GetBooleanProperty(oReader, "IsLeafNode",false);
        }
        public RubricRow[] RubricRows
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
				{
                    new SqlParameter("@pFrameworkNodeId", this.m_nId)
                };
                return (RubricRow[])DbConnector.GetObjectsOfType("GetChildRubricRowsOfFrameworkNode", aParams, typeof(RubricRow), this);
            }
        }
        public RubricRow AddRubricRow(string title, string description, int sequence,
                                        string pl1, string pl2, string pl3, string pl4)
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pTitle"          ,  title           )
                ,new SqlParameter("@pDescription"    ,  description    )
                ,new SqlParameter("@pPl1"            ,  pl1            )
                ,new SqlParameter("@pPl2"            ,  pl2            )
                ,new SqlParameter("@pPl3"            ,  pl3            )
                ,new SqlParameter("@pPl4"            ,  pl4            )
                ,new SqlParameter("@pSequence"       ,  sequence       )
                ,new SqlParameter("@pFrameworkNodeId",  m_nId          )
            };
            return (RubricRow)DbConnector.GetObjectOfType("InsertFrameworkNodeRubricRow", aParams, typeof(RubricRow), this);
        }
        public void AddRubricRow(RubricRow r)
        {
            r.FrameworkNodeId = m_nId;
            r.Save();
        }
    }
}
