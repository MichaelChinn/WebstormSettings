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

public partial class EditDanielson : WebPageBase
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
            RubricGroupGrid.DataSource = frameworkNode.RubricRows;
            RubricGroupGrid.DataBind();
        }
        else
        {
            RubricGroupGrid.Visible = false;
            lblGroupTitle.Visible = false;
        }
    }

    protected new void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            RadTreeView1.DataSource = SiteSettings.RRMgr.FrameworkNodes(1); ;
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
            RubricRow rr = SiteSettings.RRMgr.GetChildRubricRowOfFrameworkNode(fnid,rrid);
            TextBox tb = (TextBox)item.FindControl("txtTitle");
            rr.Title = tb.Text;
            tb = (TextBox)item.FindControl("txtSequence");
            rr.Sequence = Convert.ToInt32(tb.Text);
            tb = (TextBox)item.FindControl("txtPl1");
            rr.Pl1 = tb.Text;
            tb = (TextBox)item.FindControl("txtPl2");
            rr.Pl2 = tb.Text;
            tb = (TextBox)item.FindControl("txtPl3");
            rr.Pl3 = tb.Text;
            tb = (TextBox)item.FindControl("txtPl4");
            rr.Pl4 = tb.Text;
            tb = (TextBox)item.FindControl("txtDescription");
            rr.Description = tb.Text;

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
            TextBox tb = (TextBox)item.FindControl("txtTitle");
            string title = tb.Text;
            tb = (TextBox)item.FindControl("txtSequence");
            int sequence = Convert.ToInt32(tb.Text);
            tb = (TextBox)item.FindControl("txtPl1");
            string pl1 = tb.Text;
            tb = (TextBox)item.FindControl("txtPl2");
            string pl2 = tb.Text;
            tb = (TextBox)item.FindControl("txtPl3");
            string pl3 = tb.Text;
            tb = (TextBox)item.FindControl("txtPl4");
            string pl4 = tb.Text;
            tb = (TextBox)item.FindControl("txtDescription");
            string description = tb.Text;

            frameworkNode.AddRubricRow(title, description, sequence, pl1, pl2, pl3, pl4);
        }

    }


 }
