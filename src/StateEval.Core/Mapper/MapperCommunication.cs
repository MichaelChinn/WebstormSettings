using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data.Entity;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using StateEval.Core.Models;
using StateEvalData;

namespace StateEval.Core.Mapper
{
    public static partial class Mapper
    {
        public static SECommunication MaptoSECommunication(
            this CommunicationModel source, SECommunication target = null)
        {
            target = target ?? new SECommunication();
            target.CommunicationID = source.Id;
            target.CommunicationSessionKey = source.SessionKey;
            target.CreatedByUserID = source.CreatedByUserId;
            target.CreationDateTime = source.CreationDateTime;
            target.Message = source.Message;

            return target;
        }

        public static CommunicationModel MaptoCommunicationModel(
            this SECommunication source, CommunicationModel target = null)
        {

            target = target ?? new CommunicationModel();
            target.Id = source.CommunicationID;
            target.SessionKey = source.CommunicationSessionKey;
            target.CreatedByUserId = source.CreatedByUserID;
            target.CreationDateTime = source.CreationDateTime;
            target.Message = source.Message;

            return target;

        }
    }
}