<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ItemView.aspx.cs" Inherits="RREdit.ItemView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <div>
                      <telerik:RadGrid ID="RubricGrid" runat="server" AllowSorting="false" AllowPaging="false" CssClass="ObserveRubricsRadGrid" Skin="" EnableEmbeddedSkins="false"
                            ShowHeader="true" AllowMultiRowSelection="false" AllowFilteringByColumn='false' 
                            ShowFooter="false" AllowMultiRowEdit="false" AutoGenerateColumns="false" 

                            >
                               
                            <MasterTableView DataKeyNames="RubricRowId" NoMasterRecordsText="No rubric found.">
                                  <Columns>
                                  
                                    <telerik:GridBoundColumn  UniqueName="FNID" DataField="FNID" HeaderText="FNID" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle"/>
                                    <telerik:GridBoundColumn  UniqueName="RRID" DataField="RubricRowID" HeaderText="RRID" ItemStyle-HorizontalAlign="Center" ItemStyle-VerticalAlign="Middle" />
                                 
                                    <telerik:GridBoundColumn  UniqueName="Title" DataField="Title" HeaderText="RRTitle" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top" />
                                   <telerik:GridBoundColumn  UniqueName="PL1" DataField="PL1Descriptor" HeaderText="pl1" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top"  />
                                   <telerik:GridBoundColumn UniqueName="PL2" DataField="PL2Descriptor" HeaderText="pl2" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top"  />
                                   <telerik:GridBoundColumn  UniqueName="PL3" DataField="PL3Descriptor" HeaderText="ps3" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top"  />
                                   <telerik:GridBoundColumn  UniqueName="Pl4" DataField="PL4Descriptor" HeaderText="pl4" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top"  />
                                   <telerik:GridBoundColumn  UniqueName="Dsc" DataField="Description" HeaderText="DSC" ItemStyle-HorizontalAlign="Left" ItemStyle-VerticalAlign="Top"  />
                                    
                               </Columns> 
                            </MasterTableView>
                           </telerik:RadGrid>
 
    </div>
    </form>
</body>
</html>
