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
    
    public partial class SEUserPromptResponseEntry
    {
        public long UserPromptResponseEntryID { get; set; }
        public long UserPromptResponseID { get; set; }
        public string Response { get; set; }
        public long UserID { get; set; }
        public System.DateTime CreationDateTime { get; set; }
    
        public virtual SEUserPromptResponse SEUserPromptResponse { get; set; }
        public virtual SEUser SEUser { get; set; }
    }
}
