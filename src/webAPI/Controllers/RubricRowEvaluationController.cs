using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEval.Core.Constants;
using StateEval.Core.Services;
using StateEvalData;
using webAPI.Models;


namespace WebAPI.Controllers
{
    public class RubricRowEvaluationController : BaseApiController
    {
        private readonly RubricRowEvaluationService rubricRowEvaluationService = new RubricRowEvaluationService();

        [Route("api/rubricrowevaluations/prtr/{schoolYear}/{districtCode}/{schoolCode}/{evaluatorId}/{assignedOnly}")]
        [HttpGet]
        public IEnumerable<RubricRowEvaluationModel> GetRubricRowEvaluationsForPR_TR(short schoolYear, string districtCode, string schoolCode, long evaluatorId, bool assignedOnly)
        {
            return rubricRowEvaluationService.GetRubricRowEvaluationsForPR_TR(schoolYear, districtCode, schoolCode, evaluatorId, assignedOnly);
        }

        [Route("api/{evaluationId}/rubricrowevaluations")]
        public IEnumerable<RubricRowEvaluationModel> GetRubricRowEvaluationsForEvaluation(long evaluationId)
        {
            return rubricRowEvaluationService.GetRubricRowEvaluationsForEvaluation(evaluationId);
        }

        [Route("api/rubricrowevaluationsbyrequest")]
        public IEnumerable<RubricRowEvaluationModel> GetRubricRowEvaluationsForEvaluation([FromUri] RubricRowEvaluationsRequestModel requestModel)
        {
            return rubricRowEvaluationService.GetRubricRowEvaluationsForEvaluation(requestModel);
        }

        [Route("api/rubricrowevaluations/")]
        public RubricRowEvaluationModel GetRubricRowEvaluationById(long id)
        {
            return rubricRowEvaluationService.GetRubricRowEvaluationById(id);
        }

        [Route("api/evalSession/{evalSessionId}/rubricrowevaluationforrubric")]
        public RubricRowEvaluationModel GetRubricRowEvaluationModelForEvalSession(int evalSessionId, int rubricRowId)
        {
            return rubricRowEvaluationService.GetRubricRowEvaluationModelForEvalSession(evalSessionId, rubricRowId);
        }

        [Route("api/{evaluationId}/rubricrowevaluations/")]
        [HttpPut]
        public void UpdateRubricRowEvaluation(RubricRowEvaluationModel rubricRowEvaluationModel)
        {
            rubricRowEvaluationService.UpdateRubricRowEvaluation(rubricRowEvaluationModel);
        }

        [Route("api/{evaluationId}/rubricrowevaluations/")]
        [HttpPost]
        public object CreateRubricRowEvaluation(RubricRowEvaluationModel rubricRowEvaluationModel)
        {
            return rubricRowEvaluationService.CreateRubricRowEvaluation(rubricRowEvaluationModel);
        }

        [Route("api/rubricrowevaluations/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteRubricRowEvaluation(long id)
        {
            rubricRowEvaluationService.DeleteRubricRowEvaluation(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/evalSession/{evalSessionId}/rubricrowevaluations")]
        public List<RubricRowEvaluationModel> GetRubricRowEvaluationsModelForEvalSession(int evalSessionId)
        {
            return rubricRowEvaluationService.GetRubricRowEvaluationsForEvalSession(evalSessionId);
        }

    }
}
