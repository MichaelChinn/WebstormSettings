using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public class EventModel
    {
        public long EventId { get; set; }
        public int EventTypeId { get; set; }
        public string Name { get; set; }
        public string Detail { get; set; }
        public string Url { get; set; }
        public DateTime CreateDate { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<long> CreatedBy { get; set; }
        public Nullable<long> ModifiedBy { get; set; }
        public string Note { get; set; }
        public Nullable<long> ObjectId { get; set; }        
    }
}
