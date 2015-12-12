using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Collections;
using DbUtils;

using Microsoft.IdentityModel.Claims;

namespace EDSIntegrationLib
{
    public class EDSUserSyncHelper
    {
        public delegate string LocalityFixup(string districtCode, string districtName, string schoolCode, string schoolName);
        LocalityFixup _applicationSpecificLocalityFixupFunction = null;
        public LocalityFixup LocalityFixupFunction
        {
            get { return _applicationSpecificLocalityFixupFunction; }
            set { _applicationSpecificLocalityFixupFunction = value; }
        }

        public delegate bool RoleChecker(Hashtable roles);
        RoleChecker _applicationSpecificRoleChecker = null;
        public RoleChecker RoleCheckerFunction
        {
            get { return _applicationSpecificRoleChecker; }
            set { _applicationSpecificRoleChecker = value; }
        }

        string _connectionString;
        public EDSUserSyncHelper(string connectionString)
        {
            _connectionString = connectionString;

        }

        bool RolesAreConsistent()
        {
            if (RoleCheckerFunction == null)
                return true;
            else return RoleCheckerFunction(_newRoles);
        }


        const string LocalAuthenticationClaim = "http://www.hocprofessional.com/claims/IsLocallyAuthenticatedClaim";

        public bool IsEDSUser(IClaimsIdentity ici)
        {
            bool retval = false;
            foreach (Claim claim in ici.Claims)
            {
                if ((claim.ClaimType == ClaimTypes.Name)&&(claim.OriginalIssuer.Contains(".ospi.k12.wa.us")))
                {
                    retval = true;
                    break;
                }
            }
            return retval;
        }
      
        private string ComposeErrorString(string error, List<Claim> edsRawClaims)
        {
            string rawClaimsListString = "";

            foreach (Claim rawClaim in edsRawClaims)
            {
                rawClaimsListString = rawClaimsListString + "<br/>" + rawClaim.Value;
            }

            return error + rawClaimsListString;
        }
        private string FixupUnknownSchoolCode(string schoolCode)
        {
            //if  a fixup function wasn't provided, don't bother
            if (LocalityFixupFunction == null)
                return null;


            string districtName = null;
            string districtCode = null;
            string schoolName = null;
            DistrictSchoolEntityLookup.GetInfoForSchoolCode(schoolCode, ref districtCode, ref districtName, ref schoolName);

            LocalityFixupFunction(districtCode, districtName, schoolCode, schoolName);

            return districtCode;
        }

        public void GetDistrictSchoolCodeFromEDSValue(string cdsCode, ref string districtCode, ref string schoolCode)
        {
            string vut = cdsCode;

            if (vut.Length == 5)    //here, the vut is a district code, and there's no school
            {
                schoolCode = "";
                districtCode = vut;
                return;
            }

            //well, here we know it's a school, since the length of the code string should be 4
            schoolCode = vut;

            SqlParameter[] aParams = new SqlParameter[] {
            new SqlParameter("@pSchoolCode", schoolCode)
            };
            DbConnector _conn = new DbConnector(_connectionString);
            districtCode = (string)_conn.ExecuteScalar("GetDistrictCodeForSchool", aParams);

            if (districtCode == null)
                districtCode = FixupUnknownSchoolCode(schoolCode);

            return;
        }
        
        string _firstName = "";
        string _lastName = "";
        string _decoratedEdsName = "";
        string _districtCode = "";
        string _schoolCode = "";
        string _email = "";
        string _oldEDSIds = "";
        Hashtable _newRoles = new Hashtable();

        string roleOutputString = "";    //for error output only

        public string StageAndCheckClaims(IClaimsIdentity ici)
        {
            //we should only get here if he is an eds user
           
            List<Claim> edsRawClaims = new List<Claim>();
            int localityCount = 0;
            string returnTicket = "";
            foreach (Claim claim in ici.Claims)
            {
                switch (claim.ClaimType)
                {
                    case ClaimTypes.Sid:
                        returnTicket = claim.Value;
                        break;

                    case ClaimTypes.Role:
                        if (!_newRoles.ContainsKey(claim.Value))
                            _newRoles.Add(claim.Value, null);
                        roleOutputString += "..." + claim.Value;
                        break;

                    case ClaimTypes.NameIdentifier:
                        _oldEDSIds = claim.Value;
                        break;

                    case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name":
                        //this should already have been decorated
                        _decoratedEdsName = claim.Value;
                        break;
                    case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress":
                        _email = claim.Value;
                        break;
                    case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname":

                        string givenName = claim.Value;
                        string[] tokens;
                        if (givenName.Contains(","))
                        {
                            tokens = givenName.Split(new char[] { ',' });
                            _lastName = tokens[0];
                            _firstName = tokens[1];
                        }
                        else
                        {
                            tokens = givenName.Split(new char[] { ' ' });
                            _firstName = tokens[0];
                            _lastName = tokens[1];
                        }
                        break;

                    case ClaimTypes.Locality:
                        //we are now disallowing two role claims from eds; we can tell
                        // by having an additional locality...
                        localityCount++;
                        GetDistrictSchoolCodeFromEDSValue(claim.Value, ref _districtCode, ref _schoolCode);
                        break;

                    case ClaimTypes.Actor:  //these are the raw eds claims set up in CustomClaimsAuthMgr
                        RawClaims = claim.Value;
                        break;
                }
            }

            if (_newRoles.Count == 0)
                throw new Exception(ComposeErrorString("E_ROLES_MISMATCH: You don't seem to have any permissions in this application.  "
                        + "Please notify your district security advisor with the following information:<br>", edsRawClaims));
           
            if (_districtCode == null)
                throw new Exception(ComposeErrorString("E_ROLES_MISMATCH: We could not recognize what school/district you are from.  "
                        + "Please notify your district security advisor with the following information: <br>", edsRawClaims));

            if ((_districtCode == "") && (_schoolCode == ""))
                throw new Exception(ComposeErrorString("E_ROLES_MISMATCH: We could not match you to a school or location.  "
                        + "Please notify your district security advisor with the following information: <br>", edsRawClaims));

            if (localityCount > 1)  //this should never happen with the new localityRoles pattern
                throw new Exception(ComposeErrorString("E_ROLES_MISMATCH: You got logged in with multiple locations at one time.  "
                        + "Please notify your district security advisor with the following information: <br>", edsRawClaims));

            if (!RolesAreConsistent()) //this check roles within locale; for instance, se might want to disallow a person in both teacher and principal roles
                throw new Exception(ComposeErrorString("E_ROLES_MISMATCH: You have been granted inconsistent roles.  Perhaps you have been "
                        + "granted Principal and Teacher roles simultaneously?  You will not be able to use the application until this has been addressed. "
                        + "Please notify your district security advisor with the following information: "+roleOutputString+"<br>", edsRawClaims));

            return returnTicket;


        }
        public string FirstName { get { return _firstName; } }
        public string LastName { get { return _lastName; } }
        public string DecoratedEdsName { get { return _decoratedEdsName; } }
        public string DistrictCode { get { return _districtCode; } }
        public string SchoolCode { get { return _schoolCode; } }
        public string Email { get { return _email; } }
        public string OldEDSIds { get { return _oldEDSIds; } }
        public Hashtable NewRoles { get { return _newRoles; } }


        public string RawClaims { get; set; }

        

    }
}
