using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Data;
using System.Data.Linq;
using System.Text;
using System.Data.SqlClient;

using NUnit.Framework;
using WatiN.Core;
using stateevallib.tests.ui;

using DbUtils;

using RepositoryLib;

namespace stateevallib.tests.ui.smoketests
{
     [TestFixture, RequiresSTA]
    class tSmokeTest : tUIBase
    {
      //   [Test, RequiresSTA]
         public void VerifyFrameworksAreLoaded() 
         {
             LoginPageManager.SignInAsUser(_ie, "North Thurston High School Pr");
             Assert.IsTrue(_ie.ContainsText("North Thurston High School Pr"));
         }
    }
}
