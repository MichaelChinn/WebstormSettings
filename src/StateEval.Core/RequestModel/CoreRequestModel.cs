using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class CoreRequestModel
    {
        public CoreRequestModel() { }
        public CoreRequestModel(SESchoolYearEnum schoolYear, string districtCode, string schoolCode, SEEvaluationTypeEnum evalType)
        {
            SchoolYear = schoolYear;
            DistrictCode = districtCode;
            SchoolCode = schoolCode;
            EvaluationType = evalType;
        }

        public SESchoolYearEnum SchoolYear { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
    }
}
