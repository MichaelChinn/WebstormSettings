using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NUnit.Framework;
using StateEval;
using StateEval.Security;
using System.Threading;

namespace StateEval.tests
{
    [TestFixture]
    class tQuestionBankManager : tBase
    { 
        public void VerifyQuestionBankUserPromptsForUser(SEUser u, string schoolCode, SEEvaluationType evalType, SEUserPromptType promptType, string role, int expectedPCount, int expectedTCount)
        {
            SEUserPrompt[] prompts = SEUserPrompt.GetQuestionBankUserPrompts(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, schoolCode, u.Id,
                                 evalType, promptType, role);
            Assert.AreEqual(expectedPCount+expectedTCount, prompts.Length);

            int pCount = 0;
            int tCount = 0;
            foreach (SEUserPrompt p in prompts)
            {
                if (p.EvaluationType == SEEvaluationType.PRINCIPAL_OBSERVATION)
                {
                    pCount++;
                }
                else
                {
                    tCount++;
                }
            }
            Assert.AreEqual(expectedPCount, pCount);
            Assert.AreEqual(expectedTCount, tCount);
        }

        public void VerifyQuestionBankUserPromptsInner(SEUser u, string schoolCode, string role, SEEvaluationType evalType, int goalCountP, int goalCountT, int preCountP, int preCountT, int postCountP, int postCountT, int reflectCountP, int reflectCountT)
        {
            VerifyQuestionBankUserPromptsForUser(u, schoolCode, evalType, SEUserPromptType.EVALUATOR_GOAL, role, goalCountP, goalCountT);
            VerifyQuestionBankUserPromptsForUser(u, schoolCode, evalType, SEUserPromptType.PRE_CONFERENCE, role, preCountP, preCountT);
            VerifyQuestionBankUserPromptsForUser(u, schoolCode, evalType, SEUserPromptType.POST_CONFERENCE, role, postCountP, postCountT);
            VerifyQuestionBankUserPromptsForUser(u, schoolCode, evalType, SEUserPromptType.REFLECTION, role, reflectCountP, reflectCountT);
         }

