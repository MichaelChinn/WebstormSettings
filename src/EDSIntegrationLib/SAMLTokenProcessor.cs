using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.IdentityModel.Claims;
using System.Collections;


namespace EDSIntegrationLib
{

    // EDS Integration Constants

    public class SAMLTokenProcessor : ClaimsAuthenticationManager
    {
        public string EDSUserId { get; private set; }
        public string AppUserName { get; private set; }
        public string OldEDSIds { get; private set; }
        public string FullName { get; private set; }
        public string EMail { get; private set; }
        public string SID { get; private set; }
        public string LRString { get; private set; }
        public string CertNo { get; private set; }
        public bool TokenPreviouslyProcessed { get; private set; }
        public LocalityRoleContainer LRContainer
        {
            get
            {
                return new LocalityRoleContainer(LRString);
            }
        }
        public ClaimCollection ProcessedClaims { get; private set; }

        string _lastName = "";
        public string LastName
        {
            get
            {
                return _lastName;
            }
        }

        string _firstName = "";
        public string FirstName
        {
            get
            {
                return _firstName;
            }
        }


        class RolesAt
        {
            public List<string> RoleList { get; set; }
            public string OrgName { get; set; }
            public string CDSCode { get; set; }
            public RolesAt(string orgName, string cdsCode)
            {
                OrgName = orgName;
                CDSCode = cdsCode;
                RoleList = new List<string>();
            }
        }

        List<RolesAt> _rolesAtList = new List<RolesAt>();
        Hashtable _roleXlate;
        string _edsNameDiscriminator;
        string _appString;

        public delegate void ClaimSaver(string userName, string eDSFormattedRoleClaimValue);
        public delegate bool RoleChecker(string locality, string role);
        public delegate string RolePicker(string userName, string localityRolesCollectionString);
        public delegate void DebugTracer(string key, string comment);
        public delegate List<string> RoleAugmenter(string locationCode, List<string> rolesList);

        ClaimSaver _applicationSpecificClaimSaver = null;
        RoleChecker _applicationSpecificRoleChecker = null;
        RolePicker _applicationSpecificRolePicker = null;
        DebugTracer _applicationSpecificDebugTracer = null;
        RoleAugmenter _applicationSpecificRoleAugmenter = null;

        public ClaimSaver ClaimSaverFunction { get { return _applicationSpecificClaimSaver; } set { _applicationSpecificClaimSaver = value; } }
        public RoleChecker RoleConsistencyFunction { get { return _applicationSpecificRoleChecker; } set { _applicationSpecificRoleChecker = value; } }
        public RolePicker RolePickerFunction { get { return _applicationSpecificRolePicker; } set { _applicationSpecificRolePicker = value; } }
        public DebugTracer DebugTracerFunction { get { return _applicationSpecificDebugTracer; } set { _applicationSpecificDebugTracer = value; } }
        public RoleAugmenter RoleAugmenterFunction { get { return _applicationSpecificRoleAugmenter; } set { _applicationSpecificRoleAugmenter = value; } }

        public string RawClaims { get; set; }

        protected void Trace(string key, string comment)
        {
            if (_applicationSpecificDebugTracer != null)
                _applicationSpecificDebugTracer(key, comment);
        }

        bool RoleIsConsistentWithLocale(string locality, string role)
        {
            //at one time, both coe and eval constrained users to not be associated
            //with both districts and schools simultaneously; with the 9/15 release
            //of stateeval, this is no longer true.

            //so, we had to modify this.  

            //Really, it makes more sense to use a model by which
            //all the role checking is done on the application side.  In the case of
            //stateeval, it is actually deferred until just before you persist the
            //re-written roles claims.  

            //however, since we don't plan to do a coestudent prop soon, we 
            //leave this here: stateeval will set up a dummy RoleConsistencyFunction, so
            //the school/district role consistency check is not made, allowint coestudent
            //to continue to do this here with no changes.

            if (RoleConsistencyFunction != null)
                return RoleConsistencyFunction(locality, role);
            else
            {
                if ((locality.Length == 4) && (role.ToLower().Contains("school")))
                    return true;
                else if ((locality.Length == 5) && (!role.ToLower().Contains("school")))
                    return true;

                else return false;
            }
        }

