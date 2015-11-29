using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class UserOrientationModel
    {
        public SESchoolYearEnum SchoolYear { get; set; }
        public string DistrictCode { get; set; }
        public string DistrictName { get; set; }
        public string SchoolCode { get; set; }
        public string SchoolName { get; set; }
        public string RoleName { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
    }
}
