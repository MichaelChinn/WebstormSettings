using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEval.Core.Constants;
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Services
{
    public class TrainingProtocolService : BaseService
    {
        public TrainingProtocolModel GetTrainingProtocolById(long id)
        {
            SETrainingProtocol trainingProtocol =
                EvalEntities.SETrainingProtocols.FirstOrDefault(x => x.TrainingProtocolID == id);
            if (trainingProtocol != null)
            {
                return trainingProtocol.MaptoTrainingProtocolModel();
            }

            return null;
        }

        public List<TrainingProtocolModel> GetTrainingProtocols()
        {
            return EvalEntities.SETrainingProtocols.ToList().Select(x => x.MaptoTrainingProtocolModel()).ToList();
        }

        public List<TrainingProtocolLabelGroupModel> GetTrainingProtocolLabelGroups()
        {
            return EvalEntities.SETrainingProtocolLabelGroups.ToList().Select(x => x.MaptoTrainingProtocolLabelGroupModel()).ToList();
        }
    }
}
