using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;
using StateEval.Core.Constants;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static UserDistrictSchoolModel MaptoUserDistrictSchoolModel(
           this SEUserDistrictSchool source, UserDistrictSchoolModel target = null)
        {

            target = target ?? new UserDistrictSchoolModel();

            target.UserDistrictSchoolID = source.UserDistrictSchoolID;
            target.SEUserID = source.SEUserID;
            target.SchoolCode = source.SchoolCode;
            target.DistrictCode = source.DistrictCode;
            target.SchoolName = source.SchoolName;
            target.DistrictName = source.DistrictName;
            target.IsPrimary = source.IsPrimary;

            UserModel UserModel = source.SEUser.MapToUserModel(null);

            return target;
        }
    }
}
