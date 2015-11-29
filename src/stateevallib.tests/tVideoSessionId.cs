using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using StateEval;
using StateEval.Security;
using System.Xml;
using System.Xml.Schema;

using Microsoft.IdentityModel.Claims;
using Microsoft.IdentityModel.Configuration;
using Microsoft.IdentityModel.Protocols.WSTrust;
using Microsoft.IdentityModel.SecurityTokenService;
using System.Threading;
using System.Security.Principal;
using EDSIntegrationLib;
using NUnit.Framework;

namespace StateEval.tests
{
    [TestFixture]
    class tVideoSessionId
    {
        [Test]
        public void RoundTrip()
        {
            long[] numbers = new long[] {
                1, 
                2,
                3  //here goes to four digits
                ,5
                ,26
                ,27 //here goes to five digits
                ,44
                ,268
                ,269 //here goes to six digits
                ,495
                ,86741 //typical five digit number
                ,3948284
            };

            foreach (long number in numbers)
            {
                string vid = Utils.GenerateVideoSessionId(number);
                Assert.AreEqual(number, Utils.DecodeVideoSessionId(vid), number.ToString() + "|" + vid);
            }
        }
        [Test]
        public void Transpositions()
        {
            int targetCd = Utils.GetLuhnCheckDigit(1472709938);

            Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(4172709938));
            Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(1742709938));
            Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(1427709938));
            Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(1477209938));
             Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(1472079938));
            //Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(1472790938));
            Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(1472709398));
            Assert.AreNotEqual(targetCd, Utils.GetLuhnCheckDigit(1472709983));

        }

        [Test]
        public void SingleDigit()
        {
           // Random r = new Random();
            long number = 8963125;// (long)r.Next(0, 10000000);

            int target = Utils.GetLuhnCheckDigit(number);
            string sNum = number.ToString();
            int ndigits = sNum.Length;

            int ncollisions = 0;
            int nTries=0;

            StringBuilder sbCollisions = new StringBuilder();

            for (int i = 0; i < ndigits; i++)
                for (int j = 0; j < 10; j++)
                {
                    nTries++;
                    long newNumber = SetPos(number, i, j);
                    if (newNumber == number)
                        continue;

                    if (target == Utils.GetLuhnCheckDigit(newNumber))
                    {
                        ncollisions++;
                        sbCollisions.Append(newNumber + ";");
                    }
                }
            Assert.AreEqual(0, ncollisions, ncollisions.ToString() + "/" + nTries.ToString() + "..." + sbCollisions.ToString());
        }
        long SetPos(long number, int pos, int digit)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(number.ToString());
            if (pos >= sb.Length)
                throw new Exception("position out of range for number of digits");

            sb[pos] = digit.ToString()[0];

            return Int64.Parse(sb.ToString());

        }
    }
}
