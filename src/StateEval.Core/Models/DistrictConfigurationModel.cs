using System;
using System.Collections.Generic;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class DistrictConfigurationModel
    {
        public long Id { get; set; }
        public long FrameworkSetId { get; set; }
        public Nullable<long> StudentGrowthGoalSetupWfState { get; set; }
    }
}


