using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using System.Web;
using System.Web.Http.Routing;

using System.Configuration;

using System.Data.SqlClient;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class BaseApiController : ApiController
    {
        
        protected readonly StateEvalEntities entities = new StateEvalEntities();
        public BaseApiController()
        {
        }
    }
}
