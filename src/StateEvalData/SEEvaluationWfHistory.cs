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
    
    public partial class SEEvaluationWfHistory
    {
        public long EvaluationWfHistoryID { get; set; }
        public long EvaluationID { get; set; }
        public long WfTransitionID { get; set; }
        public System.DateTime Timestamp { get; set; }
        public long UserID { get; set; }
        public string Comment { get; set; }
    
        public virtual SEUser SEUser { get; set; }
        public virtual SEWfTransition SEWfTransition { get; set; }
        public virtual SEEvaluation SEEvaluation { get; set; }
    }
}
