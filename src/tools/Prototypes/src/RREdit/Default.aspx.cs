using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Configuration;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Telerik.Web.UI;
using RRLib;

using Telerik.Web.UI.GridExcelBuilder;

public partial class Default : WebPageBase
{
    protected new void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
		RadGrid1.MasterTableView.ExportToExcel(); 
    }
    protected void RadGrid1_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
    {
        RadGrid1.DataSource = SiteSettings.RRMgr.Frameworks;
    }
    protected void AdvisoryGrid_ItemDataBound(object sender, GridItemEventArgs e)
    {

    }
    protected string EditPageTarget(object name, object frameworkId)
    {
        return "<a href='EditRubricRowsForFramework.aspx?FrameworkId=" + frameworkId.ToString() + "'>" + name.ToString() + "</a>";
    }
    protected void logoutButton_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
       
        Session.Clear();
        Response.Redirect(FormsAuthentication.LoginUrl);
    }

}
