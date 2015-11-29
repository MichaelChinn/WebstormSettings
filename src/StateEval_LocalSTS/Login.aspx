<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link rel="stylesheet" type="text/css" href="includes/styles.css" />
</head>
<body scroll="yes" style="height: 100%; margin: 0">
    <form runat="server" id="form1" method="post">
    <div id="unauthenticated">
        <div id="unauthenticated_header">
            <img src="images/eval_Logo.png" id="logo" alt="State Eval" border="0px" />
        </div>
        <div id="unauthenticated_maincontent">
            <br />
            <table id='tbMain' runat='server' cellpadding="2" cellspacing="0" width="100%">
                <tr id="trLine1" runat="server">
                </tr>
                <tr id="trLine2" runat="server">
                </tr>
                
                <tr>
                    <td align="center" height="250">
                        <table cellspacing="2" cellpadding="6">
                            <tr>
                                <td align="left">
                                    <asp:Login ID="Login1" CssClass="login" TitleText="" DisplayRememberMe="false" runat="server"
                                        OnLoginError="OnLoginError" OnAuthenticate="OnAuthenticateUser">
                                        <LayoutTemplate>
                                            <table border="0" cellpadding="1" cellspacing="0" style="border-collapse: collapse;"
                                                class="loginbox">
                                                <tr>
                                                    <td align="center" rowspan="3" style="padding: 15px; font-weight: bold; color: white;
                                                        background-color: #6b696b">
                                                        Log In
                                                    </td>
                                                    <td style="width: 8px;">
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="UserName" runat="server" TabIndex="1" Columns="30"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                            ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                                    </td>
                                                    <td align="center" rowspan="3" style="padding: 15px;">
                                                        <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log In" ValidationGroup="Login1"
                                                            TabIndex="4" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 8px;">
                                                    </td>
                                                    <td align="right">
                                                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="Password" runat="server" TextMode="Password" TabIndex="2"></asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                            ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 8px;">
                                                    </td>
                                                    <td colspan="2">
                                                        <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time." TabIndex="3" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                                                ValidationGroup="Login1" ShowSummary="False" />
                                        </LayoutTemplate>
                                    </asp:Login>
                                </td>
                            </tr>
                            <tr><td align='center'><div style="font-style:italic;font-size:small">for help, call 1-360-464-6708</div></td></tr>
                            <tr>
                                <td align='center'>
                                    <div class="footer">
                                        © 2011, 2012 WEA, OSPI and ESD 113 &nbsp;&nbsp;&nbsp;Build
                                        <%=SEVersion%></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
