using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;
using System.EnterpriseServices;

using NUnit.Framework;
using DbUtils;

using RepositoryLib;

namespace StateEval.tests.objectModel
{
    [TestFixture]
    class tEvaluatee : tBase
    {
#region ReflectionsTests

/*
        [Test]
        public void Reflections_Length()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            EvaluationData teacherEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);

            string f = "";
            string s = "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890";
            for (int i = 0; i < 49; ++i)
            {
                f += s;
            }

            EvaluationData evalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
            Fixture.SEMgr.InsertReflection(SEEvaluationType.TEACHER_OBSERVATION, evalData, principal.DistrictCode, principal.SchoolCode, f, false);
            SEReflection r = GetLastAddedReflection_Evaluator(teacherEvalData, SEEvaluationType.TEACHER_OBSERVATION, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS);
            Assert.AreEqual(4900, r.Question.Length);
        }

        public void VerifyDefinedByCount(int expectedCount, string definedBy, SEReflection[] reflections)
        {
            int n = 0;
            foreach (SEReflection q in reflections)
            {
                if (q.DefinedBy == definedBy)
                    n++;
            }
            Assert.AreEqual(expectedCount, n);
        }

        protected SEReflection GetReflectionStartsWith(SEReflection[] reflections, string startsWith)
        {
            foreach (SEReflection r in reflections)
            {
                if (r.Question.StartsWith(startsWith))
                    return r;
            }
            return null;
        }

        protected void VerifyDefinedByCounts(SEReflection[] reflections, int districtCount, int schoolCount, int privateToEvaluationCount, int bankCount)
        {
            VerifyDefinedByCount(districtCount, "District", reflections);
            VerifyDefinedByCount(schoolCount, "School", reflections);
            VerifyDefinedByCount(privateToEvaluationCount, "Private to Evaluation", reflections);
            VerifyDefinedByCount(bankCount, "My Question Bank", reflections);
        }

        [Test]
        public void Reflections_Load()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            EvaluationData evalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
 
            // Teacher Evaluation
            Fixture.SEMgr.InsertReflection(SEEvaluationType.TEACHER_OBSERVATION, evalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, evalData, false);

            SEReflection r = GetLastAddedReflection_Evaluator(evalData, SEEvaluationType.TEACHER_OBSERVATION, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS);
            Assert.AreEqual("Private to Evaluation", r.DefinedBy);
            Assert.AreEqual(PilotDistricts.NorthThurston, r.DistrictCode);
            Assert.AreEqual(PilotSchools.NorthThurston_NorthThurstonHS, r.SchoolCode);
            Assert.AreEqual("R1", r.Question);
            Assert.AreEqual(r.Id, ((IDbObject)r).Id);
            Assert.AreEqual(principal.Id, r.CreatedByUserId);
            Assert.AreEqual(teacher.Id, r.EvaluateeId);
        }


        [Test]
		[Ignore("Failing in integration environment")]
		public void Reflections_Predefined()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            EvaluationData teacherEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
            EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

            // Teacher
            // Evaluator - by default new reflections are included in evaluation
            // There should be 2 pre-defined district reflections, 2 pre-defined school reflections
            SEReflection[] evaluatorReflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, teacher.DistrictCode, teacher.SchoolCode, true);
            SEReflection[] evaluateeReflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, true);

            VerifyDefinedByCounts(evaluatorReflections, 2, 2, 0, 0);
            VerifyDefinedByCounts(evaluateeReflections, 0, 0, 0, 0);

            // Principal 
            // Evaluator - by default new reflections are included in evaluation
            // There should be 2 pre-defined district reflections, 0 pre-defined school reflections
            evaluatorReflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, true);
            evaluateeReflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, true);
     
            VerifyDefinedByCounts(evaluatorReflections, 2, 0, 0, 0);
            VerifyDefinedByCounts(evaluateeReflections, 0, 0, 0, 0);
        }

        [Test]
		[Ignore("Failing in integration environment")]
		public void Reflections_EvaluatorIncludeInEvaluation()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            EvaluationData teacherEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
            EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

            // Teacher Evaluation

            // By default new reflections are included in the evaluation
            Fixture.SEMgr.InsertReflection(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            // Evaluator - all are included 
            SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, true);
            VerifyDefinedByCounts(reflections, 2, 2, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, false);
            VerifyDefinedByCounts(reflections, 2, 2, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, true);
            VerifyDefinedByCounts(reflections, 0, 0, 0, 0);

            // uncheck the first district-defined reflection
            reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, true);
            SEReflection r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined teacher final evaluation reflection #1?");
            Assert.IsTrue(r.Include);
            Fixture.SEMgr.IncludeReflection(teacher.Id, r.Id, false);
            reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, false);
            r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined teacher final evaluation reflection #1?");
            Assert.IsFalse(r.Include);
  
            // Evaluatee - one is excluded
            reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, false);
            VerifyDefinedByCounts(reflections, 2, 2, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, false);
            VerifyDefinedByCounts(reflections, 1, 2, 1, 0);


            // Principal Evaluation 

            // By default new reflections are included in the evaluation
            Fixture.SEMgr.InsertReflection(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            // Evaluatee - all are included 
            reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, true);
            VerifyDefinedByCounts(reflections, 2, 0, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, false);
            VerifyDefinedByCounts(reflections, 2, 0, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, true);
            VerifyDefinedByCounts(reflections, 0, 0, 0, 0);

            // uncheck the first district-defined reflection
            reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, true);
            r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined principal final evaluation reflection #1?");
            Fixture.SEMgr.IncludeReflection(principal.Id, r.Id, false);

            // Evaluatee - one is excluded
            reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, false);
            VerifyDefinedByCounts(reflections, 2, 0, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, false);
            VerifyDefinedByCounts(reflections, 1, 0, 1, 0);

        }

        [Test]
		[Ignore("Failing in integration environment")]
        public void Reflections_EvaluateeIsPublic()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            EvaluationData teacherEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
            EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

            // Teacher Evaluation
            // By default new reflections are included in the evaluation, but evaluatee response is not public
            Fixture.SEMgr.InsertReflection(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            // new evaluatee responses to reflections by default are not public
            SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, false);
            VerifyDefinedByCounts(reflections, 2, 2, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, true);
            VerifyDefinedByCounts(reflections, 0, 0, 0, 0);

            SEReflection r = GetLastAddedReflection_Evaluator(teacherEvalData, SEEvaluationType.TEACHER_OBSERVATION, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS);
            Fixture.SEMgr.UpdateReflectionIsPublic(r.Id, teacher.Id, true);
            r = GetLastAddedReflection_Evaluator(teacherEvalData, SEEvaluationType.TEACHER_OBSERVATION, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS);
            Assert.IsTrue(r.IsPublic);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, true);
            VerifyDefinedByCounts(reflections, 0, 0, 1, 0);

            // Principal Evaluation
            // By default new reflections are included in the evaluation, but evaluatee response is not public
            Fixture.SEMgr.InsertReflection(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, false);
            VerifyDefinedByCounts(reflections, 2, 0, 1, 0);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, true);
            VerifyDefinedByCounts(reflections, 0, 0, 0, 0);

            r = GetLastAddedReflection_Evaluator(principalEvalData, SEEvaluationType.PRINCIPAL_OBSERVATION, PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS);
            Fixture.SEMgr.UpdateReflectionIsPublic(r.Id, principal.Id, true);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, true);
            VerifyDefinedByCounts(reflections, 0, 0, 1, 0);
        }

        [Test]
        public void Reflections_Response()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            EvaluationData teacherEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
            EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

            // Teacher Evaluation
            Fixture.SEMgr.InsertReflection(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, false);

            DateTime before_updated = DateTime.Now;
            System.Threading.Thread.Sleep(100);

            SEReflection r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined teacher final evaluation reflection #1?");
            Assert.AreEqual(DateTime.MinValue, r.LastModifiedDateTime);
   
            Fixture.SEMgr.UpdateReflection_Response(r.Id, teacher.Id, "TResponse");
            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, false);
            r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined teacher final evaluation reflection #1?");
            Assert.AreEqual("TResponse", r.EvaluateeResponse);
            Assert.Greater(r.LastModifiedDateTime, before_updated);

            // Principal Evaluation
            Fixture.SEMgr.InsertReflection(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, false);

            r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined principal final evaluation reflection #1?");
            Fixture.SEMgr.UpdateReflection_Response(r.Id, principal.Id, "PResponse");
            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, false);
            r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined principal final evaluation reflection #1?");
            Assert.AreEqual("PResponse", r.EvaluateeResponse);

            // Make sure nothing changed in the other one
            reflections = Fixture.SEMgr.ReflectionsForEvaluatee(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, false);
            r = GetReflectionStartsWith(reflections, "North Thurston Public Schools-defined teacher final evaluation reflection #1?");
            Assert.AreEqual("TResponse", r.EvaluateeResponse);
        }

         // Have to look up questions with the status info
         protected SEReflection GetLastAddedReflection_Evaluator(EvaluationData evalData, SEEvaluationType evalType, string districtCode, string schoolCode)
         {
             var maxIdQuery = from x in Fixture.LINQStateEval.SEReflections
                              select x.ReflectionID;


             SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluator(evalType, evalData, districtCode, schoolCode, false);
 
             foreach (SEReflection reflection in reflections)
             {
                 if (reflection.Id == maxIdQuery.Max())
                     return reflection;
             }

             return null;
         }


         protected SEReflection CreateTeacherReflectionAndAddToBank(SEUser teacher, SEUser principal)
         {
             EvaluationData evalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
             // Teacher Evaluation
             Fixture.SEMgr.InsertReflection(SEEvaluationType.TEACHER_OBSERVATION, evalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

             SEReflection r = GetLastAddedReflection_Evaluator(evalData, SEEvaluationType.TEACHER_OBSERVATION, principal.DistrictCode, principal.SchoolCode);
             Assert.AreEqual("Private to Evaluation", r.DefinedBy);

             Fixture.SEMgr.UpdateReflection_AddToBank(teacher.Id, r.Id, principal.Id);
             r = GetLastAddedReflection_Evaluator(evalData, SEEvaluationType.TEACHER_OBSERVATION, principal.DistrictCode, principal.SchoolCode);
             Assert.AreEqual("My Question Bank", r.DefinedBy);
             return r;
         }

         protected SEReflection CreatePrincipalReflectionAndAddToBank(SEUser principal, SEUser de)
         {
             EvaluationData evalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);
 
             // By default new reflections are included in the evaluation
             Fixture.SEMgr.InsertReflection(SEEvaluationType.PRINCIPAL_OBSERVATION, evalData, principal.DistrictCode, principal.SchoolCode, "R1", false);

            SEReflection r = GetLastAddedReflection_Evaluator(evalData, SEEvaluationType.PRINCIPAL_OBSERVATION, principal.DistrictCode, principal.SchoolCode);
             Assert.AreEqual("Private to Evaluation", r.DefinedBy);

             Fixture.SEMgr.UpdateReflection_AddToBank(principal.Id, r.Id, de.Id);
             r = GetLastAddedReflection_Evaluator(evalData, SEEvaluationType.PRINCIPAL_OBSERVATION, principal.DistrictCode, principal.SchoolCode);
             Assert.AreEqual("My Question Bank", r.DefinedBy);
             return r;
         }

          [Test]
          public void Reflections_AddToBank()
          {
              SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
              SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
              SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
              EvaluationData teacherEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher.Id);
              EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

              // Teacher Evaluation

              SEReflection r = CreateTeacherReflectionAndAddToBank(teacher, principal);

              // Evaluatee - all are included 
              SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacherEvalData, principal.DistrictCode, principal.SchoolCode, true);

              // Principal Evaluation
              r = CreatePrincipalReflectionAndAddToBank(principal, de);

              // Evaluatee - all are included 
              reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.PRINCIPAL_OBSERVATION, principalEvalData, principal.DistrictCode, principal.SchoolCode, true);
          }

          [Test]
          public void Reflections_Bank_VisibleToOtherEvaluatees()
          {
              SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
              SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
              SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
              SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
              EvaluationData teacher1EvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher1.Id);
              EvaluationData teacher2EvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher2.Id);
              EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

              // Teacher Evaluation
              SEReflection r = CreateTeacherReflectionAndAddToBank(teacher1, principal);
 
              SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacher1EvalData, principal.DistrictCode, principal.SchoolCode, true);

              // Should be added to other evaluatees, not included by default
              reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacher2EvalData, principal.DistrictCode, principal.SchoolCode, false);
              VerifyDefinedByCounts(reflections, 2, 2, 0, 1);

              reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacher2EvalData, principal.DistrictCode, principal.SchoolCode, true);
              VerifyDefinedByCounts(reflections, 2, 2, 0, 0);
         }

          public void Reflections_PrivateCore(SEUser e1, SEUser e2, EvaluationData evalData1, EvaluationData evalData2, SEEvaluationType evalType, int districtCount, int schoolCount)
          {
              SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluator(evalType, evalData1, e1.DistrictCode, e1.SchoolCode, false);
              VerifyDefinedByCounts(reflections, districtCount, schoolCount, 1, 0);

              // Should not be added to evaluatee #2 
              reflections = Fixture.SEMgr.ReflectionsForEvaluator(evalType, evalData2, e1.DistrictCode, e1.SchoolCode, false);
              VerifyDefinedByCounts(reflections, districtCount, schoolCount, 0, 0);
          }

          [Test]
          public void Reflections_Private_VisibleToExisting()
          {
              SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
              SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
              SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
              EvaluationData teacher1EvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher1.Id);
              EvaluationData teacher2EvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher2.Id);
              EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

              // Teacher Evaluation
              Fixture.SEMgr.InsertReflection(SEEvaluationType.TEACHER_OBSERVATION, teacher1EvalData, principal.DistrictCode, principal.SchoolCode, "R1", false); 
              Reflections_PrivateCore(teacher1, teacher2, teacher1EvalData, teacher2EvalData,  SEEvaluationType.TEACHER_OBSERVATION, 2, 2);
          }

          [Test]
          public void Reflections_Bank_DeleteSharedReflectionWithResponses()
          {
              SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
              SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
              SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
              EvaluationData teacher1EvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher1.Id);
              EvaluationData teacher2EvalData = EvaluationManager.GetEvaluationDataForEvaluatee(teacher2.Id);
              EvaluationData principalEvalData = EvaluationManager.GetEvaluationDataForEvaluatee(principal.Id);

              SEReflection r = CreateTeacherReflectionAndAddToBank(teacher1, principal);

              // Should be added to other evaluatees, not included by default
              SEReflection[] reflections = Fixture.SEMgr.ReflectionsForEvaluator(SEEvaluationType.TEACHER_OBSERVATION, teacher2EvalData, principal.DistrictCode, principal.SchoolCode, false);
              VerifyDefinedByCounts(reflections, 2, 2, 0, 1);

              Fixture.SEMgr.UpdateReflection_Response(r.Id, teacher1.Id, "T1Response");
              Fixture.SEMgr.UpdateReflection_Response(r.Id, teacher2.Id, "T2Response");

              r = GetLastAddedReflection_Evaluator(teacher1EvalData, SEEvaluationType.TEACHER_OBSERVATION, principal.DistrictCode, principal.SchoolCode);
              Assert.AreEqual(1, r.InUseCount);
              Assert.AreEqual("T1Response", r.EvaluateeResponse);

              r = GetLastAddedReflection_Evaluator(teacher2EvalData, SEEvaluationType.TEACHER_OBSERVATION, principal.DistrictCode, principal.SchoolCode);
              Assert.AreEqual(1, r.InUseCount);
              Assert.AreEqual("T2Response", r.EvaluateeResponse);

              Fixture.SEMgr.RemoveReflection(r.Id);

              var reflectionCountQuery = from x in Fixture.LINQStateEval.SEReflections
                                         where (x.ReflectionID == r.Id)
                                         select x;

              Assert.AreEqual(0, reflectionCountQuery.Count());
          }
        */
#endregion

