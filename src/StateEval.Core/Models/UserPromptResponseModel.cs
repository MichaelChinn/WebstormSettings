using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class UserPromptResponseModel
    {
        public long UserPromptResponseID { get; set; }
        public long UserPromptID { get; set; }
        public string Prompt { get; set; }
        public string Response { get; set; }
        public Nullable<long> EvaluateeID { get; set; }
        public Nullable<long> EvalSessionID { get; set; }
        public Nullable<short> SchoolYear { get; set; }
        public Nullable<long> ArtifactID { get; set; }
        public string DistrictCode { get; set; }
        public long UserId { get; set; }
        public string UserName { get; set; }
        public DateTime ResponseDateTime { get; set; }
    }
}
