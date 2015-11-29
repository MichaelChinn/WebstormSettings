using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.EntitySql;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using StateEval.Core.Constants;
using StateEvalData;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using System.Web.Http;
using StateEval.Core.Services;
using webAPI.Models;

namespace WebAPI.Controllers
{
    public class UserPromptResponseController : BaseApiController
    {
        UserPromptResponseService userPromptResponseService = new UserPromptResponseService();

        [Route("api/preconfresponses/{evalSessionId}")]
        public IList<UserPromptResponseModel> GetUserPromptPreConfResponses(int evalSessionId)
        {
            var userPrompts = userPromptResponseService.GetuserPromptPreConfResponses(evalSessionId);
            return userPrompts;
        }

        [Route("api/userpromptresponse/save")]
        [HttpPost]
        public long SaveUserPromptResponse(UserPromptResponseModel userPromptResponse)
        {
            return userPromptResponseService.SaveUserPromptResponse(userPromptResponse);
        }

        [Route("api/userpromptresponses/save")]
        [HttpPost]
        public HttpResponseMessage SaveUserPromptResponses(List<UserPromptResponseModel> userPromptResponses)
        {
            userPromptResponseService.SaveUserPromptResponses(userPromptResponses);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/userpromptresponse/savecodedresponse")]
        [HttpPost]
        public HttpResponseMessage SaveUserPromptCodedResponse(UserPromptResponseModel userPromptResponse)
        {
            userPromptResponseService.SaveUserPromptCodedResponse(userPromptResponse);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

    }
}