        #region MiscTests


        protected void VerifyVisibility(SEUser e, bool fnExcerpts, bool finalScore, bool fnSummScore, bool rrSummScore, bool observations, bool evalComments, 
                                        bool evalExcerpts, bool evalRRAnnotations, SEEvaluationType evalType)
        {
            SEEvalVisibility v = SEMgr.Instance.GetEvalVisibilityForEvaluatee(e.Id, Fixture.CurrentSchoolYear, e.DistrictCode, evalType);
            Assert.AreEqual(fnExcerpts, v.FNExcerptsVisible);
            Assert.AreEqual(finalScore, v.FinalScoreVisible);
            Assert.AreEqual(fnSummScore, v.FNSummativeScoresVisible);
            Assert.AreEqual(rrSummScore, v.RRSummativeScoresVisible);
            Assert.AreEqual(observations, v.ObservationsVisible);
            Assert.AreEqual(evalComments, v.EvalCommentsVisible);
            Assert.AreEqual(evalExcerpts, v.EvalExcerptsVisible);
            Assert.AreEqual(evalRRAnnotations, v.RRAnnotationsVisible);
        }

        protected void SetScreenVisibilityFlags(SEUser evaluatee, bool fnExcerpts, bool finalScore, bool fnSummScore, bool rrSummScore, 
                                        bool observations, bool evalComments,  bool evalExcerpts, bool evalRRAnnotations, bool applyGlobally, SEEvaluationType evalType)
        {

            BitArray flags = new BitArray(Enum.GetNames(typeof(SEEvaluationVisiblityArea)).Length);

            flags[Convert.ToInt32(SEEvaluationVisiblityArea.FINAL_SCORE)] = finalScore;
            flags[Convert.ToInt32(SEEvaluationVisiblityArea.EVAL_COMMENTS)] = evalComments;
            flags[Convert.ToInt32(SEEvaluationVisiblityArea.EVAL_EXCERPTS)] = evalExcerpts;
            flags[Convert.ToInt32(SEEvaluationVisiblityArea.FN_SUMMATIVE_SCORES)] = fnSummScore;
            flags[Convert.ToInt32(SEEvaluationVisiblityArea.OBSERVATIONS)] = observations;
            flags[Convert.ToInt32(SEEvaluationVisiblityArea.RR_SUMMATIVE_SCORES)] = rrSummScore;
            flags[Convert.ToInt32(SEEvaluationVisiblityArea.FN_EXCERPTS)] = fnExcerpts;
            flags[Convert.ToInt32(SEEvaluationVisiblityArea.RR_ANNOTATIONS)] = evalRRAnnotations;

            Fixture.SEMgr.SetEvaluationVisibilityArea(evaluatee.Id, flags, applyGlobally, Fixture.CurrentSchoolYear, evaluatee.DistrictCode, evalType);

        }

