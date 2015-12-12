using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Utils
{
    public static class MSClaimTypes
    {
        /* from: https://eds.ospi.k12.wa.us/edssts/federationmetadata/2007-06/federationmetadata.xml
             
                Role:         Organization Name: Organization Code;Role[;Role...]
                Name:         The unique identifier of the person
                PreviousName: The previous unique identifiers of the person. OldId[;OldId...]
                EMailAddress: EMail Address
                GivenName:    Given name of the person
                Sid:          The secure identifier for the person
                Ppid:         The teacher cert number for the person
        */
        public const string Name = System.Security.Claims.ClaimTypes.Name;
        public const string Email = System.Security.Claims.ClaimTypes.Email;
        public const string GivenName = System.Security.Claims.ClaimTypes.GivenName;
        public const string PPID = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/privatepersonalidentifier";
        public const string Role = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
        public const string NameIdentifier = System.Security.Claims.ClaimTypes.NameIdentifier;
        public const string Sid = System.Security.Claims.ClaimTypes.Sid;

    }
}
