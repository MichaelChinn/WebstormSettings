using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections;
using System.IO;
using System.Text;
using System.Xml;
using System.Xml.Schema;
using System.Linq;

using StateEval.Security;

using Microsoft.IdentityModel.Claims;
using EDSIntegrationLib;
using DbUtils;
//using RepositoryLib;
//using StateEval.Messages;

//using HtmlAgilityPack;

namespace StateEval
{

    public class SEMgr
    {
        public const string AspNetAppName = "SE";

        public DbConnector DbConnector { get { return new DbConnector(_connectionString); } }
        public string ConnectionString { get { return _connectionString; } }
        string _connectionString;
        
        public SEMgr()
        {
            if (ConfigurationManager.ConnectionStrings["SEDbConnection"] == null ||
                ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString.Trim() == "")
            {
                throw new Exception("A connection string named 'SEDbConnection' with a valid connection string " +
                                    "must exist in the <connectionStrings> configuration section for the application.");
            }

            _connectionString =
              ConfigurationManager.ConnectionStrings["SEDbConnection"].ConnectionString;
            _enableTraceOutput = Convert.ToBoolean(ConfigurationManager.AppSettings["OutputTrace"].ToString());

        }
        private static SEMgr singleton = null;
        static public SEMgr Instance
        {
            get
            {
                if (singleton == null)
                {
                    singleton = new SEMgr();
                    singleton.EnableTraceOutput = Convert.ToBoolean(ConfigurationManager.AppSettings["OutputTrace"].ToString());
                }
                return singleton;

            }
        }
        public SEMgr(string connectionString)
        {
            _connectionString = connectionString;
        }


        bool _enableTraceOutput = false;
        public bool EnableTraceOutput { get { return _enableTraceOutput; } set { _enableTraceOutput = value; } }
        public void Trace(string key, string comment)
        {
            if (!_enableTraceOutput)
                return;

            comment = comment.Replace("'", "''");

            SqlParameter[] aParams = new SqlParameter[]
			{
                new SqlParameter("@pKey", key)
				,new SqlParameter("@pComment", comment)
			};

            DbConnector.ExecuteNonQuery("InsertDebugTrace", aParams);
        }



        public string PullQuoteColor { get { return "feef01"; } }
        public void RemoveAllColorTags(ref string s)
        {
            string bogusDocElement = "xyz_fliberty_gibbet";
            string x = "<" + bogusDocElement + ">" + s + "</" + bogusDocElement + ">";
            HtmlDocument doc = new HtmlDocument();
            doc.LoadHtml(x);

            HtmlNodeCollection nodes = doc.DocumentNode.SelectNodes("//*[contains(@style,'background-color')]");

            if (nodes != null)
            {
                int count = nodes.Count;
                for (int i = 0; i < count; i++)
                {
                    HtmlNode parent = nodes[i].ParentNode;
                    parent.RemoveChild(nodes[i], true);
                }
            }
            s = doc.DocumentNode.SelectSingleNode("/" + bogusDocElement).InnerHtml;
        }
        public bool GetNextBlock(ref BitArray bits, int startSearchAt, ref int blockStart, ref int blockLength)
        {
            bool toFind = bits[startSearchAt];
            blockStart = toFind == true ? FindNextTrue(ref bits, startSearchAt) : FindNextFalse(ref bits, startSearchAt);
            int blockEnd = FindLastInBlock(ref bits, blockStart);
            blockLength = blockEnd - blockStart;
            return toFind;
        }

        public void SetBitRange(ref BitArray bits, int start, int len)
        {
            try
            {
                for (int i = start; i < start + len; i++)
                {
                    bits.Set(i + start, true);
                }
            }
            catch (Exception e)
            {
                throw new Exception("you probably are trying to set a position longer than the bit array... " + e.Message);
            }
        }