        [Test]
        public void SummaryScreenVisibility()
        {
            SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            VerifyVisibility(teacher, false, false, false, false, false, false, false, false, SEEvaluationType.TEACHER_OBSERVATION);
            VerifyVisibility(principal, false, false, false, false, false, false, false, false, SEEvaluationType.PRINCIPAL_OBSERVATION);

            SetScreenVisibilityFlags(teacher, true, false, true, false, true, false, true, false, false, SEEvaluationType.TEACHER_OBSERVATION);
            SetScreenVisibilityFlags(principal, false, true, false, true, false, true, false, true, false, SEEvaluationType.PRINCIPAL_OBSERVATION);

            teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            VerifyVisibility(teacher, true, false, true, false, true, false, true, false, SEEvaluationType.TEACHER_OBSERVATION);
            VerifyVisibility(principal, false, true, false, true, false, true, false, true, SEEvaluationType.PRINCIPAL_OBSERVATION);
        }

        /* TODO: Fix for 2013
        protected void VerifyFinalEvaluationNotes(SEUser evaluatee, string evaluateeNotes, string evaluatorNotes)
        {
            EvaluationData evalData = EvaluationManager.GetEvaluationDataForEvaluatee(evaluatee.Id, Fixture.CurrentSchoolYear);
            Assert.AreEqual(evaluateeNotes, evalData.EvaluateeNotes);
            Assert.AreEqual(evaluatorNotes, evalData.EvaluatorNotes);
        }

        [Test]
        public void SummaryScreenEvaluationNotes()
        {
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            VerifyFinalEvaluationNotes(teacher1, "", "");
            VerifyFinalEvaluationNotes(teacher2, "", "");
            Fixture.SEMgr.UpdateFinalScoreEvaluateeNotes(teacher1.Id, "EvaluateeNotes_T1");
            Fixture.SEMgr.UpdateFinalScoreEvaluatorNotes(teacher1.Id, "EvaluatorNotes_T1");
            Fixture.SEMgr.UpdateFinalScoreEvaluateeNotes(teacher2.Id, "EvaluateeNotes_T2");
            Fixture.SEMgr.UpdateFinalScoreEvaluatorNotes(teacher2.Id, "EvaluatorNotes_T2");
            
            // Should update the object
            VerifyFinalEvaluationNotes(teacher1, "EvaluateeNotes_T1", "EvaluatorNotes_T1");
            VerifyFinalEvaluationNotes(teacher2, "EvaluateeNotes_T2", "EvaluatorNotes_T2");

            teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);

            // SHould be loaded from the db
            VerifyFinalEvaluationNotes(teacher1, "EvaluateeNotes_T1", "EvaluatorNotes_T1");
            VerifyFinalEvaluationNotes(teacher2, "EvaluateeNotes_T2", "EvaluatorNotes_T2");

        }
        */

