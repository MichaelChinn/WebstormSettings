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
    
    public partial class SEIFWType
    {
        public SEIFWType()
        {
            this.SEFrameworks = new HashSet<SEFramework>();
        }
    
        public short IFWTypeID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ShortName { get; set; }
    
        public virtual ICollection<SEFramework> SEFrameworks { get; set; }
    }
}
