using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static TrainingProtocolHighLeveragePracticeModel MaptoTrainingProtocolHighLeveragePracticeModel(
            this SETrainingProtocolHighLeveragePractice source, TrainingProtocolHighLeveragePracticeModel target = null)
        {
            target = target ?? new TrainingProtocolHighLeveragePracticeModel();
            target.Id = source.TrainingProtocolHighLeveragePracticeID;
            target.ShortName = source.ShortName;
            target.Title = source.Title;
            target.Description = source.Description;
            return target;
        }
    }
}