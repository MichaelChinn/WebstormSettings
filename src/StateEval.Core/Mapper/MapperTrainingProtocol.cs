using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static TrainingProtocolModel MaptoTrainingProtocolModel(
            this SETrainingProtocol source, TrainingProtocolModel target = null)
        {
            target = target ?? new TrainingProtocolModel();
            target.Id = source.TrainingProtocolID;
            target.AvgRating = source.AvgRating;
            target.Title = source.Title;
            target.Description = source.Description;
            target.DocName = source.DocName;
            target.ImageName = source.ImageName;
            target.Length = source.Length;
            target.NumRatings = source.NumRatings;
            target.Summary = source.Summary;
            target.VideoPoster = source.VideoPoster;
            target.VideoSrc = source.VideoSrc;

            if (source != null && source.SETrainingProtocolLabels.Any())
            {
                target.Labels = source.SETrainingProtocolLabels.Select(x => x.MaptoTrainingProtocolLabelModel()).ToList();
            }
            else
            {
                target.Labels = new List<TrainingProtocolLabelModel>();
            }

            if (source != null && source.SETrainingProtocolCriterias.Any())
            {
                target.AlignedCriteria = source.SETrainingProtocolCriterias.Select(x => x.MaptoTrainingProtocolCriteriaModel()).ToList();
            }
            else
            {
                target.AlignedCriteria = new List<TrainingProtocolCriteriaModel>();
            }


            if (source != null && source.SETrainingProtocolHighLeveragePractices.Any())
            {
                target.AlignedHighLeveragePractices = source.SETrainingProtocolHighLeveragePractices.Select(x => x.MaptoTrainingProtocolHighLeveragePracticeModel()).ToList();
            }
            else
            {
                target.AlignedHighLeveragePractices = new List<TrainingProtocolHighLeveragePracticeModel>();
            }

            return target;
        }
    }
}