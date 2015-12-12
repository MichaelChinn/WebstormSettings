
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.OAuth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;

using StateEval.Core.Services;
using StateEval.Core.Utils;
using StateEval.Core.Constants;
using StateEvalData;
using System.Security.Cryptography;
using System.Text;

namespace webAPI.Providers
{

    /*
     * 
        INSERT dbo.ClientApp
                ( ClientAppId ,
                  Secret ,
                  Name ,
                  ClientAppType ,
                  RefreshTokenLifeTime ,
                  AllowedOrigin, 
                  isActive
     * 
                )
        VALUES  ( N'ngSEAuthApp' , -- ClientAppId - nvarchar(50)
                  N'fweljk339482fjklsdfjksd' , -- Secret - nvarchar(max)
                  N'Angular FrontEnd SE App' , -- Name - nvarchar(50)
                  0 , -- ClientAppType - smallint
                  7200 , -- RefreshTokenLifeTime - bigint
                  N'' , -- AllowedOrigin - nvarchar(100)
                  1
        )
     */
    public class SEAuthServerProvider : OAuthAuthorizationServerProvider
    {


        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            
            string clientId = string.Empty;
            string clientSecret = string.Empty;
            ClientApp client = null;

            if (!context.TryGetBasicCredentials(out clientId, out clientSecret))
            {
                context.TryGetFormCredentials(out clientId, out clientSecret);
            }

            if (context.ClientId == null)
            {
                //Remove the comments from the below line context.SetError, and invalidate context 
                //if you want to force sending clientId/secrects once obtain access tokens. 
                context.Validated();
                //context.SetError("invalid_clientId", "ClientId should be sent.");
                return Task.FromResult<object>(null);
            }

            UserService us = new UserService();

                client = us.FindClientApp(context.ClientId);


            if (client == null)
            {
                context.SetError("invalid_clientId", string.Format("Client '{0}' is not registered in the system.", context.ClientId));
                return Task.FromResult<object>(null);
            }

            if (client.ClientAppType == Convert.ToInt16(SEClientApplicationTypes.NativeConfidential))
            {
                //GetHash("There are 10 types of people in the world: those who understand binary, and those who don't.")
                //"bZBVfmaLQ69RYfPq/ut0w4YfBtwcAxL8lBnJ/I1s2Pw="

                if (string.IsNullOrWhiteSpace(clientSecret))
                {
                    context.SetError("invalid_clientId", "Client secret should be sent.");
                    return Task.FromResult<object>(null);
                }
                else
                {
                    if (client.Secret != us.GetHash(clientSecret))
                    {
                        context.SetError("invalid_clientId", "Client secret is invalid.");
                        return Task.FromResult<object>(null);
                    }
                }
            }

            bool clientIsActive = true;
            if ((client.IsActive == false) || (client.IsActive == null))
                clientIsActive = false;
            if (!clientIsActive)
            {
                context.SetError("invalid_clientId", "Client is inactive.");
                return Task.FromResult<object>(null);
            }

            context.OwinContext.Set<string>("as:clientAllowedOrigin", client.AllowedOrigin);
            context.OwinContext.Set<string>("as:clientRefreshTokenLifeTime", client.RefreshTokenLifeTime.ToString());
            
            context.Validated();
            return Task.FromResult<object>(null);
        }

        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            /*
             * In fact, the significant things posted to this endpoint are:
             * ..a) context.UserName
             * ..b) data
             * 
             * context.Password is just something i thought I'd throw in from the other
             * side because people expect to see it... it actually does nothing at all
             * 
             * the data is an encrypted name-value collection.  It contains the *real*
             * user name, the one-time password, an expiration date, and a 'compareKey'.
             * 
             * The one time password is stored in hashed form in the database, and was 
             * put there by the gateway before creating the packet and redirecting to the
             * client app. 
             * 
             * the userName form variable (not from the name-value collection above), is
             * the clearText 'compareKey'.  This was more necessary outbound from the gateway,
             * as the comparekey and data string are emitted as query string values.  I wanted
             * to make sure that the data string and compare key were kept together (i.e., no
             * replaying the data string with a different username) ... (which i guess, isn't
             * a real username anyway).
             * 
             */
            string userName = "";
            UserService userService = new UserService();

            var formVars = await context.Request.ReadFormAsync();
            string encryptedData = formVars["data"];

