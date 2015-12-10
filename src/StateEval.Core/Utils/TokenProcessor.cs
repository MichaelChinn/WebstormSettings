using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Security.Claims;
using System.Security.Principal;

using StateEval.Core.Services;
using System.Text;

using System.Collections;
    

namespace StateEval.Core.Utils
{
    public class TokenProcessor  
    {
        const string _edsNameDiscriminator = "_edsUser";
        const string _appString = "eVal";

        int _locationCount = 0;

        public string EDSPersonId { get; private set; }
        public string FullName { get; private set; }
        public string EMail { get; private set; }
        public string CertNo { get; private set; }
        
        public string SID { get; private set; }
        public string OldEDSIds { get; private set; }
        public bool HasMultipleLocations { get; private set; }

        public List<RolesAt> RolesAtList { get; private set; }

        public bool TokenPreviouslyProcessed { get; private set; }
        public bool UserHasRoles { get; private set; }
        public string RawClaims { get; private set;}



        void DecodeEDSRoleClaim(Claim edsRoleClaim)
        {
            //eds gives us the role claim like: "OrgName;OrgCode;Role1;Role2;....."
            _locationCount++;
            List<string> roles = new List<string>();
            string[] toks = edsRoleClaim.Value.Split(new char[] { ';' });


            RolesAt ra = new RolesAt(toks[0], toks[1]);

            for (int i = 2; i < toks.Length; i++)
            {
                string role = toks[i].Trim();
                string appRole = (string)_roleXlate[role];  //the role xlated into app speak

                if (ra.IsSchool && !TokenProcessorReferences.IsSchoolRole(appRole))
                    continue;

                if (ra.IsDistrict && !TokenProcessorReferences.IsDistrictRole(appRole))
                    continue;
                

                if (!roles.Contains(appRole))
                    roles.Add(appRole);

                //have to ensure that all head principals are also principals
                if (appRole == TokenProcessorReferences.SESchoolHeadPrincipal)
                {
                    if (!roles.Contains(TokenProcessorReferences.SESchoolPrincipal))
                        roles.Add(TokenProcessorReferences.SESchoolPrincipal);
                }
            }
            if (roles.Count > 0)
            {
                ra.RoleList = roles.Distinct().ToList();
                RolesAtList.Add(ra);
            }
        }

        Dictionary<string, string> _roleXlate;


        public TokenProcessor(Dictionary<string, string> roleTranslationTable, IEnumerable<Claim>incomingClaims)
        {
            _roleXlate = roleTranslationTable;
           
            EDSPersonId = "";
            FullName = "";
            EMail = "";
            SID = "";
            CertNo = "";
            OldEDSIds = "";
            RawClaims = "";
            _locationCount = 0;
            HasMultipleLocations = false;
            RolesAtList = new List<RolesAt>();

            ProcessToken(incomingClaims);

        }


        void ProcessToken(IEnumerable<Claim> incomingClaims)
        {
            /*
             * This changes significantly with client side code base, hence the migration away
             * from EDSIntegrationLib
             * 
             * Recall that, the new code base,  only thing the WIF site is used for is as 
             * a gateway to the clientside.  The whole identity principal thing is used
             * only as a way to communicate with the web site, so that it can package
             * up the user id and a password in a secure query string to redirect to the
             * client so that *it* can send *that* to the web api to get a token.
             * 
             * In the mean time, we still have to bundle up roles ad persist them
             * 
             * So, in broad strokes, this part of the code processes the token to:
             * 
             *  a) instantiate a user, if necessary
             *  b) persist roles on a user/location basis
             *  c) simplify the claim down to an edsUser name so 
             *      gateway can get at it.
             * 
             * As before, not a lot of error checking is done, since the errors are swallowed
             * up by the framework at this point.  Inconsistent roles (school roles in districts, district
             * roles in schools, unrecognized roles) are simply skipped over.

            /*
             * from: https://eds.ospi.k12.wa.us/edssts/federationmetadata/2007-06/federationmetadata.xml
             
                    Role:         Organization Name: Organization Code;Role[;Role...]
                    Name:         The unique identifier of the person
                    PreviousName: The previous unique identifiers of the person. OldId[;OldId...]
                    EMailAddress: EMail Address
                    GivenName:    Given name of the person
                    Sid:          The secure identifier for the person
                    Ppid:         The teacher cert number for the person
            */

            
            List<Claim> edsFormattedRoleClaimsList = new List<Claim>();

            StringBuilder sbRawClaims = new StringBuilder();

            //so, the problem is that the edsUser might have a bunch of role claims
            //associating different roles with his applications.  Here is where we
            //scan through each claim and pick out the role claims in EDSFormat
            foreach (Claim claim in incomingClaims)
            {
                sbRawClaims.Append("|" + claim.Type + "+" + claim.Value);  //for debugging later if we need it

                switch (claim.Type)
                {
                        /************/
                        //these first claims will be used to persist a user to the db, or 
                        //update the user's info, if necessary

                    case MSClaimTypes.Name:                       // Name: maps to the eds person id, which will be morphed into userName
                        EDSPersonId = claim.Value;
                        break;

                    case MSClaimTypes.Email:                      // EMailAddress: EMail Address
                        EMail = claim.Value;
                        break;

                    case MSClaimTypes.GivenName:                  // GivenName:    Given name of the person; gives us first and last
                        FullName = claim.Value;
                        break;

                    case MSClaimTypes.PPID: // Ppid:         The teacher cert number for the person
                        CertNo = claim.Value;
                        break;
                        /********/

                    case MSClaimTypes.Role:                       // Role:         Organization Name: Organization Code;Role[;Role...]
                        edsFormattedRoleClaimsList.Add(claim);
                        break;

                    //keep this one around in case we decide we can do anything about it
                    case MSClaimTypes.NameIdentifier:             // PreviousName: The previous unique identifiers of the person. OldId[;OldId...]
                        OldEDSIds = claim.Value;
                        break;

                    case MSClaimTypes.Sid:                        // Sid:          The secure identifier for the person
                        SID = claim.Value;
                        break;
                }
            }

            RawClaims = sbRawClaims.ToString();
            //of course we don't have to do anything at all if the token wasn't from EDS

            if (edsFormattedRoleClaimsList.Count <0)
            {
                return;
            }

            //Ok... we know this token is from EDS, and we have roles to persist...
            foreach (Claim claim in edsFormattedRoleClaimsList)
            {
                //ignore non StateEval claims
                if (!claim.Value.ToLower().Contains(_appString.ToLower()))
                    continue;
                DecodeEDSRoleClaim(claim);
            }

            HasMultipleLocations = _locationCount == 1 ? false : true;
        }

    }
}