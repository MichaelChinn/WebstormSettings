using System;
using System.Security.Cryptography.X509Certificates;
using System.ServiceModel;
using System.Web.Configuration;

using Microsoft.IdentityModel.Claims;
using Microsoft.IdentityModel.Configuration;
using Microsoft.IdentityModel.Protocols.WSTrust;
using Microsoft.IdentityModel.SecurityTokenService;

/// <summary>
/// Summary description for TestClaims
/// </summary>
public class TestClaimGenerator
{
    /*
     * 01158 Lind SD   
     * 2903  Lind Jr Sr High     
     * 
     * 03050 Paterson SD
     * 2133  Paterson Elementary
     * 
     * */

    /*
        public const string Issuer     = "eds.ospi.k12.wa.us";

        public const string EdsNameTag   = "_edsUser";

        public const string RoleDistrictAdmin     = "eValDistrictAdmin";
        public const string RoleDistrictEvaluator = "eValDistrictEvaluator";
        public const string RoleSchoolAdmin       = "eValSchoolAdmin";
        public const string RoleSchoolPrincipal_Misspelled = "eValSchoolPrinicpal";
        public const string RoleSchoolPrincipal   = "eValSchoolPrincipal";
        public const string RoleSchoolTeacher     = "eValSchoolTeacher";
        public const string RoleStateAdmin        = "eValStateAdmin";
        public const string RoleSuperAdmin        = "eValSuperAdmin";
    */



    const string OthelloSD = "Othello SD;01147";

    const string OTH_S1 = "Othello High School;3015";
    const string OTH_S2 = "Scootney Springs Elementary;3730";
   
   

    const string NorthThurstonSD = "North Thurston Public Schools;34003";
    const string NT_S1 = "South Bay Elementary;2754";
    const string NT_S2 = "North Thurston High School;3010";


    const string DA = "eValDistrictAdmin";
    const string DE = "eValDistrictEvaluator";
    const string SA = "eValSchoolAdmin";
    const string PR = "eValSchoolPrincipal";
    const string T = "eValSchoolTeacher";
    const string DTE = "eValDistrictTeacherEvaluator";
    const string PRH = "eValHeadPrincipal";
    //const string RoleStateAdmin = "eValStateAdmin";
    //const string RoleSuperAdmin = "eValSuperAdmin";

    string RoleString(string where, string roles)
    {
        return where + ";" + roles;
    }


    Claim _userNameClaim { get; set; }
    public TestClaimGenerator(Claim UserNameClaim)
    {
        _userNameClaim = UserNameClaim;
    }
    public ClaimsIdentity Claim
    {
        get
        {
            ClaimsIdentity outputIdentity = new ClaimsIdentity();
            string fakePersonId = Convert.ToInt64(_userNameClaim.Value).ToString();
            outputIdentity.Claims.Add(new Claim(_userNameClaim.ClaimType, fakePersonId, _userNameClaim.ValueType, "eds.tst.ospi.k12.wa.us", "eds.tst.ospi.k12.wa.us"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.GivenName, "fwojfs, John", ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.Email, "tsjamieson@foogle.cxf", ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
            outputIdentity.Claims.Add(new Claim(ClaimTypes.PPID, "CX-43243"));
            string roleString = "";
             switch (_userNameClaim.Value)
            {

                /* need... 
                 * 
                 * --allowed
                 * a teacher at a school
                 * a principal at a school
                 * a de at a district
                 * a dte at a district
                 * an admin at a school
                 * an admin at a district
                 * 
                 * --allowed combinations
                 * a school admin and a teacher at a school
                 * a school admin and a principal at a school
                  * a head principal and principal in a school
                * a district admin and a de at a district
                 * a district admin and a dte at a district
                 * 
                 * --allowed multi building
                 * a teacher at multiple schools in a single district
                 * 
                 * --disallowed at single school building
                 * a head principal at a school
                 * a principal and a teacher at a school
                 * a district admin and a teacher at a school
                 * a dte and a teacher at a school
                 * a de and a teacher at a school
                 * 
                 * a district admin and a principal at a school
                 * a dte and a principal at a school
                 * a de and a principal at a school
                 * 
                 * a district admin and a school admin at a school
                 * a dte and a school admin at a school
                 * a de and a school admin at a school

                 * * 
                 * --disallowed at a single district
                 * a principal and a district admin at a district
                 * a teacher and a district admin at a district
                 * a school admin and a district admin at a district
                 *
                 * a principal and a dte at a district
                 * a teacher and a dte at a district
                 * a school admin and a dte at a district
                 * 
                 * a principal and a de at a district
                 * a teacher and a de at a district
                 * a school admin and a de at a district
                 * 
                 * --disallowed in multiple buildings
                 * multiple buildings, de
                 * multiple buildings, dte
                 * multiple buildings, da
                 * multiple buildings, principal
                 * multiple buildings, schooladmin
                 * multiple buildings, head principal
                 * 8*/
                 
            
                 case ("000201"): //multi district principal
                     {
                         outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S1 + ";" + PR, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                         outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, OTH_S1 + ";" + PR, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                         break;
                     }
                 /*   case ("__msi!x_user2"): //principal
                     {
                         roleString = RoleString(NorthThurstonHS, PR);
                          break;
                     }
                 case ("__msi!x_user3"): // de
                     {
                         roleString = RoleString(NorthThurstonSD, DE);
                         break;
                     }
                 case ("__msi!x_user4"):  // dte
                     {
                         roleString = RoleString(NorthThurstonSD, DE);
                         break;
                     }
                   */ 
                 case ("000205"): //prh
                     {
                         outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S1 + ";" + PR, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                         outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S2 + ";" + PR, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                         break;
                     }
                 

                case ("000206"):  //teachear and admin at school
                    {
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S2 + ";"  + PRH + ";" + SA, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                        break;
                    }


                case ("000207"):  //principal  at school
                     {
                         outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S1 + ";" + PRH, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                         outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S2 + ";" + PR, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));

                         break;
                     }
              

                case ("000208"):  //mulitple buildings all pr
                    {
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S1 + ";" + PR, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S2 + ";" + PRH + ";" + SA, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                       
                        break;
                    }

                case ("000209"):  //mulitple buildings all pr
                    {
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S1 + ";" + T, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S2 + ";" + T, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                       
                        break;
                    }
                case ("000210"):  //multiple buildings all teacher, one pr
                    {
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S1 + ";" + T, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, NT_S2 + ";" + T, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, "fooBar;0000" + ";" + PR, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                        break;
                    }

                case ("000211"):  //principal and admin  at school
                    {
                        roleString = RoleString(NT_S2, T);
                        outputIdentity.Claims.Add(new Claim(ClaimTypes.Role, roleString, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
                        break;
                    }


            }
            return outputIdentity;

        }
    }
}