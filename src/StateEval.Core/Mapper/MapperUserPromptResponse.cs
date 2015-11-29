using System;
using System.Collections.Generic;
using System.Linq;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static UserPromptResponseModel MapToUserPromptResponseModel(this SEUserPromptResponse source, UserPromptResponseModel target = null)
        {
            target = target ?? new UserPromptResponseModel();
            target.UserPromptID = source.UserPromptID;

            if (source.SEUserPrompt != null)
            {
                target.Prompt = source.SEUserPrompt.Prompt;
            }

            if (source.SEUserPromptResponseEntries != null && source.SEUserPromptResponseEntries.Any())
            {
                var responseEntry = source.SEUserPromptResponseEntries.FirstOrDefault();
                if (responseEntry != null)
                {
                    target.Response = responseEntry.Response;
                    target.ResponseDateTime = responseEntry.CreationDateTime;
                }
            }

            target.DistrictCode = source.DistrictCode;
            target.EvaluateeID = source.EvaluateeID;
            target.EvalSessionID = source.EvalSessionID;
            target.SchoolYear = source.SchoolYear;
            target.UserPromptResponseID = source.UserPromptResponseID;
            
            if (source.SEUser != null)
            {
                target.UserId = source.SEUser.SEUserID;
                target.UserName = source.SEUser.FirstName + " "+ source.SEUser.LastName;
            }            

            return target;
        }
    }
}

