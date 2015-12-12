using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using StateEval.Core.Constants;

namespace webAPI.Models
{
    public class ArtifactLinkRequestModel
    {
        public long ArtifactBundleId { get; set; }
        public long ObservationId { get; set;}
        public long StudentGrowthGoalBundleId { get; set; }
        public bool Link { get; set; }
    }
}