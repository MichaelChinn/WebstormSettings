using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {

        public static SEUserActivity MaptoSEUserActivity(this UserActivityModel source, SEUserActivity target = null)
        {
            target = target ?? new SEUserActivity();
            target.Id = source.Id;
            target.UserId = source.UserId;
            target.Name = source.Name;
            target.Type = source.Type;
            target.Title = source.Title;
            target.Detail = source.Detail;
            target.CreateDate = source.CreateDate;
            target.IsViewed = source.IsViewed;
            target.IsDeleted = source.IsDeleted;
            target.Url = source.Url;
            target.Param = source.Param;
            target.ObjectId = source.ObjectId;
            target.ObjectType = source.ObjectType;
            target.ActivityData = source.ActivityData;
            return target;
        }

        public static UserActivityModel MapToUserActivityModel(this SEUserActivity source, UserActivityModel target = null)
        {
            target = target ?? new UserActivityModel();
            target.Id = source.Id;
            target.UserId = source.UserId;
            target.Name = source.Name;
            target.Type = source.Type;
            target.Title = source.Title;
            target.Detail = source.Detail;
            target.CreateDate = source.CreateDate;
            target.IsViewed = source.IsViewed;
            target.IsDeleted = source.IsDeleted;
            target.Url = source.Url;
            target.Param = source.Param;
            target.ObjectId = source.ObjectId;
            target.ObjectType = source.ObjectType;
            target.ActivityData = source.ActivityData;
            return target;
            return target;
        }
    }
}
