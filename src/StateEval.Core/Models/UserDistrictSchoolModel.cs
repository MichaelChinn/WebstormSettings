using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public class UserDistrictSchoolModel
    {
        public long UserDistrictSchoolID { get; set; }
        public long SEUserID { get; set; }
        public string SchoolCode { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolName { get; set; }
        public string DistrictName { get; set; }
        public bool IsPrimary { get; set; }

        public virtual UserModel UserModel { get; set; }
    }
}

