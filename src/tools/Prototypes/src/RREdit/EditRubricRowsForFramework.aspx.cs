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

public partial class EditRubricRowsForFramework : WebPageBase
{

    private void LoadRubricRowGrid()
    {
        if (hFrameworkNodeId.Value == "")
            return;
        long frameworkNodeId = Convert.ToInt64(hFrameworkNodeId.Value);
        FrameworkNode frameworkNode = SiteSettings.RRMgr.FrameworkNode(frameworkNodeId);
        if (frameworkNode.IsLeafNode)
        {
            RubricGroupGrid.Visible = true;
            lblGroupTitle.Visible = true;
            lblGroupTitle.InnerText = frameworkNode.Description == "" ? frameworkNode.Title : frameworkNode.Description;
            RubricGroupGrid.DataSource = frameworkNode.RubricRows;
            RubricGroupGrid.DataBind();
        }
        else
        {
            RubricGroupGrid.Visible = false;
            lblGroupTitle.Visible = false;
        }
    }
    private string _frameworkName;

    protected new void Page_Load(object sender, EventArgs e)
    {
        string foo = Request.QueryString["FrameworkId"];
        long frameworkId = 0;
        Framework framework;
        if (foo == null)
            return;

        frameworkId = Convert.ToInt64(foo);
        framework = SiteSettings.RRMgr.Framework(frameworkId);
        BannerText.Text = framework.Name + " - " + framework.FrameworkType.ToString();

        if (!IsPostBack)
        {

            RadTreeView1.DataSource = SiteSettings.RRMgr.FrameworkNodes(frameworkId); ;
            RadTreeView1.DataBind();

            RadTreeView1.ExpandAllNodes();
        }
    }
    protected void RadTreeView1_OnNodeClick(object sender, RadTreeNodeEventArgs e)
    {
        long frameworkNodeId = Convert.ToInt64(e.Node.Value);
        hFrameworkNodeId.Value = frameworkNodeId.ToString();
        LoadRubricRowGrid();
    }
    protected void RadTreeView1_NodeDataBound(object sender, RadTreeNodeEventArgs e)
    {
        FrameworkNode fn = (FrameworkNode)e.Node.DataItem;
        e.Node.ToolTip = fn.Title;
        e.Node.Value = fn.Id.ToString();
    }
    protected void RubricGroupGrid_UpdateCommand(object sender, GridCommandEventArgs e)
    {
        if (e.Item is GridEditFormItem)
        {
            GridEditFormItem item = (GridEditFormItem)e.Item;
            long rrid = Convert.ToInt64(item.GetDataKeyValue("ID"));
            long fnid = Convert.ToInt64(hFrameworkNodeId.Value);
            RubricRow rr = SiteSettings.RRMgr.GetChildRubricRowOfFrameworkNode(fnid, rrid);
            RadEditor re = (RadEditor)item.FindControl("TitleEditor");
            rr.Title = re.Content;

            re = (RadEditor)item.FindControl("Pl1Editor");
            rr.Pl1 = re.Content;
            re = (RadEditor)item.FindControl("Pl2Editor");
            rr.Pl2 = re.Content;
            re = (RadEditor)item.FindControl("Pl3Editor");
            rr.Pl3 = re.Content;
            re = (RadEditor)item.FindControl("Pl4Editor");
            rr.Pl4 = re.Content;
            re = (RadEditor)item.FindControl("DescriptionEditor");
            rr.Description = re.Content;

            TextBox tb = (TextBox)item.FindControl("txtSequence");
            rr.Sequence = Convert.ToInt32(tb.Text);

            rr.Save();
        }
    }
    protected void RubricGroupGrid_OnNeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
    {
        if (hFrameworkNodeId.Value != "")
        {
            long frameworkNodeId = Convert.ToInt64(hFrameworkNodeId.Value);
            FrameworkNode frameworkNode = SiteSettings.RRMgr.FrameworkNode(frameworkNodeId);
            RubricGroupGrid.DataSource = frameworkNode.RubricRows;
        }
    }
    protected void RubricGroupGrid_DeleteCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
    {
        GridDataItem item = e.Item as GridDataItem;
        long rubricRowId = Convert.ToInt64(item.GetDataKeyValue("ID"));
        SiteSettings.RRMgr.DeleteRubricRow(rubricRowId);
        LoadRubricRowGrid();
    }
    protected void RubricGroupGrid_InsertCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
    {
        long frameworkNodeId = Convert.ToInt64(hFrameworkNodeId.Value);
        FrameworkNode frameworkNode = SiteSettings.RRMgr.FrameworkNode(frameworkNodeId);
        if (e.Item is GridEditFormItem)
        {
            GridEditFormItem item = (GridEditFormItem)e.Item;
            RadEditor re = (RadEditor)item.FindControl("TitleEditor");
            string title = re.Content;
            re = (RadEditor)item.FindControl("PL1Editor");
            string pl1 = re.Content;
            re = (RadEditor)item.FindControl("PL2Editor");
            string pl2 = re.Content;
            re = (RadEditor)item.FindControl("PL3Editor");
            string pl3 = re.Content;
            re = (RadEditor)item.FindControl("PL4Editor");
            string pl4 = re.Content;
            re = (RadEditor)item.FindControl("DescriptionEditor");
            string description = re.Content;

            TextBox tb = (TextBox)item.FindControl("txtSequence");
            int sequence = Convert.ToInt32(tb.Text);

            frameworkNode.AddRubricRow(title, description, sequence, pl1, pl2, pl3, pl4);
        }

    }

    protected void logoutButton_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
      
        Session.Clear();
        Response.Redirect(FormsAuthentication.LoginUrl);
    }


}
