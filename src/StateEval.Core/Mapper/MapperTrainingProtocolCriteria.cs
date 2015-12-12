using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static TrainingProtocolCriteriaModel MaptoTrainingProtocolCriteriaModel(
            this SETrainingProtocolCriteria source, TrainingProtocolCriteriaModel target = null)
        {
            target = target ?? new TrainingProtocolCriteriaModel();
            target.Id = source.TrainingProtocolCriteriaID;
            target.ShortName = source.ShortName;
            target.Title = source.Title;
            return target;
        }
    }
}