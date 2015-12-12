using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public class EDSLocationRoleModel
    {
        public long Id { get; set; }
        public Nullable<long> PersonId { get; set; }
        public string OrganizationName { get; set; }
        public string OSPILegacyCode { get; set; }
        public string OrganizationRoleName { get; set; }
    }
}