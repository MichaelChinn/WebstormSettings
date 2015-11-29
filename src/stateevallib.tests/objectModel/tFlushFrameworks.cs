using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;
using System.EnterpriseServices;

using NUnit.Framework;
using DbUtils;

using RepositoryLib;

namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tFlushFrameworks
    {
        #region Tables in StateEval
        List<string> _seTables = new List<string>()
        {"SEArtifact"
        ,"SEDistrictConfiguration"
        ,"SEEvalAssignmentRequest"
        ,"SEEvalSession"
        ,"SEEvaluation"
        ,"SEFramework"
        ,"SEReportSnapshot"
        ,"SEResource"
        ,"SESchoolConfiguration"
        ,"SESchoolYearDistrictConfig"
        ,"SEUserPrompt"
        ,"SEUserPromptResponse"
        ,"SEPullQuote"
        ,"SEEvalVisibility"
        ,"SEFrameworkNode"
        ,"SEFrameworkPerformanceLevel"
        ,"SERubricRowFrameworkNode"
        ,"SEFrameworkNodeScore"
        ,"SERubricRow"
        ,"SESummativeFrameworkNodeScore"
        ,"SETrainingProtocolFrameworkNodeAlignment"
        ,"SEArtifactRubricRowAlignment"
        ,"SEEvalSessionRubricRowFocus"
        ,"SERubricPLDTextOverride"
        ,"SERubricRowAnnotation"
        ,"SERubricRowScore"
        ,"SESummativeRubricRowScore"
        ,"SEUserPromptRubricRowAlignment"
        ,"SEUserPromptConferenceDefault"
        ,"SEUserPromptResponseEntry"
        ,"SEReportPrintOptionUser"
        ,"SETrainingProtocolLabelAssignment"
        ,"LocationRoleClaim"
        ,"Message"
        ,"MessageHeader"
        ,"MessageTypeRecipientConfig"
        ,"MessageTypeRole"
        ,"AppRole"
        ,"aspnet_Applications"
        ,"aspnet_Membership"
        ,"aspnet_Profile"
        ,"aspnet_Roles"
        ,"aspnet_SchemaVersions"
        ,"aspnet_Users"
        ,"aspnet_UsersInRoles"
        ,"DebugTrace"
        ,"EDSError"
        ,"veDsroles"
        ,"EDSStaging"
        ,"veDsUsers"
        ,"ELMAH_Error"
        ,"EmailDeliveryType"
        ,"EvaluationMap"
        ,"MessageType"
        ,"SEAnchorType"
        ,"SEArtifactType"
        ,"SEDistrictResource"
        ,"SEEvalAssignmentRequestStatusType"
        ,"SEEvalAssignmentRequestType"
        ,"SEEvalSessionLibraryVideo"
        ,"SEEvalSessionLockState"
        ,"SEEvaluateePlanType"
        ,"SEEvaluationRoleType"
        ,"SEEvaluationScoreType"
        ,"SEEvaluationType"
        ,"SEFrameworkType"
        ,"SEFrameworkViewType"
        ,"SEIFWType"
        ,"SEReportPrintOption"
        ,"SEReportPrintOptionType"
        ,"SEReportType"
        ,"SEResourceType"
        ,"SERubricPerformanceLevel"
        ,"SESchoolYear"
        ,"SETrainingProtocol"
        ,"SETrainingProtocolLabel"
        ,"SETrainingProtocolLabelGroup"
        ,"SEUserPromptType"
        ,"Trace"
        ,"UpdateLog"
        ,"SEDistrictSchool"
        ,"SEUser"
        ,"SEUserDistrictSchool"
        ,"SEUserLocationRole"
        };
        #endregion

        [Test]
        public void TestFlush()
        {
            /*
             * 
             * This test is meaningful only when run against a production database
             * HOWEVER, it will run successfully against a rebuilt database as well.
             *
             */


            /*
             * 
             * the first district was picked arbitrarily
             * 
             * however, after running it the first time, a number (7) of tables
             * which should have been affected had zero records to be removed.
             * This was because 27416 did not use the features in StateEval which
             * hydrated those tables.
             * 
             * So, we went on a search for districts which had records in the 7 tables
             * */

            TestFlushForDistrictYear(2014, "27416");
            TestFlushForDistrictYear(2014, "03116"); //picks up at least SEEvalAssignmentRequest, SERubricPLDTextOverride,SEUserPromptConferenceDefault
            TestFlushForDistrictYear(2014, "27400"); //picks up at least SEReportSnaposhot
            TestFlushForDistrictYear(2014, "14099"); //picks up at least SEResource
            TestFlushForDistrictYear(2014, "04222"); //picks up at least SESummativeFrameworkNodeScore, SESummativeRubricRowScore

        }

        private void TestFlushForDistrictYear(int SchoolYear, string DistrictCode)
        {
            Dictionary<string, long> InitialCounts = new Dictionary<string, long>();
            Dictionary<string, long> flushCounts = new Dictionary<string, long>();

            /*
             * we establish the initial number of records in each table
             * and also the number of records expected to be flushed in the affected table
             * do the flush and compare the record numbers
             * 
             * by this we know that only the tables expected to be flushed are affectd
             * we know that the right number of tables are flushed from the expected tables
             * (even though strictly speaking, we don't know that the *right* records have been flushed)
             * */
            //initial number of records in each table
            foreach (string table in _seTables)
            {
                InitialCounts.Add(table, GetTableCount(table));
            }

            //number of records in each of the affected tables that are expected to be flushed
            flushCounts.Add("SEArtifact", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEArtifact"));
            flushCounts.Add("SEDistrictConfiguration", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEDistrictConfiguration"));
            flushCounts.Add("SEEvalAssignmentRequest", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEEvalAssignmentRequest"));
            flushCounts.Add("SEEvalSession", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEEvalSession"));
            flushCounts.Add("SEEvaluation", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEEvaluation"));
            flushCounts.Add("SEFramework", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEFramework"));
            flushCounts.Add("SEReportSnapshot", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEReportSnapshot"));
            flushCounts.Add("SEResource", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEResource"));
            flushCounts.Add("SESchoolConfiguration", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SESchoolConfiguration"));
            flushCounts.Add("SESchoolYearDistrictConfig", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SESchoolYearDistrictConfig"));
            flushCounts.Add("SEUserPrompt", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEUserPrompt"));
            flushCounts.Add("SEUserPromptResponse", GetFlushCountFromDCSY(SchoolYear, DistrictCode, "SEUserPromptResponse"));

            flushCounts.Add("SEFrameworkNode", GetFlushCountFromFrameworkId(SchoolYear, DistrictCode, "SEFrameworkNode"));
            flushCounts.Add("SEFrameworkPerformanceLevel", GetFlushCountFromFrameworkId(SchoolYear, DistrictCode, "SEFrameworkPerformanceLevel"));

            flushCounts.Add("SERubricRowFrameworkNode", GetFlushCountFromFrameworkNodeId(SchoolYear, DistrictCode, "SERubricRowFrameworkNode"));
            flushCounts.Add("SEFrameworkNodeScore", GetFlushCountFromFrameworkNodeId(SchoolYear, DistrictCode, "SEFrameworkNodeScore"));
            flushCounts.Add("SESummativeFrameworkNodeScore", GetFlushCountFromFrameworkNodeId(SchoolYear, DistrictCode, "SESummativeFrameworkNodeScore"));
            flushCounts.Add("SETrainingProtocolFrameworkNodeAlignment", GetFlushCountFromFrameworkNodeId(SchoolYear, DistrictCode, "SETrainingProtocolFrameworkNodeAlignment"));

            flushCounts.Add("SERubricRow", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SERubricRow"));
            flushCounts.Add("SEArtifactRubricRowAlignment", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SEArtifactRubricRowAlignment"));
            flushCounts.Add("SEEvalSessionRubricRowFocus", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SEEvalSessionRubricRowFocus"));
            flushCounts.Add("SERubricPLDTextOverride", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SERubricPLDTextOverride"));
            flushCounts.Add("SERubricRowAnnotation", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SERubricRowAnnotation"));
            flushCounts.Add("SERubricRowScore", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SERubricRowScore"));
            flushCounts.Add("SESummativeRubricRowScore", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SESummativeRubricRowScore"));
            flushCounts.Add("SEUserPromptRubricRowAlignment", GetFlushCountFromRubricRowId(SchoolYear, DistrictCode, "SEUserPromptRubricRowAlignment"));

            flushCounts.Add("SEPullQuote", GetFlushCountForSecondLevelTable(SchoolYear, DistrictCode, "SEPullQuote", "SEEvalSession", "evalSessionId"));
            flushCounts.Add("SEEvalVisibility", GetFlushCountForSecondLevelTable(SchoolYear, DistrictCode, "SEEvalVisibility", "SEEvaluation", "evaluationid"));
            flushCounts.Add("SEUserPromptConferenceDefault", GetFlushCountForSecondLevelTable(SchoolYear, DistrictCode, "SEUserPromptConferenceDefault", "SEUserPrompt", "userPromptId"));
            flushCounts.Add("SEUserPromptResponseEntry", GetFlushCountForSecondLevelTable(SchoolYear, DistrictCode, "SEUserPromptResponseEntry", "SEUserPromptResponse", "userpromptresponseid"));

            Assert.AreEqual(30, flushCounts.Keys.Count);

            DoFlush(SchoolYear, DistrictCode);


            //now check...
            foreach (string table in _seTables)
            {
                long resultingCount = 0;
                long actual = GetTableCount(table);
                if (flushCounts.ContainsKey(table))
                {
                    resultingCount = InitialCounts[table] - flushCounts[table];
                    Assert.AreEqual(resultingCount, actual, "flushed..." + table + "... district: " + DistrictCode + "... schoolYear: " + SchoolYear.ToString());
                }
                else
                {
                    resultingCount = InitialCounts[table];
                    Assert.AreEqual(resultingCount, actual, table + "... district: " + DistrictCode + "... schoolYear: " + SchoolYear.ToString());
                }
            }


        
        }
        private void DoFlush(int schoolYear, string districtCode)
        {
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSchoolYear", schoolYear), new SqlParameter("@pDistrictCode", districtCode) };
            Fixture.SEMgr.DbConnector.ExecuteNonQuery("FlushFrameworkForDistrictAndSchoolYear", aParams);
        }

        private long GetTableCount(string table)
        {
            SqlParameter[]aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count (*) from " + table) };
            object foo = Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams);
            return Convert.ToInt64(foo);
        }

        private long GetFlushCountFromDCSY(int schoolYear, string districtCode, string tableName)
        {
            SqlParameter[] aParams;
            aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", "select count (*) from " + tableName + " where schoolYear = " + schoolYear + " and districtCode = '" + districtCode + "'") };
            return Convert.ToInt64(Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));

        }
        private long GetFlushCountFromFrameworkId(int schoolYear, string districtCode, string tableName)
        {
            string SqlCmd = "SELECT count(*) FROM "+tableName+" t"
                        + " JOIN seFramework f ON f.frameworkId = t.FrameworkID"
                        + " WHERE f.SchoolYear = "+schoolYear.ToString()+" AND f.districtcode = '"+districtCode+"'";

            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", SqlCmd) };
            return Convert.ToInt64(Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }
        private long GetFlushCountFromFrameworkNodeId(int schoolYear, string districtCode, string tableName)
        {
            string SqlCmd = "SELECT count(*) FROM " + tableName + " t"
                        + " join seFrameworkNode fn on fn.FrameworkNodeID = t.frameworkNodeID"
                        + " JOIN seFramework f ON f.frameworkId = fn.FrameworkID"
                        + " WHERE f.SchoolYear = " + schoolYear.ToString() + " AND f.districtcode = '" + districtCode + "'";

            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", SqlCmd) };
            return Convert.ToInt64(Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }
        private long GetFlushCountFromRubricRowId(int schoolYear, string districtCode, string tableName)
        {
            string SqlCmd = "SELECT  COUNT(*)"
                    + "FROM    " + tableName + " "
                    + "WHERE   RubricRowID IN ("
                    + "        SELECT  rubricRowID"
                    + "        FROM    dbo.SERubricRowFrameworkNode rrfn"
                    + "                JOIN dbo.SEFrameworkNode fn ON fn.FrameworkNodeID = rrfn.FrameworkNodeID"
                    + "                JOIN dbo.SEFramework fw ON fw.FrameworkID = fn.FrameworkID"
                    + "        WHERE   districtcode = '"+districtCode+"'"
                    + "                AND schoolYear = "+schoolYear+" )";

            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", SqlCmd) };
            return Convert.ToInt64(Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }
 
        private long GetFlushCountForSecondLevelTable(int schoolYear, string districtCode, string tableSecond, string tableFirst, string tableFirstId)
        {
            string SqlCmd = "SELECT count(*) FROM " + tableSecond + " tt2"
                        + " join "+tableFirst+" tt1 on tt1."+tableFirstId+" = tt2."+tableFirstId.ToString()

                        + " WHERE tt1.SchoolYear = " + schoolYear.ToString() + " AND tt1.districtcode = '" + districtCode + "'";

            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", SqlCmd) };
            return Convert.ToInt64(Fixture.SEMgr.DbConnector.ExecuteScalar("GetOneOff", aParams));
        }

    
    }
}
