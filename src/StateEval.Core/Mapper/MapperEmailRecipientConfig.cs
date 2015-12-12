using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static EventTypeEmailRecipientConfig MaptoEventTypeEmailRecipientConfig(
            this EmailRecipientConfigModel source, EventTypeEmailRecipientConfig target = null)
        {
            target = target ?? new EventTypeEmailRecipientConfig();

            target.EmailDeliveryTypeID = source.EmailDeliveryTypeID;
            target.EventTypeEmailRecipientConfigID = source.Id;
            target.EventTypeID = source.EventTypeID;
            target.Inbox = source.Inbox;
            target.RecipientID = source.RecipientID;

            return target;
        }

        public static EmailRecipientConfigModel MaptoEmailRecipientConfigModel(
            this EventTypeEmailRecipientConfig source, EmailRecipientConfigModel target = null)
        {
            target = target ?? new EmailRecipientConfigModel();
            target.EmailDeliveryTypeID = source.EmailDeliveryTypeID;
            target.Id = source.EventTypeEmailRecipientConfigID;
            target.EventTypeID = source.EventTypeID;
            target.Inbox = source.Inbox;
            target.RecipientID = source.RecipientID;
            target.EventTypeName = source.SEEventType == null ? "" : source.SEEventType.Name;

            return target;
        }
    }
}