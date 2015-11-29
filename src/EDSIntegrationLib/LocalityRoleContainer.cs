using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using System.Collections;
using System.Text;

namespace EDSIntegrationLib
{
    public class LocalityRoleContainer
    {
        List<string> _localityCDSCodes = new List<string>();
        public string BogusDistrict = "-----";

        string _rawString;

        Hashtable _htCDSCode2RoleList = new Hashtable();
        Hashtable _htCDSCode2OrgName = new Hashtable();

        Dictionary<string, string> _school2District;

        string GetStringProperty(SqlDataReader oReader, string sPropName, string sDefault)
        {
            object val;
            val = oReader[sPropName];
            if (val != System.DBNull.Value)
                return (string)val;
            else
                return sDefault;
        }

        public override string ToString()
        {
            return _rawString;
        }

        public LocalityRoleContainer(string LocalitiesAndRolesString)
        {
            _school2District = null;
            InitLRContainer(LocalitiesAndRolesString);
        }

        public LocalityRoleContainer(string LocalitiesAndRolesString, Dictionary<string, string> school2District)
        {
            _school2District = school2District;
            InitLRContainer(LocalitiesAndRolesString);
        }

        private void InitLRContainer(string LocalitiesAndRolesString)
        {

            if (LocalitiesAndRolesString == null)
                return;
            if (LocalitiesAndRolesString.Length == 0)
                return;

            _rawString = LocalitiesAndRolesString;

            string[] lRClaims = LocalitiesAndRolesString.Split(new char[] { '|' });
            foreach (string lrClaim in lRClaims)
            {
                string[] toks = lrClaim.Split(new char[] { ';' });
                string locality = toks[1];
                _localityCDSCodes.Add(locality);

                List<string> localeRoles = new List<string>();
                for (int i = 2; i < toks.Length; i++)
                {
                    string theRole = toks[i].Trim();

                    if (!localeRoles.Contains(theRole))
                        localeRoles.Add(theRole);
                }

                if (!_htCDSCode2RoleList.ContainsKey(locality))
                    _htCDSCode2RoleList.Add(locality, localeRoles);

                if (!_htCDSCode2OrgName.ContainsKey(locality))
                    _htCDSCode2OrgName.Add(locality, toks[0]);
            }
        }

        //the translated eds-formatted role claim (orgName;cdsCode;role;role;...)
        public Hashtable Locality2LRString { get { return _htCDSCode2RoleList; } }

        //List<string> of localities in the saml token from eds
        public List<string> Localities { get { return _localityCDSCodes; } }

        //hashtable of roles at any given locality
        public Hashtable htRolesAt(string locality)
        {
            Hashtable retVal = new Hashtable();

            foreach (string role in RolesAtList(locality))
            {
                if (!retVal.ContainsKey(role))
                    retVal.Add(role, null);
            }
            return retVal;
        }

        public string OrgNameOf(string locality)
        {
            return (string)_htCDSCode2OrgName[locality];
        }

        //List<string> of roles at any given locality
        public List<string> RolesAtList(string locality)
        {
            return (List<string>)_htCDSCode2RoleList[locality];
        }

        public string RolesAtString(string locality)
        {
            StringBuilder s = new StringBuilder(OrgNameOf(locality) + ";" + locality);
            foreach (string role in RolesAtList(locality))
            {
                s.Append(";" + role);
            }
            return s.ToString();
        }
        public string RolesOnlyAtString(string locality)
        {
            StringBuilder s = new StringBuilder();
            foreach (string role in RolesAtList(locality))
            {
                s.Append(";" + role);
            }
            return s.ToString().Substring(1);
        }

        public bool LooksLikeSchool(string locality)
        {
            return (locality.Length == 4) ? true : false;
        }

        public bool IsSchool(string locality)
        {
            return _school2District.ContainsKey(locality);
        }
        public string DistrictCodeFor(string locality)
        {
            if (IsSchool(locality))
                return _school2District[locality];

            if (_school2District.ContainsValue(locality))
                return locality;


            else return BogusDistrict;
        }

        public void AddRoleAt(string cdsCode, string roleString)
        {
            List<string> rolesAtList = (List<string>)_htCDSCode2RoleList[cdsCode];
            rolesAtList.Add(roleString);
            _htCDSCode2RoleList.Remove(cdsCode);
            _htCDSCode2RoleList.Add(cdsCode, rolesAtList);
        }

        public string CurrentLRCString
        {
            get
            {
                StringBuilder sbRetVal = new StringBuilder();
                foreach (string key in _htCDSCode2RoleList.Keys)
                {
                    sbRetVal.Append(
                        _htCDSCode2OrgName[key] 
                        + ";" 
                        + key 
                        + ";" 
                        + RolesOnlyAtString(key) 
                        + "|");
                }

                sbRetVal.Length--;

                return sbRetVal.ToString();
          
            }
        }
        
        public List<string> _districts = new List<string>();
        public List<string> Districts
        {
            get
            {
                if (_districts.Count == 0)
                {
                    foreach (string locality in Localities)
                    {
                        string districtCode = "";
                        if (LooksLikeSchool(locality))
                            districtCode = DistrictCodeFor(locality);
                        else
                            districtCode = locality;

                        if (!_districts.Contains(districtCode))
                            _districts.Add(districtCode);
                    }
                    
                }
                return _districts;
            }
        }
        public List<string>Schools
        {
            get
            {
                return Localities.Where(item => LooksLikeSchool(item)).ToList();
            }
        }

        public List<string> _roles = new List<string>();
        public List<string>Roles
        {
            get
            {
                if (_roles.Count == 0)
                {
                    foreach (string locality in Localities)
                    {
                        foreach (string role in htRolesAt(locality).Keys)
                        {
                            if (!_roles.Contains(role))
                            {
                                _roles.Add(role);
                            }
                        }

                    }
                }
                return _roles;
            }
        }
        public bool IsMultiDistrict
        {
            get
            {
                return Districts.Count>1?true: false;
            }
        }
      
        public List<string>UnknownSchools
        {
            get
            {
                return Schools.Where(item => DistrictCodeFor(item) == BogusDistrict).ToList();
            }
        }
    }
}

