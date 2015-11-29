using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;
using RRLib;


namespace RREdit
{
    public partial class ItemView : WebPageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {



        string foo = Request.QueryString["FrameworkId"];
        long frameworkId = 0;
        Framework framework;
        if (foo == null)
            return;

        frameworkId = Convert.ToInt64(foo);
        framework = SiteSettings.RRMgr.Framework(frameworkId);
        



            RubricGrid.DataSource = framework.RubricRows;
            RubricGrid.DataBind();
        }
     
    }
}