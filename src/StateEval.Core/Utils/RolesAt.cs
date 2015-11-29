﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace StateEval.Core.Utils
{
    public class RolesAt
    {
        public List<string> RoleList { get; set; }
        public string OrgName { get; set; }
        public string CDSCode { get; set; }
        public RolesAt(string orgName, string cdsCode)
        {
            OrgName = orgName;
            CDSCode = cdsCode;
            RoleList = new List<string>();
        }
        public void Save(long seUserid, long edsPersonId)
        {
            //TODO
        }
    }
}