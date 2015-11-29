using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data.SqlClient;

using EDSIntegrationLib;
using NUnit.Framework;
using DbUtils;

namespace Tests
{
    [TestFixture]
    class SimpleTests
    {

        string _connString = "data source=localhost;database=StateEval;uid=sa;pwd=mumBleFr@tz;Pooling=true;Max Pool Size=2000";

        void ExecuteDbString(string sqlCmd)
        {
            DbConnector conn = new DbConnector(_connString);
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", sqlCmd) };
            conn.ExecuteNonQuery("GetOneOff", aParams);
        }
        SqlDataReader ReadFromDb(string sqlCmd)
        {
            DbConnector conn = new DbConnector(_connString);
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", sqlCmd) };
            return conn.ExecuteDataReader("GetOneOff", aParams);
        }
   
        Dictionary<string, string> _districtNames = new Dictionary<string, string>
        {
            {"01109","Washtucna School District"}
           , {"01122", "Benge School District"}
           , {"01147", "Othello School District"}
        };


        //all from district '01147'
        Dictionary<string, string> _schoolNames = new Dictionary<string, string>
        {
            {"2902","Lutaga Elementary"}
           , {"2961", "Hiawatha Elementary School"}
           , {"3015", "Othello High School"}
        };

        [SetUp]
        public void Init()
        {
            ExecuteDbString("delete edsRoles");
            foreach (string code in _districtNames.Keys)
            {
                ExecuteDbString("insert edsRoles (ospiLegacycode) values ('" + code + "')");
            }

            foreach (string code in _schoolNames.Keys)
            {
                ExecuteDbString("insert edsRoles (ospiLegacycode) values ('" + code + "')");
            }

        }


        [Test]
        public void DistrictTest()
        {
            DbConnector conn;
            SqlParameter[] aParams;

            ExecuteDbString("delete sedistrictschool where districtcode in ('01122', '01147', '01109') and isschool = 0");
            conn = new DbConnector(_connString);
            SqlDataReader r = conn.ExecuteDataReader("GetUnknownDistricts");
            List<string> DistrictCodeList = new List<string>();
            while (r.Read())
            {
                DistrictCodeList.Add((string)r["DistrictCode"]);
            }
            r.Close();

            Assert.AreEqual(3, DistrictCodeList.Count);

            foreach (string districtCode in DistrictCodeList)
            {
                string districtName = _districtNames[districtCode];
                conn = new DbConnector(_connString);
            
                aParams = new SqlParameter[] { 
                    new SqlParameter("@pDistrictCode", districtCode), 
                    new SqlParameter("@pDistrictName", districtName) 
                };
                conn.ExecuteNonQuery("InsertNewDistrict", aParams);
            }


            foreach (string districtCode in DistrictCodeList)
            {
                r = ReadFromDb("select * from vdistrictName where districtCode = '" + districtCode + "'");


                int nRecs = 0;
                string districtName = "";
                while (r.Read())
                {
                    districtName = (string)r["Districtname"];
                    nRecs++;
                }
                r.Close();

                Assert.AreEqual(1, nRecs);

                Assert.AreEqual(_districtNames[districtCode], districtName);
            }
        }

        [Test]
        public void SchoolTest()
        {

            ExecuteDbString("delete seDistrictSchool where Schoolcode in ('2902', '2961', '3015') and isschool = 1");

            DbConnector conn = new DbConnector(_connString);
            SqlDataReader r = conn.ExecuteDataReader("GetUnknownSchools");
            List<string> schoolCodeList = new List<string>();
            while (r.Read())
            {
                schoolCodeList.Add((string)r["SchoolCode"]);
            }
            r.Close();

            Assert.AreEqual(3, schoolCodeList.Count);

            foreach (string schoolCode in schoolCodeList)
            {
                string SchoolName = _schoolNames[schoolCode];
                conn = new DbConnector(_connString);
                SqlParameter[]aParams = new SqlParameter[] { 
                    new SqlParameter("@pSchoolCode", schoolCode), 
                    new SqlParameter("@pSchoolName", SchoolName),
                    new SqlParameter("@pdistrictcode", "01147")
                };
                conn.ExecuteNonQuery("InsertNewSchool", aParams);
            }


            foreach (string SchoolCode in schoolCodeList)
            {
                string SchoolName = "";
                string Districtcode = "";
                r = ReadFromDb("select * from vSchoolName where SchoolCode = '" + SchoolCode + "'");

                int nRecs = 0;

                while (r.Read())
                {
                    SchoolName = (string)r["Schoolname"];
                    Districtcode = (string)r["Districtcode"];
                    nRecs++;
                }
                r.Close();

                Assert.AreEqual(1, nRecs);

                Assert.AreEqual(_schoolNames[SchoolCode], SchoolName);
                Assert.AreEqual("01147", Districtcode);
            }
        }
    }

}