        int FindLastInBlock(ref BitArray bits, int start)
        {
            bool theseBits = bits[start];
            int i = start;
            for (i = start; i < bits.Length; i++)
            {
                if (theseBits != bits[i])
                    break;
            }
            return i;
        }

        int FindNextTrue(ref BitArray bits, int startSearchAt)
        {
            int i = 0;
            for (i = startSearchAt; i < bits.Length; i++)
            {
                if (bits[i] == true)
                {
                    break;
                }
            }
            return i;
        }

        int FindNextFalse(ref BitArray bits, int startSearchAt)
        {
            int i = 0;
            for (i = startSearchAt; i < bits.Length; i++)
            {
                if (bits[i] == false)
                {
                    break;
                }
            }
            return i;
        }

        public SEUser SEUser(string username)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pSEUserName", username)
				};

            return (SEUser)DbConnector.GetObjectOfType("GetSEUserByUserName", aParams, typeof(SEUser), this);
        }

        /**************************************************************************/


        /*
                public List<string> GetAuxRolesList(string locationCode, List<string> rolesList)
                {
                    return GetAuxRolesList(
                        locationCode.Length == 4 ? true : false,
                        rolesList.Contains(UserRole.SESchoolPrincipal),
                        rolesList.Contains(UserRole.SETeacherEvaluator),
                        rolesList.Contains(UserRole.SEDistrictEvaluator),
                        rolesList.Contains(UserRole.SEPrincipalEvaluator)
                        );
                }
        */
        public void InsertEvaluationRecord(SEUser u, string homeDistrictCode, SEEvaluationType evalType)
        {
            /*
             EXEC @sql_error = dbo.InsertEvaluation @pEvaluationTypeID = @pEvaluationType,
             @pSchoolYear = NULL, @pDistrictCode = @pDistrictCode,
             @pEvaluateeID = @seUserID,
             @sql_error_message = @sql_error_message OUTPUT    * 
            */
            string sqlError = ""; //TODO: what am i going to do with this?
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@sql_error_message", sqlError)
                ,new SqlParameter("@pEvaluateeId", u.Id)
                ,new SqlParameter("@pDistrictCode", homeDistrictCode)
                ,new SqlParameter("@pEvaluationTypeId", evalType)

            };

            aParams[0].Direction = ParameterDirection.Output;
            DbConnector.ExecuteNonQuery("InsertEvaluation", aParams);
        }
        private void InsertEvaluationRecordsIfNecessary(SEUser u, string samlLrString)
        {
            //this ensures the user gets an seEvaluation record when he needs one.
            //.even across multiple districts
            LocalityRoleContainer lrcNew = new LocalityRoleContainer(samlLrString, HydrateSchool2DistrictIfNecessary());

            string theLastDistrict = "";

            for (int i = 0; i < lrcNew.Localities.Count; i++)
            {
                string location = lrcNew.Localities[i];
                string districtCode = location;
                string schoolCode = "";
                if (lrcNew.IsSchool(location))
                {
                    districtCode = lrcNew.DistrictCodeFor(location);
                    schoolCode = location;
                }

                if (districtCode != theLastDistrict)
                {
                    //so, the first time through the loop (assuming there are multiple locations)
                    //.we will also hit this code.  This means that InsertEvaluation gets called
                    //.every time we see a user regardless of whether we need to call it; however,
                    //.the sproc is smart enough not to insert into the seEvaluation table when
                    //.a record for the user and the school year and the district exists.

                    //every other time, through the loop, we'll only hit this code when the district changes
                    //.this addresses the fact that those in multiple districts need an evaluation record
                    //.for each district he's in.

                    theLastDistrict = districtCode;     //first time through is always different; others, only on change of district

                    u.DistrictCode = districtCode;  //have to change district code and 
                    u.SchoolCode = schoolCode;      //school code or InsertEvaluation doesn't do right thing
                    u.SaveUserBaseData();

                    //figure out whether we put in a type 1 or type 2 evaluation
                    string roleString = lrcNew.RolesAtString(location);
                    bool isTeacher = roleString.Contains(UserRole.SESchoolTeacher);
                    bool isPrincipal = (roleString.Contains(UserRole.SESchoolPrincipal) || (roleString.Contains(UserRole.SESchoolHeadPrincipal)));
                    if (isTeacher)
                    {
                        InsertEvaluationRecord(u, districtCode, SEEvaluationType.TEACHER_OBSERVATION);
                    }
                    if (isPrincipal)
                    {
                        InsertEvaluationRecord(u, districtCode, SEEvaluationType.PRINCIPAL_OBSERVATION);
                    }
                }
            }
        }

        public void ProcessClaimsAndSetupUser(Hashtable roleXlationTable, ClaimCollection incomingClaims)
        {
            //this method called from the WIF framwork and processes the SAML token and user

            SAMLTokenProcessor stp = new SAMLTokenProcessor(roleXlationTable, EdsIdentity.EdsNameTag, "eVal");
            stp.RolePickerFunction = PickFirstLocation;
            //stp.RoleAugmenterFunction = GetAuxRolesList;
            stp.RoleConsistencyFunction = RoleLocationConsistencyCheck;

            stp.ProcessToken(incomingClaims);

            if (stp.TokenPreviouslyProcessed)
                return;


            //create a user if necessary
            SEUser u = SearchForSEUser(stp.EDSUserId, stp.OldEDSIds);
            if (u == null)
            {
                u = CreateUserFromSAMLInfo(stp);
            }

            LocalityRoleContainer lrc = new LocalityRoleContainer(stp.LRString, HydrateSchool2DistrictIfNecessary());

            string location = lrc.Localities[0];
            string district = location;
            string school = "";
            if (lrc.IsSchool(location))
            {
                district = lrc.DistrictCodeFor(location);
                school = location;
            }

            //did any of the base info change? need to update the user's records
            if (
                (u.Email != stp.EMail)
                || u.FirstName != stp.FirstName
                || u.LastName != stp.LastName
                || u.CertificateNumber != stp.CertNo
                || u.SchoolCode != school
                || u.DistrictCode != district
            )
            {
                u.Email = stp.EMail;
                u.FirstName = stp.FirstName;
                u.LastName = stp.LastName;
                u.CertificateNumber = stp.CertNo;
                u.SchoolCode = school;
                u.DistrictCode = district;
                u.SaveUserBaseData();
            }

            //we try to insert an seEvaluation record everytime we see someone
            InsertEvaluationRecordsIfNecessary(u, stp.LRString);

            PersistLocalityRoleClaim(u, stp.LRString);
        }
        public void PersistLocalityRoleClaim(SEUser user, string samlLrString)
        {
            /*
             * Can't check the roles here; this only gets called from CustomClaimsAuthenticationManager,
             *  which gets called by the WIF framework; so exceptions in this method get caught by the 
             *  iis pipeline somewhere and god knows what happens to it after that... 
             *  
             * So, we will just set up the ones that were found by the STP (+ the aux ones)
             *  and will defer the checking until the web application is extant
             *  
             * Another big change here, this function called *after* the stp has returned.
             *  And we're assuming that the stp has created a new user if necessary.
             *  
             * Derive the current lrc (lrcCurrent) from the user that's in the database
             *  the passed in lrc (lrcNew) is what came from the token.
             * 
             * If either the locations or the roles are different, then just wipe out
             *  the old and replace with the new.
             * 
             */

            LocalityRoleContainer lrcCurrent = user.LocationRoles;
            LocalityRoleContainer lrcNew = new LocalityRoleContainer(samlLrString, HydrateSchool2DistrictIfNecessary());

            bool hasChanges = false;

            //any locale changes?
            if ((lrcNew.Localities.Except(lrcCurrent.Localities).ToList().Count + lrcCurrent.Localities.Except(lrcNew.Localities).ToList().Count) != 0)
                hasChanges = true;

            //any role changes?
            if ((lrcNew.Roles.Except(lrcCurrent.Roles).ToList().Count + lrcCurrent.Roles.Except(lrcNew.Roles).ToList().Count) >= 0)
                hasChanges = true;

            //if either location or role changes, save off new locations and roles.
            //this is a little weird, because we're saving these off using 'InserEDSFormattedRoleClaims'
            //but we do this for symmetry, as counterpart to 'GetEDSFormattedRoleStrings'... also,
            //i'm kind of keeping in mind when we have to separate out the districts and roles and move
            //and do the roles and locations in a manager all of our own.

            if (hasChanges)
            {
                StringBuilder sbAllRoles = new StringBuilder();
                StringBuilder sbAllLocations = new StringBuilder();
                foreach (string role in lrcNew.Roles)
                {
                    sbAllRoles.Append(role + ";");
                }
                foreach (string location in lrcNew.Localities)
                {
                    if (lrcNew.LooksLikeSchool(location))
                        sbAllLocations.Append(lrcNew.DistrictCodeFor(location) + "|" + location + ";");
                    else
                        sbAllLocations.Append(location + "|;");
                }

                if (sbAllLocations.Length > 0)
                    sbAllLocations.Length--;
                if (sbAllRoles.Length > 0)
                    sbAllRoles.Length--;

                SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pUserName", user.UserName)
                    ,new SqlParameter("@pAllLocationsString", sbAllLocations.ToString())
                    ,new SqlParameter("@pAllRoleString", sbAllRoles.ToString())
                };
                DbConnector.ExecuteNonQuery("InsertEDSFormattedRoleClaims", aParams);
            }
        }
        public bool RoleLocationConsistencyCheck(string locality, string role)
        {
            UserRole roleTable = new UserRole();
            if (locality.Length == 4)
                return roleTable.IsOkForSchool[role];
            else if (locality.Length == 5)
                return roleTable.IsOkForDistrict[role];
            return false;
        }
        public string PickFirstLocation(string userName, string localitiesAndRolesString)
        {
            //what the heck... just pick the first one...
            LocalityRoleContainer lrc = new LocalityRoleContainer(localitiesAndRolesString);
            return lrc.Localities[0];

        }

        public SEUser SEUserFromEDSPersonId(string personId)
        {
            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pPersonId", personId)
				};

            return (SEUser)DbConnector.GetObjectOfType("GetSEUserByEDSPersonId", aParams, typeof(SEUser), this);
        }
        public SEUser SearchForSEUser(string currentEDSId, string oldEDSIds)
        {
            //look for him with the current id
            SEUser u = SEUserFromEDSPersonId(currentEDSId);
            if (u == null)
            {
                //if you can't find him, search for him under his old ids
                string[] toks = oldEDSIds.Split(new char[] { ';' });
                foreach (string oldPersonId in toks)
                {
                    u = SEUserFromEDSPersonId(oldPersonId);
                    if (u != null)
                    {
                        string outputError = "";
                        //if you finally find him under an old id, change his username in the aspnet_users and seUsers table
                        SqlParameter[] aParams = new SqlParameter[]
                        {
                            new SqlParameter("@pCurrentEDSUserName", currentEDSId + "_edsUser"),
                            new SqlParameter("@pIDHistory", oldEDSIds),
                            new SqlParameter ("@sql_error_message", outputError)
                        };

                        aParams[2].Direction = System.Data.ParameterDirection.Output;

                        DbConnector.ExecuteNonQuery("ChangeEdsUserName", aParams);
                        break;
                    }
                }

                //did you find him under his old info? if so, refresh the object with new info
                if (u != null)
                    u = SEUserFromEDSPersonId(currentEDSId);
            }

            //he's either a user, or still null; if he's still null, we tried our best!
            return u;
        }
        public SEUser SEUserFromDecoratedEdsUserName(string decoratedName)
        {
            //decorated name looks like ... NNNNN_edsUser, where NNNNN is the eds PersonId
            int index = decoratedName.IndexOf('_');
            string personId = decoratedName.Substring(0, index); //TODO... get person id from the decorated name

            SqlParameter[] aParams = new SqlParameter[]
				{
					new SqlParameter("@pPersonId", personId)
				};

            return (SEUser)DbConnector.GetObjectOfType("GetSEUserByEDSPersonId", aParams, typeof(SEUser), this);
        }
        public SEUser CreateUserFromSAMLInfo(SAMLTokenProcessor stp)
        {
            //this is the first time we've seen a user, so we need to stuff info for him into our db
            //for instance, maybe he just got his account 15 minutes ago, and the nightly edsExport processing
            //has never run with him.

            //re: what districtCode and schoolCode code we give him:
            //... since we're keeping track of even his multi districtCode locations
            //... i guess we can just give him the first one!!!

            //first off, grab some info... districtCode, schoolCode, the rolestring (remember we can grab a rolestring at *any* 
            // location, because at the moment the roles *have* to be identical at each location

            LocalityRoleContainer lrc = new LocalityRoleContainer(stp.LRString, HydrateSchool2DistrictIfNecessary());
            string locationCode = lrc.Localities[0];

            string districtCode = locationCode;
            string schoolCode = "";

            if (lrc.IsSchool(locationCode))
            {
                districtCode = lrc.DistrictCodeFor(locationCode);
                schoolCode = locationCode;
            }



            SqlParameter[] aParams = new SqlParameter[]
                {
                    new SqlParameter("@pUserName", stp.AppUserName),
                    new SqlParameter("@pFirstName", stp.FirstName),
                    new SqlParameter("@pLastName", stp.LastName),
                    new SqlParameter("@pEMail", stp.EMail),
                    new SqlParameter("@pDistrictCode", districtCode),
                    new SqlParameter("@pSchoolCode", schoolCode) ,
                    new SqlParameter("@pCertNo", stp.CertNo)
                };
            SEUser u = (SEUser)DbConnector.GetObjectOfType("CreateUserFromSamlInfo", aParams, typeof(SEUser), this);

            return u;
        }

        public void UpdatePullQuoteImportant(long pullQuoteId, bool isImportant)
        {
            SqlParameter[] aParams = new SqlParameter[]
			{
				new SqlParameter("@pPullQuoteID", pullQuoteId)
				,new SqlParameter("@pIsImportant", isImportant)
			};

            DbConnector.ExecuteNonQuery("SetPullQuoteImportance", aParams);
        }

        public class SchoolInfo
        {
            public SchoolInfo(string name, string code) { Name = name; Code = code; }
            public string Name { get; set; }
            public string Code { get; set; }

        };
        public List<SchoolInfo> GetSchoolsInDistrict(string districtCode)
        {
            List<SchoolInfo> schools = new List<SchoolInfo>();

            SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pDistrictCode", districtCode) };

            SqlDataReader r = DbConnector.ExecuteDataReader("GetSchoolDistricts", aParams);
            try
            {
                while (r.Read())
                {
                    schools.Add(new SchoolInfo(Convert.ToString(r["Name"]), Convert.ToString(r["SchoolCode"])));
                }
            }
            finally { r.Close(); }

            return schools;
        }
        static Dictionary<string, string> School2District;
        public Dictionary<string, string> HydrateSchool2DistrictIfNecessary()
        {
            if (School2District == null)
            {

                School2District = new Dictionary<string, string>();

                SqlDataReader r = DbConnector.ExecuteDataReader("GetSchoolDistricts");
                while (r.Read())
                {
                    string schoolCode = (string)r["SchoolCode"];
                    string districtCode = (string)r["DistrictCode"];

                    if (School2District.ContainsKey(schoolCode))
                        continue;

                    School2District.Add(schoolCode, districtCode);
                }
            }
            return School2District;
        }


 
    }
}
