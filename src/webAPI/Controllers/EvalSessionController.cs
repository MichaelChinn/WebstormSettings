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
    public class EvalSessionController : BaseApiController
    {
        private readonly EvalSessionService evalSessionService = new EvalSessionService();

        [Route("api/evalsession/{evalsessionId}")]
        public EvalSessionModel GetEvalSessionById(long evalSessionId)
        {
            EvalSessionModel evalSessionMoodel = evalSessionService.GetEvalSessionById(evalSessionId);
            return evalSessionMoodel;
        }

        [Route("api/observationsforevaluation/{evaluationid}")]
        public List<EvalSessionModel> GetObservationsForEvaluation(long evaluationId)
        {
            return evalSessionService.GetObservationsForEvaluation(evaluationId);
        }

        [Route("api/evalsessionsforschool/{schoolYear}/{schoolCode}")]
        public List<EvalSessionModel> GetEvalSessionForSchool(short schoolYear, string schoolCode)
        {
            var sessions = evalSessionService.GetEvalSessionForSchool(schoolYear, schoolCode);
            return sessions;
        }

        [Route("api/evalsessions")]
        public List<EvalSessionModel> GetEvalSessions([FromUri] EvalSessionRequestModel evalSessionRequestModel)
            //, int evaluateeId, SEEvaluationTypeEnum evaluationType,  string schoolCode, string schoolYear )
        {
            var sessions = evalSessionService.GetEvalSessions(evalSessionRequestModel);
            return sessions;
        }

        [Route("api/evalsession/updateobservenotes")]
        [HttpPost]
        public HttpResponseMessage UpdateEvalSessionObservationNotes(EvalSessionModel evalSessionModel)
        {
            evalSessionService.UpdateEvalSessinNotes(evalSessionModel);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("api/evalsession/saveevalsession")]
        [HttpPost]
        public HttpResponseMessage SaveEvalSession(EvalSessionModel evalSessionModel)
        {
            evalSessionService.SaveEvalSession(evalSessionModel);
            return Request.CreateResponse(new {Id = evalSessionModel.Id});
        }

        [HttpGet]
        [Route("api/evalsession/rubricRowFocuses/{evalSessionId}")]
        public List<RubricRowModel> GetRubricRowFocuses(int evalSessionId)
        {
            return evalSessionService.GetRubricRowFocusList(evalSessionId);
        }

        [HttpPost]
        [Route("api/evalsession/saveRubricRowFocuses")]
        public HttpResponseMessage SaveRubricRowFocuses(EvalSessionModel evalSessionModel)
        {
            evalSessionService.SaveRubricRowFocuses(evalSessionModel);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [HttpGet]
        [Route("api/evalsession/{evalSessionId}/artifactbundles")]
        public IList<ArtifactBundleModel> GetArtifactBundleForEvalSession(int evalSessionId)
        {
            return evalSessionService.GetArtifctBundleModels(evalSessionId);
        }

        [HttpGet]
        [Route("api/artifactbundlesunlinkedObs")]
        public List<ArtifactBundleModel> GetUnlinkedObservationArtifactBundles(int evaluatorId, int evaluateeId)
        {
            var artifactBundles =
                evalSessionService.GetArtifactBundlesUnlinkedObservation(evaluatorId, evaluateeId);
            return artifactBundles;
        }

        [HttpPost]
        [Route("api/evalsession/{evalSessionId}/updatePreConfPromptState")]
        public bool UpdatePreConfPromptState(int evalSessionId, PreConfPromptStateEnum preConfPromptState)
        {
            evalSessionService.UpdatePreConfPromptState(evalSessionId, preConfPromptState);
            return true;
        }
    }
}