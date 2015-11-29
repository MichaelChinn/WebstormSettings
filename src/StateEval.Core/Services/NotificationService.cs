using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class NotificationService : BaseService
    {
        public IList<NotificationModel> GetNotifications()
        {
            return EvalEntities.SENotifications.ToList().Select(x => x.MaptoNotificationModel()).ToList();
        }

        public IList<NotificationModel> GetNotificationsByEventId(long eventId)
        {
            return EvalEntities.SENotifications.Where(x => x.EventId == eventId).ToList()
                .Select(x => x.MaptoNotificationModel()).ToList();
        }

        public IList<NotificationModel> GetNotificationsByReceiverId(long userId)
        {
            return EvalEntities.SENotifications.Where(x => x.ReceiverUserId == userId).ToList()
                .Select(x => x.MaptoNotificationModel()).ToList();
        }

        public IList<NotificationModel> GetNotificationsByReceiverIdFromCreatedById(long receiverId, long createdById)
        {
            return EvalEntities.SENotifications.Where(x => x.ReceiverUserId == receiverId && x.CreatedByUserId == createdById).ToList()
                .Select(x => x.MaptoNotificationModel()).ToList();
        }

        public IList<NotificationModel> GetNotificationsByCreatorId(long createdByUserId)
        {
            return EvalEntities.SENotifications.Where(x => x.CreatedByUserId == createdByUserId)
                    .ToList().Select(x => x.MaptoNotificationModel()).ToList();
        }

        public long SaveNotification(NotificationModel notification)
        {
            SENotification notificationDb = null;

            if (notification.NotificationId == 0)
            {
                notificationDb = new SENotification();
                EvalEntities.SENotifications.Add(notificationDb);
            }
            else
            {
                notificationDb =
                    EvalEntities.SENotifications.FirstOrDefault(x => x.NotificationId == notification.NotificationId);
            }

            notificationDb = notification.MaptoSeNotification(notificationDb);

            return notificationDb.NotificationId;
        }
    }
}
