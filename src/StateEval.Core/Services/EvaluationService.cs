using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNet.Identity;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class EvaluationService : BaseService
    {
        public EvaluationModel GetEvaluationById(long evaluationId)
        {
            SEEvaluation seEvaluation = EvalEntities.SEEvaluations.FirstOrDefault(x => x.EvaluationID == evaluationId);
            return seEvaluation.MapToEvaluationModel();
        }

        public EvaluationModel GetEvaluation(long userId, string districtCode, short schoolYear, short evalType)
        {
            SEEvaluation seEvaluation = EvalEntities.SEEvaluations.FirstOrDefault(x => x.DistrictCode == districtCode && x.SchoolYear == schoolYear && x.EvaluationTypeID == evalType && x.EvaluateeID == userId);
            return seEvaluation.MapToEvaluationModel();
        }

        public IEnumerable<EvaluationModel> GetEvaluationsForUser(long seUserId)
        {
            var evaluations = EvalEntities.SEEvaluations.Where(e=>e.EvaluateeID==seUserId);

            return evaluations.ToList().Select(x => x.MapToEvaluationModel());
        }

    }
}