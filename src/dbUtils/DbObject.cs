using System;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections;

using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

namespace DbUtils
{

	/// <summary>
	/// Summary description for DbObject.
	/// </summary>
	[Serializable()]
	public class DbObject:ISerializable
	{
		protected object m_oContext;
		protected long m_nId;
		protected bool m_bHasDataLoaded = true;

        public DbObject(SerializationInfo info, StreamingContext ctxt)
        {
            m_nId = (long)info.GetValue("seUserId", typeof(long));
            m_bHasDataLoaded = (bool) info.GetValue("bHasDataLoaded", typeof(bool));
        }
        public void GetObjectData(SerializationInfo info, StreamingContext ctxt)
        {
            info.AddValue("seUserId", m_nId);
            info.AddValue("bHasDataLoaded", m_bHasDataLoaded);
        }

		/// <summary>
		/// Default constructor.
		/// </summary>
		public DbObject()
		{
		}

		/// <summary>
		/// Loads a deferred load object.
		/// Default implementation does nothing.
		/// </summary>
		public virtual void CheckDataLoad(){}

		/// <summary>
		/// Returns whether the object's state has been loaded or
		/// it is still in a deferred-load state.
		/// </summary>
		protected bool ObjectStateLoaded { get { return m_bHasDataLoaded; } set { m_bHasDataLoaded = value; } }

		/// <summary>
		/// The Context object is one of the manager objects that
		/// allows communication across the object libraries.
		/// </summary>
		public object Context { get { return m_oContext; }}

		/// <summary>
		/// The database id of the object.
		/// </summary>
		public long Id { get { return m_nId; } }

		public void SetId(long value)
		{
			m_nId = value;
		}

		/// <summary>
		/// Initializes the object with context after it is loaded from the database.
		/// </summary>
		public void Init(object o)
		{
			m_oContext = o;
		}

		/// <summary>
		/// Utility to pull data from a data reader by type.
		/// </summary>
		/// <param name="oReader">the data reader</param>
		/// <param name="sPropName">the field name in the reader.</param>
		/// <param name="sDefault">the default value for the field if it is null</param>
		/// <returns>the string value of the field</returns>
		static public string GetStringProperty(IDataReader oReader, string sPropName, string sDefault)
		{
			object val;
			val = oReader[sPropName];
			if (val!=System.DBNull.Value)
				return (string) val;
			else
				return sDefault;
		}

		/// <summary>
		/// Utility to pull data from a data reader by type.
		/// </summary>
		/// <param name="oReader">the data record</param>
		/// <param name="sPropName">the field name in the reader.</param>
		/// <param name="sDefault">the default value for the field if it is null</param>
		/// <returns>the string value of the field</returns>
		static public string GetStringProperty(DbDataRecord oReader, string sPropName, string sDefault)
		{
			object val;
			val = oReader.GetValue(oReader.GetOrdinal(sPropName));
			if (val!=System.DBNull.Value)
				return (string) val;
			else
				return sDefault;
		}	

		static public int GetInt32Property(IDataReader oReader, string sPropName, int nDefault)
		{
			object val;
			val = oReader[sPropName];
			if (val!=System.DBNull.Value)
				return (int) Convert.ToInt32(val);
			else
				return nDefault;
		}
		
		static public int GetInt32Property(DbDataRecord oReader, string sPropName, int nDefault)
		{
			object val;
			val = oReader.GetValue(oReader.GetOrdinal(sPropName));
			if (val!=System.DBNull.Value)
				return (int)val;
			else
				return nDefault;
		}

		static public short GetInt16Property(IDataReader oReader, string sPropName, short nDefault)
		{
			object val;
			val = oReader[sPropName];
			if (val!=System.DBNull.Value)
				return (short) Convert.ToInt16(val);
			else
				return nDefault;
		}
		
		static public short GetInt16Property(DbDataRecord oReader, string sPropName, short nDefault)
		{
			object val;
			val = oReader.GetValue(oReader.GetOrdinal(sPropName));
			if (val!=System.DBNull.Value)
				return (short)val;
			else
				return nDefault;
		}

		static public long GetLongProperty(IDataReader oReader, string sPropName, long nDefault)
		{
			object val;
			val = oReader[sPropName];
			if (val!=System.DBNull.Value)
				return (long) Convert.ToInt64(val);
			else
				return nDefault;
		}

		static public long GetLongProperty(DbDataRecord oReader, string sPropName, long nDefault)
		{
			object val;
			val = oReader.GetValue(oReader.GetOrdinal(sPropName));
			if (val!=System.DBNull.Value)
				return (long)val;
			else
				return nDefault;
		}

		static public bool GetBooleanProperty(IDataReader oReader, string sPropName, bool bDefault)
		{
			object val;
			val = oReader[sPropName];
			if (val!=System.DBNull.Value)
				return (bool) Convert.ToBoolean(val);
			else
				return bDefault;
		}

		static public bool GetBooleanProperty(DbDataRecord oReader, string sPropName, bool bDefault)
		{
			object val;
			val = oReader.GetValue(oReader.GetOrdinal(sPropName));
			if (val!=System.DBNull.Value)
				return (bool)val;
			else
				return bDefault;
		}
		
        static public decimal GetDecimalProperty(IDataReader oReader, string sPropName, decimal dDefault)
		{
			object val;
			val = oReader[sPropName];
			if (val!=System.DBNull.Value)
				return (decimal) Convert.ToDecimal(val);
			else
				return dDefault;
		}

		static public decimal GetDecimalProperty(DbDataRecord oReader, string sPropName, decimal dDefault)
		{
			object val;
			val = oReader.GetValue(oReader.GetOrdinal(sPropName));
			if (val!=System.DBNull.Value)
				return (decimal)val;
			else
				return dDefault;
		}

		static public string GetDecimalPropertyString(IDataReader oReader, string sPropName, string sDefault)
		{
			object val;
			val = oReader[sPropName];
			if (val!=System.DBNull.Value)
				return val.ToString();
			else
				return sDefault;
		}

		static public string GetDecimalPropertyString(DbDataRecord oReader, string sPropName, string sDefault)
		{
			object val;
			val = oReader.GetValue(oReader.GetOrdinal(sPropName));
			if (val!=System.DBNull.Value)
				return val.ToString();
			else
				return sDefault;
		}
     
        static public DateTime GetDateProperty(IDataReader oReader, string sPropName, DateTime dtDefault)
        {
            object val;
            val = oReader[sPropName];
            if (val != System.DBNull.Value)
                return (DateTime)Convert.ToDateTime(val);
            else
                return dtDefault;
        }

        static public double GetDoubleProperty(IDataReader oReader, string sPropName, double nDefault)
        {
            object val;
            val = oReader.GetValue(oReader.GetOrdinal(sPropName));
            if (val != System.DBNull.Value)
                return (double)val;
            else
                return nDefault;
        }
        static public Guid GetGuidProperty(IDataReader oReader, string sPropName, Guid gDefault)
        {
            object val;
            val = oReader.GetValue(oReader.GetOrdinal(sPropName));
            if (val != System.DBNull.Value)
                return (Guid)val;
            else
                return gDefault;
        }

    }
}
