using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Security.Principal;
using System.Data.SqlClient;
using RRLib;

public class SiteSettings
{
    RRMgr _rrMgr;
    public SiteSettings()
    {
        _rrMgr = new RRMgr(ConfigurationManager.ConnectionStrings["StateEval_Proto_ConnectionString"].ToString());//this is a different change

    }
    public RRMgr RRMgr { get { return _rrMgr; } }
}