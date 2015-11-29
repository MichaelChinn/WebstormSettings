using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {

        public static SEUser MaptoSEUser(this UserModel source, SEUser target = null)
        {
            target.SEUserID = source.Id;
            return target;
        }

        public static UserModel MapToUserModel(this SEUser source, CoreRequestModel request, UserModel target = null)
        {
            target = target ?? new UserModel();
            target.Id = source.SEUserID;
            target.EvaluationId  = source.EvaluationID;
            target.FirstName = source.FirstName;
            target.LastName = source.LastName;
            target.DisplayName = target.FirstName + " " + target.LastName;
            target.HasMultipleBuildings = source.HasMultipleBuildings;
            target.EMailAddress = source.EmailAddress;
            target.EMailAddressAlternate = source.EmailAddressAlternate;
            target.CertificateNumber = source.CertificateNumber;
 
            if (request != null)
            {
                SEEvaluation seEval = source.SEEvaluations.FirstOrDefault(x =>
                                            x.DistrictCode == request.DistrictCode &&
                                            x.SchoolYear == (short)request.SchoolYear &&
                                            x.EvaluationTypeID == (short)request.EvaluationType);

                target.EvalData = seEval.MapToEvaluationModel();
            }

            List<aspnet_Roles> roles = source.aspnet_Users.aspnet_Roles.ToList();
            List<SEUserDistrictSchool> locations = source.SEUserDistrictSchools.ToList();

            List<string> roleList = roles.Select(x => x.RoleName).ToList();
            target.LocationRoles = locations.Select(x => new LocationRoleModel(x.DistrictCode, x.DistrictName, x.SchoolCode, x.SchoolName, roleList)).ToList();
            return target;
        }
    }
}
