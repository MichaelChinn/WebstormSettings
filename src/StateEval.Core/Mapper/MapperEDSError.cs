using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EDSErrorModel MapToEDSErrorModel(
           this EDSError source, EDSErrorModel target = null)
        {
            target = target ?? new EDSErrorModel();

            target.StagingId = source.stagingId;
            target.PersonId = source.personID;
            target.LocationCode = source.locationCode;
            target.LocationName = source.locationName;
            target.RoleString = source.roleString;
            target.RawRoleString = source.rawRoleString;
            target.DistrictCode = source.districtCode;
            target.SchoolCode = source.schoolCode;
            target.SeEvaluationTypeID = source.seEvaluationTypeID;
            target.CAspnetUsers = source.cAspnetUsers;
            target.CAspnetUIR = source.cAspnetUIR;
            target.CInsertEval = source.cInsertEval;
            target.IsNew = source.isNew;
            target.FirstEntry = source.firstEntry;
            target.ErrorMsg = source.errorMsg;
            target.PrevousPersonId = source.PrevousPersonId;
            target.Id = source.EDSErrorID;

            return target;
        }

        public static EDSError MaptoEDSError(
            this EDSErrorModel source, EDSError target = null)
        {
            target = target ?? new EDSError();

            target.stagingId = source.StagingId;
            target.personID = source.PersonId;
            target.locationCode = source.LocationCode;
            target.locationName = source.LocationName;
            target.roleString = source.RoleString;
            target.rawRoleString = source.RawRoleString;
            target.districtCode = source.DistrictCode;
            target.schoolCode = source.SchoolCode;
            target.seEvaluationTypeID = source.SeEvaluationTypeID;
            target.cAspnetUsers = source.CAspnetUsers;
            target.cAspnetUIR = source.CAspnetUIR;
            target.cInsertEval = source.CInsertEval;
            target.isNew = source.IsNew;
            target.firstEntry = source.FirstEntry;
            target.errorMsg = source.ErrorMsg;
            target.PrevousPersonId = source.PrevousPersonId;
            target.EDSErrorID = source.Id;


            return target;
        }
    }
}