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
    public class RubricRow : RRDbObject, IDbObject
    {
        string _title;
        string _description;
        string _pl1;
        string _pl2;
        string _pl3;
        string _pl4;
        int _sequence;
        long _frameworkNodeId;

        public string Title { get { return _title; } set { _title = value; } }
        public string Description { get { return _description; } set { _description = value; } }
        public string Pl1 { get { return _pl1; } set { _pl1 = value; } }
        public string Pl2 { get { return _pl2; } set { _pl2 = value; } }
        public string Pl3 { get { return _pl3; } set { _pl3 = value; } }
        public string Pl4 { get { return _pl4; } set { _pl4 = value; } }
        public int Sequence { get { return _sequence; } set { _sequence = value; } }
        public long FrameworkNodeId { get { return _frameworkNodeId; } set { _frameworkNodeId = value; } }

        void IDbObject.Load(IDataReader oReader, object o)
        {
            Init(o);
            m_nId = GetLongProperty(oReader, "RubricRowID", 0);
 
             _title = GetStringProperty(oReader, "Title", "");
            _description = GetStringProperty(oReader, "Description", "");
            _sequence = GetInt32Property(oReader, "Sequence", 0);
            _pl1 = GetStringProperty(oReader, "PL1Descriptor", "");
            _pl2 = GetStringProperty(oReader, "PL2Descriptor", "");
            _pl3 = GetStringProperty(oReader, "PL3Descriptor", "");
            _pl4 = GetStringProperty(oReader, "PL4Descriptor", "");
            _frameworkNodeId = GetLongProperty(oReader, "FrameworkNodeID", 0);
        }


        public void Save()
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pRubricRowId", m_nId)
                ,new SqlParameter("@pTitle"          ,  _title          )
                ,new SqlParameter("@pDescription"    ,  _description    )
                ,new SqlParameter("@pPl1"            ,  _pl1            )
                ,new SqlParameter("@pPl2"            ,  _pl2            )
                ,new SqlParameter("@pPl3"            ,  _pl3            )
                ,new SqlParameter("@pPl4"            ,  _pl4            )
                ,new SqlParameter("@pSequence"       ,  _sequence       )
                ,new SqlParameter("@pFrameworkNodeId",  _frameworkNodeId)
            };

            DbConnector.ExecuteNonQuery("UpdateRubricRow", aParams);
        }
       
    }
}
