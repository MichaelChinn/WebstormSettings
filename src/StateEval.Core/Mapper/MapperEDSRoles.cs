using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EDSLocationRoleModel MapToEDSLocationRoleModel(
           this EDSRolesV1 source, EDSLocationRoleModel target = null)
        {
            target = target ?? new EDSLocationRoleModel();

            target.Id = source.EDSRolesID;
            target.PersonId = source.PersonId;
            target.OrganizationName = source.OrganizationName;
            target.OSPILegacyCode = source.OSPILegacyCode;
            target.OrganizationRoleName = source.OrganizationRoleName;

            return target;
        }

        public static EDSLocationRoleModel MapToEDSLocationRoleModel(this EDSRolesV1 source)
        {
            EDSLocationRoleModel target =  new EDSLocationRoleModel();

            target.Id = source.EDSRolesID;
            target.PersonId = source.PersonId;
            target.OrganizationName = source.OrganizationName;
            target.OSPILegacyCode = source.OSPILegacyCode;
            target.OrganizationRoleName = source.OrganizationRoleName;

            return target;
        }
    }
}