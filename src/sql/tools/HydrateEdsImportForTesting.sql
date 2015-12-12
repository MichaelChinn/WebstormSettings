SELECT * FROM edsUsersv1

INSERT dbo.EDSUsersV1
        ( PersonId ,
          FirstName ,
          LastName ,
          Email ,
          PreviousPersonId ,
          LoginName ,
          EmailAddressAlternate ,
          CertificateNumber
        )


SELECT personid, firstName, lastname, email, previousPersonid, loginName, emailaddressAlternate, certificateNumber FROM stateeval_baseline.dbo.edsUsersv1

INSERT dbo.EDSRolesV1
        ( PersonId ,
          OrganizationName ,
          OSPILegacyCode ,
          OrganizationRoleName
        )
SELECT
 PersonId ,
          OrganizationName ,
          OSPILegacyCode ,
          OrganizationRoleName
		  FROM stateeval_baseline.dbo.edsRolesv1