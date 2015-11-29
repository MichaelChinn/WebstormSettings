using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Models;
using StateEval.Core.Services;

namespace StateEval.Core.Event
{
    public abstract class BaseEvent
    {        
        protected NotificationService NotificationService = new NotificationService();
        protected EventService EventService = new EventService();

        protected NotificationModel NewNotificaiton()
        {
            return new NotificationModel
            {
                CreateDate = DateTime.Now,
                EmailSentForNotification = false,                
            };
        }

        protected EventModel NewEventModel()
        {
            EventModel eventModel = new EventModel
            {
                CreateDate = DateTime.Now,
            };
            
            return eventModel;
        }
    }
}
