using System;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class EmailRecipientConfigModel
    {
        public long Id { get; set; }
        public long RecipientID { get; set; }
        public int EventTypeID { get; set; }
        public string EventTypeName { get; set; }
        public bool Inbox { get; set; }
        public Nullable<short> EmailDeliveryTypeID { get; set; }        
    }
}



