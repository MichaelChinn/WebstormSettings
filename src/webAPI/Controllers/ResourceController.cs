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
    public class ResourceController : BaseApiController
    {
        private readonly ResourceService resourceService = new ResourceService();



        [Route("api/resources/{id}")]
        public ResourceModel GetResourceById(long id)
        {
            return resourceService.GetResourceFromServiceById(id);
        }


        [Route("api/resources/school/{schoolCode}")]
        public IEnumerable<ResourceModel> GetResourceBySchool(string schoolCode)
        {
            return resourceService.GetResourceFromServiceBySchool(schoolCode);
        }

        [Route("api/resources/district/{districtCode}")]
        public IEnumerable<ResourceModel> GetResourceByDistrict(string districtCode)
        {
            return resourceService.GetResourceFromServiceByDistrict(districtCode);

        }

        [Route("api/resources/districtOnly/{districtCode}")]
        public IEnumerable<ResourceModel> GetResourcesForDistrictAdmin(string districtCode)
        {
            return resourceService.GetResourcesForDistrictAdmin(districtCode);
        }


        [Route("api/resources/new")]
        [HttpPost]
        public HttpResponseMessage CreateResource(ResourceModel resourceModel)
        {
            resourceService.CreateResource(resourceModel);
            return Request.CreateResponse(HttpStatusCode.OK);
        
        }

        [Route("api/resources/save")]
        [HttpPut]
        public void saveResource(ResourceModel resourceModel)
        {
            resourceService.saveResource(resourceModel);
        }

        [Route("api/resources/delete/{id}")]
        [HttpDelete]
        public HttpResponseMessage DeleteResource(long id) {
            resourceService.deleteResource(id);
            return Request.CreateResponse(HttpStatusCode.OK);

        }

    }
    
}