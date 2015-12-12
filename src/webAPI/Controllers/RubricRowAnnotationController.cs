using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;


namespace WebAPI.Controllers
{
    public class RubricRowAnnotationController : BaseApiController
    {
        private readonly RubricRowAnnotationService rubricRowAnnotationService = new RubricRowAnnotationService();

        [Route("api/evalsession/{evalSessionId}/{rubricRowId}/rubricrowannotations")]
        public IEnumerable<RubricRowAnnotationModel> GetRubricRowAnnotations(int evalSessionId, int rubricRowId)
        {
            return rubricRowAnnotationService.GetRubricRowAnnotations(evalSessionId, rubricRowId);
        }

        [Route("api/rubricrowannotation/{id}")]
        public RubricRowAnnotationModel GetRubricRowAnnotationById(long id)
        {
            return rubricRowAnnotationService.GetRubricRowAnnotationById(id);
        }

        [Route("api/rubricrowannotation/update")]
        [HttpPut]
        public void UpdateRubricRowEvaluation(RubricRowAnnotationModel rubricRowEvaluationModel)
        {
            rubricRowAnnotationService.SaveRubricRowAnnotation(rubricRowEvaluationModel);
        }

        [Route("api/rubricrowannotation/create")]
        [HttpPost]
        public HttpResponseMessage CreateRubricRowAnnotation(RubricRowAnnotationModel rubricRowAnnotationModel)
        {
            rubricRowAnnotationService.SaveRubricRowAnnotation(rubricRowAnnotationModel);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/rubricrowannotation/delete/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteRubricRowAnnotation(long id)
        {
            rubricRowAnnotationService.DeleteRubricRowAnnotation(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}
