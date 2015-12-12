using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEval.Core.RequestModel;
using webAPI.Models;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class ArtifactBundlesController : BaseApiController
    {
        private readonly ArtifactBundleService artifactBundleService = new ArtifactBundleService();

        [Route("api/artifactbundles/reject/")]
        [HttpPut]
        public object RejectArtifactBundle(ArtifactBundleRejectionModel rejectionModel)
        {
            return artifactBundleService.RejectArtifactBundle(rejectionModel);
        }

        [Route("api/artifactbundlesrejections")]
        [HttpPut]
        public void UpdateArtifactBundleRejection(ArtifactBundleRejectionModel artifactBundleRejectionModel)
        {
            artifactBundleService.UpdateArtifactBundleRejection(artifactBundleRejectionModel);
        }

        [Route("api/artifactbundles/submit")]
        [HttpPut]
        public void SubmitArtifactBundle(ArtifactBundleModel artifactBundleModel)
        {
            artifactBundleService.SubmitArtifactBundle(artifactBundleModel);
        }

        [Route("api/artifactbundlerejections/{id}")]
        public ArtifactBundleRejectionModel GetArtifactBundleRejectionByArtifactBundleId(long id)
        {
            return artifactBundleService.GetArtifactBundleRejectionByArtifactBundleId(id);
        }

        [Route("api/{evaluationId}/attachableobservations")]
        public IEnumerable<EvalSessionModel> GetAttachableObservationsForEvaluation(long evaluationId)
        {
            return artifactBundleService.GetAttachableObservationsForEvaluation(evaluationId);
        }

        [Route("api/{evaluationId}/attachablesggoalbundles")]
        public IEnumerable<StudentGrowthGoalBundleModel> GetAttachableStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            return artifactBundleService.GetAttachableStudentGrowthGoalBundlesForEvaluation(evaluationId);
        } 

        [Route("api/artifactbundles")]
        public IEnumerable<ArtifactBundleModel> GetArtifactBundlesForEvaluation([FromUri] ArtifactBundleRequestModel requestModel)
        {
            return artifactBundleService.GetArtifactBundlesForEvaluation(requestModel);
        } 

        [Route("api/artifactbundles/{id}")]
        public ArtifactBundleModel GetArtifactBundleById(long id)
        {
            return artifactBundleService.GetArtifactBundleById(id);
        }

        [Route("api/{evaluationId}/artifactbundles")]
        [HttpPut]
        public void UpdateArtifactBundle(ArtifactBundleModel artifactBundleModel)
        {
            artifactBundleService.UpdateArtifactBundle(artifactBundleModel);
        }

        [Route("api/{evaluationId}/artifactbundles")]
        [HttpPost]
        public object CreateArtifactBundle(ArtifactBundleModel artifactBundleModel)
        {
            return artifactBundleService.CreateArtifactBundle(artifactBundleModel);
        }

        [Route("api/artifactbundles/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteArtifactBundle(long id)
        {
            artifactBundleService.DeleteArtifactBundle(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }  
    }
}