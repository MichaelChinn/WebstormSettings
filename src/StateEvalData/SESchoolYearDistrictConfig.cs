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
    
    public partial class SESchoolYearDistrictConfig
    {
        public long SchoolYearDistrictConfigID { get; set; }
        public short SchoolYear { get; set; }
        public string DistrictCode { get; set; }
        public bool SchoolYearIsVisible { get; set; }
        public bool SchoolYearIsDefault { get; set; }
    
        public virtual SESchoolYear SESchoolYear { get; set; }
    }
}
