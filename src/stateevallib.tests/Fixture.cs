using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using NUnit.Framework;
using DbUtils;
using System.Data.SqlClient;
using StateEval;
//using RepositoryLib;

namespace StateEval.tests
{
    public static class PilotDistricts
    {
        public const string Almira = "22017";
        public const string Davenport = "22207";
        public const string Liberty = "32362";
        public const string MedicalLake = "32326";
        public const string Pullman = "38267";
        public const string Reardan = "22009";
        public const string Ritzville = "01160";
        public const string Wellpinit = "33049";
        public const string Wilbur = "22200";
        public const string Anacortes = "29103";
        public const string CentralValley = "32356";
        public const string Kennewick = "03017";
        public const string NorthMason = "23403";
        public const string NorthThurston = "34003";
        public const string Othello = "01147";
        public const string Snohomish = "31201";
        public const string Wenatchee = "04246";

    }
    public static class RublicRows
    {
        public const long RublicRowId1 = 1;
        public const long RublicRowId2 = 2;
        public const long RublicRowId3 = 3;
        public const long RublicRowId4 = 10000;
    }

    public static class PEvalSessionID
    {
        public const long EvalSessionID1 = 1;
    }

    public static class PilotSchools
    {
        public const string NorthThurston_NorthThurstonHS = "3010";
        public const string NorthThurston_SouthBayES = "2754";
        public const string Othello_OthelloHS = "3015";
    }

    [SetUpFixture]
    class Fixture
    {
		public static string DATABASE_BACKUP_PATH = @"C:\temp\";
		//static string DATABASE_BACKUP_PATH = @"G:\temp\";



        /* administratively changeable ***********************************************/
        public static SESchoolYear CurrentSchoolYear = SESchoolYear.SY_2015;

        public const string ESD101User = "ESD101 Ad";
        public const string NorthThurstonDistrictUser = "North Thurston Public Schools";
        public const string OthelloDistrictUser = "Othello School District";

        public const string NorthThurstonDistrictUserName_DE = "North Thurston Public Schools DE1";
        public const string NorthThurstonDistrictUserName_DA = "North Thurston Public Schools DA";
        public const string NorthThurstonHSUserName_PR = "North Thurston High School PR1";
        public const string NorthThurstonHSUserName_PRH = "North Thurston High School PRH";
        public const string NorthThurstonHSUserName_AD = "North Thurston High School AD";
        public const string NorthThurstonDistrictUserName_DTE = "North Thurston Public Schools DTE1";

        public const string NorthThurstonHSUserName_T1 = "North Thurston High School T1";
        public const string NorthThurstonHSUserName_T2 = "North Thurston High School T2";
        public const string NorthThurstonHSUserName_TMS = "North Thurston High School TMS";

        public const string AspireMSUserName_PR = "Aspire Middle School PR1";
        public const string AspireMSUserName_T1 = "Aspire Middle School T1";
        public const string AspireMSUserName_T2 = "Aspire Middle School T2";
        public const string AspireMSUserName_TMS = "Aspire Middle School TMS";

        public const string HorizonsMSUserName_PR = "Horizons Elementary PR1";
        public const string HorizonsMSUserName_T1 = "Horizons Elementary T1";
        public const string HorizonsMSUserName_T2 = "Horizons Elementary T2";
        public const string HorizonsMSUserName_TMS = "Horizons Elementary TMS";

        public const string OthelloDistrictUserName_DTE = "Othello School District DTE1";
        public const string OthelloDistrictUserName_DA = "Othello School District DA";
        public const string OthelloHSUserName_PR = "Othello High School PR1";
        public const string OthelloHSUserName_T1 = "Othello High School T1";
        public const string OthelloHSUserName_T2 = "Othello High School T2";


        public static DbConnector masterDbConnector;
        public static SEMgr SEMgr;
        //public static RepositoryMgr RepoMgr;

        public static Guid ESD101Ad_UserId = new Guid("67d281c4-7526-46fe-991f-130f08746fe2");
        public static string MsgSubject = "Test message subject";
        public static string MsgBody = "Test message body";


        // retrieve connection strings from StateEval.tests.dll.config in bin/Debug directory
        public static string _masterConnectionString; 
        public static string _connectionString; // = "data source=localhost;database=StateEval;uid=sa;pwd=;Pooling=true;Max Pool Size=2000;";
        public static string _repoConnectionString; // = "data source=localhost;database=StateEval_Repo;uid=sa;pwd=;Pooling=true;Max Pool Size=2000;";
        public static string MasterConnectionString { get { return _masterConnectionString; } }

        public static string SnapshotName(string connectionString)
        {
            return DatabaseName(connectionString) + "_TestSS";
        }

        public static string DatabaseName(string connectionString)
        {
            //!! don't call this before you initialize the connection string!
            string[] parts = connectionString.Split(new char[] { ';' });
            foreach (string part in parts)
            {
                if ((part.ToLower().Contains("initial catalog"))||(part.ToLower().Contains("database")))
                {
                    string[] toks = part.Split(new char[] { '=' });
                    return toks[1];
                }
            }
            return null;
        }

