using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static TrainingProtocolLabelModel MaptoTrainingProtocolLabelModel(
            this SETrainingProtocolLabel source, TrainingProtocolLabelModel target = null)
        {
            target = target ?? new TrainingProtocolLabelModel();
            target.Id = source.TrainingProtocolLabelID;
            target.GroupId = source.TrainingProtocolLabelGroupID;
            target.Name = source.Name;
            return target;
        }
    }
}