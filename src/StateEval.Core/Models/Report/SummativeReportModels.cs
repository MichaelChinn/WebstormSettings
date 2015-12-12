using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.Remoting.Metadata.W3cXsd2001;

namespace StateEval.Core.Models.Report
{
    public class SummativeReportModel
    {
        public List<SummativeReportItem> Items { get; set; }
    }

    public class SummativeReportItem
    {
        public string SchoolName { get; set; }
        public string Name { get; set; }
        public string EvalType { get; set; }
        public string Submitted { get; set; }
        public string Criteria { get; set; }
        public string Growth { get; set; }
        public string Final { get; set; }
        public string Evaluator { get; set; }
        public string C1 { get; set; }
        public string C2 { get; set; }
        public string C3 { get; set; }
        public string C4 { get; set; }
        public string C5 { get; set; }
        public string C6 { get; set; }
        public string C7 { get; set; }
        public string C8 { get; set; }
        public string Observe { get; set; }
        public string Self { get; set; }
        public int Evidence { get; set; }
    }
}
