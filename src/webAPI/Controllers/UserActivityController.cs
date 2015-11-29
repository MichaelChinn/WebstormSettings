using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class UserActivityController : BaseApiController
    {
        private readonly UserActivityService userActivityService = new UserActivityService();

        [Route("api/useractivities/{userId}")]
        [HttpGet]
        public IList<UserActivityModel> GetUserActivities(long userId)
        {
            return userActivityService.GetuserActivities(userId);
        }

        [Route("api/recentactivities/{userId}")]
        [HttpGet]
        public IList<UserActivityModel> GeRecentActivities(long userId)
        {
            return userActivityService.GetuserActivities(userId);
        }

        [HttpPost]
        [Route("api/useractivity/save")]
        public HttpResponseMessage SaveUserActivity(UserActivityModel userActivity)
        {
            userActivity.IsDeleted = false;
            userActivity.IsViewed = false;
            userActivity.CreateDate = DateTime.Now;            
            userActivityService.SaveUserActivity(userActivity);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}