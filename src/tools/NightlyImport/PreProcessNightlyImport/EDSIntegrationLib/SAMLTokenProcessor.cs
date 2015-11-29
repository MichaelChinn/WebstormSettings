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
        ClaimSaver _applicationSpecificClaimSaver = null;
        RoleChecker _applicationSpecificRoleChecker = null;
        RolePicker _applicationSpecificRolePicker = null;
        DebugTracer _applicationSpecificDebugTracer = null;
        public ClaimSaver ClaimSaverFunction { get { return _applicationSpecificClaimSaver; } set { _applicationSpecificClaimSaver = value; } }
        public RoleChecker RoleConsistencyFunction { get { return _applicationSpecificRoleChecker; } set { _applicationSpecificRoleChecker = value; } }
        public RolePicker RolePickerFunction { get { return _applicationSpecificRolePicker; } set { _applicationSpecificRolePicker = value; } }
        public DebugTracer DebugTracerFunction { get { return _applicationSpecificDebugTracer; } set { _applicationSpecificDebugTracer = value; } }
        

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
        }

        public void ProcessToken(ClaimCollection incomingClaims)
        {
            //This processes the token on the way in, but after the token has been authenticated.

            //This means that, for instance, if this is the first time we've ever seen this
            //.guy there is not a [APP]User record in the db, or anything in aspnet_users

            
            //Previously, we were dealing only with a 
            //.single role/locality, this class would just break up the locality/roles
            //.into separate claims and pass things on for the app to further process.

            //The change on the EDS side is that nathan will now send me every locale/role
            //.associated with the principal all at once.  So, this version now deals with
            //.that fact.  Note that, with the exception of the actual role switching code,
            //.as far as the rest of the app is concerned, we are still processing things in
            //.the same way.  the only major difference is that we've simplified the decode
            //.logic significantly, and not only that, things are safer too!

            //From the outside, the claim that gets eventually passed to the application
            //.*still* has only roles from a single location... *but* those roles are now
            //.*guaranteed* to be already consistent (i.e. district roles for school people,
            //.and school roles for district people) are filtered out.  This can be done
            //.now, because if a person wants to be in a district role, he can just switch
            //.to his district locale, or if he wants work in a school, he just switches
            //.to his school local.

            //Trace("stp", "first in");
            string edsUserName = "";
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

                //Trace("stp", "a raw claim: " + claim.ClaimType + "+" + claim.Value);

                switch (claim.ClaimType)
                {
                    //only care about the role and name claims
                    case "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name":
                        edsUserName = claim.Value;
                        nameClaim = claim;
                        break;

                    case ClaimTypes.Role:
                        //collect the eCOE claims only
                        tokenIsEDSFormatted = claim.Value.Contains(";");
                        edsFormattedRoleClaimsList.Add(claim);
                        break;
                }
            }

            RawClaims = sbRawClaims.ToString();
            //of course we don't have to do anything at all if the token wasn't from EDS
            if (!tokenIsEDSFormatted)
                return;

            //Ok... we know this token is from EDS...


            //first: process the username here...
            if (!nameClaim.Value.Contains(_edsNameDiscriminator))
            {
                //rewrite his name claim, and replace the name that's there
                incomingClaims.Remove(nameClaim);
                nameClaim = new Claim(nameClaim.ClaimType, nameClaim.Value + _edsNameDiscriminator, nameClaim.ValueType, "LOCALAUTHORITY", nameClaim.OriginalIssuer);
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
            RolesAt raBiggest = _rolesAtList[0];
            for (int i = 0; i < _rolesAtList.Count; i++)
            {
                RolesAt ra = _rolesAtList[i];
                sbLRCollection.Append(ra.OrgName + ";" + ra.CDSCode + ";");

               // Trace("stp.ProcessToken", "step third, outer, orgName, code: " + ra.OrgName + ";" + ra.CDSCode + ";");

                foreach (string role in ra.RoleList)
                {
                    sbLRCollection.Append(role + ";");
                    //Trace("stp.ProcessToken", "step third, inner; role: " + role);

                }
                sbLRCollection.Remove(sbLRCollection.Length - 1, 1);
                sbLRCollection.Append("|");

                //if (raBiggest.RoleList.Count < ra.RoleList.Count)
                  //  raBiggest = ra;
                raBiggest = ra;
            }

            string lrCollectionString = sbLRCollection.ToString().Substring(0, sbLRCollection.Length - 1);  //gets rid of leading '|' and trailing ';'

            if (ClaimSaverFunction != null)
            {
                ClaimSaverFunction(decoratedUserName, lrCollectionString);
            }

            //Fourth: delegate to the app to determine what to start out with; or just use the one with
            //.the largest number of roles
            List<string> pickedRoles=new List<string>();
            string localityToUse="";

            
            if (RolePickerFunction != null)
            {
                localityToUse = RolePickerFunction(decoratedUserName, lrCollectionString);
                if (localityToUse!="")
                foreach (RolesAt ra in _rolesAtList)
                    if (ra.CDSCode == localityToUse)
                        pickedRoles = ra.RoleList;
            }
            if (pickedRoles.Count==0)
            {
                localityToUse= raBiggest.CDSCode;
                pickedRoles = raBiggest.RoleList;
            }

            incomingClaims.Add(new Claim(ClaimTypes.Locality, localityToUse, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
            foreach (string role in pickedRoles)
                incomingClaims.Add(new Claim(ClaimTypes.Role, role, ClaimValueTypes.String, "LOCALAUTHORITY", "LOCALAUTHORITY"));
        }
    }
}



