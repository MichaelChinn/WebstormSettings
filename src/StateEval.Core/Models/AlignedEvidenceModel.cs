using System;
using System.Collections.Generic;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class AlignedEvidenceModel
    {
        public long Id { get; set; }
        public long RubricRowEvaluationId { get; set; }
        public long AvailableEvidenceId { get; set; }
        public SEEvidenceTypeEnum EvidenceType { get; set; }
        public string AdditionalInput { get; set; }
        public AvailableEvidenceModel Data { get; set; }
        public long AvailableEvidenceObjectId { get; set; }
    }
}
