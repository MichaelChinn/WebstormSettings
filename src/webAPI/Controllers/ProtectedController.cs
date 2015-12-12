using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Claims;
using System.Web.Http;


namespace webAPI.Controllers
{
    [Authorize]
    [RoutePrefix("api/protected")]
    public class ProtectedController : ApiController
    {
        [Route("")]
        public IEnumerable<object> Get()
        {
            List<string> foo = new List<string>() { "hello", "there", "everyone" };
            return foo;
        }
    }
}
