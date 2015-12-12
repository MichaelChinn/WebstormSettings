<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditDanielson.aspx.cs"
    Inherits="EditDanielson" ValidateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <telerik:RadStyleSheetManager ID="RadStyleSheetManager1" runat="server" />
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server" >
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
            <telerik:AjaxSetting AjaxControlID="RadTreeView1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RadTreeView1" />
                    <telerik:AjaxUpdatedControl ControlID="RubricGroupPanel" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="RubricGroupGrid">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="RubricGroupPanel" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <table>
        <tr>
            <td valign="top">
                <div style="border: 1px solid black">
                    <telerik:RadTreeView runat="Server" ID="RadTreeView1" OnNodeDataBound="RadTreeView1_NodeDataBound"
                        DataTextField="ShortName" DataFieldID="Id" DataFieldParentID="ParentNodeID" OnNodeClick="RadTreeView1_OnNodeClick">
                    </telerik:RadTreeView>
                </div>
            </td>
            <td valign='top'>
                <asp:Panel ID="RubricGroupPanel" runat='server'>
                    <label id='lblGroupTitle' runat="server">
                    </label>
                    <input type="hidden" id="hFrameworkNodeId" runat="server" />
                    <telerik:RadGrid ID="RubricGroupGrid" runat="server" PageSize="10" AutoGenerateColumns="false"
                        OnUpdateCommand="RubricGroupGrid_UpdateCommand" OnNeedDataSource="RubricGroupGrid_OnNeedDataSource"
                        OnDeleteCommand="RubricGroupGrid_DeleteCommand" OnInsertCommand="RubricGroupGrid_InsertCommand">
                        <PagerStyle NextPageText="Next" PrevPageText="Prev"></PagerStyle>
                        <GroupingSettings CaseSensitive="false" />
                        <MasterTableView DataKeyNames="ID" EditMode="EditForms" CommandItemDisplay="Top">
                            <CommandItemTemplate>
                                &nbsp;
                                <asp:Button ID="btnInsertRubricRow" runat="server" CommandName="InitInsert" 
                                    Text="Add Rubric Row" />
                            </CommandItemTemplate>
                            <Columns>
                                <telerik:GridEditCommandColumn UniqueName="EditCommand">
                                </telerik:GridEditCommandColumn>
                                <telerik:GridBoundColumn HeaderText="Sequence" UniqueName="Sequence" ItemStyle-VerticalAlign="Top"
                                    DataField="Sequence" DataType="System.Int32" />
                                <telerik:GridBoundColumn HeaderText="Title" UniqueName="Title" ItemStyle-VerticalAlign="Top"
                                    DataField="Title" DataType="System.String" />
                                <telerik:GridBoundColumn HeaderText="PL1" UniqueName="PL1" ItemStyle-VerticalAlign="Top"
                                    DataField="PL1" DataType="System.String" />
                                <telerik:GridBoundColumn HeaderText="PL2" UniqueName="PL2" ItemStyle-VerticalAlign="Top"
                                    DataField="PL2" DataType="System.String" />
                                <telerik:GridBoundColumn HeaderText="PL3" UniqueName="PL3" ItemStyle-VerticalAlign="Top"
                                    DataField="PL3" DataType="System.String" />
                                <telerik:GridBoundColumn HeaderText="PL4" UniqueName="PL4" ItemStyle-VerticalAlign="Top"
                                    DataField="PL4" DataType="System.String" />
                                <telerik:GridBoundColumn HeaderText="Description" UniqueName="Description" ItemStyle-VerticalAlign="Top"
                                    DataField="Description" DataType="System.String" />
                                <telerik:GridButtonColumn CommandName="Delete" Text="Delete" UniqueName="DeleteColumn"
                                    ConfirmText="Are you sure you want to delete this rubric?" ConfirmTitle="Delete rubric confirmation" />
                            </Columns>
                            <EditFormSettings EditFormType="Template">
                                <EditColumn UniqueName="EditColumn">
                                </EditColumn>
                                <FormTemplate>
                                    <table width="100%" border="1" cellpadding="2">
                                        <tr>
                                            <td style="width: 10%">
                                                Sequence:&nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtSequence" Width="100%" Text='<%# Bind( "Sequence") %>' runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%">
                                                Title:&nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtTitle" Width="100%" Text='<%# Bind( "Title") %>' runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                PL1:&nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPL1" Width="100%" Text='<%# Bind( "PL1") %>' TextMode="MultiLine"
                                                    Rows="4" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                PL2:&nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPL2" Width="100%" Text='<%# Bind( "PL2") %>' TextMode="MultiLine"
                                                    Rows="4" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                PL3:&nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPL3" Width="100%" Text='<%# Bind( "PL3") %>' TextMode="MultiLine"
                                                    Rows="4" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                PL4:&nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtPL4" Width="100%" Text='<%# Bind( "PL4") %>' TextMode="MultiLine"
                                                    Rows="4" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Description:&nbsp;
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtDescription" Width="100%" Text='<%# Bind( "Description") %>' TextMode="MultiLine"
                                                    Rows="4" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>

                                    <asp:Button ID="Button1" runat="server" CommandName='<%# ((bool)DataBinder.Eval(Container, "OwnerTableView.IsItemInserted")) ? "PerformInsert" : "Update" %>'
                                                Text='<%# ((bool)DataBinder.Eval(Container, "OwnerTableView.IsItemInserted")) ? "Insert" : "Update" %>' />
                                    
                                    <asp:Button ID="btnCancel" CommandName="Cancel" Text="Cancel" runat="server" />
                                </FormTemplate>
                            </EditFormSettings>
                        </MasterTableView>
                    </telerik:RadGrid>
                </asp:Panel>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
