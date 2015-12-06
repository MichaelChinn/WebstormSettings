using System;
using System;
using System.Collections.Generic;
using StateEval.Core.Constants;


namespace StateEval.Core.Models
{
    public class TrainingProtocolModel
    {
        public long Id { get; set; }
        public string Title { get; set; }
        public string Summary { get; set; }
        public string Description { get; set; }
        public string DocName { get; set; }
        public string Length { get; set; }
        public string VideoPoster { get; set; }
        public string VideoSrc { get; set; }
        public string ImageName { get; set; }
        public Nullable<short> AvgRating { get; set; }
        public Nullable<short> NumRatings { get; set; }

        public List<TrainingProtocolLabelModel> Labels { get; set; }
        public List<TrainingProtocolLabelGroupModel> LabelGroups { get; set; }
        public List<TrainingProtocolCriteriaModel> AlignedCriteria { get; set; }
        public List<TrainingProtocolHighLeveragePracticeModel> AlignedHighLeveragePractices { get; set;}
    }
}
