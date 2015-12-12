using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public class EDSStagingModel
    {
        public long stagingId { get; set; }
        public Nullable<long> personID { get; set; }
        public string locationCode { get; set; }
        public string locationName { get; set; }
        public string roleString { get; set; }
        public string rawRoleString { get; set; }
        public string districtCode { get; set; }
        public string schoolCode { get; set; }
        public Nullable<short> seEvaluationTypeID { get; set; }
        public string cAspnetUsers { get; set; }
        public string cAspnetUIR { get; set; }
        public string cInsertEval { get; set; }
        public Nullable<bool> isNew { get; set; }
        public Nullable<bool> firstEntry { get; set; }
        public string PrevousPersonId { get; set; }
    }
}
