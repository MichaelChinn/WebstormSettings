using System;
using System.Collections.Generic;

namespace StateEval.Core.Models
{
    public class ResourceModel
    {
        public long Id { get; set; }
        public long EvaluationId { get; set; }
        public long CreatedByUserId { get; set; }
        public string Title { get; set; }
        public string Comments { get; set; }
        public DateTime CreationDateTime { get; set; }
        public Guid? FileUUID { get; set; }
        public string WebUrl { get; set; }
        public string FileName { get; set; }
        public short ResourceType { get; set; }
        public short ItemType { get; set; }
        public string SchoolCode { get; set; }
        public string DistrictCode { get; set; }
        public IEnumerable<RubricRowModel> AlignedRubricRows { get; set; }

    }
}
