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
    public class EventController : BaseApiController
    {
        private EventService eventService = new EventService();

        [Route("api/eventtypes")]
        public List<EventTypeModel> GetEventTypes()
        {
            return eventService.GetEventTypes();
        }
    }
}