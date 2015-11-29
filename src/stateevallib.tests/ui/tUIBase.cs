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
using WatiN.Core;
using stateevallib.tests.ui;

using DbUtils;

using RepositoryLib;

namespace stateevallib.tests
{
    class tUIBase
    {
        protected IE _ie = null;

        [TestFixtureSetUp]
        public void StandardTestFixureSetup()
        {
            _ie = LoginPageManager.NavigateToLoginPage();
        }

        [TestFixtureTearDown]
        public void testSearchFixtureTearDown()
        {
            LoginPageManager.SignOut(_ie);
        }

        [SetUp]
        public void Setup()
        {
           ServiceConfig config = new ServiceConfig();
            config.Transaction = TransactionOption.RequiresNew;
            ServiceDomain.Enter(config);

            LoginPageManager.SignOut(_ie);
        }

        [TearDown]
        public void Teardown()
        {
            if (ContextUtil.IsInTransaction)
            {
                ContextUtil.SetAbort();
            }
            ServiceDomain.Leave();
        }
    }
}
