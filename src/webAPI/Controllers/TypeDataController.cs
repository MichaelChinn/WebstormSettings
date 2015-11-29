using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using StateEval.Core.Models;
using StateEval.Core.Services;
using WebAPI.Controllers;

namespace webAPI.Controllers
{
    public class TypeDataController:BaseApiController
    {
        TypeDataService typeDataService = new TypeDataService();

        [Route("api/typedata/emaildeliverytypes")]
        public List<EmailDeliveryTypeModel> GetEmailDeliveryTypes()
        {
            return typeDataService.GetEmailDeliveryTypes();
        }
    }
}