        void DecodeEDSRoleClaim(Claim edsRoleClaim)
        {
            //eds gives us the role claim like: "OrgName;OrgCode;Role1;Role2;....."

            //need to rewrite the string with app role names to squirrel away for role change
            //need to come up with a location/role to start the app out in

            //note that in this version of the code, the roles are consistent within an org level.

            List<string> roles = new List<string>();
            string[] toks = edsRoleClaim.Value.Split(new char[] { ';' });

            RolesAt ra = new RolesAt(toks[0], toks[1]);
            Hashtable appRolesSeen = new Hashtable();

            for (int i = 2; i < toks.Length; i++)
            {
                string role = toks[i].Trim();

                if (_roleXlate.ContainsKey(role))               //if you don't recognize a role, skip it
                {
                    string appRole = (string)_roleXlate[role];  //the role xlated into app speak
                    if (RoleIsConsistentWithLocale(ra.CDSCode, appRole))
                    {
                        //this extra piece is so that we don't add a role twice,
                        //which can happen because of the translation of the 
                        //eds-to-cs roles; one eds roles do not map uniquely because
                        //of cindy request to clean up roles, 6/15/2012
                        if (!appRolesSeen.ContainsKey(appRole))
                        {
                            appRolesSeen.Add(appRole, null);
                            ra.RoleList.Add(appRole);
                        }
                    }
                }
            }
            if (RoleAugmenterFunction!=null)
            {
                List<string> AugRoles = RoleAugmenterFunction(ra.CDSCode,ra.RoleList);
                foreach (string augRole in AugRoles)
                    if (!ra.RoleList.Contains(augRole))
                        ra.RoleList.Add(augRole);
            }
            if (ra.RoleList.Count > 0)
            {
                _rolesAtList.Add(ra);
            }
        }
        public SAMLTokenProcessor(Hashtable roleTranslationTable, string edsDiscriminator, string appString)
        {
            _roleXlate = roleTranslationTable;
            _edsNameDiscriminator = edsDiscriminator;
            _appString = appString.ToLower();


           
            TokenPreviouslyProcessed = false;
            EDSUserId = "";
            AppUserName = "";
            OldEDSIds = "";
            FullName = "";
            EMail = "";
            SID = "";
            LRString = "";
            CertNo = "";
            /*  */

        }

