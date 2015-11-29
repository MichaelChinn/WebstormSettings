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
    class LoginPage : AbstractPage 
    {
        static public IE NavigateTo()
        {
            return NavigateToPage("Login.aspx");
        }
    }
}
