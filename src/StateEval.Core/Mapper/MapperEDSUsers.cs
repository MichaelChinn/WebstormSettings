using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EDSUserLocationRoleModel MapToEDSUserLocationRoleModel(
           this EDSUsersV1 source, EDSUserLocationRoleModel target = null)
        {
            target = target ?? new EDSUserLocationRoleModel();

            target.Id = source.EDSUsersID;
            target.PersonId = source.PersonId;
            target.FirstName = source.FirstName;
            target.LastName = source.LastName;
            target.Email = source.Email;
            target.PreviousPersonId = source.PreviousPersonId;
            target.LoginName = source.LoginName;
            target.EmailAddressAlternate = source.EmailAddressAlternate;
            target.CertificateNumber = source.CertificateNumber;

            target.LocationRoles = null;

            StateEvalEntities EvalEntities = new StateEvalEntities();



            target.LocationRoles = EvalEntities.EDSRolesV1.Where(x => x.PersonId == target.PersonId).ToList()
                .Select(x => x.MapToEDSLocationRoleModel()).ToList();

           // List<EDSRolesV1> rolesList =EvalEntities.EDSRolesV1.Where(x=>x.PersonId==target.PersonId).ToList();
           // target.LocationRoles= rolesList.Select(x => x.MapToEDSLocationRoleModel()).ToList();

            return target;
        }
    }
}