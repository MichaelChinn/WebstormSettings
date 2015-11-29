namespace StateEval.Core.Models
{
    public class ImportErrorRecordModel
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string OSPILegacyCode { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public string LocationName { get; set; }
        public string RawRoleString { get; set; }
        public string ErrorMsg { get; set; }
    }
}