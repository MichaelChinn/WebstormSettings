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
    
    public partial class SESummativeRubricRowScore
    {
        public long SummativeRubricRowScoreID { get; set; }
        public long EvaluationID { get; set; }
        public Nullable<short> PerformanceLevelID { get; set; }
        public long CreatedByUserID { get; set; }
        public long RubricRowID { get; set; }
    
        public virtual SEEvaluation SEEvaluation { get; set; }
        public virtual SERubricPerformanceLevel SERubricPerformanceLevel { get; set; }
        public virtual SERubricRow SERubricRow { get; set; }
        public virtual SEUser SEUser { get; set; }
    }
}
