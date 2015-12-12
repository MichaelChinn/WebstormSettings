using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class UserLocationRoleModel
    {
        public long UserLocationRoleID { get; set; }
        public Nullable<long> SEUserID { get; set; }
        public string UserName { get; set; }
        public string RoleName { get; set; }
        public System.Guid RoleId { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public Nullable<bool> LastActiveRole { get; set; }
        public System.DateTime CreateDate { get; set; }
        public string DistrictName { get; set; }
        public string SchoolName { get; set; }
    }
}
