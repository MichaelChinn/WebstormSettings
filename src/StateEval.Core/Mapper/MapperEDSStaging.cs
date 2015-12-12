using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EDSStagingModel MapToEDSStagingModel(
           this EDSStaging source, EDSStagingModel target = null)
        {
            target = target ?? new EDSStagingModel();

            target.stagingId = source.stagingId;
            target.personID = source.personID;
            target.locationCode = source.locationCode;
            target.locationName = source.locationName;
            target.roleString = source.roleString;
            target.rawRoleString = source.rawRoleString;
            target.districtCode = source.districtCode;
            target.schoolCode = source.schoolCode;
            target.seEvaluationTypeID = source.seEvaluationTypeID;
            target.cAspnetUsers = source.cAspnetUsers;
            target.cAspnetUIR = source.cAspnetUIR;
            target.cInsertEval = source.cInsertEval;
            target.isNew = source.isNew;
            target.firstEntry = source.firstEntry;
            target.PrevousPersonId = source.PrevousPersonId;

            return target;
        }

       /* public static EDSStaging MapToEDSLocationRoleModel(this EDSStagingModel source)
        {
            EDSStaging target = new EDSStaging();


            return target;
        }*/
    }
}