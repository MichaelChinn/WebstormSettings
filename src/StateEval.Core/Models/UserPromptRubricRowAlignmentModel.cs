using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StateEval.Core.Models
{
    public class UserPromptRubricRowAlignmentModel
    {
        public long SEUserPromptRubricRowAlignmentID { get; set; }
        public long UserPromptID { get; set; }
        public long RubricRowID { get; set; }
        public long CreatedByUserID { get; set; }        

    }
}
