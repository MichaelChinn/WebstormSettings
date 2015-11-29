using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.Constants;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class StudentGrowthGoalBundleService : BaseService
    {
        public IEnumerable<ArtifactBundleModel> GetArtifactBundlesForStudentGrowthGoalBundle(long goalBundleId)
        {
            IQueryable<SEArtifactBundle> artifactBundles = EvalEntities.SEArtifactBundles.Where(
                x => x.SEStudentGrowthGoalBundles.Select(y=>y.StudentGrowthGoalBundleID).Contains(goalBundleId));

            return artifactBundles.ToList().Select(x => x.MaptoArtifactBundleModel());
        }

        public IEnumerable<StudentGrowthGoalBundleModel> GetInProgressStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            var bundles = EvalEntities.SEStudentGrowthGoalBundles.Where(
                x => x.EvaluationID == evaluationId &&
                     x.WfStateID == (short)SEWfStateEnum.GOAL_BUNDLE_IN_PROGRESS);

            return bundles.ToList().Select(x => x.MaptoStudentGrowthGoalBundleModel());
        }

        public IEnumerable<StudentGrowthGoalBundleModel> GetSubmittedStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            var bundles = EvalEntities.SEStudentGrowthGoalBundles.Where(
                x => x.EvaluationID == evaluationId &&
                     x.WfStateID >= (short)SEWfStateEnum.GOAL_BUNDLE_PROCESS_SUBMITTED);

            return bundles.ToList().Select(x => x.MaptoStudentGrowthGoalBundleModel());
        }

        public IEnumerable<StudentGrowthGoalBundleModel> GetStudentGrowthGoalBundlesForEvaluation(long evaluationId)
        {
            var bundles = EvalEntities.SEStudentGrowthGoalBundles.Where(
                x => x.EvaluationID == evaluationId);

            return bundles.ToList().Select(x => x.MaptoStudentGrowthGoalBundleModel());
        }

        public StudentGrowthGoalBundleModel GetStudentGrowthGoalBundleById(long id)
        {
            var studentGrowthBundle =
                EvalEntities.SEStudentGrowthGoalBundles.FirstOrDefault(x => x.StudentGrowthGoalBundleID == id);
            if (studentGrowthBundle != null)
            {
                return studentGrowthBundle.MaptoStudentGrowthGoalBundleModel();
            }

            return null;
        }

        public StudentGrowthGoalModel GetStudentGrowthGoalById(long id)
        {
            var studentGrowthGoal =
                EvalEntities.SEStudentGrowthGoals.FirstOrDefault(x => x.StudentGrowthGoalID == id);
            if (studentGrowthGoal != null)
            {
                return studentGrowthGoal.MaptoStudentGrowthGoalModel(studentGrowthGoal.GoalBundleID, "");
            }

            return null;
        }

        public void UpdateStudentGrowthGoal(StudentGrowthGoalModel studentGrowthGoalModel)
        {
            SEStudentGrowthGoal seStudentGrowthGoal =
                EvalEntities.SEStudentGrowthGoals.FirstOrDefault(x => x.StudentGrowthGoalID == studentGrowthGoalModel.Id);

            if (seStudentGrowthGoal != null)
            {
                studentGrowthGoalModel.MaptoSEStudentGrowthGoal(EvalEntities, seStudentGrowthGoal);
            }

            EvalEntities.SaveChanges();
        }


        public void UpdateStudentGrowthGoalBundle(StudentGrowthGoalBundleModel studentGrowthGoalBundleModel)
        {
            SEStudentGrowthGoalBundle seStudentGrowthGoalBundle =
                EvalEntities.SEStudentGrowthGoalBundles.FirstOrDefault(x => x.StudentGrowthGoalBundleID == studentGrowthGoalBundleModel.Id);

            if (seStudentGrowthGoalBundle != null)
            {
                studentGrowthGoalBundleModel.MaptoSEStudentGrowthGoalBundle(EvalEntities, seStudentGrowthGoalBundle);
            }

           
            EvalEntities.SaveChanges();

            UpdateAvailableEvidence(seStudentGrowthGoalBundle);
        }

        void UpdateAvailableEvidence(SEStudentGrowthGoalBundle bundle)
        {
            // TODO: had to move this here because EF was giving an error when saving it out in the mapper
            bundle.SEStudentGrowthGoals.ToList().ForEach(x =>
            {
                SEAvailableEvidence evidence = EvalEntities.SEAvailableEvidences.FirstOrDefault(y => y.StudentGrowthGoalID == x.StudentGrowthGoalID);
                if (evidence == null)
                {
                    if (x.ProcessRubricRowID != 0)
                    {
                        EvalEntities.SEAvailableEvidences.Add(x.MapToAvailableEvidence(x.ProcessRubricRowID));
                    }
                    if (x.ResultsRubricRowID != 0)
                    {
                        EvalEntities.SEAvailableEvidences.Add(x.MapToAvailableEvidence((long)x.ResultsRubricRowID));
                    }
                }
            });

            EvalEntities.SaveChanges();
        }

        public object CreateStudentGrowthGoalBundle(StudentGrowthGoalBundleModel studentGrowthGoalBundleModel)
        {
            SEStudentGrowthGoalBundle seStudentGrowthGoalBundle = studentGrowthGoalBundleModel.MaptoSEStudentGrowthGoalBundle(EvalEntities);
            seStudentGrowthGoalBundle.CreationDateTime = DateTime.Now;
            EvalEntities.SEStudentGrowthGoalBundles.Add(seStudentGrowthGoalBundle);
            EvalEntities.SaveChanges();

            UpdateAvailableEvidence(seStudentGrowthGoalBundle);

            return new { Id = seStudentGrowthGoalBundle.StudentGrowthGoalBundleID };
        }

        public void DeleteStudentGrowthGoalBundle(long id)
        {
            var studentGrowthBundle = EvalEntities.SEStudentGrowthGoalBundles.FirstOrDefault(x => x.StudentGrowthGoalBundleID == id);
            if (studentGrowthBundle != null)
            {
                foreach (SEStudentGrowthGoal g in EvalEntities.SEStudentGrowthGoals.Where(x => x.GoalBundleID == id))
                {
                    EvalEntities.SEStudentGrowthFormPromptResponses.RemoveRange(g.SEStudentGrowthFormPromptResponses);
                }

                EvalEntities.SEStudentGrowthGoals.RemoveRange(EvalEntities.SEStudentGrowthGoals.Where(x => x.GoalBundleID == id));
                EvalEntities.SEStudentGrowthGoalBundles.Remove(studentGrowthBundle);

                studentGrowthBundle.SERubricRows.ToList().ForEach(rr => studentGrowthBundle.SERubricRows.Remove(rr));
                EvalEntities.SERubricRowEvaluations.RemoveRange(EvalEntities.SERubricRowEvaluations.Where(x => x.LinkedStudentGrowthGoalBundleID == id));
                studentGrowthBundle.SERubricRowEvaluations.ToList().ForEach(rr => studentGrowthBundle.SERubricRowEvaluations.Remove(rr));

                EvalEntities.SaveChanges();
            }

        }
    }
}
