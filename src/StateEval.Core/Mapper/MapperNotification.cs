using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SENotification MaptoSeNotification(
            this NotificationModel source, SENotification target = null)
        {
            target = target ?? new SENotification();

            target.NotificationId = source.NotificationId;
            target.EventId = source.EventId;
            target.Title = source.Title;
            target.AlignedTo = source.AlignedTo;
            target.ReceiverUserId = source.ReceiverUserId;
            target.ReceiverRoleId = source.ReceiverRoleId;
            target.IsViewed = source.IsViewed;
            target.ViewedDateTime = source.ViewedDateTime;
            target.EmailSentForNotification = source.EmailSentForNotification;
            target.NotificationType = source.NotificationType;
            target.CreateDate = source.CreateDate;
            target.ModifiedDate = source.ModifiedDate;
            target.IsDeleted = source.IsDeleted;
            target.DeletedDateTime = source.DeletedDateTime;
            return target;
        }

        public static NotificationModel MaptoNotificationModel(
            this SENotification source, NotificationModel target = null)
        {
            target = target ?? new NotificationModel();

            target.NotificationId = source.NotificationId;
            target.EventId = source.EventId;
            target.Title = source.Title;
            target.AlignedTo = source.AlignedTo;
            target.EventType = source.SEEvent.SEEventType.Name;
            target.ReceiverUserId = source.ReceiverUserId;
            target.ReceiverRoleId = source.ReceiverRoleId;
            target.IsViewed = source.IsViewed;
            target.ViewedDateTime = source.ViewedDateTime;
            target.EmailSentForNotification = source.EmailSentForNotification;
            target.NotificationType = source.NotificationType;
            target.CreateDate = source.CreateDate;
            target.ModifiedDate = source.ModifiedDate;
            target.IsDeleted = source.IsDeleted;
            target.DeletedDateTime = source.DeletedDateTime;
            return target;
        }
    }
}