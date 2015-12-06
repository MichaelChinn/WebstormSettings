using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static TrainingProtocolLabelGroupModel MaptoTrainingProtocolLabelGroupModel(
            this SETrainingProtocolLabelGroup source, TrainingProtocolLabelGroupModel target = null)
        {
            target = target ?? new TrainingProtocolLabelGroupModel();
            target.Id = source.TrainingProtocolLabelGroupID;
            target.Name = source.Name;

            if (source != null && source.SETrainingProtocolLabels.Any())
            {
                target.Labels = source.SETrainingProtocolLabels.Select(x => x.MaptoTrainingProtocolLabelModel()).ToList();
            }
            else
            {
                target.Labels = new List<TrainingProtocolLabelModel>();
            }

            return target;
        }
    }
}