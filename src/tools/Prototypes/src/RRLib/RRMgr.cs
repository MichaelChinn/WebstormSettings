using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections;
using System.IO;
using System.Text;

using DbUtils;

namespace RRLib
{
     public enum FrameworkType
    {
        UNDEFINED = 0,
        TSTATE,
        TINSTRUCTIONAL,
        PSTATE,
        PINSTRUCTIONAL
    }

    public class RRMgr
    {
        string _connectionString;
       
        public RRMgr(string connectionString)
        {
            _connectionString = connectionString;
        }
     
        public DbConnector DbConnector { get { return new DbConnector(_connectionString); } }
        public string ConnectionString { get { return _connectionString; } }
        public RRMgr(string connectionString, bool isCString) { _connectionString = connectionString; }
        /*
        public RubricRow[] RubricRows(FrameworkTypes frameworkType)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pFrameworkTypeID", Convert.ToInt16(frameworkType))
                };
            return (RubricRow[])DbConnector.GetObjectsOfType("GetRubricRowsForFrameworkType", aParams, typeof(RubricRow), this);
        }
        public RubricRow[] ChildRubricRows(long frameworkNodeID)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pFrameworkNodeID", frameworkNodeID)
                };
            return (RubricRow[])DbConnector.GetObjectsOfType("GetChildRubricsOfNode", aParams, typeof(RubricRow), this);
        }
        public FrameworkNode[] ChildNodes(long frameworkNodeID)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pFrameworkNodeID", frameworkNodeID)
                };
            return (FrameworkNode[])DbConnector.GetObjectsOfType("GetChildNodesOfNode", aParams, typeof(FrameworkNode), this);
        }
         * */
        public FrameworkNode FrameworkNode(long frameworkNodeId)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
                    new SqlParameter("@pFrameworkNodeId", frameworkNodeId)
                };
            return (FrameworkNode)DbConnector.GetObjectOfType("GetFrameworkNodeById", aParams, typeof(FrameworkNode), this);
        }

        public FrameworkNode[] FrameworkNodes(long frameworkId)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
                    new SqlParameter("@pFrameworkID", frameworkId)
                };
            return (FrameworkNode[])DbConnector.GetObjectsOfType("GetNodesInFramework", aParams, typeof(FrameworkNode), this);
        }

        public RubricRow GetChildRubricRowOfFrameworkNode(long frameworkNodeId, long RubricRowId)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
                    new SqlParameter("@pFrameworkNodeID", frameworkNodeId)
                    ,new SqlParameter("@pRubricRowId", RubricRowId)
                };
            return (RubricRow)DbConnector.GetObjectOfType("GetChildRubricRowOfFrameworkNode", aParams, typeof(RubricRow), this);
        }
        public void DeleteRubricRow(long RubricRowId)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
                    new SqlParameter("@pRubricRowId", RubricRowId)
                };
           DbConnector.ExecuteNonQuery("DeleteRubricRow", aParams);
        }
        public Framework Framework(long frameworkId)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
                    new SqlParameter("@pFrameworkId", frameworkId)
                };
            return (Framework)DbConnector.GetObjectOfType("GetFrameworkById", aParams, typeof(Framework), this);
        }
        public Framework[] Frameworks
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
				{
                    new SqlParameter("@pFrameworkID", -1)
                };
                return (Framework[])DbConnector.GetObjectsOfType("GetPrototypeFrameworks", aParams, typeof(Framework), this);
            }
        }
    }
}
