using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEval.Core.Services;
using webAPI.Models;
using StateEvalData;


namespace WebAPI.Controllers
{
    public class StudentGrowthFormPromptController : BaseApiController
    {
        [Route("api/sgprocesssettings/submit/{frameworkSetId}")]
        [HttpPut]
        public void SubmitSettings(long frameworkSetId)
        {
            formPromptService.SubmitSettings(frameworkSetId);
        }

        [Route("api/settingshavebeensubmitted/{frameworkSetId}")]
        [HttpGet]
        public bool GetStudentGrowthProcessSettingsHaveBeenSubmitted(long frameworkSetId)
        {
            return formPromptService.GetStudentGrowthProcessSettingsHaveBeenSubmitted(frameworkSetId);
        }

        private readonly StudentGrowthFormPromptService formPromptService = new StudentGrowthFormPromptService();

        [Route("api/sgavailableprompts/")]
        [HttpGet]
        public IEnumerable<StudentGrowthFormPromptModel> GetAvailablePrompts([FromUri] StudentGrowthFormPromptRequestModel requestModel)
        {
            return formPromptService.GetAvailablePrompts(requestModel);
        }

        [Route("api/sgdistrictprompts/")]
        [HttpGet]
        public IEnumerable<StudentGrowthFormPromptFrameworkNodeModel> GetDistrictPrompts([FromUri] StudentGrowthFormPromptRequestModel requestModel)
        {
            return formPromptService.GetDistrictPrompts(requestModel);
        }

        [Route("api/sgactiveprompts/")]
        [HttpGet]
        public IEnumerable<StudentGrowthFormPromptModel> GetActiveFormPrompts([FromUri] StudentGrowthFormPromptRequestModel requestModel)
        {
            return formPromptService.GetActivePrompts(requestModel);
        }

        [Route("api/sgtogglepromptuse/")]
        [HttpPut]
        public void TogglePromptUse(StudentGrowthFormPromptRequestModel requestModel)
        {
            formPromptService.TogglePromptUse(requestModel);
        }

        [Route("api/sgformprompts")]
        [HttpPost]
        public object CreatePrompt(StudentGrowthFormPromptModel formPromptModel)
        {
            return formPromptService.CreatePrompt(formPromptModel);
        }

        [Route("api/sgformprompts/{id}")]
        [HttpDelete]
        public void DeletePrompt(long id)
        {
            formPromptService.DeletePrompt(id);
        }

        [Route("api/sgformprompts")]
        [HttpPut]
        public void UpdatePrompt(StudentGrowthFormPromptModel formPromptModel)
        {
            formPromptService.UpdatePrompt(formPromptModel);
        }

  
    }
}
