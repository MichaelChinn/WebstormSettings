using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web.Http;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class NotificationController : BaseApiController
    {
        private readonly NotificationService notificationService = new NotificationService();
        private readonly EventService eventService = new EventService();

        [Route("api/notifications/workedon/{userId}")]
        public IList<NotificationModel> GetNotificationsWorkedOn(long userId)
        {
            return notificationService.GetNotificationsByCreatorId(userId);
        }

        [Route("api/notifications/receivedby/{receivedByUserId}/createdBy/{createdByUserId}")]
        public IList<NotificationModel> GetNotificationsByReceiverIdFromCreatedById(long receivedByUserId, long createdByUserId)
        {
            return notificationService.GetNotificationsByReceiverIdFromCreatedById(receivedByUserId, createdByUserId);
        }

        public IList<EventModel> GetEvents()
        {
            return eventService.GetEvents();
        }
    }
}