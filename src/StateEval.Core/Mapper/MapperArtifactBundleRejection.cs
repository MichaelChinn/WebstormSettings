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
        public static SEArtifactBundleRejection MaptoSEArtifactBundleRejection(
            this ArtifactBundleRejectionModel source, StateEvalEntities evalEntities, SEArtifactBundleRejection target = null)
        {
            target = target ?? new SEArtifactBundleRejection();
            target.ArtifactBundleRejectionID = source.Id;
            target.ArtifactBundleID = source.ArtifactBundleId;
            target.CommunicationSessionKey = source.CommunicationSessionKey;
            target.RejectionTypeID = source.RejectionType;
            target.CreatedByUserID = source.CreatedByUserId;

            List<CommunicationModel> toAdd = source.Communications.Where(n => !evalEntities.SECommunications.Select(db => db.CommunicationID).Contains(n.Id)).ToList();

            toAdd.ForEach(x =>
            {
                SECommunication communication = new SECommunication();
                x.CreationDateTime = DateTime.Now;
                x.SessionKey = source.CommunicationSessionKey;
                evalEntities.SECommunications.Add(x.MaptoSECommunication(communication));
            });

            return target;
        }

        public static ArtifactBundleRejectionModel MaptoArtifactBundleRejectionModel(
            this SEArtifactBundleRejection source, StateEvalEntities evalEntities, ArtifactBundleRejectionModel target = null)
        {
 
            target = target ?? new ArtifactBundleRejectionModel();
            target.Id = source.ArtifactBundleRejectionID;
            target.ArtifactBundleId = source.ArtifactBundleID;
            target.CommunicationSessionKey = source.CommunicationSessionKey;
            target.RejectionType = source.RejectionTypeID;
            target.CreatedByUserId = source.CreatedByUserID;

            // Get all the communications that have the same session key as the rejection

            // TODO: trouble comparing sessionkey GUIDs in LINQ, so cast them to strings and compare in a loop
            target.Communications = new List<CommunicationModel>();
            List<SECommunication> list = evalEntities.SECommunications.ToList();
            list.ForEach(x =>
                {
                    string sessionKeyDb = x.CommunicationSessionKey.ToString();
                    string sourceKey = source.CommunicationSessionKey.ToString();
                    if (sessionKeyDb == sourceKey)
                    {
                        target.Communications.Add(x.MaptoCommunicationModel());
                    }
                });

            return target;
        }
    }
}