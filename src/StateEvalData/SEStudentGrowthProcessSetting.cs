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
    
    public partial class SEStudentGrowthProcessSetting
    {
        public SEStudentGrowthProcessSetting()
        {
            this.SEStudentGrowthProcessSettingsFormPrompts = new HashSet<SEStudentGrowthProcessSettingsFormPrompt>();
        }
    
        public long StudentGrowthProcessSettingsID { get; set; }
        public string DistrictCode { get; set; }
        public short EvaluationTypeID { get; set; }
        public short SchoolYear { get; set; }
        public string FrameworkNodeShortName { get; set; }
    
        public virtual SEEvaluationType SEEvaluationType { get; set; }
        public virtual SESchoolYear SESchoolYear { get; set; }
        public virtual ICollection<SEStudentGrowthProcessSettingsFormPrompt> SEStudentGrowthProcessSettingsFormPrompts { get; set; }
    }
}
