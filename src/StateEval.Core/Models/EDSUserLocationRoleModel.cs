using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNet.Identity;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class EDSUserLocationRoleModel
    {
        public long Id {get;set;}
        public Nullable <long> PersonId { get; set; }
        public string FirstName {get;set;}
        public string LastName {get;set;}
        public string Email {get;set;}
        public string PreviousPersonId {get;set;}
        public string LoginName {get;set;}
        public string EmailAddressAlternate{get;set;}
        public string CertificateNumber {get;set;}

        public List<EDSLocationRoleModel> LocationRoles {get;set;}
    }
}
