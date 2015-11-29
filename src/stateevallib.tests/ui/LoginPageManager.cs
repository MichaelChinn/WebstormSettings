using System;
using System.IO;
using System.Threading;
using WatiN.Core;
using WatiN.Core.DialogHandlers;
using WatiN.Core.Exceptions;
using WatiN.Core.Interfaces;
using WatiN.Core.Logging;
using NUnit.Framework;

namespace stateevallib.tests.ui
{
    class LoginPageManager
    {
        const string password = "password";

        static public IE NavigateToLoginPage()
        {
            return LoginPage.NavigateTo();
        }

        static public void SignIn(IE ie, string username, string password)
        {
            ie.TextField(Find.ByName("ctl00$MainContent$Login1$UserName")).TypeText(username);
            ie.TextField(Find.ByName("ctl00$MainContent$Login1$Password")).TypeText(password);
            ie.Button(Find.ByName("ctl00$MainContent$Login1$LoginButton")).Click();
        }

        static public void SignOut(IE ie)
        {
        //    ie.Link(Find.ByUrl("javascript:__doPostBack('ctl00$ucHeader$LoginStatus1$ctl00','')")).Click();
        }

        static public void SignInAsUser(IE ie, string userName)
        {
            SignIn(ie, userName, password);
        }
    }
}
