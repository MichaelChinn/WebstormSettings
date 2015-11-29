using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;

using DbUtils;

namespace StateEval
{
	public class SEUserDistrictSchool : SEDbObject, IDbObject
	{
        string _districtCode;
        string _schoolCode;
        string _districtName;
        string _schoolName;
        bool _isPrimary;

        public SEUserDistrictSchool() { }

		long IDbObject.Id { get { return m_nId; } }

		void IDbObject.Load(IDataReader reader, object o)
		{
			Load(reader, o);
		}

		protected void Load(IDataReader reader, object o)
		{
			Init(o);
			m_nId = (long)reader["SEUserID"];
  			_districtName = GetStringProperty(reader, "DistrictName", "");
            _districtCode = GetStringProperty(reader, "districtCode", "");
            _schoolCode = GetStringProperty(reader, "schoolCode", "");
			_schoolName = GetStringProperty(reader, "SchoolName", "");
            _isPrimary = GetBooleanProperty(reader, "IsPrimary", false);
		}

        public string District { get { return _districtName; } }
        public string School { get { return _schoolName; } }
        public string DistrictCode { get { return _districtCode; } }
        public string SchoolCode { get { return _schoolCode; } }
        public bool IsPrimary { get { return _isPrimary; } }
	}
}
