using System;
using StateEvalData;

namespace StateEval.Core.Models
{
    public class NotificationModel
    {
        public long NotificationId { get; set; }
        public string Title { get; set; }
        public Nullable<long> EventId { get; set; }
        public long? ReceiverUserId { get; set; }
        public int? ReceiverRoleId { get; set; }
        public Nullable<bool> IsViewed { get; set; }
        public Nullable<System.DateTime> ViewedDateTime { get; set; }
        public Nullable<bool> EmailSentForNotification { get; set; }
        public Nullable<int> NotificationType { get; set; }        
        public string AlignedTo { get; set; }
        public string EventType { get; set; }
        public Nullable<System.DateTime> CreateDate { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public Nullable<System.DateTime> DeletedDateTime { get; set; }        
    }
}



