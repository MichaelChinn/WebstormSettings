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

namespace StateEval.Core.Services
{
    public class EDSImportInfoService : BaseService
    {
        public List<EDSErrorModel> GetEDSErrors()
        {
            return EvalEntities.EDSErrors.ToList().Select(x => x.MapToEDSErrorModel()).ToList();
        }

        public List<EDSErrorModel> GetEDSErrorsForEDSPersonId(long personId)
        {
            return EvalEntities.EDSErrors.Where(x => x.personID == personId).ToList()
                .Select(x => x.MapToEDSErrorModel()).ToList();
        }

        public List<EDSStagingModel> GetEDSStagingRecords()
        {
            return EvalEntities.EDSStagings.ToList().Select(x => x.MapToEDSStagingModel()).ToList();
        }

        public List<EDSStagingModel> GetEDSStagingRecordsForEDSPerionId(long personId)
        {
            return EvalEntities.EDSStagings.Where(x => x.personID == personId).ToList()
                .Select(x => x.MapToEDSStagingModel()).ToList();
        }


        public List<EDSUserLocationRoleModel> GetEDSUserLocationRoleForLastName(string lastName)
        {
            //blose, eloff, kinnear are good test cases
            return EvalEntities.EDSUsersV1.Where(x => x.LastName == lastName).ToList()
                .Select(x => x.MapToEDSUserLocationRoleModel()).ToList();
        }
    }
}

