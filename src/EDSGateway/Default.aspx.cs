using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

using System.IdentityModel.Protocols.WSTrust;

using System.Security.Claims;
using System.Text;
using System.Security.Cryptography;

using StateEval.Core.Services;
using StateEval.Core.Utils;

namespace EDSGateway
{

    /*to test:
     * 
     * a) run this file, break in MyClientSite and grab the QS value for 'password'
     * b) call the token endpoint of the eVal web api, and feed it:
     * .. grant_type:password
     * .. username: [any reasonable string]
     * .. password: [the qs value grabbed above]
     * 
     * .This should result in the granting of a token
     * 
     * c) call the protected eval endpoint, inserting the 
     * .above acquired token, and verify that eval lets you grab the values
     * 
     * If all works, still need to:
     * .. change over the edsGateway to a WIF site
     * .. use a customClaimsAuthMgr and the EDSIntegrationLib to 
     *         process the incoming saml token, saving username,
     *         location and role values to db
     * .. setup the one time password in the database so it can be 
     *         checked downstream
     */
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
             * grab the username from the claim; (recall that all the roles have already
             * .. been squirreled away by the wif framework while processing the saml token
             * 
             * generate a one time password, and store in the seUser record
             * .. (consider re-encrypting this value, so that the pw is not stored
             * .. in clear text in the database)
             * 
             * generate an expiration time of some short duration
             * 
             * take the above three pieces of information and encrypt into a SecureQS
             * 
             * generate some random bogus user name
             * 
             * Take the random bogus username and the SecureQS and construct a
             * .. clear text querystring where userName = the bogus one, and password = the secureQS
             * 
             * append the querystring to the redirection to the index.html... 
             * .. here is where michael has to do his thing
             * 
             * Now, on the web api side, write the token endpoint which will take the password
             * .. and decrypt the query string with the user and password.  validate these
             * .. in the database with the value stored in OTPW.  If all is well, pass the
             * .. bearer token back to the client
             * 
             */


            string baseApplicationUrl = ConfigurationManager.AppSettings["ApplicationUrlBase"];
            ClaimsPrincipal principal = Page.User as ClaimsPrincipal;
            IEnumerable<Claim> claims = principal.Claims;

            string userName = "";
            foreach (Claim c in claims)
            {
                if (c.Type == ClaimTypes.Name)
                {
                    userName = c.Value;
                    long foo = 0;
                    bool isPersonId = long.TryParse(userName, out foo);
                    if (isPersonId)
                        userName = userName + "_edsUser";
                }
            }

            string otpw = GenRandomStringOfLength(15);
            string clearTextCompareKey = GenRandomStringOfLength(12);
            string fakePW = GenRandomStringOfLength(20);

            UserService userService = new UserService();
            userService.PersistOTPW(userName, otpw);

            SecureQueryString qs = new SecureQueryString();
            qs["userName"] = userName;
            qs["password"] = otpw;
            qs["compare"] = clearTextCompareKey;
            qs["expiration"] = DateTime.Now.AddMinutes(120).ToString();

            //In the query string:
            // username <- compareKey
            // password is nonsense
            // data is encrypted querystring
            string urlString = string.Format(baseApplicationUrl + "Default.aspx?userName={0}&password={1}&data={2}", clearTextCompareKey,fakePW, qs.EncryptedString);

            Response.Redirect(urlString);

        }

        public static string GenRandomStringOfLength(int maxSize)
        {
            char[] chars = new char[62];
            chars =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890".ToCharArray();
            byte[] data = new byte[1];
            using (RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider())
            {
                crypto.GetNonZeroBytes(data);
                data = new byte[maxSize];
                crypto.GetNonZeroBytes(data);
            }
            StringBuilder result = new StringBuilder(maxSize);
            foreach (byte b in data)
            {
                result.Append(chars[b % (chars.Length)]);
            }
            return result.ToString();
        }


    }

}