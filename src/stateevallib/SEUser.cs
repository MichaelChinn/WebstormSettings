using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Collections.Generic;

using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;

using DbUtils;
using EDSIntegrationLib;

namespace StateEval
{
    [Serializable()]
	public class SEUser : SEDbObject, IDbObject, ISerializable
	{
        public SEUser() { }

    	/// <summary>
		/// Expose the Id field as read/write to allow mapping operations
		/// </summary>
		public long HackId
		{
			get
			{
				return Id;
			}
			set
			{
				SetId(value);
			}
		}

		void IDbObject.Load(IDataReader reader, object o)
		{
			Load(reader, o);
		}

		protected void Load(IDataReader reader, object o)
		{
			Init(o);
			m_nId = (long)reader["SEUserID"];
            UserName = GetStringProperty(reader, "UserName", "");
            Email = GetStringProperty(reader, "Email", "");
			FirstName = GetStringProperty(reader, "FirstName", "");
			LastName = GetStringProperty(reader, "LastName", "");
			District = GetStringProperty(reader, "DistrictName", "");
            DistrictCode = GetStringProperty(reader, "districtCode", "");
            SchoolCode = GetStringProperty(reader, "schoolCode", "");
			School = GetStringProperty(reader, "SchoolName", "");
            HasMultipleBuildings = GetBooleanProperty(reader, "HasMultipleBuildings", false);
            MessageEmailOverride = GetStringProperty(reader, "MessageEmailOverride", "");
            CertificateNumber = GetStringProperty(reader, "CertificateNumber", "");
            EmailAddressAlternate = GetStringProperty(reader, "EmailAddressalternate", "");
            LoginName = GetStringProperty(reader, "LoginName", "");
            MobileAccessKey = Convert.ToString((Guid)reader["MobileAccessKey"]);
		}

        public string MessageEmailOverride { get; set; }
        public string UserName { get; protected set; }
        public string Email { get; set; }
        public string LastName { get; set; }
        public string FirstName { get; set; }
		public string DisplayName { get { return FirstName + " " + LastName; } }
        public string District { get; protected set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public string School { get; protected set; }
        public bool HasMultipleBuildings { get; protected set; }
        public string CertificateNumber { get; set; }
        public string EmailAddressAlternate { get; protected set; }
        public string LoginName { get; protected set; }
        public string MobileAccessKey { get; set; }

		public override string ToString()
		{
			return LastName + ", " + FirstName;
		}

		/// <summary>
		/// Additional evaluation data
		/// </summary>
		//public SEEvaluation UserEvaluation { get; set; }

        public void SaveLocale()
        {
            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter("@pUserId", this.Id)
                ,new SqlParameter("@pDistrictCode", DistrictCode)
                ,new SqlParameter("@pSchoolCode", SchoolCode)
            };
            DbConnector.ExecuteNonQuery("UpdateUserLocale", aParams);
        }

        public void SaveMessageEmailOverride()
        {
            SqlParameter[] aParams = new SqlParameter[]{
                new SqlParameter("@pUserId", this.Id)
                ,new SqlParameter("@pEmail", MessageEmailOverride)
            };
            DbConnector.ExecuteNonQuery("UpdateUserMessageEmailOverride", aParams);
        }

        public List<string> Roles(string appName)
        {

            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@ApplicationName", appName)
                ,new SqlParameter("@UserName", UserName)
            };

            List<string> roles = new List<string>();

            SqlDataReader r = DbConnector.ExecuteDataReader("aspnet_UsersInRoles_GetRolesForUser", aParams);
            while (r.Read())
            {
                roles.Add((string)r[0]);
            }
            r.Close();

            return roles;
        }
        public void RemoveRolesFromUser(string appName, string removeRoles)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                     new SqlParameter("@ApplicationName", appName)
                    ,new SqlParameter("@UserNames", UserName)
                    ,new SqlParameter("@RoleNames", removeRoles)
                    
                };
            DbConnector.ExecuteNonQuery("aspnet_UsersInRoles_RemoveUsersFromRoles", aParams);

        }

        public SqlParameter[] AddRolesToUser(string appName, string newRoles)
        {
            SqlParameter[] aParams = new SqlParameter[]
                {
                     new SqlParameter("@ApplicationName", appName)
                    ,new SqlParameter("@UserNames", UserName)
                    ,new SqlParameter("@RoleNames", newRoles)
                    ,new SqlParameter("@CurrentTimeUtc", DateTime.UtcNow)
                };
            DbConnector.ExecuteNonQuery("aspnet_UsersInRoles_AddUsersToRoles", aParams);
            return aParams;
        }

        public void ChangeMobileAccessKey()
        {
            SqlParameter[] aParams = new SqlParameter[]
            {
                new SqlParameter("@pUserID", Id)
            };

            MobileAccessKey = Convert.ToString((Guid)DbConnector.ExecuteScalar("ChangeMobileAccessKey", aParams));
        }

        public List<SEUserDistrictSchool> Locations
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pUserId", this.Id) };
                return (List<SEUserDistrictSchool>)this.DbConnector.GetListOfType("GetSeUserDistrictSchools", aParams, typeof(SEUserDistrictSchool), this.Context);
            }
        }
        public void SaveUserBaseData()
        {
            SqlParameter[] aParams = new SqlParameter[] 
            { 
                new SqlParameter("@pUserId", this.Id) ,
                new SqlParameter("@pFirstName", this.FirstName),
                new SqlParameter("@pLastName", this.LastName),
                new SqlParameter("@pEmail", this.Email),
                new SqlParameter("@pCertNo", this.CertificateNumber),
                new SqlParameter("@pDistrictCode", this.DistrictCode),
                new SqlParameter("@pSchoolcode", this.SchoolCode)
            };
            DbConnector.ExecuteNonQuery("UpdateSeUser", aParams);
        }
        public LocalityRoleContainer LocationRoles
        {
            get
            {
                SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSEUserId", this.Id) };
                string lrString = (string)this.DbConnector.ExecuteScalar("GetEDSFormattedRoleStringForUser", aParams);
                return new LocalityRoleContainer(lrString, SEMgr.HydrateSchool2DistrictIfNecessary());
            }
        }
        public Dictionary<string, string> Districts
        {
            get
            {
                Dictionary<string, string> districts = new Dictionary<string, string>();
                SqlParameter[] aParams = new SqlParameter[] { new SqlParameter("@pSEUserId", this.Id) };
                SqlDataReader r = this.DbConnector.ExecuteDataReader("GetDistrictsForUser", aParams);

                while (r.Read())
                {
                    string districtCode = GetStringProperty(r, "DistrictCode", "");
                    string districtName = GetStringProperty(r, "DistrictName", "");
                    districts.Add(districtCode, districtName);
                }
                r.Close();
                return districts;
            }
        }
	}
}
