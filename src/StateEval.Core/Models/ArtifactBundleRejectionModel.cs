using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace StateEval.Core.Models
{
    public class ArtifactBundleRejectionModel
    {
        public long Id { get; set; }
        public long ArtifactBundleId { get; set; }
        public long CreatedByUserId { get; set; }
        public short RejectionType { get; set; }
        public Guid CommunicationSessionKey { get; set; }
        public List<CommunicationModel> Communications { get; set; }
    }
}
