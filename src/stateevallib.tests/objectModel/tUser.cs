using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;

using NUnit.Framework;
using DbUtils;

using RepositoryLib;
using StateEval.Security;

namespace StateEval.tests.objectModel
{
     [TestFixture]
    class tUser : tBase
    {  
         [Test]
         public void VerifyLoad()
         {
             SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);
             Assert.AreEqual(teacher.Id, ((IDbObject)teacher).Id);
             Assert.AreEqual(teacher.LastName + ", " + teacher.FirstName, teacher.ToString());
             Assert.AreEqual(Fixture.NorthThurstonHSUserName_T1, teacher.UserName);
             Assert.AreEqual("T1@3010.edu", teacher.Email);
             Assert.AreEqual("North Thurston Public Schools", teacher.District);
             Assert.AreEqual("North Thurston High School", teacher.School);
             Assert.IsFalse(teacher.HasMultipleBuildings);
         }

         public void VerifyRoleExists(List<string> roles, string role)
         {
             foreach (string r in roles)
             {
                 if (r == role)
                     return;
             }

             Assert.Fail("Role Not Found: ", role);
         }

         [Test]
         public void Roles()
         {
             SEUser teacher = Fixture.SEMgr.SEUser(Fixture.NorthThurstonHSUserName_T1);

             List<string> roles = teacher.Roles("SE");
             Assert.AreEqual(1, roles.Count);

             teacher.AddRolesToUser("SE", "SESchoolAdmin");
             roles = teacher.Roles("SE");
             Assert.AreEqual(2, roles.Count);
             VerifyRoleExists(roles, "SESchoolTeacher");
             VerifyRoleExists(roles, "SESchoolAdmin");

             teacher.RemoveRolesFromUser("SE", "SESchoolAdmin");
             roles = teacher.Roles("SE");
             Assert.AreEqual(1, roles.Count);
             VerifyRoleExists(roles, "SESchoolTeacher");

             SEUser[] teachers = Fixture.SEMgr.GetTeachersInSchool(Fixture.CurrentSchoolYear, teacher.DistrictCode, teacher.SchoolCode);

             //north thurston hs has two teachers + 1 teacher in 'multiple schools'
             Assert.AreEqual(3, teachers.Length);

             teacher.RemoveRolesFromUser("SE", "SESchoolTeacher");

             teachers = Fixture.SEMgr.GetTeachersInSchool(Fixture.CurrentSchoolYear, teacher.DistrictCode, teacher.SchoolCode);

             Assert.AreEqual(2, teachers.Length);

     
         }


    }
}
