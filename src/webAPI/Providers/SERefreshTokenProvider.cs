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
using StateEvalData;
using Microsoft.Owin.Security.Infrastructure;

namespace webAPI.Providers
{
    public class SERefreshTokenProvider : IAuthenticationTokenProvider
    {

        /* ... what you need to initialize the clients table 
         
        INSERT dbo.ClientApp
                ( ClientAppId ,
                  Secret ,
                  Name ,
                  ClientAppType ,
                  RefreshTokenLifeTime ,
                  AllowedOrigin,
				  isActive
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
        public async Task CreateAsync(AuthenticationTokenCreateContext context)
        {
            var clientid = context.Ticket.Properties.Dictionary["as:client_id"];

            if (string.IsNullOrEmpty(clientid))
            {
                return;
            }

            var refreshTokenId = Guid.NewGuid().ToString("n");
            TimeSpan untilMidnight = DateTime.Today.AddDays(1.0) - DateTime.Now;
            double nSeconds = untilMidnight.TotalSeconds;

            //using (AuthRepository _repo = new AuthRepository())  //.... TODO??
            //{
            UserService us = new UserService();

            var refreshTokenLifeTime = context.OwinContext.Get<string>("as:clientRefreshTokenLifeTime");

            var token = new RefreshToken()
            {
                RefreshTokenId = us.GetHash(refreshTokenId),
                ClientAppId = clientid,
                Subject = context.Ticket.Identity.Name,
                IssuedUtc = DateTime.UtcNow,
                //ExpiresUtc = DateTime.UtcNow.AddMinutes(Convert.ToDouble(refreshTokenLifeTime))
                ExpiresUtc = DateTime.UtcNow.AddSeconds(nSeconds)
            };

            context.Ticket.Properties.IssuedUtc = token.IssuedUtc;
            context.Ticket.Properties.ExpiresUtc = token.ExpiresUtc;

            token.ProtectedTicket = context.SerializeTicket();

            var result = await us.AddRefreshToken(token);

            if (result)
            {
                context.SetToken(refreshTokenId);
            }

            //}
        }

        public async Task ReceiveAsync(AuthenticationTokenReceiveContext context)
        {

            var allowedOrigin = context.OwinContext.Get<string>("as:clientAllowedOrigin");
            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { allowedOrigin });


            //using (AuthRepository _repo = new AuthRepository()) //.... TODO??
            //{

            UserService us = new UserService();
            string hashedTokenId = us.GetHash(context.Token);

            var refreshToken = await us.FindRefreshToken(hashedTokenId);

            if (refreshToken != null)
            {
                //Get protectedTicket from refreshToken class
                context.DeserializeTicket(refreshToken.ProtectedTicket);
                var result = await us.RemoveRefreshToken(hashedTokenId);
            }
            // }
        }

        public void Create(AuthenticationTokenCreateContext context)
        {
            throw new NotImplementedException();
        }

        public void Receive(AuthenticationTokenReceiveContext context)
        {
            throw new NotImplementedException();
        }
    }
}