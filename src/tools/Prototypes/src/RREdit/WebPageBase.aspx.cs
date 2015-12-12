using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class WebPageBase : System.Web.UI.Page
{
    protected void Page_Load(object sender, System.EventArgs e)
    {

    }
    public SiteSettings SiteSettings
    {
        get
        {
            return UiUtils.SiteSettings;
        }
    }
}