        [Test]
        public void IDbObject()
        {
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

            Assert.AreEqual(teacher1.Id, ((IDbObject)teacher1).Id);
        }

        [Test]
        public void Evaluator()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEEvaluation teacherEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
            SEEvaluation principalEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(principal.Id, Fixture.CurrentSchoolYear, principal.DistrictCode);

            SEEvalSession s1_t1 = Fixture.CreateTestTeacherEvalSession("S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                                           principal.Id, teacher1.Id);

 
            SEEvalSession s1_p1 = Fixture.CreateTestPrincipalEvalSession("P1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                    de.Id, principal.Id);

            teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            Assert.AreEqual(principal.Id, teacherEvalData.EvaluatorId);
            Assert.AreEqual(de.Id, principalEvalData.EvaluatorId);
        }

        protected void SetCheckFinalScore(SEEvaluation evalData, long evaluatorId, SERubricPerformanceLevel pl, string districtCode)
        {
            Fixture.SEMgr.ScoreFinalScore(evaluatorId, evalData.EvaluateeId, pl, Fixture.CurrentSchoolYear, districtCode);
            SEEvaluation newEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(evalData.EvaluateeId, Fixture.CurrentSchoolYear, districtCode);
            Assert.AreEqual(pl, (SERubricPerformanceLevel)Convert.ToInt32(newEvalData.PerformanceLevel));
        }

        [Test]
        public void FinalScore()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);
            SEEvaluation teacherEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
            SEEvaluation principalEvalData = Fixture.SEMgr.GetEvaluationDataForEvaluatee(principal.Id, Fixture.CurrentSchoolYear, principal.DistrictCode);

