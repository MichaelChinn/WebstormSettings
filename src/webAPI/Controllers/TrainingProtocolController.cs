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
    public class TrainingProtocolController : BaseApiController
    {
        private readonly TrainingProtocolService trainingProtocolService = new TrainingProtocolService();

        [Route("api/trainingprotocols")]
        [HttpGet]
        public List<TrainingProtocolModel> GetTrainingProtocols()
        {
            return trainingProtocolService.GetTrainingProtocols();
        }


        [Route("api/trainingprotocollabelgroups")]
        [HttpGet]
        public List<TrainingProtocolLabelGroupModel> GetTrainingProtocolLabelGroups()
        {
            return trainingProtocolService.GetTrainingProtocolLabelGroups();
        }

        [Route("api/trainingprotocols/{id}")]
        [HttpGet]
        public TrainingProtocolModel GetTrainingProtocolById(long id)
        {
            return trainingProtocolService.GetTrainingProtocolById(id);
        }
    }
}