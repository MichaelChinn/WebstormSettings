using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web.Http;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class EvaluationController : BaseApiController
    {
        private readonly EvaluationService evaluationservice = new EvaluationService();

        [Route("api/evaluations/{evaluationId}")]
        public EvaluationModel GetEvaluationById(long evaluationId)
        {
            return evaluationservice.GetEvaluationById(evaluationId);
        }

        [Route("api/evaluations/{userId}/{districtCode}/{schoolYear}/{evalType}")]
        public EvaluationModel GetEvaluationById(long userId, string districtCode, short schoolYear, short evalType)
        {
            return evaluationservice.GetEvaluation(userId, districtCode, schoolYear, evalType);
        }
    }
}