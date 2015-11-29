using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public class EDSErrorModel
    {
        public Nullable<long> StagingId { get; set; }
        public Nullable<long> PersonId { get; set; }
        public string LocationCode { get; set; }
        public string LocationName { get; set; }
        public string RoleString { get; set; }
        public string RawRoleString { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public Nullable<short> SeEvaluationTypeID { get; set; }
        public string CAspnetUsers { get; set; }
        public string CAspnetUIR { get; set; }
        public string CInsertEval { get; set; }
        public Nullable<bool> IsNew { get; set; }
        public Nullable<bool> FirstEntry { get; set; }
        public string ErrorMsg { get; set; }
        public string PrevousPersonId { get; set; }
        public long Id { get; set; }

    }
}
