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
    public class ArtifactBundleService : BaseService
    {
        public IEnumerable<StudentGrowthGoalBundleModel> GetAttachableStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            IQueryable<SEStudentGrowthGoalBundle> bundles = EvalEntities.SEStudentGrowthGoalBundles
                    .Where(x => x.EvaluationID == evaluationId ||
                              x.WfStateID >= (short)SEWfStateEnum.GOAL_BUNDLE_PROCESS_SUBMITTED);

            return bundles.ToList().Select(x => x.MaptoStudentGrowthGoalBundleModel());
        }

        public IEnumerable<EvalSessionModel> GetAttachableObservationsForEvaluation(long evaluationId)
        {
            IQueryable<SEEvalSession> observations = EvalEntities.SEEvalSessions
                    .Where(x => x.EvaluationID == evaluationId ||
                              x.WfStateID == (short)SEWfStateEnum.OBS_IN_PROGRESS_TOR);

            return observations.ToList().Select(x => x.MaptoEvalSessionModel());
        }

        public IEnumerable<ArtifactBundleModel> GetArtifactBundlesForEvaluation(ArtifactBundleRequestModel bundleRequestModel)
        {
            IQueryable<SEArtifactBundle> bundles = EvalEntities.SEArtifactBundles
                .Where(x=>x.EvaluationID==bundleRequestModel.EvaluationId);

            // Can never see artifacts owned by someone else that are not yet submitted 
            bundles = bundles.Where(x => x.CreatedByUserID == bundleRequestModel.CurrentUserId ||
                             x.WfStateID > (short)SEWfStateEnum.ARTIFACT);

            if (bundleRequestModel.WfState!=(short)SEWfStateEnum.UNDEFINED)
            {
                bundles = bundles.Where(x=>x.WfStateID == bundleRequestModel.WfState);
            }

            if (bundleRequestModel.CreatedByUserId!=0) 
            {
                bundles = bundles.Where(x=>x.CreatedByUserID==bundleRequestModel.CreatedByUserId);
            }

            if (bundleRequestModel.RubricRowId != 0)
            {
                bundles = bundles.Where(x => x.SERubricRows.Select(y => y.RubricRowID).Contains(bundleRequestModel.RubricRowId));
            }

            return bundles.ToList().Select(x => x.MaptoArtifactBundleModel());
        }

        public IEnumerable<ArtifactBundleModel> GetArtifactBundlesForEvaluation(long evaluationId, short wfState)
        {
            IQueryable<SEArtifactBundle> bundles = EvalEntities.SEArtifactBundles.Where(
                x => x.EvaluationID == evaluationId && (x.WfStateID == wfState || wfState == 0));
            return bundles.ToList().Select(x => x.MaptoArtifactBundleModel());
        }

        public ArtifactBundleModel GetArtifactBundleById(long id)
        {
            SEArtifactBundle artifactBundle =
                EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == id);
            if (artifactBundle != null)
            {
                return artifactBundle.MaptoArtifactBundleModel();
            }

            return null;
        }

        public void UpdateArtifactBundle(ArtifactBundleModel artifactBundleModel)
        {
            SEArtifactBundle seArtifactBundle =
                EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == artifactBundleModel.Id);

            if (seArtifactBundle != null)
            {
                artifactBundleModel.MaptoSEArtifactBundle(this.EvalEntities, seArtifactBundle);
            }

            EvalEntities.SaveChanges();

        }

        public void SubmitArtifactBundle(ArtifactBundleModel artifactBundleModel)
        {
            SEArtifactBundle seArtifactBundle = null;
            artifactBundleModel.WfState = Convert.ToInt64(SEWfStateEnum.ARTIFACT_SUBMITTED);

            if (artifactBundleModel.Id == 0)
            {
                object retval = CreateArtifactBundle(artifactBundleModel);
                PropertyInfo p = retval.GetType().GetProperty("Id");
                long id = Convert.ToInt64(p.GetValue(retval));
                seArtifactBundle = EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == id);
            }
            else 
            {
                seArtifactBundle = EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == artifactBundleModel.Id);
                artifactBundleModel.MaptoSEArtifactBundle(this.EvalEntities, seArtifactBundle);
            }

            if (seArtifactBundle != null)
            { 
                SEEvaluation seEval = EvalEntities.SEEvaluations.FirstOrDefault(x => x.EvaluationID == artifactBundleModel.EvaluationId);
                if (seEval.EvaluatorID != null)
                {
                    new EventService().SaveArtifactSubmittedEvent(artifactBundleModel, Convert.ToInt64(seEval.EvaluatorID), seEval.EvaluateeID);
                }
            }
        
            EvalEntities.SaveChanges();
        }
         

        public object CreateArtifactBundle(ArtifactBundleModel artifactBundleModel)
        {
            SEArtifactBundle seArtifactBundle = new SEArtifactBundle();
            artifactBundleModel.MaptoSEArtifactBundle(this.EvalEntities, seArtifactBundle);
            seArtifactBundle.CreationDateTime = DateTime.Now;
            EvalEntities.SEArtifactBundles.Add(seArtifactBundle);

            using (TransactionScope transaction = new TransactionScope())
            {
                SEEvaluation seEvaluation = EvalEntities.SEEvaluations
                    .FirstOrDefault(x=>x.EvaluationID==artifactBundleModel.EvaluationId);

                int count = EvalEntities.SEArtifactBundles
                    .Where(x => x.EvaluationID == artifactBundleModel.EvaluationId).Count();

                seArtifactBundle.ShortName = "Artifact " + Convert.ToString(seEvaluation.SchoolYear - 1) + "-" + Convert.ToString(seEvaluation.SchoolYear) + "." + Convert.ToString(count + 1);
                seArtifactBundle.Title = seArtifactBundle.ShortName;

                EvalEntities.SaveChanges();

                transaction.Complete();
            }


            return new { Id = seArtifactBundle.ArtifactBundleID };
        }

        public ArtifactBundleRejectionModel UpdateArtifactBundleRejection(ArtifactBundleRejectionModel artifactBundleRejectionModel)
        {
            SEArtifactBundleRejection seArtifactBundleRejection =
                EvalEntities.SEArtifactBundleRejections.FirstOrDefault(x => x.ArtifactBundleRejectionID == artifactBundleRejectionModel.Id);

            if (seArtifactBundleRejection != null)
            {
                artifactBundleRejectionModel.MaptoSEArtifactBundleRejection(this.EvalEntities, seArtifactBundleRejection);
            }

            EvalEntities.SaveChanges();
            return GetArtifactBundleRejectionById(artifactBundleRejectionModel.Id);
        }

        public ArtifactBundleRejectionModel RejectArtifactBundle(ArtifactBundleRejectionModel rejectionModel)
        {
            var artifactBundle = EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == rejectionModel.ArtifactBundleId);
            if (artifactBundle != null)
            {
                if (artifactBundle.SEArtifactBundleRejections.Count > 0)
                {
                    var seRejection = artifactBundle.SEArtifactBundleRejections.First();
                    rejectionModel.CommunicationSessionKey = seRejection.CommunicationSessionKey;
                }
                else
                {
                    rejectionModel.CommunicationSessionKey = Guid.NewGuid();
                }
                artifactBundle.WfStateID = Convert.ToInt64(SEWfStateEnum.ARTIFACT_REJECTED);
                artifactBundle.RejectionTypeID = rejectionModel.RejectionType;
                

                SEArtifactBundleRejection seArtifactBundleRejection = rejectionModel.MaptoSEArtifactBundleRejection(EvalEntities);

                EvalEntities.SEArtifactBundleRejections.Add(seArtifactBundleRejection);

                SEEvaluation seEval = EvalEntities.SEEvaluations.FirstOrDefault(x => x.EvaluationID == artifactBundle.ArtifactBundleID);
                if (seEval.EvaluatorID != null)
                {
                    new EventService().SaveArtifactRejectedEvent(artifactBundle.ArtifactBundleID, artifactBundle.Title, Convert.ToInt64(seEval.EvaluatorID), seEval.EvaluateeID);
                }

                EvalEntities.SaveChanges();

                return GetArtifactBundleRejectionById(seArtifactBundleRejection.ArtifactBundleRejectionID);
            }

            return null;
        }

        public ArtifactBundleRejectionModel GetArtifactBundleRejectionByArtifactBundleId(long id)
        {
            SEArtifactBundleRejection artifactBundleRejection =
                EvalEntities.SEArtifactBundleRejections.FirstOrDefault(x => x.ArtifactBundleID == id);
            if (artifactBundleRejection != null)
            {
                return artifactBundleRejection.MaptoArtifactBundleRejectionModel(EvalEntities);
            }

            return null;
        }

        public ArtifactBundleRejectionModel GetArtifactBundleRejectionById(long id)
        {
            SEArtifactBundleRejection artifactBundleRejection =
                EvalEntities.SEArtifactBundleRejections.FirstOrDefault(x => x.ArtifactBundleRejectionID == id);
            if (artifactBundleRejection != null)
            {
                return artifactBundleRejection.MaptoArtifactBundleRejectionModel(EvalEntities);
            }

            return null;
        }

        public List<EvalSessionModel> GetLinkedObservations(long bundleId)
        {
            var artifactBundle = EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == bundleId);
            if (artifactBundle != null)
            {
                return artifactBundle.SEEvalSessions.Select(x => x.MaptoEvalSessionModel()).ToList();
            }

            return null;
        }

        public List<StudentGrowthGoalBundleModel> GetLinkedStudentGrowthGoalBundles(long bundleId)
        {
            var artifactBundle = EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == bundleId);
            if (artifactBundle != null)
            {
                return artifactBundle.SEStudentGrowthGoalBundles.Select(x => x.MaptoStudentGrowthGoalBundleModel()).ToList();
            }

            return null;
        }


        public void DeleteArtifactBundle(long id)
        {
            SEArtifactBundle artifactBundle =
                EvalEntities.SEArtifactBundles.FirstOrDefault(x => x.ArtifactBundleID == id);

            if (artifactBundle != null)
            {
                artifactBundle.SEArtifactLibItems.ToList().ForEach(rr => artifactBundle.SEArtifactLibItems.Remove(rr));
                artifactBundle.SERubricRows.ToList().ForEach(rr => artifactBundle.SERubricRows.Remove(rr));

                artifactBundle.SEArtifactBundleRejections.ToList().ForEach(rr => artifactBundle.SEArtifactBundleRejections.Remove(rr));
                EvalEntities.SEArtifactBundleRejections.RemoveRange(EvalEntities.SEArtifactBundleRejections.Where(x => x.ArtifactBundleID == id));

                artifactBundle.SEStudentGrowthGoalBundles.Clear();
                artifactBundle.SEEvalSessions.Clear();

                EvalEntities.SEArtifactBundles.Remove(artifactBundle);
                EvalEntities.SaveChanges();
            }
        }
    }
}
