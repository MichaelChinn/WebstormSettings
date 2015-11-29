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
    public class Framework : RRDbObject, IDbObject
    {
        string _name;
        string _description;
        string _districtCode;
        int _schoolYear;
        int _frameworkTypeID;
        int _ifwTypeID;
        bool _isPrototype;
        

        public string Name { get { return _name; } set { _name = value; } }
        public string Description { get { return _description; } set { _description = value; } }
        public string DistrictCode { get { return _districtCode; } set { _districtCode = value; } }
        public int SchoolYear { get { return _schoolYear; } set { _schoolYear = value; } }
        public int FrameworkTypeID { get { return _frameworkTypeID; } set { _frameworkTypeID = value; } }
        public FrameworkType FrameworkType { get { return (FrameworkType)_frameworkTypeID; } set { _frameworkTypeID = Convert.ToInt16(value); } }
        public int IFWType { get { return _ifwTypeID; } set { _ifwTypeID = value; } }
        public bool IsPrototype { get { return _isPrototype; } set { _isPrototype = value; } }

        void IDbObject.Load(IDataReader oReader, object o)
        {
            Init(o);
            m_nId = GetLongProperty(oReader, "FrameworkId", 0);

            _name = GetStringProperty(oReader, "Name", "");
            _description = GetStringProperty(oReader, "Description", "");
            _isPrototype = GetBooleanProperty(oReader, "IsPrototype", false);
            _districtCode = GetStringProperty(oReader, "DistrictCode", "");
            _schoolYear = GetInt16Property(oReader, "SchoolYear", 0);
            _frameworkTypeID = GetInt16Property(oReader, "FrameworkTypeID", 0);
            _ifwTypeID = GetInt16Property(oReader, "IFWTypeID", 0);
            
        }

        public DataTable RubricRows
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pFrameworkId", m_nId)

                };

                return DbConnector.GetDataTable("AllRubricRowsForFramework", aParams);
            }
        }
        public void Save()
        {
           /* SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pRubricRowId", m_nId)
                ,new SqlParameter("@pTitle"          ,  _name          )
                ,new SqlParameter("@pDescription"    ,  _description    )
                ,new SqlParameter("@pPl1"            ,  _districtCode            )
                ,new SqlParameter("@pPl2"            ,  _schoolYear            )
                ,new SqlParameter("@pPl3"            ,  _frameworkTypeID            )
                ,new SqlParameter("@pPl4"            ,  _ifwTypeID            )
                ,new SqlParameter("@pSequence"       ,  _isPrototype       )
                ,new SqlParameter("@pFrameworkNodeId",  _frameworkNodeId)
            };*/

           // DbConnector.ExecuteNonQuery("UpdateRubricRow", aParams);
        }

    }
}