        [Test]
        public void QuestionBankUserPrompts()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser da = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DA);
            SEUser sa = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_AD);
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            VerifyQuestionBankUserPromptsInner(da, "", UserRole.SEDistrictAdmin, SEEvaluationType.UNDEFINED, 0, 0, 2, 2, 2, 2, 2, 2);
            VerifyQuestionBankUserPromptsInner(sa, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolAdmin,SEEvaluationType.UNDEFINED, 0, 0, 2, 4, 2, 4, 2, 4);
            VerifyQuestionBankUserPromptsInner(de, "", UserRole.SEDistrictEvaluator, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 2, 0, 2, 0, 2, 0);
            VerifyQuestionBankUserPromptsInner(pr, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolPrincipal, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 4, 0, 4, 0, 4);

            // Create a bunch in the question bank

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
                                     SEEvaluationType.PRINCIPAL_OBSERVATION, da.Id, "DAGoal1_Title",
                                                 "DAGoal1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
                          SEEvaluationType.TEACHER_OBSERVATION, da.Id, "DAGoal1_Title",
                                      "DAGoal1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.TEACHER_OBSERVATION, sa.Id, "SAGoal1_Title",
                         "SAGoal1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEGoal1_Title",
                         "DEGoal1_Content", true, false);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRGoal1_Title",
                         "PRGoal1_Content", true, false);


            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.PRE_CONFERENCE,
                         SEEvaluationType.PRINCIPAL_OBSERVATION, da.Id, "DAPre1_Title",
                                     "DAPre1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.PRE_CONFERENCE,
              SEEvaluationType.TEACHER_OBSERVATION, da.Id, "DAPre1_Title",
                          "DAPre1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.PRE_CONFERENCE,
                         SEEvaluationType.TEACHER_OBSERVATION, sa.Id, "SAPre1_Title",
                                     "SAPre1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.PRE_CONFERENCE,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEPre1_Title",
                         "DEPre1_Content", true, false);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.PRE_CONFERENCE,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRPre1_Title",
                         "PRPre1_Content", true, false);


            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.POST_CONFERENCE,
              SEEvaluationType.PRINCIPAL_OBSERVATION, da.Id, "DAPost1_Title",
                          "DAPost1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.POST_CONFERENCE,
             SEEvaluationType.TEACHER_OBSERVATION, da.Id, "DAPost1_Title",
              "DAPost1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.POST_CONFERENCE,
                         SEEvaluationType.TEACHER_OBSERVATION, sa.Id, "SAPost1_Title",
                                     "SAPost1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.POST_CONFERENCE,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEPost1_Title",
                         "DEPost1_Content", true, false);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.POST_CONFERENCE,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRPost1_Title",
                         "PRPost1_Content", true, false);


            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.REFLECTION,
                SEEvaluationType.PRINCIPAL_OBSERVATION, da.Id, "DAReflect1_Title",
               "DAReflect1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.REFLECTION,
                SEEvaluationType.TEACHER_OBSERVATION, da.Id, "DAReflect1_Title",
               "DAReflect1_Content", true, true);


            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.REFLECTION,
                         SEEvaluationType.TEACHER_OBSERVATION, sa.Id, "SAReflect1_Title",
                                     "SAReflect1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.REFLECTION,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEReflect1_Title",
                         "DEReflect1_Content", true, false);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.REFLECTION,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRReflect1_Title",
                         "PRReflect1_Content", true, false);

            VerifyQuestionBankUserPromptsInner(da, "", UserRole.SEDistrictAdmin, SEEvaluationType.UNDEFINED, 1, 1, 3, 3, 3, 3, 3, 3);
            VerifyQuestionBankUserPromptsInner(sa, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolAdmin, SEEvaluationType.UNDEFINED, 1, 2, 3, 6, 3, 6, 3, 6);
            VerifyQuestionBankUserPromptsInner(de, "", UserRole.SEDistrictEvaluator, SEEvaluationType.PRINCIPAL_OBSERVATION, 2, 0, 4, 0, 4, 0, 4, 0);
            VerifyQuestionBankUserPromptsInner(pr, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolPrincipal, SEEvaluationType.TEACHER_OBSERVATION, 0, 3, 0, 7, 0, 7, 0, 7);

            // Create some private ones

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
            SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEGoal1_Title",
              "DEGoal1_Content", pr.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRGoal1_Title",
                         "PRGoal1_Content", t1.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.PRE_CONFERENCE,
            SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEPre1_Title",
              "DEPre1_Content", pr.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.PRE_CONFERENCE,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRPre1_Title",
                         "PRPre1_Content", t1.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.POST_CONFERENCE,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEPost1_Title",
                         "DEPost1_Content", pr.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.POST_CONFERENCE,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRPost1_Title",
                         "PRPost1_Content", t1.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.REFLECTION,
            SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEReflect1_Title",
              "DEReflect1_Content",  pr.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.REFLECTION,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRReflect1_Title",
                         "PRReflect1_Content", t1.Id);

            // The private ones don't show up in the bank
            VerifyQuestionBankUserPromptsInner(da, "", UserRole.SEDistrictAdmin, SEEvaluationType.UNDEFINED, 1, 1, 3, 3, 3, 3, 3, 3);
            VerifyQuestionBankUserPromptsInner(sa, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolAdmin, SEEvaluationType.UNDEFINED, 1, 2, 3, 6, 3, 6, 3, 6);
            VerifyQuestionBankUserPromptsInner(de, "", UserRole.SEDistrictEvaluator, SEEvaluationType.PRINCIPAL_OBSERVATION, 2, 0, 4, 0, 4, 0, 4, 0);
            VerifyQuestionBankUserPromptsInner(pr, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolPrincipal, SEEvaluationType.TEACHER_OBSERVATION, 0, 3, 0, 7, 0, 7, 0, 7);
        }

        protected void VerifyPromptFields(SEUserPrompt prompt, string districtCode, string schoolCode, SEUserPromptType promptType, SEEvaluationType evalType, long createdByUserId,
                                            string title, string content, bool published, bool isPrivate, bool createdByAdmin)
        {
            Assert.IsNotNull(prompt);
            Assert.AreEqual(districtCode, prompt.DistrictCode);
            Assert.AreEqual(schoolCode, prompt.SchoolCode);
            Assert.AreEqual(promptType, (SEUserPromptType)prompt.PromptType);
            Assert.AreEqual(evalType, (SEEvaluationType)prompt.EvaluationType);
            Assert.AreEqual(createdByUserId, prompt.CreatedByUserId);
            Assert.AreEqual(title, prompt.Title);
            Assert.AreEqual(content, prompt.Prompt);
            Assert.AreEqual(published, prompt.Published);
            Assert.AreEqual(isPrivate, prompt.Private);
            Assert.AreEqual(createdByAdmin, prompt.CreatedAsAdmin);
        }

        [Test]
        public void UpdatePrompt()
        {
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            long id = SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.REFLECTION,
                SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRReflect1_Title",
             "PRReflect1_Content", true, false);

            SEUserPrompt prompt = SEUserPrompt.UserPrompt(id);
            VerifyPromptFields(prompt, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.REFLECTION, SEEvaluationType.TEACHER_OBSERVATION,
                                pr.Id, "PRReflect1_Title", "PRReflect1_Content", true, false, false);

            prompt.UpdatePublicUserPrompt("NewTitle", "NewContent", true, false);
            prompt = SEUserPrompt.UserPrompt(id);
 
            VerifyPromptFields(prompt, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.REFLECTION, SEEvaluationType.TEACHER_OBSERVATION,
                                 pr.Id, "NewTitle", "NewContent", true, false, false);
        }

        [Test]
        public void DeletePrompt()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser da = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DA);
            SEUser sa = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_AD);

            VerifyQuestionBankUserPromptsInner(da, "", UserRole.SEDistrictAdmin, SEEvaluationType.UNDEFINED, 0, 0, 2, 2, 2, 2, 2, 2);
            VerifyQuestionBankUserPromptsInner(sa, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolAdmin, SEEvaluationType.UNDEFINED, 0, 0, 2, 4, 2, 4, 2, 4);
            VerifyQuestionBankUserPromptsInner(de, "", UserRole.SEDistrictEvaluator, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 2, 0, 2, 0, 2, 0);
            VerifyQuestionBankUserPromptsInner(pr, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolPrincipal, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 4, 0, 4, 0, 4);


            // Create and delete a bank one
            long id = SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
                                     SEEvaluationType.PRINCIPAL_OBSERVATION, da.Id, "DAGoal1_Title",
                                                 "DAGoal1_Content", true, true);

            SEUserPrompt.DeleteUserPrompt(id);

            VerifyQuestionBankUserPromptsInner(da, "", UserRole.SEDistrictAdmin, SEEvaluationType.UNDEFINED, 0, 0, 2, 2, 2, 2, 2, 2);
            VerifyQuestionBankUserPromptsInner(sa, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolAdmin, SEEvaluationType.UNDEFINED, 0, 0, 2, 4, 2, 4, 2, 4);
            VerifyQuestionBankUserPromptsInner(de, "", UserRole.SEDistrictEvaluator, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 2, 0, 2, 0, 2, 0);
            VerifyQuestionBankUserPromptsInner(pr, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolPrincipal, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 4, 0, 4, 0, 4);

            // Create and delete a private one
            id = SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
                                                SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEGoal1_Title",
                                                  "DEGoal1_Content", pr.Id);

            SEUserPrompt.DeleteUserPrompt(id);

            VerifyQuestionBankUserPromptsInner(da, "", UserRole.SEDistrictAdmin, SEEvaluationType.UNDEFINED, 0, 0, 2, 2, 2, 2, 2, 2);
            VerifyQuestionBankUserPromptsInner(sa, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolAdmin, SEEvaluationType.UNDEFINED, 0, 0, 2, 4, 2, 4, 2, 4);
            VerifyQuestionBankUserPromptsInner(de, "", UserRole.SEDistrictEvaluator, SEEvaluationType.PRINCIPAL_OBSERVATION, 0, 0, 2, 0, 2, 0, 2, 0);
            VerifyQuestionBankUserPromptsInner(pr, PilotSchools.NorthThurston_NorthThurstonHS, UserRole.SESchoolPrincipal, SEEvaluationType.TEACHER_OBSERVATION, 0, 0, 0, 4, 0, 4, 0, 4);
        }

        protected void VerifyPromptIsInList(SEUserPrompt[] prompts, string title)
        {
            foreach (SEUserPrompt p in prompts)
            {
                if (p.Title == title)
                    break;
            }

            Assert.False(false, "The prompt with title '" + title + "' was not in the list");
        }

        protected void VerifyPromptIsInList(SEUserPromptConferenceDefault[] prompts, string title)
        {
            foreach (SEUserPromptConferenceDefault p in prompts)
            {
                if (p.Title == title)
                    break;
            }

            Assert.False(false, "The prompt with title '" + title + "' was not in the list");
        }

        [Test]
        public void AssignPrompt()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser da = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DA);
            SEUser sa = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_AD);
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);


            // Create some public ones
            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
                                     SEEvaluationType.PRINCIPAL_OBSERVATION, da.Id, "DAGoal",
                                                 "DAGoal1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.TEACHER_OBSERVATION, sa.Id, "SAGoal",
                         "SAGoal1_Content", true, true);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEGoalPublic",
                         "DEGoal1_Content", true, false);

            // this one is not published
            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
            SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEGoalNotPublished",
             "DEGoal1_Content", false, false);

            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRGoalPublic",
                         "PRGoal1_Content", true, false);

            // this one is not published
            SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.EVALUATOR_GOAL,
              SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRGoalNotPublished",
                          "PRGoal1_Content", false, false);

            // Create some private ones
            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEGoalPrivate",
               "DEGoal1_Content", pr.Id);

            SEUserPrompt.InsertPrivateNonConferenceUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.EVALUATOR_GOAL,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRGoalPrivate",
                         "PRGoal1_Content", t1.Id);

            // Make sure only the ones that the user should inherit and are public come back
            SEUserPrompt[] prPrompts = SEUserPrompt.GetAssignableNonConferenceUserPrompts(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", 
                                                  "", de.Id, SEEvaluationType.PRINCIPAL_OBSERVATION, SEUserPromptType.EVALUATOR_GOAL, UserRole.SEDistrictEvaluator, pr.Id);

            Assert.AreEqual(3, prPrompts.Length);
            VerifyPromptIsInList(prPrompts, "DAGoal");
            VerifyPromptIsInList(prPrompts, "DEGoalPrivate");
            VerifyPromptIsInList(prPrompts, "DEGoalPublic");

            foreach (SEUserPrompt p in prPrompts)
            {
                SEUserPrompt.AssignPromptToUser(pr.Id, Fixture.CurrentSchoolYear, pr.DistrictCode, p.Id);
            }

            prPrompts = SEUserPrompt.GetAssignedUserPrompts(pr.Id, Fixture.CurrentSchoolYear, pr.DistrictCode, SEUserPromptType.EVALUATOR_GOAL);
            Assert.AreEqual(3, prPrompts.Length);
            VerifyPromptIsInList(prPrompts, "DAGoal");
            VerifyPromptIsInList(prPrompts, "DEGoalPrivate");
            VerifyPromptIsInList(prPrompts, "DEGoalPublic");


            SEUserPrompt[] trPrompts = SEUserPrompt.GetAssignableNonConferenceUserPrompts(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                       "", pr.Id, SEEvaluationType.TEACHER_OBSERVATION, SEUserPromptType.EVALUATOR_GOAL, UserRole.SESchoolPrincipal, t1.Id);

            Assert.AreEqual(3, trPrompts.Length);
            VerifyPromptIsInList(trPrompts, "DAGoal");
            VerifyPromptIsInList(trPrompts, "PRGoalPrivate");
            VerifyPromptIsInList(trPrompts, "PRGoalPublic");

            foreach (SEUserPrompt p in trPrompts)
            {
                SEUserPrompt.AssignPromptToUser(t1.Id, Fixture.CurrentSchoolYear, t1.DistrictCode, p.Id);
            }

            trPrompts = SEUserPrompt.GetAssignedUserPrompts(t1.Id, Fixture.CurrentSchoolYear, t1.DistrictCode, SEUserPromptType.EVALUATOR_GOAL);
            Assert.AreEqual(3, trPrompts.Length);
            VerifyPromptIsInList(trPrompts, "DAGoal");
            VerifyPromptIsInList(trPrompts, "PRGoalPrivate");
            VerifyPromptIsInList(trPrompts, "PRGoalPublic");

            foreach (SEUserPrompt p in prPrompts)
            {
                SEUserPrompt.UnassignPromptToUser(pr.Id, p.Id, Fixture.CurrentSchoolYear, pr.DistrictCode, null);
            }

            prPrompts = SEUserPrompt.GetAssignedUserPrompts(pr.Id, Fixture.CurrentSchoolYear, pr.DistrictCode, SEUserPromptType.EVALUATOR_GOAL);
            Assert.AreEqual(0, prPrompts.Length);

            trPrompts = SEUserPrompt.GetAssignedUserPrompts(t1.Id, Fixture.CurrentSchoolYear, pr.DistrictCode, SEUserPromptType.EVALUATOR_GOAL);
            Assert.AreEqual(3, trPrompts.Length);

            foreach (SEUserPrompt p in trPrompts)
            {
                SEUserPrompt.UnassignPromptToUser(t1.Id, p.Id, Fixture.CurrentSchoolYear, p.DistrictCode, null);
            }

            trPrompts = SEUserPrompt.GetAssignedUserPrompts(t1.Id, Fixture.CurrentSchoolYear, t1.DistrictCode, SEUserPromptType.EVALUATOR_GOAL);
            Assert.AreEqual(0, trPrompts.Length);
        }

        [Test]
        public void ConferencePromptDefaultInstantiation()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser pr = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser da = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DA);
            SEUser sa = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_AD);
            SEUser t1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            // Create some public ones
            long prPromptId = SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, "", SEUserPromptType.PRE_CONFERENCE,
             SEEvaluationType.PRINCIPAL_OBSERVATION, de.Id, "DEPreConfPublic",
                         "DEPreConf1_Content", true, false);

            long trPromptId = SEUserPrompt.InsertPublicUserPrompt(Fixture.CurrentSchoolYear, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, SEUserPromptType.PRE_CONFERENCE,
             SEEvaluationType.TEACHER_OBSERVATION, pr.Id, "PRPreConfPublic",
                         "PRPreConf1_Content", true, false);

            SEUserPrompt.AssignPromptDefaultToUser(pr.DistrictCode, pr.Id, prPromptId, SEUserPromptType.PRE_CONFERENCE);

            long sessionId = Fixture.SEMgr.CreateStandardEvalSession("", pr.DistrictCode, de.Id, pr.Id, "PR_Session", Fixture.CurrentSchoolYear, true, SEEvaluationType.PRINCIPAL_OBSERVATION);
            //isFormalObs = true

            SEEvalSession s = Fixture.SEMgr.EvalSession(sessionId);
            SEUserPromptResponse[] responses = s.UserPromptResponses(pr.Id, SEUserPromptType.PRE_CONFERENCE);
            Assert.AreEqual(1, responses.Length);
            Assert.AreEqual("DEPreConfPublic", responses[0].Title);

            responses[0].InsertUserPromptResponseEntry("ResponseDE", de.Id);

            Thread.Sleep(10);

            responses[0].InsertUserPromptResponseEntry("ResponsePR", pr.Id);

            SEUserPromptResponseEntry[] entries = responses[0].GetResponseEntries();
            Assert.AreEqual(2, entries.Length);
            Assert.AreEqual("ResponseDE", entries[1].Response);
            Assert.AreEqual("ResponsePR", entries[0].Response);
        }

        [Test]
        public void Test()
        {
        }
    }
}