        //static constructor
		static Fixture()
		{
			DATABASE_BACKUP_PATH = @"C:\temp\";
			if (!Directory.Exists(DATABASE_BACKUP_PATH))
			{
				DATABASE_BACKUP_PATH = @"G:\temp\";
				if (!Directory.Exists(DATABASE_BACKUP_PATH))
				{
					if (Directory.Exists("C:\\"))
					{
						Directory.CreateDirectory(@"C:\temp\");
						DATABASE_BACKUP_PATH = @"C:\temp\";
					}
				}
			}
			//string DATABASE_BACKUP_PATH = @"G:\temp\";

		}
		
		public Fixture() { }


        [TearDown]
        public void Cleanup()
        {
            RevertSnapshot(DatabaseName(_connectionString));
            RevertSnapshot(DatabaseName(_repoConnectionString));

        }
        [SetUp]
        public void Init()
        {
             _connectionString = ConfigurationManager.ConnectionStrings["StateEval.tests.Properties.Settings.stateevalConnectionString"].ConnectionString;
            _repoConnectionString = ConfigurationManager.ConnectionStrings["StateEval.tests.Properties.Settings.StateEval_RepoConnectionString"].ConnectionString;
            _masterConnectionString = ConfigurationManager.ConnectionStrings["StateEval.tests.Properties.Settings.masterConnectionString"].ConnectionString;
           
			
            Fixture.SEMgr = new SEMgr(_connectionString);
            //Fixture.RepoMgr = new RepositoryMgr(_repoConnectionString);
            SEMgr.EnableTraceOutput = true;

            SnapshotDB(DatabaseName(_connectionString));
            SnapshotDB(DatabaseName(_repoConnectionString));
        }

        public static void SEMgrExecute(string sqlCmd)
        {
            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", sqlCmd) };
            SEMgr.DbConnector.ExecuteNonQuery("GetOneOff", aParams);
        }

        public static void RepoMgrExecute(string sqlCmd)
        {
            //SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSqlCmd", sqlCmd) };
            //RepoMgr.DbConnector.ExecuteNonQuery("GetOneOff", aParams);
        }

   
        private static void RunSqlCmd(string cmd)
        {
            System.Diagnostics.Process process1 = new System.Diagnostics.Process();
            process1.EnableRaisingEvents = false;

            process1.StartInfo.FileName = "sqlcmd";
            process1.StartInfo.Arguments = cmd;
            process1.Start();
        }

        public static void RevertDbInner(string dbName, string ssName, string backupPath)
        {
            if (File.Exists(backupPath))
            {

                try
                {
                    Fixture.masterDbConnector = new DbConnector(_masterConnectionString);
                    masterDbConnector.ExecuteNonSpNonQuery("use master ALTER DATABASE " + dbName + " SET SINGLE_USER WITH ROLLBACK IMMEDIATE");

                    Fixture.masterDbConnector = new DbConnector(_masterConnectionString);
                    masterDbConnector.ExecuteNonSpNonQuery("use master RESTORE DATABASE [" + dbName + "] FROM  DISK = N'" + DATABASE_BACKUP_PATH
                                                         + ssName + ".bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10");
                }
                catch { }
                finally
                {
                    try
                    {
                        // MAKE SURE THE DATABASE DOESN'T END UP STUCK IN SINGLE USER MODE
                        Fixture.masterDbConnector = new DbConnector(_masterConnectionString);
                        masterDbConnector.ExecuteNonSpNonQuery("use master ALTER DATABASE " + dbName + " SET MULTI_USER");
                    }
                    catch { }
                }
            }
        }





        static string SS_SUFFIX = "_SnapShot";

        public static void RevertSnapshot(string dbName)
        {
            ExecuteMasterNonQuery("use master ALTER DATABASE " + dbName + " SET SINGLE_USER WITH ROLLBACK IMMEDIATE");


            string backupPath = Fixture.DATABASE_BACKUP_PATH + dbName + SS_SUFFIX; 
            string sqlCmd = "RESTORE DATABASE [" + dbName + "] FROM  DISK = N'"
                + backupPath + "' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10";
            ExecuteMasterNonQuery(sqlCmd);


            //take it back out of single user mode
            ExecuteMasterNonQuery("ALTER DATABASE " + dbName + " SET MULTI_USER");
        }



        public static void SnapshotDB(string dbName)
        {
            
            string backupPath = Fixture.DATABASE_BACKUP_PATH + dbName + SS_SUFFIX; 

            File.Delete(backupPath);
            
            ExecuteMasterNonQuery("ALTER DATABASE " + dbName + " SET SINGLE_USER WITH ROLLBACK IMMEDIATE");


            string sqlCmd = "BACKUP DATABASE [" + dbName + "] TO  DISK = N'" + backupPath
                       + "' WITH NOFORMAT, INIT,  NAME = N'" + dbName + " Snapshot For Test', SKIP, NOREWIND, NOUNLOAD,  STATS = 10";
            ExecuteMasterNonQuery(sqlCmd);



            ExecuteMasterNonQuery("ALTER DATABASE " + dbName + " SET MULTI_USER");
        }

        static void ExecuteMasterNonQuery(string sqlCmd)
        {
            DbConnector masterDbConnector = new DbConnector(Fixture.MasterConnectionString);
            masterDbConnector.ExecuteNonSpNonQuery(sqlCmd);
            masterDbConnector.Close();
        }







    }

}