using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using DbUtils;
using stateevallib;
using System.Xml;
using System.Xml.Schema;
using System.IO;
using NUnit.Framework;

namespace stateevallib.Tests
{

    [TestFixture]
    class LoadSSDRubrics
    {
        StreamReader OpenStream(string fileName)
        {
                // Create an instance of StreamReader to read from a file.
                // The using statement also closes the StreamReader.
            return new StreamReader(@"D:\dev\StateEval\docs\DistrictDocuments\snohomish\" + fileName);

        }
        string DoubleTics(string s)
        {
            string retval = s.Replace("?", "''");  //what a hack!!!
            return retval;
        }
       void PersistRubricRow(string table, string title, string[] ps)
        {
            string sqlCmd = "insert StateEval_PrePro.dbo."
                + table
                + " (t, p1, p2, p3, p4) values ("
                + "'" + DoubleTics(title) + "',"
                + "'" + DoubleTics(ps[3]) + "',"
                + "'" + DoubleTics(ps[2]) + "',"
                + "'" + DoubleTics(ps[1]) + "',"
                + "'" + DoubleTics(ps[0]) + "')";

            Fixture.SEMgrExecute(sqlCmd);
        }

        private void DoSet(string name, string table)
        {


            StreamReader r = OpenStream(name);
            string[] ps = new string[4];
            string rrTitle = "";
            int lineNo = 0;

            string line = "";
            int whichP = 0;

            while ((line = r.ReadLine()) != null)
            {
                try
                {
                    lineNo++;
                    if (line.IndexOf('c') == 0)
                    {
                        if (rrTitle != "")
                        {
                            PersistRubricRow(table, rrTitle, ps);
                            for(int i = 0; i< 4; i++)
                            {
                                if (ps[i].Length==0)
                                    throw new Exception("at line " + lineNo.ToString() + " -- missing p");

                                ps[i] = "";
                            }
                        }
                        rrTitle = line;
                        whichP = 0;
                    }
                    else if (line.Length == 0)
                        continue;

                    else ps[whichP++] = line;
                }
                catch (Exception e)
                {
                    r.Close();
                    throw new Exception("Line number... " + lineNo + " for "+name+"... " + e.Message);

                }

            }
            PersistRubricRow(table, rrTitle, ps);

            r.Close();


        }
        
        [Test]
        public void Load()
        {
            //DoSet("PrincipalRubrics.txt", "snoPrinState_rr");
            //DoSet("TeacherRubrics.txt", "snoTeachState_rr");
        }
    }
}
