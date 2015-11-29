using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
         public static DistrictConfigurationModel MaptoDistrictConfigurationModel(
            this SEDistrictConfiguration source, DistrictConfigurationModel target = null)
        {
            target = target ?? new DistrictConfigurationModel();

            target.Id = source.DistrictConfigurationID;
            target.FrameworkSetId = source.FrameworkContextID;
            target.StudentGrowthGoalSetupWfState = source.StudentGrowthGoalSetupWfStateID;

            return target;
        }

        public static SEDistrictConfiguration MaptoSEDistrictConfiguration(
            this DistrictConfigurationModel source, SEDistrictConfiguration target = null)
        {
            target = target ?? new SEDistrictConfiguration();

            target.DistrictConfigurationID = source.Id;
            target.FrameworkContextID = source.FrameworkSetId;
            target.StudentGrowthGoalSetupWfStateID = source.StudentGrowthGoalSetupWfState;

            return target;
        }
    }
}