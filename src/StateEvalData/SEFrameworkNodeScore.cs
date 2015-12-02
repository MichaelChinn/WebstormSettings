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
    
    public partial class SEFrameworkNodeScore
    {
        public long FrameworkNodeScoreID { get; set; }
        public long EvaluationID { get; set; }
        public Nullable<short> PerformanceLevelID { get; set; }
        public long CreatedByUserID { get; set; }
        public long FrameworkNodeID { get; set; }
        public short LinkedItemTypeID { get; set; }
        public long LinkedItemID { get; set; }
        public Nullable<long> LearningWalkClassRoomID { get; set; }
    
        public virtual SEEvaluation SEEvaluation { get; set; }
        public virtual SEFrameworkNode SEFrameworkNode { get; set; }
        public virtual SELearningWalkClassRoom SELearningWalkClassRoom { get; set; }
        public virtual SERubricPerformanceLevel SERubricPerformanceLevel { get; set; }
        public virtual SEUser SEUser { get; set; }
        public virtual SELinkedItemType SELinkedItemType { get; set; }
    }
}
