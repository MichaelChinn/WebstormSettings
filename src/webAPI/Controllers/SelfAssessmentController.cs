using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Microsoft.Ajax.Utilities;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEvalData;
using  StateEval.Core.Services;

namespace WebAPI.Controllers
{
    public class SelfAssessmentController : BaseApiController
    {
        private readonly SelfAssessmentService selfAssessmentService = new SelfAssessmentService();

        [Route("api/selfassessments/{id}")]
        public SelfAssessmentModel GetSelfAssessmentById(long id)
        {
            return selfAssessmentService.GetSelfAssessmentById(id);
        }

        [Route("api/selfassessments")]
        public List<SelfAssessmentModel> GetSelfAssessmentsForEvaluation([FromUri] SelfAssessmentRequestModel requestModel)
        {
            return selfAssessmentService.GetSelfAssessmentsForEvaluation(requestModel);
        }

        [Route("api/selfassessments")]
        [HttpPut]
        public void UpdateArtifactBundle(SelfAssessmentModel selfAssessmentModel)
        {
            selfAssessmentService.UpdateSelfAssessment(selfAssessmentModel);
        }

        [Route("api/selfassessments")]
        [HttpPost]
        public object CreateSelfAssessment(SelfAssessmentModel selfAssessmentModel)
        {
            return selfAssessmentService.CreateSelfAssessment(selfAssessmentModel);
        }

        [Route("api/selfassessments/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteSelfAssessment(long id)
        {
            selfAssessmentService.DeleteSelfAssessment(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }  
    }
}