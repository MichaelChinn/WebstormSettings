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
        public static UserOrientationModel MapToUserOrientationModel(this vUserOrientation source,  UserOrientationModel target = null)
        {
            target = target ?? new UserOrientationModel();
            target.SchoolYear = (SESchoolYearEnum)source.SchoolYear;
            target.DistrictCode = source.DistrictCode;
            target.SchoolCode = source.SchoolCode;
            target.RoleName = source.RoleName;
            target.EvaluationType = (SEEvaluationTypeEnum)source.EvaluationTypeID;
            target.DistrictName = source.DistrictName;
            target.SchoolName = source.SchoolName;
            return target;
        }
    }
} 
