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
    
    public partial class SEPracticeSessionParticipant
    {
        public long PracticeSessionParticipantID { get; set; }
        public long PracticeSessionID { get; set; }
        public long EvalSessionID { get; set; }
        public long UserID { get; set; }
    
        public virtual SEPracticeSession SEPracticeSession { get; set; }
        public virtual SEEvalSession SEEvalSession { get; set; }
        public virtual SEUser SEUser { get; set; }
    }
}
