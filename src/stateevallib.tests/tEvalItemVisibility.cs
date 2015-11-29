using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using StateEval;
using System.Xml;
using System.Xml.Schema;

using NUnit.Framework;

namespace StateEval.tests
{
    [TestFixture]
    public class tEvalItemVisibility
    {
        /* This only works with a db initialized with the test users (*pr, *de, *tN) */
        [Test]
        public void ToggleBits()
        {
            /*
             * Find a TOR
             * Find all his TEES
             * Find one TEE in the list
             * Find one TEE not in the preceding list
             * 
             * Invoke SetEvaluationVisibilityArea with 
             * . different bit settings for inTEE
             * 
             * Areas: 0101010... 
             * Everyone Sees? : 0
             * 
             * Assert inTee sees 010101...
             * Assert otherTees sees nothing
             * Assert notTee sees nothing
             * 
             * Areas: 101010... 
             * Everyone Sees? : 0
             * 
             * Assert inTee sees 1010101...
             * Assert otherTees sees nothing
             * Assert notTee sees nothing
             *
             * Areas: 101010... 
             * Everyone Sees? : 1
             * 
             * Assert inTee sees 1010101...
             * Assert otherTees sees 1010101...
             * Assert notTee sees nothing

             * 
             */

        }

    }
}
