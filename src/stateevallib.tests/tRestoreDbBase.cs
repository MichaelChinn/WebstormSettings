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

namespace StateEval.tests
{
    class tRestoreDbBase
    {
        [SetUp]
        public void Setup()
        {
            Fixture.RevertToSnapshots();
        }


    }
}
