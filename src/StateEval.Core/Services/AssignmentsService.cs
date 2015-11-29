using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEval.Core.RequestModel;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class AssignmentsService : BaseService
    {
        public IEnumerable<UserModel> GetPrincipalsForAssignment(SESchoolYearEnum schoolYear, string districtCode)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.aspnet_Users.aspnet_Roles.Any(r => r.RoleName == RoleName.SESchoolPrincipal))
                .Where(u => u.SEUserDistrictSchools.Any(d => d.DistrictCode == districtCode && d.SchoolCode != ""))
                .Where(u => u.SEEvaluations.Any(e => e.EvaluateeID == u.SEUserID
                                && e.SchoolYear == (short)schoolYear
                                && e.EvaluationTypeID == (short)SEEvaluationTypeEnum.PRINCIPAL
                                && e.DistrictCode == districtCode))
                .OrderBy(u => new { u.LastName, u.FirstName });

            return users.ToList().Select(x => x.MapToUserModel(new CoreRequestModel(schoolYear, districtCode, "", SEEvaluationTypeEnum.PRINCIPAL)));
        }

        public IEnumerable<UserModel> GetTeachersForAssignment(SESchoolYearEnum schoolYear, string districtCode, string schoolCode)
        {
            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.aspnet_Users.aspnet_Roles.Any(r => r.RoleName == RoleName.SESchoolTeacher))
                .Where(u => u.SEUserDistrictSchools.Any(d => d.DistrictCode == districtCode && d.SchoolCode == schoolCode))
                .Where(u => u.SEEvaluations.Any(e => e.EvaluateeID == u.SEUserID
                                && e.SchoolYear == (short)schoolYear
                                && e.EvaluationTypeID == (short)SEEvaluationTypeEnum.TEACHER
                                && e.DistrictCode == districtCode))
                .OrderBy(u => new { u.LastName, u.FirstName });

            return users.ToList().Select(x => x.MapToUserModel(new CoreRequestModel(schoolYear, districtCode, "", SEEvaluationTypeEnum.TEACHER)));
        }

        public void AssignEvaluateePlanType(SESchoolYearEnum schoolYear, string districtCode, SEEvaluationTypeEnum evalType, long evaluateeId, 
            SEEvaluateePlanTypeEnum planType, long? focusFrameworkNodeId, long? sgFocusFrameworkNodeId)
        {
            SEEvaluation seEvaluation = EvalEntities.SEEvaluations.FirstOrDefault(
                x => x.DistrictCode == districtCode 
                && x.SchoolYear == (short)schoolYear 
                && x.EvaluationTypeID == (short)evalType 
                && x.EvaluateeID == evaluateeId);

            if (seEvaluation != null)
            {
                seEvaluation.EvaluateePlanTypeID = (short)planType;
                seEvaluation.FocusedFrameworkNodeID = focusFrameworkNodeId;
                seEvaluation.FocusedSGFrameworkNodeID = sgFocusFrameworkNodeId;
                EvalEntities.SaveChanges();
            }
        }

        public void AssignEvaluator(SESchoolYearEnum schoolYear, string districtCode, SEEvaluationTypeEnum evalType, long evaluateeId, long? evaluatorId)
        {
            SEEvaluation seEvaluation = EvalEntities.SEEvaluations.FirstOrDefault(
                x => x.DistrictCode == districtCode
                && x.SchoolYear == (short)schoolYear
                && x.EvaluationTypeID == (short)evalType
                && x.EvaluateeID == evaluateeId);

            if (seEvaluation != null)
            {
                seEvaluation.EvaluatorID = evaluatorId;
                EvalEntities.SaveChanges();
            }
        }

        public void DelegateAssignments(SESchoolYearEnum schoolYear, string districtCode, string schoolCode, bool delegateAssignments)
        {
            SESchoolConfiguration config = EvalEntities.SESchoolConfigurations.FirstOrDefault(
                    x => x.SchoolCode == schoolCode
                    && x.DistrictCode == districtCode);
            if (config != null)
            {
                config.IsPrincipalAssignmentDelegated = delegateAssignments;
                EvalEntities.SaveChanges();
            }
        }

        public bool DistrictDelegatedTeacherAssignmentsForSchool(SESchoolYearEnum schoolYear, string districtCode, string schoolCode)
        {
            SESchoolConfiguration config = EvalEntities.SESchoolConfigurations.FirstOrDefault(
                    x => x.SchoolCode == schoolCode
                    && x.DistrictCode == districtCode);

            return config.IsPrincipalAssignmentDelegated;
        }

        public IEnumerable<EvalAssignmentRequestModel> GetEvalAssignmentRequestsForDTE(short schoolYear, string districtCode, long dteId)
        {
            IQueryable<SEEvalAssignmentRequest> requests = EvalEntities.SEEvalAssignmentRequests.Where(
                    x => x.SchoolYear == schoolYear && x.DistrictCode == districtCode && x.EvaluatorID == dteId);
            return requests.ToList().Select(x => x.MapToEvalAssignmentRequestModel(EvalEntities));
        }

        public IEnumerable<EvalAssignmentRequestModel> GetEvalAssignmentRequestForSchool(short schoolYear, string districtCode, string schoolCode)
        {
            short evalType = Convert.ToInt16(SEEvaluationTypeEnum.TEACHER);

            IQueryable<SEUser> users = EvalEntities.SEUsers
                .Where(u => u.aspnet_Users.aspnet_Roles.Any(r => r.RoleName == RoleName.SESchoolTeacher))
                .Where(u => u.SEUserDistrictSchools.Any(d => d.DistrictCode == districtCode && d.SchoolCode == schoolCode))
                .Where(u => u.SEEvaluations.Any(e => e.EvaluateeID == u.SEUserID
                                                && e.SchoolYear == schoolYear
                                                && e.EvaluationTypeID == evalType
                                                && e.DistrictCode == districtCode));
            
            IQueryable<SEEvalAssignmentRequest> requests = EvalEntities.SEEvalAssignmentRequests
                .Where(x => x.SchoolYear == schoolYear && x.DistrictCode == districtCode && users.Any(u=>u.SEUserID==x.EvaluateeID));

            return requests.ToList().Select(x => x.MapToEvalAssignmentRequestModel(EvalEntities));
        }

        public object CreateEvalAssignmentRequestForDTE(EvalAssignmentRequestModel requestModel)
        {
            SEEvalAssignmentRequest seRequest = new SEEvalAssignmentRequest();
            requestModel.MapToEvalAssignmentRequestModel(seRequest);
            seRequest.RequestTypeID = (short)SEEvalRequestTypeEnum.ASSIGNED_EVALUATOR;
            seRequest.Status = (short)SEEvalRequestStatusEnum.PENDING;

            EvalEntities.SEEvalAssignmentRequests.Add(seRequest);
            EvalEntities.SaveChanges();
            return new { Id = seRequest.EvalAssignmentRequestID };
        }

        public void UpdateEvalAssignmentRequestForDTE(EvalAssignmentRequestModel requestModel)
        {
            SEEvalAssignmentRequest seRequest =
                EvalEntities.SEEvalAssignmentRequests.FirstOrDefault(x => x.EvalAssignmentRequestID == requestModel.Id);

            if (seRequest != null)
            {
                SEEvaluation seEvaluation = EvalEntities.SEEvaluations.FirstOrDefault(
                    x => x.DistrictCode == requestModel.DistrictCode
                        && x.SchoolYear == requestModel.SchoolYear
                        && x.EvaluationTypeID == (short)SEEvaluationTypeEnum.TEACHER
                        && x.EvaluateeID == requestModel.EvaluateeId);

                if (requestModel.EvalRequestStatus == (short)SEEvalRequestStatusEnum.ACCEPTED)
                {
                    if (requestModel.EvalRequestType == (short)SEEvalRequestTypeEnum.ASSIGNED_EVALUATOR)
                    {
                        seEvaluation.EvaluatorID = requestModel.EvaluatorId;
                    }
                    else
                    {
                        if (seEvaluation.EvaluatorID == requestModel.EvaluatorId)
                        {
                            seEvaluation.EvaluatorID = null;
                        }
                    }

                }
                // If they are turning off accepted then we need to clear assignment if necessary
                if (requestModel.EvalRequestStatus == (short)SEEvalRequestStatusEnum.REJECTED ||
                    requestModel.EvalRequestStatus == (short)SEEvalRequestStatusEnum.PENDING)
                {
                    if (seEvaluation.EvaluatorID == requestModel.EvaluatorId)
                    {
                        seEvaluation.EvaluatorID = null;
                    }

                }

                requestModel.MapToEvalAssignmentRequestModel(seRequest);
                EvalEntities.SaveChanges();
            }
        }

        public void DeleteAssignmentRequestForDTE(long id)
        {
            SEEvalAssignmentRequest seRequest =
                EvalEntities.SEEvalAssignmentRequests.FirstOrDefault(x => x.EvalAssignmentRequestID == id);

            if (seRequest != null)
            {
                if (seRequest.Status == (short)SEEvalRequestStatusEnum.ACCEPTED && 
                    seRequest.RequestTypeID == (short)SEEvalRequestTypeEnum.ASSIGNED_EVALUATOR)
                {
                    SEEvaluation seEvaluation = EvalEntities.SEEvaluations.FirstOrDefault(
                        x => x.DistrictCode == seRequest.DistrictCode
                            && x.SchoolYear == seRequest.SchoolYear
                            && x.EvaluationTypeID == (short)SEEvaluationTypeEnum.TEACHER
                            && x.EvaluateeID == seRequest.EvaluateeID
                            && x.EvaluatorID == seRequest.EvaluatorID);

                    if (seEvaluation != null)
                    {
                        seEvaluation.EvaluatorID = null;
                    }
                }
                EvalEntities.SEEvalAssignmentRequests.Remove(seRequest);
                EvalEntities.SaveChanges();
            }
        }
    }
}
