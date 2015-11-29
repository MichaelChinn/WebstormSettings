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
    public class ArtifactLibItemsController : BaseApiController
    {
        private readonly ArtifactLibItemService artifactLibItemService = new ArtifactLibItemService();

        [Route("api/{evaluationId}/libItems")]
        public IEnumerable<ArtifactLibItemModel> GetArtifactLibItemsForEvaluation(long evaluationId)
        {
            return artifactLibItemService.GetArtifactLibItemsForEvaluation(evaluationId);
        }

        [Route("api/{evaluationId}/libItems/{id}")]
        public ArtifactLibItemModel GetArtifactLibItemById(long id)
        {
            return artifactLibItemService.GetArtifactLibItemById(id);
        }        

        [Route("api/{evaluationId}/libItems")]
        [HttpPut]
        public HttpResponseMessage UpdateArtifactLibItem(ArtifactLibItemModel artifactLibItemModel)
        {
            artifactLibItemService.UpdateArtifactLibItem(artifactLibItemModel);
            return Request.CreateResponse(HttpStatusCode.OK);
        }





        [Route("api/{evaluationId}/libItems")]
        [HttpPost]
        public object CreateArtifactLibItem(ArtifactLibItemModel artifactLibItemModel)
        {
            return artifactLibItemService.CreateArtifactLibItem(artifactLibItemModel);            
        }



        [Route("api/artifactLibItems/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteArtifactLibItem(long id)
        {
            artifactLibItemService.DeleteArtifactLibItem(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}