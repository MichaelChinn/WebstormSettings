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
    public class UserPromptResponseService : BaseService
    {
        public List<UserPromptResponseModel> GetuserPromptPreConfResponses(long evalSessionId)
        {
            var userResponses =
                EvalEntities.SEUserPromptResponses.Where(x => x.EvalSessionID == evalSessionId && x.SEUserPrompt != null
                    && x.SEUserPrompt.PromptTypeID == (short)SEUserPromptTypeEnum.PRE_CONFERENCE)
                    .ToList()
                    .Select(x => x.MapToUserPromptResponseModel()).ToList();

            return userResponses;
        }

        public long SaveUserPromptResponse(UserPromptResponseModel userPromptResponse)
        {
            SavePromptResponse(userPromptResponse);
            EvalEntities.SaveChanges();

            return userPromptResponse.UserPromptResponseID;
        }

        public void SaveUserPromptResponses(List<UserPromptResponseModel> userPromptResponses)
        {
            foreach (var userPromptResponseModel in userPromptResponses)
            {
                SavePromptResponse(userPromptResponseModel);
            }

            EvalEntities.SaveChanges();
        }

        public void SaveUserPromptCodedResponse(UserPromptResponseModel userPromptResponse)
        {
            var userPromptResponseEntry =
                EvalEntities.SEUserPromptResponseEntries.FirstOrDefault(
                    x => x.UserPromptResponseID == userPromptResponse.UserPromptResponseID);

            if (userPromptResponseEntry != null)
            {
                userPromptResponseEntry.Response = userPromptResponse.Response;
            }
            EvalEntities.SaveChanges();
        }

        private void SavePromptResponse(UserPromptResponseModel userPromptResponse)
        {
            var userPromptResponseEntry =
                EvalEntities.SEUserPromptResponseEntries.FirstOrDefault(
                    x => x.UserPromptResponseID == userPromptResponse.UserPromptResponseID);

            if (userPromptResponseEntry == null)
            {
                userPromptResponseEntry = new SEUserPromptResponseEntry
                {
                    CreationDateTime = DateTime.Now,                    
                    UserPromptResponseID = userPromptResponse.UserPromptResponseID,                    
                };

                EvalEntities.SEUserPromptResponseEntries.Add(userPromptResponseEntry);
            }

            userPromptResponseEntry.Response = userPromptResponse.Response;
            userPromptResponseEntry.UserID = userPromptResponse.UserId;
        }

    }
}