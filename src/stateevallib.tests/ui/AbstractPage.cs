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
    abstract class AbstractPage
    {
        static public string SiteUrl { get { return "http://localhost/stateeval/"; } }
        static public string BuildUrl(string page) { return SiteUrl + "/" + page; }

        static public string GetPageUrl(string pageName)
        {
            return SiteUrl + "/" + pageName;
        }

        static public IE NavigateToPage(string pageName)
        {
            return new IE(SiteUrl + "/" + pageName);
        }
        static public void NavigateToPageFromNavBar(IE ie, string pageName)
        {
            ie.Link(Find.ByUrl(SiteUrl + "/" + pageName)).Click();
        }
    }
}
