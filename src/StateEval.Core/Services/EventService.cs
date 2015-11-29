using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations.Model;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class EventService : BaseService
    {
        public IList<EventModel> GetEvents()
        {
            return EvalEntities.SEEvents.ToList().Select(x => x.MaptoEventModel()).ToList();
        }

        public IList<EventModel> GetEventsByCreatorId(int userId)
        {
            return EvalEntities.SEEvents.Where(x => x.CreatedBy == userId).ToList()
                .Select(x => x.MaptoEventModel()).ToList();
        }

        public SEEvent CreateEvent(string name, long ObjectId, EventTypeEnum eventType,
            long? createdBy)
        {
            var seEvent = new SEEvent();
            seEvent.Name = name;            
            seEvent.CreatedBy = createdBy;
            seEvent.ObjectId = ObjectId;
            seEvent.CreateDate = DateTime.Now;
            seEvent.EventTypeId = (int)eventType;            
            EvalEntities.SEEvents.Add(seEvent);
            EvalEntities.SaveChanges();
            return seEvent;
        }

        public SENotification CreateNotification(SEEvent seEvent, string title, long? receiverId, long? createdById)
        {
            var notification = new SENotification();
            notification.CreateDate = DateTime.Now;
            notification.EventId = seEvent.EventId;
            notification.NotificationType = (int)EventTypeEnum.ObservationCreated;
            notification.CreateDate = DateTime.Now;
            notification.Description = title;
            notification.Title = title;
            notification.ReceiverUserId = receiverId;
            notification.CreatedByUserId = createdById;
            EvalEntities.SENotifications.Add(notification);
            return notification;
        }

        public long SaveObservationCreatedEvent(EvalSessionModel evalSessionModel)
        {
            var seEvent = CreateEvent("Observation Created", evalSessionModel.Id,
                EventTypeEnum.ObservationCreated, evalSessionModel.EvaluatorId);

            var description = evalSessionModel.Title;
            CreateNotification(seEvent, description, evalSessionModel.EvaluateeId, evalSessionModel.EvaluatorId);
            EvalEntities.SaveChanges();

            return seEvent.EventId;
        }

        public long SaveArtifactSubmittedEvent(ArtifactBundleModel artifactBundleModel, long evaluatorId, long evaluateeId)
        {
            var seEvent = CreateEvent("Artifact Submitted", artifactBundleModel.Id,
                EventTypeEnum.ArtifactSubmitted, artifactBundleModel.CreatedByUserId);

            var description = artifactBundleModel.Title;
            CreateNotification(seEvent, description, evaluatorId, evaluateeId);
            EvalEntities.SaveChanges();

            return seEvent.EventId;
        }


        public long SaveArtifactRejectedEvent(long artifactBundleId, string artifactBundleTitle, long evaluatorId, long evaluateeId)
        {
            var seEvent = CreateEvent("Request for Further Input for Artifact", artifactBundleId,
                                        EventTypeEnum.ArtifactRejected, evaluatorId);

            CreateNotification(seEvent, artifactBundleTitle, evaluateeId, evaluatorId);
            EvalEntities.SaveChanges();

            return seEvent.EventId;
        }


        public long SaveEvent(EventModel eventModel)
        {
            SEEvent eventDb = null;

            if (eventModel.EventId == 0)
            {
                eventDb = new SEEvent();
                EvalEntities.SEEvents.Add(eventDb);
            }
            else
            {
                eventDb = EvalEntities.SEEvents.FirstOrDefault(x => x.EventId == eventDb.EventId);
            }

            eventDb = eventModel.MaptoSeEvent(eventDb);

            return eventDb.EventId;
        }

        public List<EventTypeModel> GetEventTypes()
        {
            List<EventTypeModel> eventTypes = EvalEntities.SEEventTypes.ToList()
                .Select(x => x.MaptoEventTypeModel(null)).ToList();

            return eventTypes;
        }
    }
}
