using System;
using System.Collections.Generic;
using StateEvalData;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class PrototypeFrameworkContextModel
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public SESchoolYearEnum SchoolYear { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
    }
}