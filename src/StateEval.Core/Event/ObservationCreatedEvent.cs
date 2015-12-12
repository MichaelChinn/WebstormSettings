using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;

namespace StateEval.Core.Event
{
    public class ObservationCreatedEvent : BaseEvent
    {
        public void Publish(EvalSessionModel evalSession)
        {
            var eventModel = this.NewEventModel();
            eventModel.Name = "Observation Create Event";
            if (evalSession.EvaluatorId != null)
            {
                eventModel.CreatedBy = (int) evalSession.EvaluatorId;
            }

            eventModel.ObjectId = (int)evalSession.Id;

            eventModel.EventId = this.EventService.SaveEvent(eventModel);
            
            
            var notification = this.NewNotificaiton();
            notification.EventId = eventModel.EventId;
            if (evalSession.EvaluatorId != null)
            {
                notification.ReceiverUserId = (int) evalSession.EvaluatorId;
            }
            
            NotificationService.SaveNotification(notification);
        }        
    }
}
