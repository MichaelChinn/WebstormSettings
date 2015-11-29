using System;
using System.Collections.Generic;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class UserModel
    {
        public long Id { get; set; }
        public long? EvaluationId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DisplayName { get; set; }
        public bool HasMultipleBuildings { get; set; }
        public string EMailAddress { get; set; }
        public string CertificateNumber { get; set; }
        public string EMailAddressAlternate { get; set; }
        public List<LocationRoleModel> LocationRoles { get; set; }
        public EvaluationModel EvalData { get; set; }
        public List<UserOrientationModel> UserOrientations { get; set; }

    }
}