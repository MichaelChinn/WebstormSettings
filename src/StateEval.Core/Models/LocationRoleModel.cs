using System.Collections.Generic;

namespace StateEval.Core.Models
{
    public class LocationRoleModel
    {
        public LocationRoleModel() { }

        public LocationRoleModel(string districtCode, string districtName, string schoolCode, string schoolName, List<string> roles)
        {
            DistrictCode = districtCode;
            DistrictName = districtName;
            SchoolCode = schoolCode ?? "";
            SchoolName = schoolName ?? "";
            Roles = roles;
        }

        public string DistrictCode { get; set; }
        public string DistrictName { get; set; }
        public string SchoolCode { get; set; }
        public string SchoolName { get; set; }
        public List<string> Roles { get; set; }
    }
}