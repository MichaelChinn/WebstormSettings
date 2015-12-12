using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StateEval;
using StateEval.Core.Constants;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class SummativeFrameworkNodeScoreModel
    {
        public long Id { get; set; }
        public long EvaluationId { get; set; }
        public Nullable<short> PerformanceLevel { get; set; }
        public long FrameworkNodeId { get; set; }
        public long CreatedByUserId { get; set; }
        public string StatementOfPerformance { get; set; } 
    }
}
