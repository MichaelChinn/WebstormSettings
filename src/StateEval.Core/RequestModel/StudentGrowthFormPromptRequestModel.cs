using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StateEval.Core.Constants;

namespace StateEval.Core.RequestModel
{
    public class StudentGrowthFormPromptRequestModel
    {
        public StudentGrowthFormPromptRequestModel() { }

        public SESchoolYearEnum SchoolYear { get; set; }
        public string DistrictCode { get; set; }
        public long FrameworkNodeId { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
        public long PromptId { get; set; }
        public short PromptType { get; set; }
    }
}
