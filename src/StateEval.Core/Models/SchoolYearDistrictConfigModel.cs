using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using StateEval;
using StateEvalData;

namespace WebAPI.Models
{
    public class SchoolYearDistrictConfigModel
    {
        public long Id { get; set; }
        public bool SchoolYearIsVisible { get; set; }
        public bool SchoolYearIsDefault { get; set; }
        public SESchoolYear SchoolYear { get; set; }
        public string DistrictCode { get; set; }
    }
}



