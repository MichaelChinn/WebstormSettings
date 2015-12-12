using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data.SqlClient;

using EDSIntegrationLib;

using DbUtils;

namespace PreProcessNightlyImport
{

    class Program
    {
        private static void NewSchools(DbConnector conn)
        {
            // New Schools
            conn = new DbConnector(ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString);

            SqlDataReader r = conn.ExecuteDataReader("GetUnknownSchools");
            List<string> schoolCodeList = new List<string>();
            while (r.Read())
            {
                schoolCodeList.Add((string)r["SchoolCode"]);
            }
            r.Close();

            foreach (string schoolCode in schoolCodeList)
            {
                string districtName = null;
                string districtCode = null;
                string schoolName = null;
                DistrictSchoolEntityLookup.GetInfoForSchoolCode(schoolCode, ref districtCode, ref districtName, ref schoolName);

                conn = new DbConnector(ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString);
                SqlParameter[] aParams = new SqlParameter[] { 
                    new SqlParameter("@pDistrictCode", districtCode), 
                    new SqlParameter("@pSchoolCode", schoolCode),
                    new SqlParameter("@pSchoolName", schoolName) 
                };
                conn.ExecuteNonQuery("InsertNewSchool", aParams);

            }
        }

        private static void NewDistricts(DbConnector conn)
        {
            // New Districts
            conn = new DbConnector(ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString);
            SqlDataReader r = conn.ExecuteDataReader("GetUnknownDistricts");
            List<string> districtCodeList = new List<string>();
            while (r.Read())
            {
                districtCodeList.Add((string)r["DistrictCode"]);
            }
            r.Close();

            foreach (string districtCode in districtCodeList)
            {
                string districtName = DistrictSchoolEntityLookup.GetDistrictName(districtCode);
                conn = new DbConnector(ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString);
                SqlParameter[] aParams = new SqlParameter[] { 
                    new SqlParameter("@pDistrictCode", districtCode), 
                    new SqlParameter("@pDistrictName", districtName) 
                };
                conn.ExecuteNonQuery("InsertNewDistrict", aParams);
            }
        }
       
        static void Main(string[] args)
        {
            DbConnector conn = new DbConnector(ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString);
           // NewDistricts(conn);
           // NewSchools(conn);

            //TODO... MERGED USER PROCESSING

            /*
             * test code....
            */
            string districtName = null;
            string districtCode = null;
            string schoolName = null;
            DistrictSchoolEntityLookup.GetInfoForSchoolCode("3075", ref districtCode, ref districtName, ref schoolName);
             /* */
        }


        
    }
}
