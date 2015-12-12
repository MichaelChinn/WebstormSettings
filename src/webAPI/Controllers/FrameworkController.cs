using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Configuration;

using System.Data.SqlClient;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using StateEval.Core.Services;
using System.Net.Http;
using System.Web.Http;
using System.Net;
using System.Web.Http.Routing;

using StateEvalData;
using StateEval.Core.Mapper;
using StateEval.Core.RequestModel;
using webAPI.Models;

namespace WebAPI.Controllers
{
    public class FrameworkController : BaseApiController
    {
        private FrameworkService frameworkService = new FrameworkService();
        public FrameworkController()
        {
        }

        [Route("api/loadframeworkcontext/{districtCode}/{protoId}")]
        [HttpPut]
        public FrameworkContextModel LoadFrameworkContext([FromUri] string districtCode, long protoId)
        {
            return frameworkService.LoadFrameworkContext(districtCode, protoId);
        }

        [Route("api/loadedframeworkcontexts/{districtCode}")]
        [HttpGet]
        public List<FrameworkContextModel> GetLoadedFrameworkContexts(string districtCode)
        {
            return frameworkService.GetLoadedFrameworkContexts(districtCode);
        }

        [Route("api/protoframeworkcontexts")]
        [HttpGet]
        public List<PrototypeFrameworkContextModel> GetPrototypeFrameworkContexts()
        {
            return frameworkService.GetPrototypeFrameworkContexts();
        }

        [Route("api/frameworkcontexts")]
        [HttpGet]
        public FrameworkContextModel GetFrameworkContext([FromUri] CoreRequestModel requestModel)
        {
            return frameworkService.GetFrameworkContext(requestModel.SchoolYear, requestModel.DistrictCode, requestModel.EvaluationType);
        }
        [Route("api/frameworkcontexts")]
        [HttpPut]
        public void UpdateFrameworkContext(FrameworkContextUpdateRequestModel requestModel)
        {
            frameworkService.UpdateFrameworkContext(requestModel.FrameworkContextId, requestModel.FrameworkViewType, requestModel.IsActive);
        }

    }
}
