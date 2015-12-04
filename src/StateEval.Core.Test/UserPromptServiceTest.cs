using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using StateEval.Core.Constants;
using StateEval.Core.Models;
using StateEval.Core.Services;
using StateEvalData;
using System.Transactions;

namespace StateEval.Core.Test
{
    [TestClass]
    public class UserPromptServiceTest
    {
        [TestMethod]
        public void SaveUserPrompt_Pre_conference_question_bank_Test()
        {
            using (TransactionScope scope = new TransactionScope())
            {
                UserPromptService userPromptService = new UserPromptService();
                UserPromptModel userPromptModel = new UserPromptModel
                {
                    Title = "Unit Test",
                    Prompt = "Unit Test Prompt",
                    PromptTypeID = SEUserPromptTypeEnum.PRE_CONFERENCE,
                    SchoolCode = TestHelper.DEFAULT_SCHOOLCODE,
                    SchoolYear = TestHelper.DEFAULT_SCHOOLYEAR,
                    CreatedByUserID = DefaultPrincipal.UserId,
                    DistrictCode = TestHelper.DEFAULT_DISTRICTCODE,
                    Published = true,
                    PublishedDate = DateTime.Now,
                    EvaluationTypeID = (short) SEEvaluationTypeEnum.TEACHER,
                    CreatedAsAdmin = true,
                    RubricRows = new List<RubricRowModel>
                    {
                        new RubricRowModel
                        {
                            Id = 1
                        }
                    }
                };

                userPromptService.SaveUserPrompt(userPromptModel);

                var userPrompts = userPromptService.GetQuestionBankUserPrompts(
                    (SESchoolYearEnum) TestHelper.DEFAULT_SCHOOLYEAR, userPromptModel.DistrictCode,
                    userPromptModel.SchoolCode,
                    userPromptModel.CreatedByUserID,
                    SEEvaluationTypeEnum.TEACHER,
                    SEUserPromptTypeEnum.PRE_CONFERENCE, RoleName.SESchoolPrincipal);

                Assert.IsTrue(userPrompts.Count > 0);
            }
        }
    }
}
