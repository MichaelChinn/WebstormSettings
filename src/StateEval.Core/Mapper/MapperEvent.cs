using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SEEvent MaptoSeEvent(
            this EventModel source, SEEvent target = null)
        {
            target = target ?? new SEEvent();

            target.EventId = source.EventId;
            target.EventTypeId = source.EventTypeId;
            target.Name = source.Name;
            target.Detail = source.Detail;
            target.Url = source.Url;
            target.CreateDate = source.CreateDate;
            target.ModifiedDate = source.ModifiedDate;
            target.CreatedBy = source.CreatedBy;
            target.ModifiedBy = source.ModifiedBy;
            target.Note = source.Note;
            target.ObjectId = source.ObjectId;
            return target;
        }

        public static EventModel MaptoEventModel(
            this SEEvent source, EventModel target = null)
        {
            target = target ?? new EventModel();
            target.EventId = source.EventId;
            target.EventTypeId = source.EventTypeId;
            target.Name = source.Name;
            target.Detail = source.Detail;
            target.Url = source.Url;
            target.CreateDate = source.CreateDate;
            target.ModifiedDate = source.ModifiedDate;
            target.CreatedBy = source.CreatedBy;
            target.ModifiedBy = source.ModifiedBy;
            target.Note = source.Note;
            target.ObjectId = source.ObjectId;
            return target;
        }

        public static EventTypeModel MaptoEventTypeModel(
            this SEEventType source, EventTypeModel target)
        {
            target = target ?? new EventTypeModel();
            target.EventTypeId = source.EventTypeId;
            target.Description = source.Description;
            target.Name = source.Name;
            return target;
        }
    }
}