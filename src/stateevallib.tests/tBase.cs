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

//using RepositoryLib;

namespace StateEval.tests
{
    public class tBase
    {
        protected ServiceConfig _config;
        
        [SetUp]
        public void Setup()
        {
            _config = new ServiceConfig();
            _config.Transaction = TransactionOption.RequiresNew;
            ServiceDomain.Enter(_config);
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