        public void ProcessToken(ClaimCollection incomingClaims)
        {
            /*
             * The job of this object is to:
             *   a) extract the claims so that a user object can be instantiated
             *   b) translate the EDS role names to Application Specific (SE or COE) role names
             *   c) combine the one to many incoming 'Role' claims (eds formatted strings with edsroles)
             *          to a single LRC string containing app roles
             *        
             * (just a note; a/b/c/d/ don't correspond to 1/2/3/4 below)...
             * 
             * This processes the token on the way in, but after the token has been authenticated.
             * The motivation for these changes was that location switching for multi location users wasn't
             * working.  And, after years of use and thinking about it, decided that it was possible to do
             * more work in the CustomClaimsAuthMgr (called by the framework) and avoid a lot of the processing
             * done in the app by the 'SyncUser' stuff.
             * 
             * Basically, instead of waiting till the app gets hold of the token, we are creating the
             * user as soon as the token is seen by the WIF framework.
             * 
             * To accommodate this, many of the token claims have been made publicly available as
             * properties on the object. This way, after 'ProcessToken' is called, the properties can
             * be used to create (if necessary) the user in the CustomClaimsAuthenticationManager.Authenticate
             * method.
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

            Claim nameClaim = null;
            bool tokenIsEDSFormatted = false;

            List<Claim> edsFormattedRoleClaimsList = new List<Claim>();

            StringBuilder sbRawClaims = new StringBuilder();

            //so, the problem is that the edsUser might have a bunch of role claims
            //associating different roles with his applications.  Here is where we
            //scan through each claim and pick out the role claims in EDSFormat
            foreach (Claim claim in incomingClaims)
            {
                sbRawClaims.Append("|" +claim.ClaimType + "+" + claim.Value);

                switch (claim.ClaimType)
                {
                    
                    case ClaimTypes.Name:                       // Name:         The unique identifier of the person
                        nameClaim = claim;
                        break;

                    case ClaimTypes.Role:                       // Role:         Organization Name: Organization Code;Role[;Role...]
                        tokenIsEDSFormatted = claim.Value.Contains(";");
                        edsFormattedRoleClaimsList.Add(claim);
                        break;

                    //the rest of these are passed through; but we 
                    //.gathering them to hydrate the properties
                       
                    case ClaimTypes.NameIdentifier:             // PreviousName: The previous unique identifiers of the person. OldId[;OldId...]
                        OldEDSIds = claim.Value;
                        break;
                    case ClaimTypes.Email:                      // EMailAddress: EMail Address
                        EMail = claim.Value;
                        break;
                    case ClaimTypes.GivenName:                  // GivenName:    Given name of the person
                        FullName = claim.Value;

                                               
                        string[] tokens;
                        if (FullName.Contains(","))
                        {
                            tokens = FullName.Split(new char[] { ',' });
                            _lastName = tokens[0].Trim();
                            _firstName = tokens[1].Trim();
                        }
                        else
                        {
                            tokens = FullName.Split(new char[] { ' ' });
                            _firstName = tokens[0].Trim();
                            _lastName = tokens[1].Trim();
                        }
                        break;

                    case ClaimTypes.Sid:                        // Sid:          The secure identifier for the person
                        SID = claim.Value;
                        break;
                    case ClaimTypes.PPID:                       // Ppid:         The teacher cert number for the person
                        CertNo = claim.Value;
                        break;
                }
            }

            RawClaims = sbRawClaims.ToString();
            //of course we don't have to do anything at all if the token wasn't from EDS
            if (!tokenIsEDSFormatted)
            {
                TokenPreviouslyProcessed = true;
                return;
            }
               

            //Ok... we know this token is from EDS...


            //first: process the username here...
            if (!nameClaim.Value.Contains(_edsNameDiscriminator))
            {
                EDSUserId = nameClaim.Value;
                AppUserName = EDSUserId + _edsNameDiscriminator;
                //rewrite his name claim, and replace the name that's there
                incomingClaims.Remove(nameClaim);
                nameClaim = new Claim(nameClaim.ClaimType, AppUserName, nameClaim.ValueType, "LOCALAUTHORITY", nameClaim.OriginalIssuer);
                incomingClaims.Add(nameClaim);

                //Trace("stp.ProcessToken, step first", "the name is set to: " + nameClaim.Value + _edsNameDiscriminator);
            }
            string decoratedUserName = nameClaim.Value;

            //second: process the eds-formatted role claims.  At one time, nathan was sending me 
            // non coe roles, so have to be careful.

            //the only thing we're doing here is breaking up the edsFormatted role Claims into 
            //location/role pairs, xlating the roles into the HOC versions
            foreach (Claim roleClaim in edsFormattedRoleClaimsList)
            {
                incomingClaims.Remove(roleClaim);        //remove the original claim from the token             

                //ignore non eCOE claims
                if (!roleClaim.Value.ToLower().Contains(_appString))
                    continue;


                //hydrate _rolesAtList<>
                DecodeEDSRoleClaim(roleClaim);
            }

            incomingClaims.Add(new Claim(ClaimTypes.Actor, RawClaims //keep around original (eCOE) claims for later use
               , ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));

            if (_rolesAtList.Count == 0)    //maybe there's nothing here!
                return;

            //Third: have to box up the locality/role lists and squirrel them away
            StringBuilder sbLRCollection = new StringBuilder();
            for (int i = 0; i < _rolesAtList.Count; i++)
            {
                RolesAt ra = _rolesAtList[i];
                sbLRCollection.Append(ra.OrgName + ";" + ra.CDSCode + ";");

                foreach (string role in ra.RoleList)
                {
                    sbLRCollection.Append(role + ";");
                    //Trace("stp.ProcessToken", "step third, inner; role: " + role);

                }
                sbLRCollection.Remove(sbLRCollection.Length - 1, 1);
                sbLRCollection.Append("|");
            }

            LRString = sbLRCollection.ToString().Substring(0, sbLRCollection.Length - 1);  //gets rid of leading '|' and trailing ';'

            if (ClaimSaverFunction != null)
            {
                ClaimSaverFunction(decoratedUserName, LRString);
            }

            //Fourth: delegate to the app to determine what to start out with;
            //or just use the first one.
            List<string> pickedRoles = _rolesAtList[0].RoleList;
            string localityToUse = _rolesAtList[0].CDSCode;

            if (RolePickerFunction != null)
            {
                localityToUse = RolePickerFunction(decoratedUserName, LRString);
                if (localityToUse!="")
                foreach (RolesAt ra in _rolesAtList)
                    if (ra.CDSCode == localityToUse)
                        pickedRoles = ra.RoleList;
            }

            incomingClaims.Add(new Claim(ClaimTypes.Locality, localityToUse, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
            foreach (string role in pickedRoles)
                incomingClaims.Add(new Claim(ClaimTypes.Role, role, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));

            ProcessedClaims = incomingClaims;
        }
    }
}



