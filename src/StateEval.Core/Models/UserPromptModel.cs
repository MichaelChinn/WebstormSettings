using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;

namespace StateEval.Core.Models
{
    public class UserPromptModel
    {
        public long UserPromptID { get; set; }
        public SEUserPromptTypeEnum PromptTypeID { get; set; }
        public string Title { get; set; }
        public string Prompt { get; set; }
        public string DistrictCode { get; set; }
        public string SchoolCode { get; set; }
        public long CreatedByUserID { get; set; }
        public bool Published { get; set; }
        public Nullable<System.DateTime> PublishedDate { get; set; }
        public bool Retired { get; set; }
        public short EvaluationTypeID { get; set; }
        public string EvaluationType { get; set; }
        public bool Private { get; set; }
        public Nullable<long> EvaluateeID { get; set; }
        public Nullable<long> EvalSessionID { get; set; }
        public bool CreatedAsAdmin { get; set; }
        public Nullable<short> Sequence { get; set; }
        public short SchoolYear { get; set; }
        public Nullable<System.Guid> GUID { get; set; }
        public string DefinedBy { get; set; }
        public bool InUse { get; set; }
        public bool AddToBank { get; set; }
        public bool Assigned { get; set; }
        public string RubricRowNames { get; set; }
        public Nullable<long> WfStateID { get; set; }
        public List<RubricRowModel> RubricRows { get; set; }        
    }
}