            if (encryptedData == null)
            {
                //here, we've logged in directly, and need to be authenticated from the local db

                if (!userService.VerifyHashedMembershipPW(context.UserName, context.Password))
                {
                    context.SetError("invalid_grant", "Direct PW invalid.");
                    return;
                }
            }
            else
            {
                SecureQueryString qs = new SecureQueryString(encryptedData);

                userName = qs["userName"];
                string otpw = qs["password"];
                string compareKeyQS = qs["compare"];
                string packageExpiration = qs["expiration"];

                if (compareKeyQS != context.UserName)
                {
                    context.SetError("invalid_grant", "The compareKey mismatch.");
                    return;
                }
                if (DateTime.Parse(packageExpiration) < DateTime.Now)
                {
                    context.SetError("invalid_grant", "The authorization info packet has expired.  Try to log in again from EDS");
                    return;
                }

                if (!userService.VerifyHashedOTPW(userName, otpw))
                {
                    context.SetError("invalid_grant", "OTPW invalid.");
                    return;
                }

                //well, if he makes it, you don't need this password anymore, right?
                userService.RemoveOTPW(userName);
            }
            var identity = new ClaimsIdentity(context.Options.AuthenticationType);
            identity.AddClaim(new Claim(ClaimTypes.Name, userName));
            
            /*
            identity.AddClaim(new Claim(ClaimTypes.Role, "user"));//TODO
            identity.AddClaim(new Claim("sub", userName));
             * 
             */

            var props = new AuthenticationProperties(new Dictionary<string, string>
                {
                    { 
                        "as:client_id", (context.ClientId == null) ? string.Empty : context.ClientId
                        //"as:client_id", string.Empty
                    },
                    { 
                        "userName", userName
                    }
                });

            DateTime midNightTonight = DateTime.Today.AddDays(1.0);


            var ticket = new AuthenticationTicket(identity, props);
            ticket.Properties.ExpiresUtc = midNightTonight.ToUniversalTime();
            context.Validated(ticket);

        }

        public override Task GrantRefreshToken(OAuthGrantRefreshTokenContext context)
        {
            var originalClient = context.Ticket.Properties.Dictionary["as:client_id"];
            var currentClient = context.ClientId;

            if (originalClient != currentClient)
            {
                context.SetError("invalid_clientId", "Refresh token is issued to a different clientId.");
                return Task.FromResult<object>(null);
            }

            // Change auth ticket for refresh token requests
            var newIdentity = new ClaimsIdentity(context.Ticket.Identity);

            var newClaim = newIdentity.Claims.Where(c => c.Type == "newClaim").FirstOrDefault();
            if (newClaim != null)
            {
                newIdentity.RemoveClaim(newClaim);
            }
            newIdentity.AddClaim(new Claim("newClaim", "newValue"));

            var newTicket = new AuthenticationTicket(newIdentity, context.Ticket.Properties);
            context.Validated(newTicket);

            return Task.FromResult<object>(null);
        }

        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }

        private static string EncryptPassword(string pass, int passwordFormat, string salt, HashAlgorithm algorithm)
        {
            if (passwordFormat == 0) // MembershipPasswordFormat.Clear
                return pass;

            byte[] bIn = Encoding.Unicode.GetBytes(pass);
            byte[] bSalt = Convert.FromBase64String(salt);
            byte[] bRet = null;

            if (passwordFormat == 1)
            { // MembershipPasswordFormat.Hashed 
                HashAlgorithm hm = algorithm;
                if (hm is KeyedHashAlgorithm)
                {
                    KeyedHashAlgorithm kha = (KeyedHashAlgorithm)hm;
                    if (kha.Key.Length == bSalt.Length)
                    {
                        kha.Key = bSalt;
                    }
                    else if (kha.Key.Length < bSalt.Length)
                    {
                        byte[] bKey = new byte[kha.Key.Length];
                        Buffer.BlockCopy(bSalt, 0, bKey, 0, bKey.Length);
                        kha.Key = bKey;
                    }
                    else
                    {
                        byte[] bKey = new byte[kha.Key.Length];
                        for (int iter = 0; iter < bKey.Length; )
                        {
                            int len = Math.Min(bSalt.Length, bKey.Length - iter);
                            Buffer.BlockCopy(bSalt, 0, bKey, iter, len);
                            iter += len;
                        }
                        kha.Key = bKey;
                    }
                    bRet = kha.ComputeHash(bIn);
                }
                else
                {
                    byte[] bAll = new byte[bSalt.Length + bIn.Length];
                    Buffer.BlockCopy(bSalt, 0, bAll, 0, bSalt.Length);
                    Buffer.BlockCopy(bIn, 0, bAll, bSalt.Length, bIn.Length);
                    bRet = hm.ComputeHash(bAll);
                }
            }

            return Convert.ToBase64String(bRet);
        }

    }
}