            SetCheckFinalScore(teacherEvalData, principal.Id, SERubricPerformanceLevel.PL1, principal.DistrictCode);
            SetCheckFinalScore(teacherEvalData, principal.Id, SERubricPerformanceLevel.PL2, principal.DistrictCode);
            SetCheckFinalScore(teacherEvalData, principal.Id, SERubricPerformanceLevel.PL3, principal.DistrictCode);
            SetCheckFinalScore(teacherEvalData, principal.Id, SERubricPerformanceLevel.PL4, principal.DistrictCode);
            SetCheckFinalScore(teacherEvalData, principal.Id, SERubricPerformanceLevel.UNDEFINED, principal.DistrictCode);

            SetCheckFinalScore(principalEvalData, de.Id, SERubricPerformanceLevel.PL1, de.DistrictCode);
            SetCheckFinalScore(principalEvalData, de.Id, SERubricPerformanceLevel.PL2, de.DistrictCode);
            SetCheckFinalScore(principalEvalData, de.Id, SERubricPerformanceLevel.PL3, de.DistrictCode);
            SetCheckFinalScore(principalEvalData, de.Id, SERubricPerformanceLevel.PL4, de.DistrictCode);
            SetCheckFinalScore(principalEvalData, de.Id, SERubricPerformanceLevel.UNDEFINED, de.DistrictCode);
        }

        protected SEEvalSession FindSessionWithTitle(SEEvalSession[] sessions, string title)
        {
            foreach (SEEvalSession s in sessions)
            {
                if (s.Title == title)
                    return s;
            }
            return null;
        }

