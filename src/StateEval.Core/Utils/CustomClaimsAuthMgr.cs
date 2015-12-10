using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Security.Claims;
using System.Security.Principal;

using StateEval.Core.Services;
using System.Text;

namespace StateEval.Core.Utils
{
    public class CustomClaimsAuthMgr : ClaimsAuthenticationManager
    {


        public override ClaimsPrincipal Authenticate(string resourceName, ClaimsPrincipal incomingPrincipal)
        {

            if (incomingPrincipal != null && incomingPrincipal.Identity.IsAuthenticated == true)
            {
                TokenProcessor tp = new TokenProcessor(TokenProcessorReferences.RoleXlate, incomingPrincipal.Claims);

                long seUserId = CreateUserIfNecessaryFromTokenInfo(tp);
                long edsPersonId = Int64.Parse(tp.EDSPersonId);
                SaveRoleSetAndLocations(edsPersonId, tp.RolesAtList);
            }

            return incomingPrincipal;
        }

        long CreateUserIfNecessaryFromTokenInfo(TokenProcessor tp)
        {
            string lastName = "";
            string firstName = "";
            string fullName = tp.FullName;

            //process the full name into first, last
            string[] tokens;
            if (fullName.Contains(","))
            {
                tokens = fullName.Split(new char[] { ',' });
                lastName = tokens[0].Trim();
                firstName = tokens[1].Trim();
            }
            else
            {
                tokens = fullName.Split(new char[] { ' ' });
                firstName = tokens[0].Trim();
                lastName = tokens[1].Trim();
            }

            UserService userService = new UserService();
            long seUserId = userService.InsertOrFindSeUserId(
                Int64.Parse(tp.EDSPersonId)
                , firstName
                , lastName
                , tp.EMail
                , tp.CertNo
                , tp.HasMultipleLocations);

            return seUserId;
        }

        void SaveRoleSetAndLocations(long edsPersonId, List<RolesAt> rolesAtList)
        {
            //string has to end up looking like:
            //... locationCode|roleString, locationCode|roleString....
            StringBuilder sbLocationRoleString = new StringBuilder();


            foreach (RolesAt ra in rolesAtList)
            {
                foreach (string role in ra.RoleList)
                {
                    sbLocationRoleString.Append(ra.CDSCode + "|" + role + ",");
                }
            }

            sbLocationRoleString.Length--;  //remove the trailing ','

            UserService userService = new UserService();
            userService.InsertUpdateUserReferenceTables(edsPersonId, sbLocationRoleString.ToString());
        }
    }
}