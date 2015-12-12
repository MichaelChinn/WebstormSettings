using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public class CommunicationModel
    {
        public long Id { get; set; }
        public Guid SessionKey { get; set; }
        public long CreatedByUserId { get; set; }
        public DateTime CreationDateTime { get; set; }
        public string Message { get; set; }
    }
}