        [Test]
        public void ObservationEvalSessions()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEEvalSession s1_t1 = Fixture.CreateTestTeacherEvalSession("S1_T1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                                           principal.Id, teacher1.Id);
            s1_t1.UpdateIsPublic(false, true, false);

            SEEvalSession s2_t1 = Fixture.CreateTestTeacherEvalSession("S2_T1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                                            principal.Id, teacher1.Id);
            s2_t1.UpdateIsPublic(false, true, false);

            SEEvalSession s1_t2 = Fixture.CreateTestTeacherEvalSession("S1_T2", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                               principal.Id, teacher2.Id);

            s1_t2.UpdateIsPublic(false, true, false);

            SEEvalSession s1_p1 = Fixture.CreateTestPrincipalEvalSession("P1_S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,
                                    de.Id, principal.Id);

            s1_p1.UpdateIsPublic(false, true, false);

            SEEvalSession[] t1_sessions = Fixture.SEMgr.EvalSessionsForEvaluatee_Summary(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode, SEEvaluationType.TEACHER_OBSERVATION, false);
            Assert.AreEqual(2, t1_sessions.Length);
            Assert.IsNotNull(FindSessionWithTitle(t1_sessions, "S1_T1"));
            Assert.IsNotNull(FindSessionWithTitle(t1_sessions, "S2_T1"));

            SEEvalSession[] t2_sessions = Fixture.SEMgr.EvalSessionsForEvaluatee_Summary(teacher2.Id, Fixture.CurrentSchoolYear, teacher2.DistrictCode, SEEvaluationType.TEACHER_OBSERVATION, false);
            Assert.AreEqual(1, t2_sessions.Length);
            Assert.IsNotNull(FindSessionWithTitle(t2_sessions, "S1_T2"));

            SEEvalSession[] p_sessions = Fixture.SEMgr.EvalSessionsForEvaluatee_Summary(principal.Id, Fixture.CurrentSchoolYear, principal.DistrictCode, SEEvaluationType.PRINCIPAL_OBSERVATION, false);
            Assert.AreEqual(1, p_sessions.Length);
        }

        [Test]
        public void SelfAssessEvalSessions()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEEvalSession s1_t1 = Fixture.CreateTestTeacherSelfAssessSession("S1_T1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, teacher1.Id);

            SEEvalSession s2_t1 = Fixture.CreateTestTeacherSelfAssessSession("S2_T1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, teacher1.Id);

            SEEvalSession s1_t2 = Fixture.CreateTestPrincipalSelfAssessSession("S1_T2", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, teacher2.Id);

            SEEvalSession s1_p1 = Fixture.CreateTestPrincipalSelfAssessSession("P1_S1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS,  principal.Id);

            SEEvalSession[] t1_sessions = Fixture.SEMgr.EvalSessionsForSelfEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode, true, false);
            Assert.AreEqual(2, t1_sessions.Length);
            Assert.IsNotNull(FindSessionWithTitle(t1_sessions, "S1_T1"));
            Assert.IsNotNull(FindSessionWithTitle(t1_sessions, "S2_T1"));

            SEEvalSession[] p1_sessions = Fixture.SEMgr.EvalSessionsForSelfEvaluatee(principal.Id, Fixture.CurrentSchoolYear, principal.DistrictCode, true, false);
            Assert.AreEqual(1, p1_sessions.Length);
            Assert.IsNotNull(FindSessionWithTitle(p1_sessions, "P1_S1"));

            Fixture.SEMgr.UpdateEvalSessionIsPublic(s1_t1.Id, true, true, true);

            t1_sessions = Fixture.SEMgr.EvalSessionsForSelfEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode, false, false);
            Assert.AreEqual(1, t1_sessions.Length);
            Assert.IsNotNull(FindSessionWithTitle(t1_sessions, "S1_T1"));
        }

        [Test]
        public void RubricRowScore_Principal()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEEvalSession s1_p1 = Fixture.CreateTestTeacherSelfAssessSession("s1_p1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id);

            SEEvalSession s2_p1 = Fixture.CreateTestTeacherSelfAssessSession("s2_p1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, principal.Id);

            SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.PSTATE);
            Assert.IsNotNull(stateFramework);

            SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
            SERubricRow[] rrows = c1Node.RubricRows;
            SERubricRow rrc1a = Fixture.FindRubricRowTitleStartWith(rrows, "1.1");

            SEFrameworkNode c8Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C8");
            rrows = c8Node.RubricRows;
            SERubricRow rrc8a = Fixture.FindRubricRowTitleStartWith(rrows, "8.1");

            s1_p1.ScoreRubricRow(principal.Id, rrc1a.Id, SERubricPerformanceLevel.PL1);
            s2_p1.ScoreRubricRow(principal.Id, rrc8a.Id, SERubricPerformanceLevel.PL3);

            SERubricRowScore[] p1_scores = Fixture.SEMgr.RubricRowScoresForEvaluatee(principal.Id, Fixture.CurrentSchoolYear, principal.DistrictCode);
            Assert.AreEqual(2, p1_scores.Length);
            Assert.IsNotNull(FindRubricRowScore(p1_scores, s1_p1.Id, rrc1a.Id, SERubricPerformanceLevel.PL1));
            Assert.IsNull(FindRubricRowScore(p1_scores, s1_p1.Id, rrc8a.Id, SERubricPerformanceLevel.PL3));
        }

        [Test]
        public void RubricRowScore_Teacher()
        {
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEEvalSession s1_t1 = Fixture.CreateTestTeacherSelfAssessSession("S1_T1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, teacher1.Id);

            SEEvalSession s2_t1 = Fixture.CreateTestTeacherSelfAssessSession("S2_T1", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, teacher1.Id);

            SEEvalSession s1_t2 = Fixture.CreateTestPrincipalSelfAssessSession("S1_T2", PilotDistricts.NorthThurston, PilotSchools.NorthThurston_NorthThurstonHS, teacher2.Id);

            SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            Assert.IsNotNull(stateFramework);

            SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
            SERubricRow[] rrows = c1Node.RubricRows;
            SERubricRow rr1c = Fixture.FindRubricRowTitleStartWith(rrows, "2b");

            SEFrameworkNode c2Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C2");
            rrows = c2Node.RubricRows;
            SERubricRow rr1e = Fixture.FindRubricRowTitleStartWith(rrows, "3b");

            s1_t1.ScoreRubricRow(principal.Id, rr1c.Id, SERubricPerformanceLevel.PL1);
            s2_t1.ScoreRubricRow(principal.Id, rr1e.Id, SERubricPerformanceLevel.PL3);
            s1_t2.ScoreRubricRow(principal.Id, rr1c.Id, SERubricPerformanceLevel.PL2);

            SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
            Assert.IsNotNull(instructFramework);

            SEFrameworkNode d1Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D1");
            rrows = d1Node.RubricRows;
            SERubricRow rr1a = Fixture.FindRubricRowTitleStartWith(rrows, "1a");
           
            s1_t1.ScoreRubricRow(principal.Id, rr1a.Id, SERubricPerformanceLevel.PL2);
            s1_t2.ScoreRubricRow(principal.Id, rr1a.Id, SERubricPerformanceLevel.PL1);

            SERubricRowScore[] t1_scores = Fixture.SEMgr.RubricRowScoresForEvaluatee(teacher1.Id, Fixture.CurrentSchoolYear, teacher1.DistrictCode);
            Assert.AreEqual(3, t1_scores.Length);
            Assert.IsNotNull(FindRubricRowScore(t1_scores, s1_t1.Id, rr1c.Id, SERubricPerformanceLevel.PL1));
            Assert.IsNull(FindRubricRowScore(t1_scores, s1_t1.Id, rr1e.Id, SERubricPerformanceLevel.PL3));
            Assert.IsNotNull(FindRubricRowScore(t1_scores, s2_t1.Id, rr1e.Id, SERubricPerformanceLevel.PL3));
            Assert.IsNotNull(FindRubricRowScore(t1_scores, s1_t1.Id, rr1a.Id, SERubricPerformanceLevel.PL2));

            SERubricRowScore[] t2_scores = Fixture.SEMgr.RubricRowScoresForEvaluatee(teacher2.Id, Fixture.CurrentSchoolYear, teacher2.DistrictCode);
            Assert.AreEqual(2, t2_scores.Length);
            Assert.IsNotNull(FindRubricRowScore(t2_scores, s1_t2.Id, rr1c.Id, SERubricPerformanceLevel.PL2));
            Assert.IsNull(FindRubricRowScore(t2_scores, s1_t2.Id, rr1e.Id, SERubricPerformanceLevel.PL3));
            Assert.IsNotNull(FindRubricRowScore(t2_scores, s1_t2.Id, rr1a.Id, SERubricPerformanceLevel.PL1));
        }

        protected SERubricRowScore FindRubricRowScore(SERubricRowScore[] scores, long sessionId, long rrId, SERubricPerformanceLevel pl)
        {
            foreach (SERubricRowScore score in scores)
            {
                if (score.EvalSessionId == sessionId &&
                    score.PerformanceLevel == pl &&
                    score.RubricRowId == rrId)
                    return score;
            }
            return null;
        }

        [Test]
        public void SummativeRubricRowScore_Teacher()
        {
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            Assert.IsNotNull(stateFramework);

            SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
            SERubricRow[] rrows = c1Node.RubricRows;
            SERubricRow rr1c = Fixture.FindRubricRowTitleStartWith(rrows, "2b");
            SERubricRow rr2b = Fixture.FindRubricRowTitleStartWith(rrows, "3a");

            SEFrameworkNode c2Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C2");
            rrows = c2Node.RubricRows;
            SERubricRow rr1e = Fixture.FindRubricRowTitleStartWith(rrows, "3b");

            Fixture.SEMgr.ScoreSummativeRubricRow(principal.Id, teacher1.Id, rr1c.Id, SERubricPerformanceLevel.PL1);
            Fixture.SEMgr.ScoreSummativeRubricRow(principal.Id, teacher1.Id, rr2b.Id, SERubricPerformanceLevel.PL2);
            Fixture.SEMgr.ScoreSummativeRubricRow(principal.Id, teacher2.Id, rr1c.Id, SERubricPerformanceLevel.PL4);

            SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
            Assert.IsNotNull(instructFramework);

            SEFrameworkNode d1Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D1");
            rrows = d1Node.RubricRows;
            SERubricRow rr1a = Fixture.FindRubricRowTitleStartWith(rrows, "1a");

            Fixture.SEMgr.ScoreSummativeRubricRow(principal.Id, teacher1.Id, rr1a.Id, SERubricPerformanceLevel.PL3);

            SESummativeRubricRowScore[] t1_scores = Fixture.SEMgr.SummativeRubricRowScoresForEvaluatee(teacher1.Id, teacher1.DistrictCode, Fixture.CurrentSchoolYear);
            Assert.AreEqual(3, t1_scores.Length);
            Assert.AreEqual(((IDbObject)t1_scores[0]).Id, t1_scores[0].Id);
            Assert.AreEqual(principal.Id, t1_scores[0].UserId);
            Assert.IsNotNull(FindSummativeRubricRowScore(t1_scores, teacher1.Id, rr1c.Id, SERubricPerformanceLevel.PL1));
            Assert.IsNotNull(FindSummativeRubricRowScore(t1_scores, teacher1.Id, rr2b.Id, SERubricPerformanceLevel.PL2));
            Assert.IsNotNull(FindSummativeRubricRowScore(t1_scores, teacher1.Id, rr1a.Id, SERubricPerformanceLevel.PL3));

            SESummativeRubricRowScore[] t2_scores = Fixture.SEMgr.SummativeRubricRowScoresForEvaluatee(teacher2.Id, teacher2.DistrictCode, Fixture.CurrentSchoolYear);
            Assert.AreEqual(1, t2_scores.Length);
            Assert.IsNotNull(FindSummativeRubricRowScore(t2_scores, teacher2.Id, rr1c.Id, SERubricPerformanceLevel.PL4));
        }

        [Test]
        public void SummativeRubricRowScore_Principal()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.PSTATE);
            Assert.IsNotNull(stateFramework);

            SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
            SERubricRow[] rrows = c1Node.RubricRows;
            SERubricRow rr1a = Fixture.FindRubricRowTitleStartWith(rrows, "1.1");
            SERubricRow rr1b = Fixture.FindRubricRowTitleStartWith(rrows, "1.2");

            Fixture.SEMgr.ScoreSummativeRubricRow(de.Id, principal.Id, rr1a.Id, SERubricPerformanceLevel.PL1);
            Fixture.SEMgr.ScoreSummativeRubricRow(de.Id, principal.Id, rr1b.Id, SERubricPerformanceLevel.PL2);

            SESummativeRubricRowScore[] scores = Fixture.SEMgr.SummativeRubricRowScoresForEvaluatee(principal.Id, principal.DistrictCode, Fixture.CurrentSchoolYear);
            Assert.AreEqual(2, scores.Length);
            Assert.IsNotNull(FindSummativeRubricRowScore(scores, principal.Id, rr1a.Id, SERubricPerformanceLevel.PL1));
            Assert.IsNotNull(FindSummativeRubricRowScore(scores, principal.Id, rr1b.Id, SERubricPerformanceLevel.PL2));
        }

