//-----------------------------------------------------------------------------
//
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
//
//-----------------------------------------------------------------------------

using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.Profile;
using System.Data.SqlClient;

public partial class Login : System.Web.UI.Page
{

    public string SEVersion { get;set; } 
    public string Banner1 { get; set; }
    public string Banner2 { get; set; }

    protected void Page_Load( object sender, EventArgs e )
    {
        trLine1.Visible = false;
        trLine2.Visible = false;
        SEVersion = ConfigurationManager.AppSettings["version"];
        Banner1 = ConfigurationManager.AppSettings["Banner1"];
        Banner2 = ConfigurationManager.AppSettings["Banner2"];

        if (Banner1.Length != 0)
        {
            HtmlTableCell tdLine1 = new HtmlTableCell();
            tdLine1.InnerHtml = "<h2>" + Banner1 + "</h2>";
            tdLine1.Align = "center";
            HtmlTableCell tdLine2 = new HtmlTableCell();
            tdLine2.InnerHtml = "<h3>" + Banner2 + "</h3>";
            tdLine2.Align = "center";

            trLine1.Controls.Add(tdLine1);
            trLine2.Controls.Add(tdLine2);

            trLine1.Visible = true;
            trLine2.Visible = true;


        }
    }
    
    protected void OnLoginError(object sender, EventArgs e)
    {
  
        ClientScript.RegisterStartupScript(this.GetType(), "LoginError",
        String.Format("alert('{0}');", Login1.FailureText.Replace("'", "\'")), true);
    }
    protected void OnAuthenticateUser(object sender, AuthenticateEventArgs e)
    {
        bool lockedOut = false;
        string userName = Login1.UserName.Trim();

        //Check if valid username and lockout status
        MembershipUserCollection muColl = Membership.FindUsersByName(userName);
        if (muColl.Count > 0)
        {
            MembershipUser mu = (MembershipUser)muColl[userName];
            if (mu.IsLockedOut)
            {
                Login1.FailureText = "Your login is locked out.  Please contact your administrator.";
                lockedOut = true;
            }
        }

        if (lockedOut)
            return;

        e.Authenticated = Membership.ValidateUser(userName, Login1.Password);
        if (!e.Authenticated)
        {
            return;
        }

   
    }

}
