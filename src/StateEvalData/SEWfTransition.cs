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
    
    public partial class SEWfTransition
    {
        public SEWfTransition()
        {
            this.SEEvaluationWfHistories = new HashSet<SEEvaluationWfHistory>();
        }
    
        public long WfTransitionID { get; set; }
        public long StartStateID { get; set; }
        public long EndStateID { get; set; }
        public string Description { get; set; }
    
        public virtual ICollection<SEEvaluationWfHistory> SEEvaluationWfHistories { get; set; }
        public virtual SEWfState SEWfState { get; set; }
        public virtual SEWfState SEWfState1 { get; set; }
    }
}
