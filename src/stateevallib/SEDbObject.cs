using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections;

using DbUtils;

using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace StateEval
{
    public enum SECalibrationScoreElementType
    {
        FrameworkNode,
        RubricRow
    }

    public enum SECalibrationReportLevel
    {
        Level1=1,
        Level2,
        Level3
    }

    public interface ICalibrationScoreElement
    {
        string Id    { get; }
        string Field { get; }
        string Title { get; }
        SECalibrationScoreElementType ElementType { get; }
    };

	/// <summary>
	/// Summary description for SEDbObject.
	/// </summary>
    /// 
    [Serializable()]
	public class SEDbObject : DbObject, ISerializable
	{
		public SEDbObject()
		{
		}
        
        protected SEDbObject(SerializationInfo info, StreamingContext ctxt): base(info, ctxt)
        {
        }
        public new void GetObjectData(SerializationInfo info, StreamingContext ctxt)
        {
            base.GetObjectData(info, ctxt);
        }

        public SEMgr SEMgr
		{
            get { return ((SEMgr)m_oContext); }
		}

		public DbConnector DbConnector
		{
			get
			{
                return SEMgr.DbConnector;
			}
		}
	}
}
