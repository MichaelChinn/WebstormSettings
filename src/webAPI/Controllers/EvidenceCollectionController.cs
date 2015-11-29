using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web.Http;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEval.Core.RequestModel;
using StateEvalData;

namespace WebAPI.Controllers
{
    public class EvidenceCollectionController : BaseApiController
    {
        private readonly EvidenceCollectionService evidenceCollectionService = new EvidenceCollectionService();

        [Route("api/evidencecollections")]
        public EvidenceCollectionModel GetEvidenceCollection([FromUri] EvidenceCollectionRequestModel collectionRequest)
        {
            return evidenceCollectionService.GetEvidenceCollection(collectionRequest);
        }

        [Route("api/evidencecollections/scorerubricrow")]
        [HttpPut]
        public object ScoreRubricRow(RubricRowScoreModel rubricRowScoreModel)
        {
            return evidenceCollectionService.ScoreRubricRow(rubricRowScoreModel);
        }

        [Route("api/evidencecollections/scoreframeworknode")]
        [HttpPut]
        public object ScoreFrameworkNode(FrameworkNodeScoreModel frameworkNodeScoreModel)
        {
            return evidenceCollectionService.ScoreFrameworkNode(frameworkNodeScoreModel);
        }

        [Route("api/evidencecollections/scoresummativerubricrow")]
        [HttpPut]
        public object ScoreSummativeRubricRow(SummativeRubricRowScoreModel rubricRowScoreModel)
        {
            return evidenceCollectionService.ScoreSummativeRubricRow(rubricRowScoreModel);
        }

        [Route("api/evidencecollections/scoresummativeframeworknode")]
        [HttpPut]
        public object ScoreSummativeFrameworkNode(SummativeFrameworkNodeScoreModel frameworkNodeScoreModel)
        {
            return evidenceCollectionService.ScoreSummativeFrameworkNode(frameworkNodeScoreModel);
        }
    }
}
