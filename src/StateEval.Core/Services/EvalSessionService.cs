using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNet.Identity;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Services
{
    public class EvalSessionService : BaseService
    {
        public List<EvalSessionModel> GetObservationsForEvaluation(long evaluationId)
        {
            IQueryable<SEEvalSession> sessions = EvalEntities.SEEvalSessions.Where(
                x => x.EvaluationID == evaluationId);
            return sessions.ToList().Select(x => x.MaptoEvalSessionModel(EvalEntities)).ToList();
        }

        public EvalSessionModel GetEvalSessionById(long evalSessionId)
        {
            SEEvalSession seEvalSession = EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionId);
            return seEvalSession == null ? null : seEvalSession.MaptoEvalSessionModel(EvalEntities);
        }

        public List<EvalSessionModel> GetEvalSessionForSchool(short schoolYear, string schoolCode)
        {
            var seEvalSessions = EvalEntities.SEEvalSessions
                .Where(x => x.SchoolYear == schoolYear
                            && x.SchoolCode==schoolCode).ToList().Select(x => x.MaptoEvalSessionModel(EvalEntities)).ToList();

            return seEvalSessions;
        }

        public List<EvalSessionModel> GetEvalSessions(EvalSessionRequestModel evalSessionRequestModel)
        {
            List<EvalSessionModel> evalSessions = new List<EvalSessionModel>();

            if (evalSessionRequestModel.IsEvaluator)
            {
                evalSessions = EvalEntities.SEEvalSessions
                    .Where(x => x.EvaluatorUserID == evalSessionRequestModel.EvaluatorId
                                && x.EvaluateeUserID == evalSessionRequestModel.EvaluateeId
                                && x.EvaluationTypeID == (short) evalSessionRequestModel.EvaluationType
                                && x.EvaluationID == evalSessionRequestModel.EvaluationId
                                && x.EvaluationScoreTypeID == 1)
                    .ToList()
                    .Select(x => x.MaptoEvalSessionModel(EvalEntities))
                    .ToList();
            }
            else
            {
                evalSessions = EvalEntities.SEEvalSessions
                    .Where(x => x.EvaluateeUserID == evalSessionRequestModel.EvaluateeId
                                && x.EvaluationTypeID == (short) evalSessionRequestModel.EvaluationType
                        ///&& x.EvaluationID == evalSessionRequestModel.EvaluationId
                                && x.EvaluationScoreTypeID == 1)
                    .ToList()
                    .Select(x => x.MaptoEvalSessionModel(EvalEntities))
                    .ToList();
            }

            return evalSessions;
        }

        public void UpdateEvalSessinNotes(EvalSessionModel evalSessionModel)
        {
            SEEvalSession seEvalSession =
            EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionModel.Id);

            if (seEvalSession != null)
            {
                if (!string.IsNullOrEmpty(evalSessionModel.ObserveNotes))
                {
                    seEvalSession.ObserveNotes = evalSessionModel.ObserveNotes;
                }
                else if (!string.IsNullOrEmpty(evalSessionModel.EvaluatorPreConNotes))
                {
                    seEvalSession.EvaluatorPreConNotes = evalSessionModel.EvaluatorPreConNotes;
                }
                else if (!string.IsNullOrEmpty(evalSessionModel.EvaluateePreConNotes))
                {
                    seEvalSession.EvaluateePreConNotes = evalSessionModel.EvaluateePreConNotes;
                }
            }

            EvalEntities.SaveChanges();
        }

        public long SaveEvalSession(EvalSessionModel evalSessionModel)
        {
            SEEvalSession seEvalSession =
                EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionModel.Id);

            seEvalSession = evalSessionModel.MaptoSEEvalSession(seEvalSession);

            if (seEvalSession.EvalSessionID == 0)
            {
                seEvalSession.EvaluationScoreTypeID = 1;
                seEvalSession.CreationDateTime = DateTime.Now;
                EvalEntities.SEEvalSessions.Add(seEvalSession);
            }
            
            using (TransactionScope transaction = new TransactionScope())
            {
                SEEvaluation seEvaluation = EvalEntities.SEEvaluations
                    .FirstOrDefault(x => x.EvaluationID == evalSessionModel.EvaluationId);

                int count = EvalEntities.SEEvalSessions
                    .Where(x => x.EvaluationID == evalSessionModel.EvaluationId).Count();

                seEvalSession.ShortName = "Obs " + Convert.ToString(seEvaluation.SchoolYear - 1) + "-" + Convert.ToString(seEvaluation.SchoolYear) + "." + Convert.ToString(count + 1);
                if (seEvalSession.Title == "")
                {
                    seEvalSession.Title = seEvalSession.ShortName;
                }

                EvalEntities.SaveChanges();

                transaction.Complete();
            }

            if (evalSessionModel.Id == 0)
            {
                evalSessionModel.Id = seEvalSession.EvalSessionID;
                new EventService().SaveObservationCreatedEvent(evalSessionModel);
            }

            return seEvalSession.EvalSessionID;
        }

        public List<RubricRowModel> GetRubricRowFocusList(int evalSessionId)
        {
            var evalSession = EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionId);
            if (evalSession != null)
            {
                return evalSession.SERubricRows.Select(x => x.MaptoRubricRowModel(0, null)).ToList();
            }

            return null;
        }

        public void SaveRubricRowFocuses(EvalSessionModel evalSessionModel)
        {
            var evalSession = EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionModel.Id);

            if (evalSession != null)
            {
                evalSession.SERubricRows = new List<SERubricRow>();
                foreach (var rubricRow in evalSessionModel.RubricRows)
                {
                    if (evalSession.SERubricRows.All(x => x.RubricRowID != rubricRow.Id))
                    {
                        var rubricRowDb = EvalEntities.SERubricRows.FirstOrDefault(x => x.RubricRowID == rubricRow.Id);

                        evalSession.SERubricRows.Add(rubricRowDb);
                    }
                }
            }

            EvalEntities.SaveChanges();
        }

        public IList<ArtifactBundleModel> GetArtifctBundleModels(int evalSessionId)
        {
            var evalSession = EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionId);
            if (evalSession != null)
            {
                return evalSession.SEArtifactBundles.Select(x => x.MaptoArtifactBundleModel(EvalEntities)).ToList();
            }
            return null;
        }

        public List<ArtifactBundleModel> GetArtifactBundlesUnlinkedObservation(long evaluatorId, long evaluateeId)
        {
            return new List<ArtifactBundleModel>();
            /* TODO: this doesn't compile because artfacts can now be linked to mutliple items, but this
             * functionality is going to be removed since will no longer have unlinked evidence tab
            var artifactBundles =
                EvalEntities.SEArtifactBundles.Where(
                    x =>
                        x.EvalSessionID == null &&
                        x.ArtifactTypeID == (short)SEArtifactTypeEnum.OBSERVATION &&
                        (x.CreatedByUserID == evaluatorId || x.CreatedByUserID == evaluateeId) &&
                        x.WfStateID == (short)SEWfStateEnum.ARTIFACT_SUBMITTED);
            return artifactBundles.ToList().Select(x => x.MaptoArtifactBundleModel()).ToList();
             */
        }

        public void UpdatePreConfPromptState(int evalSessionId, PreConfPromptStateEnum preCOnfPrompState)
        {
            var evalSession = EvalEntities.SEEvalSessions.FirstOrDefault(x => x.EvalSessionID == evalSessionId);
            if (evalSession != null)
            {
                evalSession.PreConfPromptState = (int?) preCOnfPrompState;
            }

            EvalEntities.SaveChanges();
        }
    }
}