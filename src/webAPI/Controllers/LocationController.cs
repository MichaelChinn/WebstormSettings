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

namespace WebAPI.Controllers
{
    public class LocationController : BaseApiController
    {
        private  readonly LocationService locationService = new LocationService();
        public LocationController()
        {
        }

        [Route("api/schoolsInDistrict/{districtCode}")]
        [HttpGet]
        public IEnumerable<LocationModel> GetSchoolsInDistrict(string districtCode)
        {
            return locationService.GetSchoolsInDistrict(districtCode);
        } 
     
    }
}
