using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static LocationModel MaptoLocationModel(
            this SEDistrictSchool source, LocationModel target = null)
        {
            target = target ?? new LocationModel();
            target.DistrictCode = source.districtCode;
            target.SchoolCode = source.schoolCode;
            target.IsSchool = source.isSchool;
            target.Name = source.districtSchoolName;
            return target;
        }
    }
}