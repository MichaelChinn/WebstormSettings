using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNet.Identity;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class UserActivityService : BaseService
    {
        public IList<UserActivityModel> GetuserActivities()
        {
            return this.EvalEntities.SEUserActivities.ToList().Select(x => x.MapToUserActivityModel()).ToList();
        }

        public IList<UserActivityModel> GetuserActivities(long userId)
        {
            return
                this.EvalEntities.SEUserActivities.Where(x => x.UserId == userId).ToList()
                    .Select(x => x.MapToUserActivityModel())
                    .ToList();
        }

        public IList<UserActivityModel> GetuserRecentActivities(long userId)
        {
            return
                this.EvalEntities.SEUserActivities.Where(x => x.UserId == userId)
                    .OrderBy(x => x.CreateDate)
                    .Take(20)
                    .ToList()
                    .Select(x => x.MapToUserActivityModel())
                    .ToList();
        }

        public UserActivityModel GetUserActivity(int userActivityId)
        {
            var userActivity = EvalEntities.SEUserActivities.FirstOrDefault(x => x.Id == userActivityId);

            if (userActivity != null)
            {
                return userActivity.MapToUserActivityModel();
            }

            return null;
        }

        public long SaveUserActivity(UserActivityModel userActivity)
        {
            userActivity.CreateDate = DateTime.Now;
            SEUserActivity seUserActivity = null;
            
            if (userActivity.Id == 0)
            {
                seUserActivity = new SEUserActivity();
                EvalEntities.SEUserActivities.Add(seUserActivity);
            }
            else
            {
                seUserActivity = EvalEntities.SEUserActivities.FirstOrDefault(x => x.Id == userActivity.Id);
            }

            seUserActivity = userActivity.MaptoSEUserActivity(seUserActivity);
            EvalEntities.SaveChanges();
            return seUserActivity.Id;
        }
    }
}