//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace StateEvalData
{
    using System;
    using System.Collections.Generic;
    
    public partial class SEStudentGrowthFormPromptType
    {
        public SEStudentGrowthFormPromptType()
        {
            this.SEStudentGrowthFormPrompts = new HashSet<SEStudentGrowthFormPrompt>();
        }
    
        public short StudentGrowthFormPromptTypeID { get; set; }
        public string Name { get; set; }
    
        public virtual ICollection<SEStudentGrowthFormPrompt> SEStudentGrowthFormPrompts { get; set; }
    }
}
