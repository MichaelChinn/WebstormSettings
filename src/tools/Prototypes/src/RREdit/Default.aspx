<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        <Scripts>
            <%--Needed for JavaScript IntelliSense in VS2010--%>
            <%--For VS2008 replace RadScriptManager with ScriptManager--%>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>
    <script type="text/javascript">
        //Put your JavaScript code here.
    </script>
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadGrid1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadGrid1" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

     <table>
        <tr><td colspan="2" align="right">
            <asp:Button ID="logoutButton" runat="server" 
                onclick="logoutButton_Click" Text = "logout" style="height: 26px" /></td></tr>
                <tr><td>


    <div>
        <telerik:RadGrid ID="RadGrid1" runat="server" AutoGenerateColumns="false" OnNeedDataSource="RadGrid1_NeedDataSource">
            <MasterTableView DataKeyNames="ID">
                <Columns>
                    <telerik:GridTemplateColumn HeaderText="Framework" Groupable="false" HeaderStyle-HorizontalAlign="Left"
                        ItemStyle-VerticalAlign="Top" AllowFiltering="false">
                        <ItemTemplate>
                            <div style="white-space: nowrap">
                                <asp:Label ID="Label1" runat="server" Text='<%# EditPageTarget(Eval("Name"), Eval("id"))%>' />
                            </div>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridBoundColumn HeaderText="Description" UniqueName="Description" ItemStyle-VerticalAlign="Top"
                        DataField="Description" DataType="System.String" />
                        <telerik:GridBoundColumn HeaderText="DistrictCode" UniqueName="DistrictCode" ItemStyle-VerticalAlign="Top"
                        DataField="DistrictCode" DataType="System.String" />
                    <telerik:GridBoundColumn HeaderText="SchoolYear" UniqueName="SchoolYear" ItemStyle-VerticalAlign="Top"
                        DataField="SchoolYear" DataType="System.String" />
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
    </div>
   </td></tr></table> </form>
</body>
</html>
