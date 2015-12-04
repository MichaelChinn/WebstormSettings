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
    public class SelfAssessmentService : BaseService
    {
  
        public List<SelfAssessmentModel> GetSelfAssessmentsForEvaluation(SelfAssessmentRequestModel requestModel)
        {
            IQueryable<SESelfAssessment> assessments = EvalEntities.SESelfAssessments
                .Where(x=>x.EvaluationID==requestModel.EvaluationId);

            // Can never see assessments owned by someone else that are not shared 
            assessments = assessments.Where(x => x.EvaluateeID == requestModel.CurrentUserId || x.IsSharedWithEvaluator);

            return assessments.ToList().Select(x => x.MaptoSelfAssessmentModel()).ToList();
        }

        public SelfAssessmentModel GetSelfAssessmentById(long id)
        {
            SESelfAssessment assessment =
                EvalEntities.SESelfAssessments.FirstOrDefault(x => x.SelfAssessmentID == id);
            if (assessment != null)
            {
                return assessment.MaptoSelfAssessmentModel();
            }

            return null;
        }

        public void UpdateSelfAssessment(SelfAssessmentModel assessmentModel)
        {
            SESelfAssessment assessment =
               EvalEntities.SESelfAssessments.FirstOrDefault(x => x.SelfAssessmentID == assessmentModel.Id);
            if (assessment != null)
            {
                assessmentModel.MaptoSESelfAssessment(EvalEntities, assessment);
            }

            EvalEntities.SaveChanges();
        }

        public void ShareSelfAssessment(SelfAssessmentModel assessmentModel)
        {
            SESelfAssessment seAssessment = null;
            assessmentModel.IsSharedWithEvaluator = true;

            SESelfAssessment assessment =
               EvalEntities.SESelfAssessments.FirstOrDefault(x => x.SelfAssessmentID == assessmentModel.Id);
            if (assessment != null)
            {
                assessmentModel.MaptoSESelfAssessment(EvalEntities, assessment);
                SEEvaluation seEvaluation = EvalEntities.SEEvaluations
                        .FirstOrDefault(x => x.EvaluationID == assessmentModel.EvaluationId);

                if (seEvaluation.EvaluatorID != null)
                {
                    new EventService().SelfAssessmentSharedEvent(assessment.SelfAssessmentID, assessment.Title, Convert.ToInt64(seEvaluation.EvaluatorID), seEvaluation.EvaluateeID);

                }
            }
        
            EvalEntities.SaveChanges();
        }
         

        public object CreateSelfAssessment(SelfAssessmentModel selfAssessmentModel)
        {
            SESelfAssessment seSelfAssessment = new SESelfAssessment();
            selfAssessmentModel.MaptoSESelfAssessment(this.EvalEntities, seSelfAssessment);
            seSelfAssessment.CreationDateTime = DateTime.Now;
            EvalEntities.SESelfAssessments.Add(seSelfAssessment);

            using (TransactionScope transaction = new TransactionScope())
            {
                SEEvaluation seEvaluation = EvalEntities.SEEvaluations
                    .FirstOrDefault(x=>x.EvaluationID==selfAssessmentModel.EvaluationId);

                int count = EvalEntities.SESelfAssessments
                    .Where(x => x.EvaluationID == selfAssessmentModel.EvaluationId).Count();

                seSelfAssessment.ShortName = "Self-Assess " + Convert.ToString(seEvaluation.SchoolYear - 1) + "-" + Convert.ToString(seEvaluation.SchoolYear) + "." + Convert.ToString(count + 1);
                seSelfAssessment.Title = seSelfAssessment.ShortName;

                EvalEntities.SaveChanges();

                transaction.Complete();
            }


            return new { Id = seSelfAssessment.SelfAssessmentID };
        }

        public void DeleteSelfAssessment(long id)
        {
             SESelfAssessment assessment =
               EvalEntities.SESelfAssessments.FirstOrDefault(x => x.SelfAssessmentID == id);
            if (assessment != null)
            {
                assessment.SERubricRows.ToList().ForEach(rr => assessment.SERubricRows.Remove(rr));
                EvalEntities.SESelfAssessments.Remove(assessment);
                EvalEntities.SaveChanges();
            }
        }
    }
}