        protected SESummativeRubricRowScore FindSummativeRubricRowScore(SESummativeRubricRowScore[] scores, long evaluateeId, long rrId, SERubricPerformanceLevel pl)
        {
            foreach (SESummativeRubricRowScore score in scores)
            {
                if (score.EvaluateeId == evaluateeId &&
                    score.PerformanceLevel == pl &&
                    score.RubricRowId == rrId)
                    return score;
            }
            return null;
        }

        [Test]
        public void SummativeFrameworkNodeScore_Teacher()
        {
            SEUser teacher1 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
            SEUser teacher2 = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T2);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TSTATE);
            Assert.IsNotNull(stateFramework);

            SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");
 
            SEFrameworkNode c2Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C2");
  
            Fixture.SEMgr.ScoreSummativeFrameworkNode(principal.Id, teacher1.Id, c1Node.Id, SERubricPerformanceLevel.PL1);
            Fixture.SEMgr.ScoreSummativeFrameworkNode(principal.Id, teacher1.Id, c2Node.Id, SERubricPerformanceLevel.PL2);
            Fixture.SEMgr.ScoreSummativeFrameworkNode(principal.Id, teacher2.Id, c1Node.Id, SERubricPerformanceLevel.PL4);

            SEFramework instructFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.TINSTRUCTIONAL);
            Assert.IsNotNull(instructFramework);

            SEFrameworkNode d1Node = Fixture.FindFrameworkNodeWithShortName(instructFramework.AllNodes, "D1");

            Fixture.SEMgr.ScoreSummativeFrameworkNode(principal.Id, teacher1.Id, d1Node.Id, SERubricPerformanceLevel.PL3);

            SESummativeFrameworkNodeScore[] t1_scores = Fixture.SEMgr.SummativeFrameworkNodeScoresForEvaluatee(teacher1.Id, teacher1.DistrictCode, Fixture.CurrentSchoolYear);
            Assert.AreEqual(3, t1_scores.Length);
            Assert.AreEqual(((IDbObject)t1_scores[0]).Id, t1_scores[0].Id);
            Assert.AreEqual(principal.Id, t1_scores[0].UserId);
 
            Assert.IsNotNull(FindSummativeFrameworkNodeScore(t1_scores, teacher1.Id, c1Node.Id, SERubricPerformanceLevel.PL1));
            Assert.IsNotNull(FindSummativeFrameworkNodeScore(t1_scores, teacher1.Id, c2Node.Id, SERubricPerformanceLevel.PL2));
            Assert.IsNotNull(FindSummativeFrameworkNodeScore(t1_scores, teacher1.Id, d1Node.Id, SERubricPerformanceLevel.PL3));
 
            SESummativeFrameworkNodeScore[] t2_scores = Fixture.SEMgr.SummativeFrameworkNodeScoresForEvaluatee(teacher2.Id, teacher2.DistrictCode, Fixture.CurrentSchoolYear);
            Assert.AreEqual(1, t2_scores.Length);
            Assert.IsNotNull(FindSummativeFrameworkNodeScore(t2_scores, teacher2.Id, c1Node.Id, SERubricPerformanceLevel.PL4));
        }

        [Test]
        public void SummativeFrameworkNodeScore_Principal()
        {
            SEUser de = Fixture.SEMgr.SEUser(Fixture.NorthThurstonDistrictUserName_DE);
            SEUser principal = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_PR);

            SEFramework stateFramework = Fixture.SEMgr.Framework(PilotDistricts.NorthThurston, Fixture.CurrentSchoolYear, SEFrameworkType.PSTATE);
            Assert.IsNotNull(stateFramework);

            SEFrameworkNode c1Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C1");

            SEFrameworkNode c2Node = Fixture.FindFrameworkNodeWithShortName(stateFramework.AllNodes, "C2");

            Fixture.SEMgr.ScoreSummativeFrameworkNode(de.Id, principal.Id, c1Node.Id, SERubricPerformanceLevel.PL1);
            Fixture.SEMgr.ScoreSummativeFrameworkNode(de.Id, principal.Id, c2Node.Id, SERubricPerformanceLevel.PL2);
 
             SESummativeFrameworkNodeScore[] scores = Fixture.SEMgr.SummativeFrameworkNodeScoresForEvaluatee(principal.Id, principal.DistrictCode, Fixture.CurrentSchoolYear);
            Assert.AreEqual(2, scores.Length);
            Assert.IsNotNull(FindSummativeFrameworkNodeScore(scores, principal.Id, c1Node.Id, SERubricPerformanceLevel.PL1));
            Assert.IsNotNull(FindSummativeFrameworkNodeScore(scores, principal.Id, c2Node.Id, SERubricPerformanceLevel.PL2));
         }

        protected SESummativeFrameworkNodeScore FindSummativeFrameworkNodeScore(SESummativeFrameworkNodeScore[] scores, long evaluateeId, long nodeId, SERubricPerformanceLevel pl)
        {
            foreach (SESummativeFrameworkNodeScore score in scores)
            {
                if (score.EvaluateeId == evaluateeId &&
                    score.PerformanceLevel == pl &&
                    score.FrameworkNodeId == nodeId)
                    return score;
            }
            return null;
        }

        protected void FrameworkNodeScoreInner(SEEvalSession s, SEFrameworkNode fn, SERubricPerformanceLevel pl, int count)
        {
            s.ScoreFrameworkNode(1, fn.Id, pl);
            s = Fixture.SEMgr.EvalSession(s.Id);
            SEFrameworkNodeScore[] scores = s.FrameworkNodeScores;
            Assert.AreEqual(count, scores.Length);
            bool found = false;
            foreach (SEFrameworkNodeScore score in scores)
            {
                if (score.EvalSessionId == s.Id && score.FrameworkNodeId == fn.Id && score.PerformanceLevel == pl && score.UserId == 1)
                {
                    found = true;
                    break;
                }
            }
            Assert.IsTrue(found);

        }


        #endregion


    }
}
