using System;
using System.Collections.Generic;
using StateEvalData;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class FrameworkContextModel
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string DistrictCode { get; set; }
        public SESchoolYearEnum SchoolYear { get; set; }
        public SEEvaluationTypeEnum EvaluationType { get; set; }
        public FrameworkModel StateFramework { get; set; }
        public FrameworkModel InstructionalFramework { get; set; }
        public Nullable<long> StateFrameworkId { get; set; }
        public Nullable<long> InstructionalFrameworkId { get; set; }
        public bool IsActive { get; set; }
        public Nullable<DateTime> LoadDateTime { get; set; }
        public SEFrameworkViewTypeEnum FrameworkViewType { get; set; }
        public long PrototypeFrameworkContextId { get; set; }
    }
}