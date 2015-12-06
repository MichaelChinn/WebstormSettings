using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNet.Identity;
using StateEval.Core.Constants;
using StateEval.Core.Mapper;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Services
{
    public class UserPromptService : BaseService
    {
        public List<UserPromptModel> GetEvaluatorDefinedQuestionBankUserPrompts(SESchoolYearEnum schoolYear, string districtCode,
               string schoolCode, SEEvaluationTypeEnum evalType, SEUserPromptTypeEnum promptType, SEWfStateEnum wfState, long createdByUserId)
        {
            var districtPrompts =
                EvalEntities.SEUserPrompts.Where(
                    x =>
                        x.DistrictCode == districtCode &&
                        ((schoolCode == null) || (x.SchoolCode == schoolCode)) &&
                        x.SchoolYear == (short)schoolYear &&
                        x.EvaluationTypeID == (short)evalType &&
                        x.PromptTypeID == (short)promptType &&
                        x.WfStateID == (long)wfState &&
                        !x.CreatedAsAdmin &&
                        x.CreatedByUserID == createdByUserId &&
                        !x.Private);

            return districtPrompts.ToList().Select(x => x.MapToUserPromptModel()).ToList();
        }

        public List<UserPromptModel> GetSchoolAdminDefinedQuestionBankUserPrompts(SESchoolYearEnum schoolYear, string districtCode,
                string schoolCode, SEEvaluationTypeEnum evalType, SEUserPromptTypeEnum promptType, SEWfStateEnum wfState)
        {
            var districtPrompts =
                EvalEntities.SEUserPrompts.Where(
                    x =>
                        x.DistrictCode == districtCode && 
                        x.SchoolCode == schoolCode &&
                        x.SchoolYear == (short)schoolYear &&
                        x.CreatedAsAdmin &&
                        x.EvaluationTypeID == (short)evalType &&
                        x.PromptTypeID == (short)promptType &&
                        x.WfStateID == (long)wfState);

            return districtPrompts.ToList().Select(x => x.MapToUserPromptModel()).ToList();
        }

        public List<UserPromptModel> GetSchoolAdminDefinedQuestionBankUserPromptsForDTE(SESchoolYearEnum schoolYear, string districtCode,
                SEEvaluationTypeEnum evalType, SEUserPromptTypeEnum promptType, SEWfStateEnum wfState, long evaluatorId)
        {
            /*
             * TODO: I need to filter the schoolPrompts to only include those that have the same schoolCode as the schoolCodes of the assignedUsers list.
             * 
             * */
            
            UserService userService = new UserService();
            IEnumerable<UserModel> assignedUsers = userService.GetObserveEvaluateesForDTEEvaluator((short)schoolYear, districtCode, evaluatorId);
            
            var schoolCodes = new List<string>();

            foreach (var assignedUser in assignedUsers)
            {
                List<UserLocationRoleModel> locations = assignedUser.LocationRoles.Where(x=>x.SchoolCode!="").ToList();
                schoolCodes.AddRange(locations.Select(x => x.SchoolCode));
            }
            
            var schoolPrompts =
                EvalEntities.SEUserPrompts
                    .Where(x =>
                        x.DistrictCode == districtCode &&
                        x.SchoolCode != "" && schoolCodes.Any(y => y == x.SchoolCode)
                            //TODO: this needs to filter from assignedUsers list above
                        && x.SchoolYear == (short) schoolYear &&
                        x.CreatedAsAdmin &&
                        x.EvaluationTypeID == (short) evalType &&
                        x.PromptTypeID == (short) promptType &&
                        x.WfStateID == (long) wfState);


            return schoolPrompts.ToList().Select(x => x.MapToUserPromptModel()).ToList();
        }


        public List<UserPromptModel> GetDistrictAdminDefinedQuestionBankUserPrompts(SESchoolYearEnum schoolYear, string districtCode, 
            SEEvaluationTypeEnum evalType, SEUserPromptTypeEnum promptType, SEWfStateEnum wfState)
        {
            var districtPrompts =
                EvalEntities.SEUserPrompts.Where(
                    x =>
                        x.DistrictCode == districtCode && string.IsNullOrEmpty(x.SchoolCode) &&
                        x.SchoolYear == (short)schoolYear && 
                        x.CreatedAsAdmin &&
                        x.EvaluationTypeID==(short)evalType &&
                        x.PromptTypeID == (short)promptType &&
                        x.WfStateID == (long)wfState);

            return districtPrompts.ToList().Select(x => x.MapToUserPromptModel()).ToList();
        }

        public List<UserPromptModel> GetQuestionBankUserPrompts(SESchoolYearEnum schoolYear, string districtCode,
            string schoolCode, long createdByUserId, SEEvaluationTypeEnum evalType,
            SEUserPromptTypeEnum promptType, string roleName)
        {
            var userPrompts = new List<SEUserPrompt>();

            var districtPrompts =
                EvalEntities.SEUserPrompts.Where(
                    x =>
                        x.DistrictCode == districtCode && string.IsNullOrEmpty(x.SchoolCode) &&
                        x.SchoolYear == (short)schoolYear &&
                        (roleName == RoleName.SEDistrictAdmin || (x.WfStateID == (long)SEWfStateEnum.USERPROMPT_FINALIZED && x.Retired)) && x.CreatedAsAdmin &&
                        x.PromptTypeID == (short)promptType);


            userPrompts.AddRange(districtPrompts);

            if (roleName == RoleName.SESchoolAdmin || roleName == RoleName.SESchoolPrincipal)
            {
                var saDefinedPrompts =
                    EvalEntities.SEUserPrompts.Where(
                        x =>
                            x.DistrictCode == districtCode && !string.IsNullOrEmpty(x.SchoolCode) &&
                            x.SchoolCode == schoolCode && x.SchoolYear == (short)schoolYear &&
                            (roleName == RoleName.SESchoolAdmin || (x.WfStateID == (long)SEWfStateEnum.USERPROMPT_FINALIZED && x.Retired))
                            && x.PromptTypeID == (short)promptType && x.CreatedAsAdmin);

                userPrompts.AddRange(saDefinedPrompts);
            }

            //Get Self Defined prompts
            if (roleName == RoleName.SEDistrictEvaluator)
            {
                var districtEvaluatorDefinedPrompts =
                    EvalEntities.SEUserPrompts.Where(
                        x =>
                            x.DistrictCode == districtCode && string.IsNullOrEmpty(x.SchoolCode) &&
                            x.SchoolYear == (short)schoolYear && x.PromptTypeID == (short)promptType &&
                            x.CreatedByUserID == createdByUserId && !x.CreatedAsAdmin && !x.Private);

                userPrompts.AddRange(districtEvaluatorDefinedPrompts);
            }

            else if (roleName == RoleName.SESchoolPrincipal)
            {
                var principalDefinedPrompts =
                    EvalEntities.SEUserPrompts.Where(
                        x =>
                            x.DistrictCode == districtCode && x.SchoolCode == schoolCode &&
                            x.SchoolYear == (short)schoolYear &&
                            x.PromptTypeID == (short)promptType && x.CreatedByUserID == createdByUserId &&
                            x.CreatedAsAdmin && !x.Private);

                userPrompts.AddRange(principalDefinedPrompts);
            }

            //var ownDefinedPrompts = EvalEntities.SEUserPrompts.Where(x => x.CreatedByUserID == createdByUserId);

            //userPrompts.AddRange(ownDefinedPrompts);

            return userPrompts.Select(x => x.MapToUserPromptModel()).ToList();
        }

        public List<UserPromptModel> GetAssignableUserPrompts(SESchoolYearEnum schoolYear,
            string districtCode, string schoolCode, string evaluateeSchoolCode,
            long createdByUserId, SEEvaluationTypeEnum evalType, SEUserPromptTypeEnum promptType, string roleName,
            long? sessionId, long? evaluateeId)
        {

            var userPrompts = new List<SEUserPrompt>();

            var districtPrompts = EvalEntities.SEUserPrompts.Where(x => x.DistrictCode == districtCode
                                                                        && string.IsNullOrEmpty(x.SchoolCode)
                                                                        && x.SchoolYear == (short)schoolYear
                                                                        && x.WfStateID == (long)SEWfStateEnum.USERPROMPT_FINALIZED
                                                                        && !x.Retired
                                                                        && x.CreatedAsAdmin
                                                                        && x.PromptTypeID == (short)promptType
                                                                        && x.EvaluationTypeID == (short)evalType);

            userPrompts.AddRange(districtPrompts);

            if (roleName == RoleName.SESchoolPrincipal)
            {
                var principalPrompts = EvalEntities.SEUserPrompts.Where(x => x.DistrictCode == districtCode
                                                                             &&
                                                                             (!string.IsNullOrEmpty(x.SchoolCode) &&
                                                                              x.SchoolCode == schoolCode)
                                                                             && x.SchoolYear == (short)schoolYear
                                                                             && x.PromptTypeID == (short)promptType
                                                                             && x.CreatedAsAdmin
                                                                             && x.EvaluationTypeID == (short)evalType
                                                                             && x.WfStateID == (long)SEWfStateEnum.USERPROMPT_FINALIZED
                                                                             && !x.Retired);

                userPrompts.AddRange(principalPrompts);
            }


            if (roleName == RoleName.SEDistrictEvaluator)
            {
                var evaluatorPrompts = EvalEntities.SEUserPrompts.Where(x =>
                    x.DistrictCode == districtCode
                    && string.IsNullOrEmpty(x.SchoolCode)
                    && x.SchoolYear == (short)schoolYear
                    && x.PromptTypeID == (short)promptType
                    && x.CreatedByUserID == createdByUserId
                    && x.EvaluationTypeID == (short)evalType
                    && x.WfStateID == (long)SEWfStateEnum.USERPROMPT_FINALIZED
                    && x.Retired
                    && !x.CreatedAsAdmin &&
                    (!x.Private || (x.EvalSessionID != null && x.EvalSessionID == sessionId) ||
                     (evaluateeId != null && x.EvaluateeID == evaluateeId)));

                userPrompts.AddRange(evaluatorPrompts);
            }
            else if (roleName == RoleName.SESchoolPrincipal)
            {
                var principalPprompts2 = EvalEntities.SEUserPrompts
                    .Where(x => x.DistrictCode == districtCode
                                && x.SchoolCode == schoolCode
                                && x.SchoolYear == (short)schoolYear
                                && x.PromptTypeID == (short)promptType
                                && x.CreatedByUserID == createdByUserId
                                && x.EvaluationTypeID == (short)evalType
                                && x.WfStateID == (long)SEWfStateEnum.USERPROMPT_FINALIZED
                                && !x.Retired
                                && !x.CreatedAsAdmin
                                && (!x.Private || (sessionId != null && x.EvalSessionID == sessionId) ||
                                    (evaluateeId != null && x.EvaluateeID == evaluateeId)));

                userPrompts.AddRange(principalPprompts2);
            }


            return userPrompts.Select(x => x.MapToUserPromptModel()).ToList();
        }

        public UserPromptModel GetUserPrompt(int userPromptId)
        {
            var userPrompt = EvalEntities.SEUserPrompts.FirstOrDefault(x => x.UserPromptID == userPromptId);

            if (userPrompt != null)
            {
                return userPrompt.MapToUserPromptModel();
            }

            return null;
        }

        public void DeleteUserPrompt(long id)
        {
            SEUserPrompt userPrompt =
                EvalEntities.SEUserPrompts.FirstOrDefault(x => x.UserPromptID == id);

            if (userPrompt != null)
            {
                userPrompt.SERubricRows.ToList().ForEach(rr => userPrompt.SERubricRows.Remove(rr));
                EvalEntities.SEUserPrompts.Remove(userPrompt);
                EvalEntities.SaveChanges();
            }
        }

        public bool SaveUserPrompt(UserPromptModel userPrompt)
        {
            SEUserPrompt seUserPrompt = userPrompt.UserPromptID == 0 ? null : EvalEntities.SEUserPrompts.FirstOrDefault(x => x.UserPromptID == userPrompt.UserPromptID);

            SEEvalSession evalSession = new SEEvalSession();

            if (seUserPrompt == null)
            {
                seUserPrompt = new SEUserPrompt();
                EvalEntities.SEUserPrompts.Add(seUserPrompt);
            }

            userPrompt.MaptoSEUserPrompt(this.EvalEntities, seUserPrompt);

            EvalEntities.SaveChanges();
            
            return true;
        }

        public void AssignPromptToUser(long? sessionId, SESchoolYearEnum schoolYear, string districtCode, long userId,
            long promptId)
        {
            var response =
                EvalEntities.SEUserPromptResponses.FirstOrDefault(
                    x => x.EvaluateeID == userId && x.UserPromptID == promptId && x.SchoolYear == (short)schoolYear
                         && x.DistrictCode == districtCode &&
                         ((x.EvalSessionID == null && sessionId == null) || x.EvalSessionID == sessionId));

            if (response == null)
            {
                response = new SEUserPromptResponse
                {
                    EvaluateeID = userId,
                    UserPromptID = promptId,
                    SchoolYear = (short)schoolYear,
                    DistrictCode = districtCode,
                    EvalSessionID = sessionId
                };

                EvalEntities.SEUserPromptResponses.Add(response);
                EvalEntities.SaveChanges();
            }
        }

        public void UnAssignpromptToUser(long userId, long promptId, SESchoolYearEnum schoolYear, string districtCode,
            long? promptResponseId)
        {
            if (promptResponseId == null)
            {
                SEUserPromptResponse response = EvalEntities.SEUserPromptResponses.FirstOrDefault
                    (x => x.UserPromptID == promptId
                          && x.EvaluateeID == userId
                          && x.SchoolYear == (short)schoolYear
                          && x.DistrictCode == districtCode);

                if (response != null)
                {
                    promptResponseId = response.UserPromptResponseID;
                }
            }


            if (promptResponseId != null)
            {
                var responseEntries =
                    EvalEntities.SEUserPromptResponseEntries.Where(x => x.UserPromptResponseID == promptResponseId);

                if (responseEntries.Any())
                {
                    EvalEntities.SEUserPromptResponseEntries.RemoveRange(responseEntries);
                }

                var userPromptResponses =
                    EvalEntities.SEUserPromptResponses.Where(x => x.UserPromptResponseID == promptResponseId);

                if (userPromptResponses.Any())
                {
                    EvalEntities.SEUserPromptResponses.RemoveRange(userPromptResponses);
                }

                EvalEntities.SaveChanges();
            }
        }

        public void InsertNewPreConfPrompt(bool addToBank, long? sessionId, SEUserPromptTypeEnum promptType, string prompt,
            SESchoolYearEnum schoolYear, string schoolCode, string districtCode, long createdByUserId, short evaluationTypeId)
        {
            var userPrompt = new SEUserPrompt();
            userPrompt.SchoolYear = (short)schoolYear;
            userPrompt.DistrictCode = districtCode;
            userPrompt.SchoolCode = schoolCode;
            userPrompt.PromptTypeID = (short)promptType;
            userPrompt.EvaluationTypeID = evaluationTypeId;
            userPrompt.CreatedByUserID = createdByUserId;
            userPrompt.Title = "";
            userPrompt.Prompt = prompt;
            userPrompt.WfStateID = (long)SEWfStateEnum.USERPROMPT_FINALIZED;
            userPrompt.PublishedDate = DateTime.Now;

            if (addToBank)
            {
                userPrompt.CreatedAsAdmin = false;
                userPrompt.Retired = false;
                userPrompt.Private = false;
                userPrompt.EvalSessionID = null;
            }

            else if (sessionId == null)
            {
                userPrompt.Retired = false;
                userPrompt.Private = true;
                userPrompt.CreatedAsAdmin = true;
                userPrompt.EvalSessionID = null;
                //userPrompt.EvaluateeID = SiteSettings.Evaluatee.Id
                userPrompt.EvaluateeID = 1;
                EvalEntities.SEUserPrompts.Add(userPrompt);
                EvalEntities.SaveChanges();
                AssignPromptToUser(userPrompt.EvaluateeID, schoolYear, districtCode, createdByUserId, userPrompt.UserPromptID);
            }
            else
            {
                userPrompt.EvalSessionID = sessionId;
                userPrompt.Retired = false;
                userPrompt.Private = true;
                userPrompt.CreatedAsAdmin = false;
                EvalEntities.SEUserPrompts.Add(userPrompt);
                EvalEntities.SaveChanges();
                AssignPromptToUser(sessionId, schoolYear, districtCode, createdByUserId, userPrompt.UserPromptID);
            }
        }

        private SEEvaluationTypeEnum GetEvaluationTypeFromEvaluateeType()
        {
            return SEEvaluationTypeEnum.TEACHER;
        }
    }
}