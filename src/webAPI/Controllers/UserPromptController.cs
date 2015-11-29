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
    public class UserPromptController : BaseApiController
    {
        UserPromptService userPromptService = new UserPromptService();

        [Route("api/toruserprompts/questionbank")]
        public IList<UserPromptModel> GetEvaluatorDefinedQuestionBankUserPrompts([FromUri]UserPromptRequestModel userPromptRequestModel)
        {
            var userPrompts = new UserPromptService().GetEvaluatorDefinedQuestionBankUserPrompts(userPromptRequestModel.SchoolYear,
                userPromptRequestModel.DistrictCode, userPromptRequestModel.SchoolCode, userPromptRequestModel.EvaluationType,
                userPromptRequestModel.PromptType, userPromptRequestModel.WfState, userPromptRequestModel.CreatedByUserId);
            return userPrompts;
        }

        [Route("api/sauserprompts/questionbank")]
        public IList<UserPromptModel> GetSchoolAdminDefinedQuestionBankUserPrompts([FromUri]UserPromptRequestModel userPromptRequestModel)
        {
            var userPrompts = new UserPromptService().GetSchoolAdminDefinedQuestionBankUserPrompts(userPromptRequestModel.SchoolYear, 
                userPromptRequestModel.DistrictCode, userPromptRequestModel.SchoolCode,userPromptRequestModel.EvaluationType, 
                userPromptRequestModel.PromptType, userPromptRequestModel.WfState);
            return userPrompts;
        }

        [Route("api/dauserprompts/questionbank")]
        public IList<UserPromptModel> GetDistrictAdminDefinedQuestionBankUserPrompts([FromUri]UserPromptRequestModel userPromptRequestModel)
        {
            var userPrompts = new UserPromptService().GetDistrictAdminDefinedQuestionBankUserPrompts(userPromptRequestModel.SchoolYear, 
                userPromptRequestModel.DistrictCode, userPromptRequestModel.EvaluationType, userPromptRequestModel.PromptType, 
                userPromptRequestModel.WfState);
            return userPrompts;
        }

        [Route("api/userprompts/questionbank")]
        public IList<UserPromptModel> GetuserPrompts([FromUri]UserPromptRequestModel userPromptRequestModel)
        {
            var userPrompts = new UserPromptService().GetQuestionBankUserPrompts(userPromptRequestModel.SchoolYear, userPromptRequestModel.DistrictCode,
                userPromptRequestModel.SchoolCode, userPromptRequestModel.CreatedByUserId,
                    userPromptRequestModel.EvaluationType, userPromptRequestModel.PromptType, userPromptRequestModel.RoleName);
            return userPrompts;
        }

        [Route("api/userprompts/preconference")]
        public IList<UserPromptModel> GetPreConferenceUserPrompts([FromUri]UserPromptRequestModel userPromptRequestModel)
        {
            var userPrompts = userPromptService.GetAssignableUserPrompts(userPromptRequestModel.SchoolYear,
                userPromptRequestModel.DistrictCode, userPromptRequestModel.SchoolCode,
                userPromptRequestModel.SchoolCode,
                userPromptRequestModel.CreatedByUserId, userPromptRequestModel.EvaluationType,
                userPromptRequestModel.PromptType, userPromptRequestModel.RoleName, userPromptRequestModel.EvalSessionId,
                null);
            return userPrompts;
        }

        [Route("api/userprompts/postconference")]
        public IList<UserPromptModel> GetPostConferenceUserPrompts(UserPromptRequestModel userPromptRequestModel)
        {
            var userPrompts = userPromptService.GetAssignableUserPrompts(userPromptRequestModel.SchoolYear,
                userPromptRequestModel.DistrictCode,
                userPromptRequestModel.SchoolCode, userPromptRequestModel.SchoolCode,
                userPromptRequestModel.CreatedByUserId, userPromptRequestModel.EvaluationType,
                userPromptRequestModel.PromptType, userPromptRequestModel.RoleName, userPromptRequestModel.EvalSessionId,
                null);
            return userPrompts;
        }

        [Route("api/userprompt/{userPromptId}")]
        public UserPromptModel GetuserPromptModel(int userPromptId)
        {
            var userPromptModel = userPromptService.GetUserPrompt(userPromptId);
            return userPromptModel;
        }

        [Route("api/userprompt/save")]
        public UserPromptModel SaveUserPrompt(UserPromptModel userPrompt)
        {
            userPromptService.SaveUserPrompt(userPrompt);
            return userPrompt;
        }

        [Route("api/userprompt/delete/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteUserPrompt(long id)
        {
            userPromptService.DeleteUserPrompt(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/userprompt/assign")]
        [HttpPost]
        public HttpResponseMessage AssignUserPrompt(UserPromptModel userpromptModel)
        {
            if (userpromptModel.Assigned)
            {
                userPromptService.AssignPromptToUser(userpromptModel.EvalSessionID, (SESchoolYearEnum)userpromptModel.SchoolYear, userpromptModel.DistrictCode, userpromptModel.CreatedByUserID, userpromptModel.UserPromptID);
            }
            else
            {
                userPromptService.UnAssignpromptToUser(userpromptModel.CreatedByUserID, userpromptModel.UserPromptID, (SESchoolYearEnum)userpromptModel.SchoolYear, userpromptModel.DistrictCode, null);
            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/confprompt/insert")]
        [HttpPost]
        public HttpResponseMessage InsertNewConfPrompt(UserPromptModel userPromptModel)
        {
            userPromptService.InsertNewPreConfPrompt(userPromptModel.AddToBank, userPromptModel.EvalSessionID, userPromptModel.PromptTypeID,
                userPromptModel.Prompt, (SESchoolYearEnum)userPromptModel.SchoolYear, userPromptModel.SchoolCode, userPromptModel.DistrictCode, userPromptModel.CreatedByUserID, userPromptModel.EvaluationTypeID);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}
