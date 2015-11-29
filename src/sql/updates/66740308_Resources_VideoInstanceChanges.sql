
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 66740308
, @title = 'New Resources section - Instance'
, @comment = ''
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

/*
SELECT * FROM dbo.SETrainingProtocol
*/

DECLARE @UserName VARCHAR(100), @AppName VARCHAR(24)
DECLARE @utcDate DATETIME

SELECT @utcDate = getutcdate()
SELECT @AppName = 'SE'
SELECT @UserName = 'happlewhite'
EXEC dbo.InsertSEUser
	@pUserName=@UserName, @pFirstname='Hannah', @pLastName='Applewhite', @pEMail='happlewhite@esd113.org'
EXEC dbo.aspnet_UsersInRoles_AddUsersToRoles @AppName, @UserName, 'SESuperAdmin', @utcDate

DECLARE @ProtocolID BIGINT

INSERT dbo.SEPracticeSessionType(Name) VALUES('LIVE')
INSERT dbo.SEPracticeSessionType(Name) VALUES('VIDEO')

UPDATE SETrainingProtocol SET ImageName='video96.png' WHERE TrainingProtocolID=1
UPDATE SETrainingProtocol SET AvgRating=0

IF NOT EXISTS (SELECT ArtifactTypeID FROM SEArtifactType WHERE Name='Link to Video')
BEGIN
	INSERT dbo.SEArtifactType(Name) VALUES('Link to Video')
END

INSERT dbo.SETrainingProtocolRatingStatusType(Name) VALUES('InReview')
INSERT dbo.SETrainingProtocolRatingStatusType(Name) VALUES('Approved')
INSERT dbo.SETrainingProtocolRatingStatusType(Name) VALUES('Inappropriate')
	
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Social Studies', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Science', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('English/Language Arts', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Art', 1)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('CTE', 1)

INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Intermediate', 2)

INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('ProvidedBy')

-- ProvidedBy Areas
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('National Board', 4)
INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('BERC Group', 4)
	
/* Allison King - Grade 4 Social Studies Post Part1 */			
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Allison King - Grade 4 Social Studies Post Part1', '15:18', 
		'Social Studies Post - Part 1',
		'This 4th grade social studies lesson focuses on explorers of the Northwest. Teacher has students discuss different aspects about exploring new places and how personal experiences relate to historical experiences.',
		'https://evalwashington.blob.core.windows.net/asset-dd9738c6-7a0f-4900-87d7-2c754c03bcce/King_Allison_4_Social_Studies_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-11T19%3A27%3A44Z&se=2016-04-10T19%3A27%3A44Z&sr=c&si=a39e595e-9074-4cbd-bb77-b60aebb9438f&sig=Ylo4S8MbTSW8F2qr0sAOPahCLI5haPxzzAjiTeg1jAo%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-cf37d450-b45b-47cf-a91c-87ee7f61cfdd/King_Allison_4_Social_Studies_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.1800091.jpg?sv=2012-02-12&se=2029-05-03T07:23:41Z&sr=c&si=7a22311e-109b-4c02-826a-898de79e80aa&sig=Jt%2BzoNsl%2B8hJxpedfeW4QaTmYN4khc2mbAC5hrWaKN0%3D')
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Intermediate', 'BERC Group')

/* Allison King Grade 4 Social Studies Post Part2 */		
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Allison King Grade 4 Social Studies Post Part2', '13:34', 
		'Social Studies Post - Part 2',
		'Each group has been assigned an explorer. Students discuss amongst themselves their different topics. Students then teach each other in their expert groups. Finally, students are given a self-assessment to evaluate their performance.',
		'https://evalwashington.blob.core.windows.net/asset-dfba5cfc-781e-450b-a89d-950c9fc7f25f/King_Allison_4_Social_Studies_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-11T19%3A24%3A59Z&se=2016-04-10T19%3A24%3A59Z&sr=c&si=e62fdca2-0e2e-4e2b-93af-cd20cb0c93d3&sig=%2FElMU8vUplJnZQLYzrSmAQYvcsCJnpm9YToVOesCTgE%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-36e77c50-a589-45d9-b5f6-dc6b19d5f50f/King_Allison_4_Social_Studies_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.1423093.jpg?sv=2012-02-12&se=2029-05-03T07:24:46Z&sr=c&si=bd3ede96-a372-4101-949b-17806561f9f0&sig=W3N%2Bk2qauQ3SFRBlPz1G8ZOEc7J2ZcSDWhsvH2E4zKE%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Intermediate', 'BERC Group')
		
/* Ami McMoran Grade K English Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Ami McMoran Grade K English Post Part1', '14:38', 
		'English Post - Part 1',
		'This 1st grade English lesson begins with a review of spelling to create the long “a” sound. Students learn about blending, in which adding an “e” onto the end of a word such as “can” turns it into “cane” with a long “a” sound. They continue on to learn new words “said” and “that.”',
		'https://evalwashington.blob.core.windows.net/asset-3ef2d410-e2e1-4e43-82fc-a93b9cb06fb3/McMoran_Ami_K_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-12T01%3A49%3A06Z&se=2016-04-11T01%3A49%3A06Z&sr=c&si=c2d07ce8-acd8-4dd5-ba84-d609eb3c2183&sig=7E3LJ2b%2FvcgXFrZpyeNR%2F5HE1TtA3plOOfDS9oqmQGI%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-a25e452b-5308-4050-b1f9-fc957cdc1684/McMoran_Ami_K_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.7838766.jpg?sv=2012-02-12&se=2029-05-03T07:21:41Z&sr=c&si=b8ec44c0-c7db-41e4-9685-b0358a9c985f&sig=F2j5uATZlaJp0cBJxHcOWJK2bI3vtSmMrSkvz1s7xac%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')

				
/* Ami McMoran Grade K English Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Ami McMoran Grade K English Post Part2', '15:12', 
		'English Post - Part 2',
		'Class discusses new decodable book they will begin reading the next day. They learn five new words they will encounter in their books. Students are given an assignment to sound out four new words and draw a picture of each.',
		'https://evalwashington.blob.core.windows.net/asset-f2f0b7f9-cab9-4255-927d-7b465252b9e8/McMoran_Ami_K_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-11T21%3A19%3A58Z&se=2016-04-10T21%3A19%3A58Z&sr=c&si=fd482255-47f7-4903-a7af-afd653ef70a8&sig=yZjKXrUeRkohTjOMPwmBIO7LmJqIBgFll4fwgUnx7l8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-cb5014c9-f62a-463f-83c7-449fe2c37b89/McMoran_Ami_K_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.1289252.jpg?sv=2012-02-12&se=2029-05-03T07:22:47Z&sr=c&si=7a0af52a-568e-46ec-aa4b-ea40b137e7d7&sig=CDFZ8gz%2BMK%2BnhHwHG4WDfUSr0cKWZfEhbkkIVoT30AY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')
		
/* Ami McMoran Grade K English Post Part3 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Ami McMoran Grade K English Post Part3', '18:08', 
		'English Post - Part 3',
		'Teacher meets with groups of four students and has them work on writing the letter A. Meanwhile, other students finish their assignment, then are instructed to draw and label their own pictures. Students share the pictures they drew and words they wrote. Finally, class reviews their new five words.',
		'https://evalwashington.blob.core.windows.net/asset-bf73fdd2-ae09-4077-9da6-97fb7ca5c8f0/McMoran_Ami_K_English_Post_Part3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-12T02%3A29%3A03Z&se=2016-04-11T02%3A29%3A03Z&sr=c&si=d305887e-f207-4292-bce7-cae2c65a476c&sig=fKLWBIP9lSx2hO7S9EAPWeHixjVVTrvyY401hHXydQk%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-241cb338-42cb-4349-b4d5-ddb0d7d2bb32/McMoran_Ami_K_English_Post_Part3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.8852825.jpg?sv=2012-02-12&se=2029-05-03T07:20:30Z&sr=c&si=ff73b9fb-bbe4-49b5-8ca8-c713b35c403a&sig=j66d1ovP4xRe%2FlAKPdXxySPmsRd2nN6QLa6KeiQD8Ko%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')
	
		
/* Andi Manion Grade 9 English Post Part1 */		
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Andi Manion Grade 9 English Post Part1', '17:12', 
		'English Post - Part 1',
		'This 9th grade English class begins with students rating their understanding of the play “Romeo and Juliet.” Students then review the series of events and place them in order of occurrence.',
		'https://evalwashington.blob.core.windows.net/asset-30d01bf0-60c1-4de3-ba11-c5d162be9201/Manion_Andi_9_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-12T05%3A54%3A39Z&se=2016-04-11T05%3A54%3A39Z&sr=c&si=13dc889f-f09d-47d6-a366-ac11d8bb27ef&sig=wqp9ZvIYLLCVyRdj5GHcRUnn5W0mN%2BYTxiNOkWserGo%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-b716f588-c312-47d8-b204-c005aa4f7a5d/Manion_Andi_9_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.3280036.jpg?sv=2012-02-12&se=2029-05-03T07:18:34Z&sr=c&si=14c8c8bb-3758-4a0f-a385-ac913a2c0d17&sig=YFCzvTzdcLHU%2BIPwN6XBvWpjN9tfDS6e2hYxuNbavaM%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')

/* Andi Manion Grade 9 English Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Andi Manion Grade 9 English Post Part2', '13:42', 
		'English Post - Part 2',
		'Students continue work on ordering events of the play and once finished and the class has discussed, move onto rating their understanding post-activity. Finally, they begin ordering the events by what they believe to be the most crucial parts of the play.',
		'https://evalwashington.blob.core.windows.net/asset-582db6dd-d567-4c5e-b854-ac837dab8b34/Manion_Andi_9_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-12T05%3A54%3A30Z&se=2016-04-11T05%3A54%3A30Z&sr=c&si=35678d9f-e6c4-4207-8ada-b0081ec51ee5&sig=ceZVLPKWHODCZ7GJRaxgSGaAjQVJ%2Fu%2Bb%2FBQNaL4zqEs%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-6a3a0459-e2b0-4576-9216-2fe9212ca704/Manion_Andi_9_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.2226503.jpg?sv=2012-02-12&se=2029-05-03T07:19:35Z&sr=c&si=a6b6486b-f86b-4b9a-bc2c-e04d3914b168&sig=OSqxsmFiH6aLIV3SeQxwqTQbaGEZaFFt69FCWLl%2BpKY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')
		
/* Annie Douglas Grade 2 Math Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Annie Douglas Grade 2 Math Post Part1', '17:45', 
		'Math Post - Part 1',
		'This 2nd grade math class begins with students working in groups to discuss different strategies they used to complete their work. Next, they review fractions and measurements.',
		'https://evalwashington.blob.core.windows.net/asset-28063a99-6197-4b82-a4de-bcdab293d3cd/Douglas_Annie_2_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A23%3A35Z&se=2016-04-14T04%3A23%3A35Z&sr=c&si=dc6331cf-63f7-49be-88d9-ddee529862b9&sig=EHlcWl5VNj7Y0RqPhkPcYvjmArTz3beVWt6mYynOqiY%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-3a37bfb5-716a-4899-ab3f-cc530bbbc11f/Douglas_Annie_2_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.6567982.jpg?sv=2012-02-12&se=2029-05-03T07:11:52Z&sr=c&si=21175e4f-4300-45f7-b4cf-f4b55e5ca158&sig=aXVVVcmy1nEZvLxhFMot3HuW6pvFWi4FfLnTVbp%2BetM%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary')

	
/* Annie Douglas Grade 2 Math Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Annie Douglas Grade 2 Math Post Part2', '18:57', 
		'Math Post - Part 2',
		'Teacher instructs students to work on a new measuring task in groups. The class ends with a lesson about finding the perimeter of various rectangular objects.',
		'https://evalwashington.blob.core.windows.net/asset-9e566566-5a80-4ab2-90f9-9706e55b7702/Douglas_Annie_2_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A23%3A32Z&se=2016-04-14T04%3A23%3A32Z&sr=c&si=4c868554-4fb9-4dcf-b004-c4e225d45ee7&sig=xLgMWVZ%2Fe%2Blq8FOnq2AcfFeQxGHcESDZ5MTLFdo0Cso%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-c28e451e-0977-48bd-9848-59bf2f9ca9e7/Douglas_Annie_2_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.3708117.jpg?sv=2012-02-12&se=2029-05-03T07:10:37Z&sr=c&si=9bb5a923-9b14-4726-ab1b-d5d219e12473&sig=skBLqQL7jOldJJgX0llydCQQrGCgzflN1i9KNHgOues%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'BERC Group')

		
/* Beth Conroy Humphrey Grade 3 English Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Beth Conroy Humphrey Grade 3 English Post Part1', '13:42', 
		'English Post - Part 1',
		'This 3rd grade English lesson begins by reading together a poem and article and finding the main idea between the two.',
		'https://evalwashington.blob.core.windows.net/asset-f5b83230-1c62-4ce1-9269-044221560ddb/Conroy-Humphrey_Beth_3_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A23%3A25Z&se=2016-04-14T04%3A23%3A25Z&sr=c&si=025723e6-d6e7-44ce-99bc-abe1c2c5a845&sig=jmGPiOTVqulGbtclHMzsBGBFxT4U6qGXVKyxnKnhtSs%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-e7ce7263-79e5-480d-85d1-696e6e2bca94/Conroy-Humphrey_Beth_3_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.2219537.jpg?sv=2012-02-12&se=2029-05-03T07:09:35Z&sr=c&si=334f1437-78af-4fc0-b0c4-3c181f668fc3&sig=hkixfXTRkceYzWNWnb7bUXyW%2F2v%2FSgW7p4wdwrQdr0k%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Intermediate', 'BERC Group')


/* Bonnie Bushaw Grade 5 Math Pre Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Bonnie Bushaw Grade 5 Math Pre Part1', '14:27', 
		'Math Pre - Part 1',
		'This 5th grade math lesson begins by defining fractions. The students read definitions aloud and begin a review of multiplying and dividing fractions.',
		'https://evalwashington.blob.core.windows.net/asset-812a8ca3-1c2b-4784-a70c-5f1e4da76838/Bushaw_Bonnie_5_Math_Pre_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A23%3A52Z&se=2016-04-14T04%3A23%3A52Z&sr=c&si=8cb343f5-d51f-4b98-beae-ae444f828bd9&sig=u5pltFvDP9wmcRK3lr6ZR2sUD8B6Oh%2BXKpJGpV4WDXI%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-65ff3295-8392-4209-bf20-ac445404e481/Bushaw_Bonnie_5_Math_Pre_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.6747428.jpg?sv=2012-02-12&se=2029-05-03T07:14:05Z&sr=c&si=ab8bccbc-3802-412f-bbb6-a821cf49f062&sig=mClwWEXiXLCTcvc%2FBakKkWy16wPdUhdWqgxzxsMnXMI%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')

	
/* Bonnie Bushaw Grade 5 Math Pre Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Bonnie Bushaw Grade 5 Math Pre Part2', '13:24', 
		'Math PRe - Part 2',
		'The teacher puts math problems up on the projector and the class works together to solve each of them.',
		'https://evalwashington.blob.core.windows.net/asset-cc01d98f-d6cd-4437-bb2d-f68879b81efc/Bushaw_Bonnie_5_Math_Pre_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A23%3A50Z&se=2016-04-14T04%3A23%3A50Z&sr=c&si=0c4cc0c8-4f5e-4836-9c76-8de21cf810b3&sig=hZJqUzmoffeDiEbJ3hE9X438k7Ny8OB5%2BfESAkLj%2BeU%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-d32399e2-bc6a-4f6a-b211-7d51e8ee97d4/Bushaw_Bonnie_5_Math_Pre_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.0466431.jpg?sv=2012-02-12&se=2029-05-03T07:12:51Z&sr=c&si=282361b7-b9ee-4e38-b44e-f8a62ddfa4c1&sig=%2B%2B%2FMEDFBK%2FC3zqqna%2FAXEzjLjni0MkgkC7FtArZ23kg%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')

/* Bonnie Bushaw Grade 5 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Bonnie Bushaw Grade 5 Math Post Part1', '13:24', 
		'Math Post - Part 1',
		'This 5th grade math lesson focuses on dividing fractions. The teacher asks how many muffins each student would get if there were a certain amount of muffins and a specific amount of students in a classroom.',
		'https://evalwashington.blob.core.windows.net/asset-14b7d9fc-32fe-421e-99e9-c1e5bf8cee1c/Bushaw_Bonnie_5_Math_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A24%3A14Z&se=2016-04-14T04%3A24%3A14Z&sr=c&si=f25c72be-91c8-4315-866f-29bcc8fc722a&sig=EPDoabO2%2BEbat%2Bu3mmd2%2BhsNxFvmq3CknnzKfk0UkBU%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-50088030-6780-443c-9e21-cef28d631eea/Bushaw_Bonnie_5_Math_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.0426956.jpg?sv=2012-02-12&se=2029-05-03T07:16:31Z&sr=c&si=bea49991-5c80-411f-bc28-bace122271ec&sig=x75pVf6xiq59wKyfY49lUC9t0osOivta5w2aIPc%2FBGA%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')
	
/* Bonnie Bushaw Grade 5 Math Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Bonnie Bushaw Grade 5 Math Post Part2', '12:32', 
		'Math Post - Part 2',
		'The teacher shows the students a number line to help introduce them to dividing fractions.',
		'https://evalwashington.blob.core.windows.net/asset-9d276808-8c41-4d6b-aae3-bafc23a1ef21/Bushaw_Bonnie_5_Math_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A24%3A18Z&se=2016-04-14T04%3A24%3A18Z&sr=c&si=b8ea962c-c9b4-4a1e-8b40-ab1ecf98d0df&sig=%2B9bBthe2TnSxLbQfJ2xnGnOMscTGlJibZ%2FzZjrwSi4w%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7765241c-9079-4ea1-81df-cd490e5547e2/Bushaw_Bonnie_5_Math_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.07.5225686.jpg?sv=2012-02-12&se=2029-05-03T07:17:22Z&sr=c&si=95842d9c-3c89-418c-a228-cdb1d0e9c655&sig=sgd4Jhoa3a4LnD3pMdtw6cEF36f4SwV0%2Ffhlhu2MJ0w%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')
	
/* Bonnie Bushaw Grade 5 Math Post Part3 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Bonnie Bushaw Grade 5 Math Post Part3', '16:34', 
		'Math Post - Part 3',
		'The class uses story problems to review division of fractions.',
		'https://evalwashington.blob.core.windows.net/asset-2dec19fc-32a1-41f9-a0fa-5cb4fb5ab824/Bushaw_Bonnie_5_Math_Post_Part3_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A23%3A18Z&se=2016-04-14T04%3A23%3A18Z&sr=c&si=4a0b093b-6023-4826-b2e2-fc855d517576&sig=BNTJlf%2BoP64vZwPNklPSUNNzLCH%2F9SbLMOtnPCu0auk%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-397af505-8b6c-4d82-b0cb-2cfcb9036352/Bushaw_Bonnie_5_Math_Post_Part3_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.9441777.jpg?sv=2012-02-12&se=2029-05-03T07:15:20Z&sr=c&si=949e9b77-027d-41b6-8a6d-61a64ce378c4&sig=28wtiBn16UNRQDP03CnTC5wMtpp6%2B9RL0LugumHO2%2FA%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')


/* Brad Demond Grade 10 English Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Brad Demond Grade 10 English Post Part1', '15:47', 
		'English Post - Part 1',
		'This 10th grade English class focuses on the similarities and differences between the literary elements in Kitchen and Sound of Waves.',
		'https://evalwashington.blob.core.windows.net/asset-c8d03b22-ec26-4479-a918-f760f73efe8c/Demond_Brad_10_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A22%3A40Z&se=2016-04-14T04%3A22%3A40Z&sr=c&si=66a9bd6a-c809-4e3e-bfa2-4682197e60dd&sig=oadQSjvaVi0Ibp373p%2Bh1TW5jUWi1nfLaHCabmbdYTI%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7746886d-2b2c-4479-bdf5-8235d4d5a948/Demond_Brad_10_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.4772244.jpg?sv=2012-02-12&se=2029-05-03T07:08:25Z&sr=c&si=1e3bf305-ec11-4f1d-9b3d-780b3b76529a&sig=OFfah8EDXzukxyRfVcjwbjq25UyD7jWf7CWuA7gWhL8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')
	
/* Brad Demond Grade 10 English Post Part2 Revised */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Brad Demond Grade 10 English Post Part2 Revised', '17:30', 
		'English Post - Part 2 Revised',
		'Continuation of literary elements discussion.',
		'https://evalwashington.blob.core.windows.net/asset-c7cbfb19-35d3-43cf-91a1-a704adba78f1/Demond_Brad_10_English_Post_Part2_Revised_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A22%3A36Z&se=2016-04-14T04%3A22%3A36Z&sr=c&si=060e6adf-bbed-4286-b2bb-9c8f4a11152d&sig=VMNpOKdKGgbn%2B6HHlfVqrV0%2Flj2R%2F12eUMDrRBn2gN8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-00412b93-9c7f-404b-89dc-882456ce0a09/Demond_Brad_10_English_Post_Part2_Revised_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.5058684.jpg?sv=2012-02-12&se=2029-05-03T07:06:53Z&sr=c&si=8cb1081e-67b6-4ec7-9b7c-84992120c2f6&sig=aupaCEv0CRtDB3udF5R33xkcCXsls9t71xN2SV6lTW4%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')

	
/* Brian Wiggins Grade 5 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Brian Wiggins Grade 5 Math Post Part1', '16:22', 
		'Math Post - Part 1',
		'This 5th grade math lesson is a class review of math topics taught throughout the year.',
		'https://evalwashington.blob.core.windows.net/asset-d58d2ab9-8f8c-47c3-8d7d-bca5757c9b3b/Wiggins_Brian_5_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A22%3A30Z&se=2016-04-14T04%3A22%3A30Z&sr=c&si=f88a5276-bd22-4625-8212-b1ea66f68da2&sig=A24MVEjBiI6WCfZpvKrI5CKdc%2F%2Bv3wiIycumzUBEQUg%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-4a1a2e7a-d637-4a66-b6fa-421d32178d93/Wiggins_Brian_5_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.8245950.jpg?sv=2012-02-12&se=2029-05-03T07:05:36Z&sr=c&si=7b264392-b316-4666-957b-d67aa12cc43f&sig=yvDThnTTCwkXCO%2BAOzIAjb6i8QMJDV12OQ6igv6vUUY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')
 		
/* Cass Cline Grade 7 Art Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Cass Cline Grade 7 Art Post Part1', '15:41', 
		'Art Post - Part 1',
		'Students in this 7th grade art class begin by drawing flowers. They continue on to split up into four groups – games drawing, ukulele, Makahiki research, and grid drawing and work on their own assignments.',
		'https://evalwashington.blob.core.windows.net/asset-98f589fb-16f1-46f7-8402-b286effc19b2/Cline_Cass_7_Art_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A22%3A14Z&se=2016-04-14T04%3A22%3A14Z&sr=c&si=680909f3-ecba-41fe-b47d-8d391a312a81&sig=tIqfNW8SLf%2BIR6oztyhF6iCnbZOTJ9C%2BBcstF1fyZL8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7eb0a965-3d8a-4da7-94e9-e660df45561f/Cline_Cass_7_Art_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.4138340.jpg?sv=2012-02-12&se=2029-05-03T07:04:26Z&sr=c&si=ed479669-daf4-4617-99fd-278f6355ee43&sig=3zYzqHrOlZeiQxOr6WJdsJ6jZgGTGvEMETShNQykMVs%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Secondary', 'BERC Group')

/* Cass Cline Grade 7 Art Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Cass Cline Grade 7 Art Post Part2', '13:45', 
		'Art Post - Part 2',
		'Students continue to work in their groups on their separate projects – games drawing, ukulele, Makahiki research, and grid drawing. Teacher checks in on each group. After awhile, students switch groups.',
		'https://evalwashington.blob.core.windows.net/asset-9780d5b9-ba10-411d-bfd7-558593d6b922/Cline_Cass_7_Art_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A22%3A09Z&se=2016-04-14T04%3A22%3A09Z&sr=c&si=92497233-2be4-4baa-b654-d9cdf92fde85&sig=2BpJNd8QCY7JxxCA4hD3mdZB8ov1dgfolWaXBJe9H0M%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-afa2eeec-54dd-4f4f-86e1-3f8949df8ec4/Cline_Cass_7_Art_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.2581768.jpg?sv=2012-02-12&se=2029-05-03T07:03:18Z&sr=c&si=53625f52-b69e-4f99-b78b-5596198cd8f1&sig=Y%2F58qOUu7YeOLtliTG0m41YOiT5dkU3rOFbsdjxHVXY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Secondary', 'BERC Group')
		
/* Chris Schlesselman Grade 11 CTE Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Chris Schlesselman Grade 11 CTE Part1', '17:00', 
		'CTE - Part 1',
		'This 11th grade CTE class begins with a review of task requirements for their Rube Goldberg machines. Classmates work together to create their own machine.',
		'https://evalwashington.blob.core.windows.net/asset-c1098142-21fe-469f-850c-b0dc8040cf01/Schlesselman_Chris_11_CTE_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A47Z&se=2016-04-14T04%3A21%3A47Z&sr=c&si=0332497c-529d-41a8-a39d-361ea73f7b1f&sig=KEN961HWWAQ%2BuKGswuntAFMvJDVcyfFA%2FMGVwXE7sRc%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7d59f31c-6192-4468-b2bf-4d88932adf0b/Schlesselman_Chris_11_CTE_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.2037768.jpg?sv=2012-02-12&se=2029-05-03T06:42:47Z&sr=c&si=578e8ff4-a8f4-421f-a646-10cc52487049&sig=e32NIhSiR%2B0Kk%2FmE2VY60MYk%2BjYp23maFvV4VHXhGt8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('CTE', 'Secondary', 'BERC Group')
		
/* Chris Schlesselman Grade 11 CTE Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Chris Schlesselman Grade 11 CTE Part2', '16:08', 
		'CTE - Part 2',
		'Students continue to work on their Rube Goldberg machines. Teacher checks in with each group and asks questions.',
		'https://evalwashington.blob.core.windows.net/asset-e754b1e9-9d55-4758-aeef-1e708a8146aa/Schlesselman_Chris_11_CTE_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A52Z&se=2016-04-14T04%3A21%3A52Z&sr=c&si=f64f5f92-fbcd-4b46-8d26-4035fef0fbc3&sig=1dRYKaX9C6xvB1ZmQCxoX5H012lovIpVbTeRdmjv5d8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-2a511fa2-5f68-490d-b576-0bd6e5445277/Schlesselman_Chris_11_CTE_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.6896871.jpg?sv=2012-02-12&se=2029-05-04T05:12:15Z&sr=c&si=3f056fda-40a1-474a-9a7c-9e112d9de0c7&sig=JCZf1vs4AnhRauomcYIRjwlVhgW3zPr5qe1QThNlZAg%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('CTE', 'Secondary', 'BERC Group')


/* Craig Johnson Grade 8 Science Pre Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Craig Johnson Grade 8 Science Pre Part1', '14:31', 
		'Science Pre - Part 1',
		'8th grade science students focus on local winds – valley breeze, mountain breeze, sea breeze, and land breeze. Teacher instructs students to draw diagrams of each type.',
		'https://evalwashington.blob.core.windows.net/asset-cc29ba7d-8dc7-4a89-9bcc-4b54c7fc56f0/Johnson_Craig_8_Science_Pre_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A28Z&se=2016-04-14T04%3A21%3A28Z&sr=c&si=479366ea-2f0b-459f-8a01-d74b07781bd9&sig=oj4R8KpZpFuAwrLy7cdWVBNtbvosqlgGZvm9vqdY4gQ%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-6f2d79a4-7f53-44a0-bb50-16acc2bce8f9/Johnson_Craig_8_Science_Pre_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.7170032.jpg?sv=2012-02-12&se=2029-05-03T06:38:57Z&sr=c&si=a76e62bc-2d03-4279-aae5-a91318be1e71&sig=9CXcRCUfBUvQrng%2FnPXn13%2FGdOJ38wzu96BSx97cyoY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
		
/* Craig Johnson Grade 8 Science Pre Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Craig Johnson Grade 8 Science Pre Part2', '15:50', 
		'Science Pre - Part 2',
		'Students work on diagrams, then read together about local winds.',
		'https://evalwashington.blob.core.windows.net/asset-0d37fd87-f3a0-4d3d-a84e-37774a277819/Johnson_Craig_8_Science_Pre_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A22Z&se=2016-04-14T04%3A21%3A22Z&sr=c&si=80c27adb-2aca-43c3-86f2-e43fa03eeb3c&sig=tw41LeZWT%2FIsFruLLYf74nywvMlNdzw66ViHoNFaaPc%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-33318cb3-29bb-40be-8b22-8fc87fb0c631/Johnson_Craig_8_Science_Pre_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.5071782.jpg?sv=2012-02-12&se=2029-05-03T06:37:59Z&sr=c&si=5ffaecb7-1876-4dbb-88a0-1c92f3991c1d&sig=m%2B2YXsFMtU60Eo90q8Bzo4Pkfn2SDqzLVQ1WctNFd1k%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
		
/* Craig Johnson Grade 8 Science Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Craig Johnson Grade 8 Science Post Part1', '15:28', 
		'Science Post - Part 1',
		'Students learn about differential heating and how it affects wind. Students work together on various scenarios, including figuring out the best placement of a wind turbine.',
		'https://evalwashington.blob.core.windows.net/asset-3b7134e0-009f-4332-848d-66879fddd32f/Johnson_Craig_8_Science_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A34Z&se=2016-04-14T04%3A21%3A34Z&sr=c&si=d82be86b-738f-438a-9236-deae43ddcb53&sig=g5UzhgrY8kLE8Kokn%2F9uPlQFf2PeUr43fzWQBuS4aGU%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-33360e12-771e-408b-bb99-cf04cb228a47/Johnson_Craig_8_Science_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.2847311.jpg?sv=2012-02-12&se=2029-05-03T06:41:42Z&sr=c&si=eb59686d-aaf8-4691-9870-5d1c0a6bcb94&sig=rBqsGMWcM9thb5mWjkB6W61ogDbyVUPzgFEnOTH8ehk%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
		
/* Craig Johnson Grade 8 Science Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Craig Johnson Grade 8 Science Post Part2', '15:09', 
		'Science Post - Part 2',
		'Students finish work on their different scenarios, and share their answers with the class.',
		'https://evalwashington.blob.core.windows.net/asset-518f89bd-924c-481d-b4ca-ccf76725e30c/Johnson_Craig_8_Science_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A30Z&se=2016-04-14T04%3A21%3A30Z&sr=c&si=9f6159f5-bf08-45d7-844f-51423aaa8ce7&sig=Dorzc7ZMiR3%2BYQkzsZAeI%2FqbAOXlfBhRO%2BLTYxOJrVQ%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-d81343ea-2dcf-4ee6-b2a1-437433355035/Johnson_Craig_8_Science_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.0924698.jpg?sv=2012-02-12&se=2029-05-03T06:39:51Z&sr=c&si=fc53dbd0-848d-43f5-a0fc-7b2fe508f08e&sig=cOLBY050gc845zSSmnRWs9OpeOG016458pi%2FgNU9gp8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')

/* Dani Flangan Grade 1 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Dani Flangan Grade 1 Math Post Part1', '15:21', 
		'Math Post - Part 1',
		'1st graders in a math class review subtraction and its different strategies.',
		'https://evalwashington.blob.core.windows.net/asset-217f10ae-722e-4e65-95c5-dbfc52880c16/Flangan_Dani_1_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A10Z&se=2016-04-14T04%3A21%3A10Z&sr=c&si=62b46bf4-83b0-48c5-97a2-1e00ba03c7cf&sig=kInq3xXyT1qnz8yx84cTuv41Yl5wTJl1cpJrvFqF2s4%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-d6d2d1d4-ea41-4c1e-8997-3b014efcb153/Flangan_Dani_1_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.2129814.jpg?sv=2012-02-12&se=2029-05-03T06:35:26Z&sr=c&si=a4b738d7-192e-44f9-a935-78c1780155ce&sig=xXFfILDX%2BaxlrGPaUKL5IPstZ9UKGuSt439AHU7jy1s%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'BERC Group')


/* Dani Flangan Grade 1 Math Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Dani Flangan Grade 1 Math Post Part2', '13:58', 
		'Math Post - Part 2',
		'Students finish subtraction review.',
		'https://evalwashington.blob.core.windows.net/asset-13c52cd2-4591-44c3-a948-d3fa78e45175/Flangan_Dani_1_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A21%3A16Z&se=2016-04-14T04%3A21%3A16Z&sr=c&si=81041701-5506-464c-975b-79bd28cf6ad4&sig=NRHyjribrzL%2BzMpA964UNcp6m%2BwIM1BwAke3jNTfhSA%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7c28a4f2-bb82-4894-ba05-b142c807fb88/Flangan_Dani_1_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.3858866.jpg?sv=2012-02-12&se=2029-05-03T06:36:46Z&sr=c&si=dfc212ee-ffa0-4978-bde8-f934447cec16&sig=NKADk%2F067ir06n8kvhY%2Fb%2FFwYVVAfadqyAaa8pBCRUc%3D'
		)	
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'BERC Group')

	
/* Darrel Nichols Grade 5 English Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Darrel Nichols Grade 5 English Post Part1', '16:52', 
		'English Post - Part 1',
		'In this 5th grade English class, students review and discuss their two objectives. Their first is to visualize and describe thinking with evidence and inference, and the second is to use their knowledge of poetic elements and their understanding of synonyms to create a personal synonym poem. Students are first given the assignment of sketching an image of what a particular poem means to them. Students then share their images with each other. Teacher gives students the word “summer” and instructs them to brainstorm what summer means to them. Students take their two favorite words, write them on index cards, and are allowed to exchange them with other students’ words.',
		'https://evalwashington.blob.core.windows.net/asset-d4e87f5d-7416-43dc-a57c-db786ddefaba/Nichols_Darrel_5_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A20%3A46Z&se=2016-04-14T04%3A20%3A46Z&sr=c&si=0b7d9f16-20bf-407c-8bcb-a2bd3722aaa4&sig=Vz0hnRrS97CaI4ui6tmwHOCWM5bfkGeEYLY%2BSuJJCJU%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-9b362686-940c-42ef-a51b-5aea118178d2/Nichols_Darrel_5_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.1220426.jpg?sv=2012-02-12&se=2029-05-03T06:33:03Z&sr=c&si=5c5d2dff-11bb-4169-a301-2588cd559beb&sig=DU%2FP9N1iIMUX7jjBqSvU4raP1lhv2qQx%2Fxif5EWVfUM%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Intermediate', 'BERC Group')
		
/* Darrel Nichols Grade 5 English Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Darrel Nichols Grade 5 English Post Part2', '15:18', 
		'English Post - Part 2',
		'Students finish exchanging their words, then begin work on their poems. A few students share their poems, and then the class continues to work. Teacher then has students read each other’s poems and give feedback.',
		'https://evalwashington.blob.core.windows.net/asset-c9d8c437-929e-47bc-9333-0da4f25c9478/Nichols_Darrel_5_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A20%3A50Z&se=2016-04-14T04%3A20%3A50Z&sr=c&si=57484e92-7103-4636-8d28-27b840d64870&sig=tfbBXD3uYvTSRdDSqE%2BZPOwDc9ZOfGjKUbndnr2rhVo%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-99dc6702-29a7-4f67-bce9-9f16b64df840/Nichols_Darrel_5_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.1800091.jpg?sv=2012-02-12&se=2029-05-03T06:34:16Z&sr=c&si=9cb52ea3-f7a9-4a16-9932-a1befe87f51f&sig=9Y8BLSX8Cc4r1IehXCF3M3X9ZEcOJoEWW4yKtN9QlHs%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Intermediate', 'BERC Group')
		
/* Darrel Nichols Grade 5 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Darrel Nichols Grade 5 Math Post Part1', '17:37', 
		'Math Post - Part 1',
		'In this 5th grade math class, students review and discuss their two objectives. The first is to use the tech design process to put together a visual math tutorial in order to help other students who struggle with fraction concepts. Their second objective is to use storyboard elements to communicate conceptual understanding of fractions. Students watch teacher’s example of a visual math tutorial and write down their own ideas.',
		'https://evalwashington.blob.core.windows.net/asset-6a5b0c2f-6df6-4c2b-9a53-a56e150c15dd/Nichols_Darrel_5_Math_Post_Part1_480p_1200k.mp4?sv=2012-02-12&st=2014-04-28T06%3A50%3A28Z&se=2016-04-27T06%3A50%3A28Z&sr=c&si=52f37e92-7fdc-44f7-9227-5e3a33f918b9&sig=yKBWeMBinmgyq9dd4d%2FSPjcrRhmUZRUO2XNw09UVfcs%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-b735cfe7-8c72-436e-b3c6-99ecd8e79934/Nichols_Darrel_5_Math_Post_Part1_480p_1200k_00.00.10.5768268.jpg?sv=2012-02-12&se=2029-05-04T05:20:12Z&sr=c&si=1fc4e7d3-a2dc-4a7e-aeeb-e1252a651487&sig=4Ng0XHv%2BNk8Lr2Nl57TPWAJyMkqPaOae%2FCdh%2BTPkDdo%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')

/* Darrel Nichols Grade 5 Math Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Darrel Nichols Grade 5 Math Post Part2', '15:44', 
		'Math Post - Part 2',
		'Students finish writing down their ideas, then discuss together. Students work in math partners to storyboard.',
		'https://evalwashington.blob.core.windows.net/asset-41635808-2c68-4db0-9bed-5bc1a8b632e9/Nichols_Darrel_5_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A20%3A28Z&se=2016-04-14T04%3A20%3A28Z&sr=c&si=881e6cf0-f758-45e1-a74c-1e8c472e84da&sig=W3VG3B6FhBKdrs6mWcvTaZsPyA6Ca1SZwwpMd9KmWoQ%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-6c0bc359-d814-4fcd-90aa-74dcaebc449d/Nichols_Darrel_5_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.4423945.jpg?sv=2012-02-12&se=2029-05-03T04:58:05Z&sr=c&si=77c23975-b284-4176-9c23-e38d31282706&sig=p%2Bvx7so%2B%2BG0RbJ9S%2FkQ10sckv7HaZN34zngFOBCeCn0%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')
		
/* Darrel Nichols Grade 5 Math Post Part3 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Darrel Nichols Grade 5 Math Post Part3', '19:57', 
		'Math Post - Part 3',
		'Students continue storyboarding and create their visual math tutorials. Teacher shows one group’s video about the Egyptian method for writing a fraction. Class gives constructive feedback for this group, then teacher gives self-evaluation assignment.',
		'https://evalwashington.blob.core.windows.net/asset-652145b5-c886-4943-9bf0-b14c1c280018/Nichols_Darrel_5_Math_Post_Part3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A20%3A22Z&se=2016-04-14T04%3A20%3A22Z&sr=c&si=31f872b1-9031-416a-a0eb-fc2e38d0c333&sig=uFBj1BW31S74K4Xbg%2BbMxViXsWsdlzmbwKZ30sFryB4%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-469453d3-fc23-4e18-a8cb-bdd50d3c9965/Nichols_Darrel_5_Math_Post_Part3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.9761560.jpg?sv=2012-02-12&se=2029-05-03T06:31:42Z&sr=c&si=59a2dc61-1299-4f45-9db8-d31b3b309d14&sig=rY%2Fqrv3UzGWnp10WWf32She2vn0kP5P3pchcmEqaaDk%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')
	
/* David Kish Grade 11 Math Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'David Kish Grade 11 Math Post Part2', '15:48', 
		'Math Post - Part 2',
		'Starts midway through class. In this 11th grade math class, students are working together on a quadratic equation assignment. Teacher reviews answers with class.',
		'https://evalwashington.blob.core.windows.net/asset-b7f829e8-bd20-4f53-a33b-8f29c7ca493e/Kish_David_11_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A20%3A07Z&se=2016-04-14T04%3A20%3A07Z&sr=c&si=87df69ae-ed37-4776-b174-735d91fbb949&sig=GX7C7j9Siv1cLUdHNxRjtIgoytYZK6PAT4z08Kk8OxA%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-1b21a216-7256-43a4-8b59-c8663f92948f/Kish_David_11_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.4876734.jpg?sv=2012-02-12&se=2029-05-03T06:29:57Z&sr=c&si=df773578-ba01-4e34-b527-74e70a64cb5d&sig=EpT4MgcLzX93L7Flh5ItihxZChmA2sIkDuSP9XFQZPI%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
		
/* Faith Powell Grade K Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Faith Powell Grade K Math Post Part1', '12:18', 
		'Math Post - Part 1',
		'This kindergarten math class focuses on counting dots. Students are asked how many dots there are and how they see them. Students are asked to go to their math stations, where they work with partners and continue their counting lesson with various activities.',
		'https://evalwashington.blob.core.windows.net/asset-4c5e1bd4-f57c-4728-823a-dc49930e304f/Powell_Faith_K_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A20%3A35Z&se=2016-04-14T04%3A20%3A35Z&sr=c&si=e6c86bf7-d57c-4d12-b640-2327866ba87e&sig=bKK7787qdPh0Emt4mwZBe6QPpClgbZNu0QyxvBb6l00%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-635bbe8b-cf76-49bc-88ae-90654050c585/Powell_Faith_K_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.07.3848743.jpg?sv=2012-02-12&se=2029-05-03T06:28:30Z&sr=c&si=45a74138-6dc7-4104-ba36-e643c23f67bd&sig=dhH6BeIcOEEjoIQLBKOo6Yiu%2BrKmvU8QrqVDVJBwD1s%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'BERC Group')
	
/* Faith Powell Grade K Math Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Faith Powell Grade K Math Post Part2', '10:20', 
		'Math Post - Part 2',
		'Students continue working with partners on their counting lesson. Teacher has students gather together and share with one another what they did at their math stations. They end with another counting activity as a group.',
		'https://evalwashington.blob.core.windows.net/asset-ca6f2579-2af5-4555-b5bc-874601e2099e/Powell_Faith_K_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A20%3A31Z&se=2016-04-14T04%3A20%3A31Z&sr=c&si=44fb9c5d-96f6-462f-9ac5-d1b4000b0238&sig=8f2oTKuDEjqgF0bgJoYLctBZDX%2FgjIFqzLkVuKKEQBA%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-c6adb488-2d26-4a4b-bb6a-f5c1147d0471/Powell_Faith_K_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.06.2069261.jpg?sv=2012-02-12&se=2029-05-03T06:27:20Z&sr=c&si=39d8458d-f347-4f5f-bfe0-ea5a2cd812da&sig=LceA%2Fw%2BP%2Fi%2B5r91myRali%2BZy12eA3pt7HaMB%2BcuV9CI%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'BERC Group')
	
/* Heather Fox Grade 9 Social Studies Pre Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Heather Fox Grade 9 Social Studies Pre Part1', '10:45', 
		'Social Studies Pre - Part 1',
		'This 9th grade social studies lesson is about philosophies of government. Lesson objective is to understand the age of enlightenment and to read about and understand the different philosophers. Teacher lectures about different philosophies of government.',
		'https://evalwashington.blob.core.windows.net/asset-eddbea22-8555-402a-82ec-051237134cc7/Fox_Heather_9_Social_Studies_Pre_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A19%3A25Z&se=2016-04-14T04%3A19%3A25Z&sr=c&si=53acc6f1-757f-44b3-87d5-1a51c835ad31&sig=HBdLHExQEgUo%2FJerDcU5DI52Hi2ATl9rfgmV5Gv2TqQ%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-d6e03c4b-c7b1-4b9e-968f-e67d1e7527e3/Fox_Heather_9_Social_Studies_Pre_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.06.4549152.jpg?sv=2012-02-12&se=2029-05-03T06:23:23Z&sr=c&si=024b2776-e646-4268-9d10-0b9639945204&sig=IYizmXwjPkaOwWozK4evQ%2F%2FzMXKd%2FN310hmKM6cs4Eg%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'BERC Group')
		
/* Heather Fox Grade 9 Social Studies Pre Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Heather Fox Grade 9 Social Studies Pre Part2', '10:48', 
		'Social Studies Pre - Part 2',
		'Teacher continues to teach about different forms of government. Teacher has students answer three questions, and then they discuss the answers as a class.',
		'https://evalwashington.blob.core.windows.net/asset-10a74e69-e8d2-4ded-8c20-3282914a6406/Fox_Heather_9_Social_Studies_Pre_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A19%3A17Z&se=2016-04-14T04%3A19%3A17Z&sr=c&si=48454b64-fde7-444e-b66d-2930a67545c6&sig=eZZQ8CHjm2MAebFoht0bayoMat%2Fhnzf4kxlgCg8Gpas%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7f8e22a1-afec-4d3b-bd43-511d5fc70135/Fox_Heather_9_Social_Studies_Pre_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.06.4862621.jpg?sv=2012-02-12&se=2029-05-03T06:20:20Z&sr=c&si=a123a65b-3f91-49d5-a387-811bbfe90e75&sig=qZHAJCUVoVlGqV18vhzUkNMOI4wLF1JKikYX4N7TaQ8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'BERC Group')

/* Heather Fox Grade 9 Social Studies Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Heather Fox Grade 9 Social Studies Post Part1', '15:58', 
		'Social Studies Post - Part 1',
		'9th graders in this social studies class are learning about the French Revolution. Teacher asks students to think about why the revolution period followed the absolutism period. Teacher says she will have students write their own philosophies of government.',
		'https://evalwashington.blob.core.windows.net/asset-86ec4c06-ef66-46e0-920c-92930b3f4083/Fox_Heather_9_Social_Studies_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A19%3A31Z&se=2016-04-14T04%3A19%3A31Z&sr=c&si=aff2b97b-1c51-46f6-93c7-caabd0fe30cc&sig=QGFD92g9lmbju1rVCm81eayj%2FqWrvuzzOKwCBA2aCmw%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-658dbf69-0853-42d6-8b03-1086bf330b55/Fox_Heather_9_Social_Studies_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.5868226.jpg?sv=2012-02-12&se=2029-05-03T06:24:30Z&sr=c&si=8257c55d-687b-42b7-bb35-aa0a23d3269f&sig=5o5jCrEB6KCYH1rJnpVLdvSO3LNV20dM3GZJz74JQS8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'BERC Group')

/* Heather Fox Grade 9 Social Studies Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Heather Fox Grade 9 Social Studies Post Part2', '15:46', 
		'Social Studies Post - Part 2',
		'Teacher splits up class into four groups and has them read articles on four different philosophers. She asks the groups to decide on the three most important points each one believed. Class then discusses.',
		'https://evalwashington.blob.core.windows.net/asset-de7f6e45-0333-4543-9ab1-c4fe875b4df2/Fox_Heather_9_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A19%3A42Z&se=2016-04-14T04%3A19%3A42Z&sr=c&si=b44774d7-fd50-47c1-9a91-053d49d1bdf6&sig=3ELNsV98EfWo5c%2FBdII%2BfYR7kUIfZlisbnNZ98Qa8l8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-1ccce90d-617a-4836-a2ae-c47df53a7440/Fox_Heather_9_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.4688653.jpg?sv=2012-02-12&se=2029-05-03T06:26:16Z&sr=c&si=a3b461ab-177b-43f9-bac0-b70b1dd1c1ac&sig=3tGd4sXp6P2fyPYBmMJs5xHqEboa%2F%2BqFaDF0E04D%2BmQ%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'BERC Group')

/* Heather Fox Grade 9 Social Studies Post Part3 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Heather Fox Grade 9 Social Studies Post Part3', '15:38', 
		'Social Studies Post - Part 3',
		'Class continues to read articles and discuss their thoughts. Teacher asks class to reflect about what they learned about philosophies of government and to write their own philosophies.',
		'https://evalwashington.blob.core.windows.net/asset-47532654-152b-45bb-8859-1a76dff567c5/Fox_Heather_9_Social_Studies_Post_Part3_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A19%3A21Z&se=2016-04-14T04%3A19%3A21Z&sr=c&si=28183b3f-cbb9-45a8-8437-5fdb0174b616&sig=VK7a5JImpzUlHe9RD2aZvKF9L6c4ZPIbuBP2srCdEOU%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-926dd9cf-9676-495b-9dac-4304293922a3/Fox_Heather_9_Social_Studies_Post_Part3_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.3866666.jpg?sv=2012-02-12&se=2029-05-03T06:22:16Z&sr=c&si=cdcedddc-30bb-4c49-91e4-ae31a1a4c23d&sig=mwsVqKjaru%2FG9mtuz8bqQXB0nU4RpdTgY8hHdeGb%2B8Q%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'BERC Group')

/* Heather Swenson Grade 3 English Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Heather Swenson Grade 3 English Post Part1', '19:08', 
		'English Post - Part 1',
		'3rd grade English class makes vocabulary maps of new words they just learned in their books. Vocabulary maps include the definition, synonyms, a sentence demonstrating use, and a picture.',
		'https://evalwashington.blob.core.windows.net/asset-d4fec4b2-853e-491a-80fc-fde6e375b3d5/Swenson_Heather_3_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A19%3A02Z&se=2016-04-14T04%3A19%3A02Z&sr=c&si=eb915326-5ccf-44a7-9c1f-82f0e24a817d&sig=YgcWrNLm5m%2FmPbi2NUhp9u%2F7I0Mv1EgvejWLKrmL9P4%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-af9430d9-920b-400c-84ea-1f23d6628d35/Swenson_Heather_3_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.4864471.jpg?sv=2012-02-12&se=2029-05-03T06:18:21Z&sr=c&si=6f1b8426-56bf-4b62-bd3a-87f33195f388&sig=EqcKcj9mLPjuyWLBmrw4MVKNahXbYJ3QqHVmCOU06vk%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Intermediate', 'BERC Group')
 		
/* Heather Swenson Grade 3 English Post Part2 Revised*/	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Heather Swenson Grade 3 English Post Part2 Revised', '12:40', 
		'English Post - Part 2 Revised',
		'Students finish work on vocabulary maps. Teacher has students share their word maps with the class. Students in audience are to write down the presenters’ words and any questions they may have about them. Students are then instructed to circle the word that was the most difficult for them.',
		'https://evalwashington.blob.core.windows.net/asset-a78a2b58-2ebd-4f46-b3c9-9e3f8fd5db43/Swenson_Heather_3_English_Post_Part2_Revised_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A19%3A08Z&se=2016-04-14T04%3A19%3A08Z&sr=c&si=1ef60f34-4284-4824-8b47-d1480270fd54&sig=fP63DqJVhFXUzqWqapcgO8%2BGz7RlDTTkqh1s4v6zRrE%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-c4cec1f6-70db-4362-ae58-a327604dfdfb/Swenson_Heather_3_English_Post_Part2_Revised_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.07.6059283.jpg?sv=2012-02-12&se=2029-05-03T06:19:24Z&sr=c&si=d19ad3c3-836f-47f1-8115-2ee8cb6a5ce4&sig=VD2D4WMnpXRpWNyQ3VVRnNOLFbDkMn5qztzmQlx2o6Y%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Intermediate', 'BERC Group')

		
/* Janell Doggett Grade 3 English Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Janell Doggett Grade 3 English Post Part1', '17:24', 
		'English Post - Part 1',
		'3rd grade English class focuses on comparing and contrasting. Teacher first has students discuss with one another when they use this skill. Class brainstorms differences and similarities between the sun and the moon, then writes them down in a Venn Diagram. Teacher has students decide between being moon experts and being sun experts. Students continue on to fill out their Venn Diagrams.',
		'https://evalwashington.blob.core.windows.net/asset-5044a6c1-ddcb-4d27-86d7-d8a5e8e32c33/Doggett_Janell_3_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A18%3A47Z&se=2016-04-14T04%3A18%3A47Z&sr=c&si=50358d60-1efa-4755-bbe0-8e53188e83d4&sig=Y%2Fxp0HecJmtcTn4C86WKW2KyHwKNQhYgwf2EVnEN4fg%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-1ad07d21-d645-44e0-bd9a-4458ade16df5/Doggett_Janell_3_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.4408525.jpg?sv=2012-02-12&se=2029-05-03T06:17:04Z&sr=c&si=6f0ed328-1437-42b5-b147-a537104a20fc&sig=RxWwpTW2ua3NrDF3ZRWlIiBsGFT65DfN3RYZO4%2FffMo%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Intermediate', 'BERC Group')
		
/* Jill Reinfeld Grade 7 Social Studies Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Jill Reinfeld Grade 7 Social Studies Post Part1', '17:43', 
		'Social Studies Post - Part 1',
		'This 7th grade social studies class is studying the 2nd down what they think about guns, then sharing their opinions with their neighbors. Class moves onto discuss what influences their views on guns. Class defines rights protected under the 2nd amendment.',
		'https://evalwashington.blob.core.windows.net/asset-671e1639-f9ae-480d-b64a-37e3ef36c326/Reinfeld_Jill_7_Social_Studies_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A18%3A31Z&se=2016-04-14T04%3A18%3A31Z&sr=c&si=33afbe22-103f-4bee-9d5d-b2b8b3836425&sig=Ib5uEYgeaI4AUSAuRtyzEHMrJnM%2B4T4Yd1Kxbu%2FWUP4%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-2cb75279-3e15-4ab5-aec0-c9cf6169a259/Reinfeld_Jill_7_Social_Studies_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.6310240.jpg?sv=2012-02-12&se=2029-05-03T06:15:50Z&sr=c&si=e2d7059f-b86d-4bbc-9a71-1f1b04a9e0d9&sig=1l8aGu4pkIDH%2BSBmChkIhExSA7jegVhReL%2BskmtAz0A%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'BERC Group')

	
/* Jill Reinfeld Grade 7 Social Studies Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Jill Reinfeld Grade 7 Social Studies Post Part2', '20:52', 
		'Social Studies Post - Part 2',
		'Class continues to define rights protected under 2nd amendment. amendment. Teacher asks class to answer various questions regarding guns, such as “Should there be a waiting period before getting a handgun?” Students then share their answers with the class. Teacher has students reformulate opinions after class has presented.',
		'https://evalwashington.blob.core.windows.net/asset-756578bf-cd89-437d-ab93-4fef620366a8/Reinfeld_Jill_7_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A18%3A27Z&se=2016-04-14T04%3A18%3A27Z&sr=c&si=69046039-bd83-448d-9ac3-d63126e9b227&sig=n5ypy9PT3GBU6wsn%2FiwDwmwDGusryNYT8l7L87PvGq8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-fa3525e2-c42a-4432-9634-31118360923e/Reinfeld_Jill_7_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.12.5215927.jpg?sv=2012-02-12&se=2029-05-03T06:14:38Z&sr=c&si=f1d89d3d-af70-437a-8d05-7f2aa1c1d8ca&sig=9ChVsIn3x%2FuhoAndDSprbRWbZr1EebL1mRCDEo0pHnQ%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Secondary', 'BERC Group')
		
/* Jeannie Joseph Grade 7 English Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Jeannie Joseph Grade 7 English Post Part1', '17:40', 
		'English Post - Part 1',
		'7th grade English class begins by forming guesses about what the chapter “Locked Up” will be about. They then discuss certain words from the book and use context clues to discover their meaning. Students come up with ways to help them remember the different vocabulary words.',
		'https://evalwashington.blob.core.windows.net/asset-84fc05df-c60e-4e6b-ae4b-b7125929715e/Joseph_Jeannie_7_English_Post_Part1_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A18%3A11Z&se=2016-04-14T04%3A18%3A11Z&sr=c&si=64be0730-9c4d-4a3b-a583-398df260a16f&sig=9BB9Y%2FVupwX10MhbDkKAU3KZAwHZ7ZS8wgCIADmrQ%2BE%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-dee2008e-87a8-42b4-9970-042f28023e21/Joseph_Jeannie_7_English_Post_Part1_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.6096616.jpg?sv=2012-02-12&se=2029-05-03T06:12:24Z&sr=c&si=b8a27a4e-cf0e-460e-a688-5cffa00e78e8&sig=U3b9fiTjffPAL33W0fnDYpKz%2Fg5N8thjbRAHQTeqL4I%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')

		
/* Jeannie Joseph Grade 7 English Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Jeannie Joseph Grade 7 English Post Part2', '17:05', 
		'English Post - Part 2',
		'Students share out their ideas of what helps them remember these vocabulary words.Teacher then has students write their own sentences with the vocab words using context clues so others would be able to understand the meaning. Class reads the “Locked Up” chapter together and discusses concepts.',
		'https://evalwashington.blob.core.windows.net/asset-8f97b06d-a110-4521-86e1-cd193e498b8e/Joseph_Jeannie_7_English_Post_Part2_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A18%3A14Z&se=2016-04-14T04%3A18%3A14Z&sr=c&si=76df39f3-a6a5-400f-a251-eb7b6a0024f9&sig=8k4PwqPIbEtPBPr3hx%2FJPSxUhssyRET6CZPiX16McBY%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-8aebafba-1e59-4afc-8333-bb1de94b7b2e/Joseph_Jeannie_7_English_Post_Part2_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.2534675.jpg?sv=2012-02-12&se=2029-05-03T06:13:39Z&sr=c&si=d2d11e2a-3369-4508-a37a-21d1687d9189&sig=AMJbqu9WG%2FlqkjIp8mdMirMgtiSOV9O6bOoANCj9OsQ%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')
		
/* Joyce Mihalovich Grade 1 English Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Joyce Mihalovich Grade 1 English Post Part1', '15:14', 
		'English Post - Part 1',
		'1st grade English class discusses rereading, rethinking, and revising. Class goals for the day are for the students to plan their writing and decide what type fits their purpose. Teacher asks students to share ideas on what they are going to write about in their writer’s workshop.',
		'https://evalwashington.blob.core.windows.net/asset-7f515af2-af84-4a94-b852-bf0dc15b30e3/Mihalovich_Joyce_1_English_Post_Part1_4X3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A18%3A02Z&se=2016-04-14T04%3A18%3A02Z&sr=c&si=22f50e17-a0bd-4994-b0e4-36d2efc4e24d&sig=DNlUkbTQ3kxjE6n8s8pfZqGQD6Jzl3eK7GFJOy6OtqM%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-0240f81b-2f6f-49e4-987c-a36be9ceb000/Mihalovich_Joyce_1_English_Post_Part1_4X3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.1400707.jpg?sv=2012-02-12&se=2029-05-03T06:11:11Z&sr=c&si=0d700a8f-79f7-4c85-929c-849c06129f61&sig=ccW6OGlzFpPQDpIVHCwQxSmmlgVFvLat9O0ZbZKI7o4%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')
		
/* Joyce Mihalovich Grade 1 English Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Joyce Mihalovich Grade 1 English Post Part2', '16:39', 
		'English Post - Part 2',
		'Students continue writer’s workshop. Teacher checks in with each student to see how their writing is going. Class gathers together to share their writing with the group.',
		'https://evalwashington.blob.core.windows.net/asset-3479551c-7766-41e1-a70c-43b3aab77bb2/Mihalovich_Joyce_1_English_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A18%3A00Z&se=2016-04-14T04%3A18%3A00Z&sr=c&si=4a8e98e3-3327-48d0-94f5-60b39e092151&sig=Cp5Clm3Gu%2FrQ4mAGP6rKTVypoAbiwe%2F1e3iQiXcK3oI%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-15321f6e-e269-48a8-aef8-e5b31614b737/Mihalovich_Joyce_1_English_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.9910821.jpg?sv=2012-02-12&se=2029-05-03T06:10:02Z&sr=c&si=09c102e8-3b0e-460f-8e2b-e46972b1c05d&sig=oI7dgC7p8pRtLVD1NCGObZQsf08MPqXWiOPPYpi6LxI%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')

/* Judy Williams Grade 4 Science Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Judy Williams Grade 4 Science Post Part1', '15:06', 
		'Science Post - Part 1',
		'The topic of this 4th grade science lesson is advanced connections. Teacher reviews schematics. The challenge for the day is to get two light bulbs to light at the same time. Students work on their circuits. Students create a series circuit, and notice that one of the light bulbs isn’t very bright. Students brainstorm why this might have been.',
		'https://evalwashington.blob.core.windows.net/asset-25b10f5f-9215-41ad-b232-e5e6cb64d8d8/Williams_Judy_4_Science_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A53Z&se=2016-04-14T04%3A17%3A53Z&sr=c&si=1877eebf-f954-4ad4-b078-f9b18b12d39b&sig=WhRQgIgG3SJo%2BJM%2FwL93BNNMC8VcNpzm5g8QMj%2FgAmA%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-04932c92-e0c4-493a-8030-1fb3877dc5cc/Williams_Judy_4_Science_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.0620516.jpg?sv=2012-02-12&se=2029-05-03T06:08:53Z&sr=c&si=b55e683d-4367-4469-82ae-817b2a0d8baa&sig=rO2CkXTLvimxUfqJRgU74yQelJL%2BtNlCgJUYKKERRug%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Intermediate', 'BERC Group')

		
/* Karen Lipp Grade K English Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Karen Lipp Grade K English Post Part1', '15:51', 
		'English Post - Part 1',
		'A kindergarten English class begins with a discussion of The Three Bears and important messages in the story. Teacher then reads Christmas Cricket and asks students questions about the story. Class discusses the important messages in the story.',
		'https://evalwashington.blob.core.windows.net/asset-898e51d2-97fd-490c-bae9-c7e9172ff6ad/Lipp_Karen_K_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A53Z&se=2016-04-14T04%3A17%3A53Z&sr=c&si=8ada0e2e-e27d-4115-9178-8b19ce72fd82&sig=D5NYJCos5v3QWpln4JL1Fg1NqxzK%2Be9SdDQ09S0qk6I%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-e1f29436-45aa-4709-80d3-1ca738168e28/Lipp_Karen_K_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.5157696.jpg?sv=2012-02-12&se=2029-05-03T06:02:57Z&sr=c&si=c3ab1e76-bb79-420d-a6d8-faa6b22b872e&sig=P9PZ%2FvaltPvopQgECDZQzUhWKgoe%2BfskLWVtyAHF9D4%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')

/* Karen Lipp Grade K English Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Karen Lipp Grade K English Post Part2', '16:43', 
		'English Post - Part 2',
		'Teacher discusses how students have gifts, just like the cricket in the story, and has them connect Christmas Cricket to themselves. Teacher asks students what they can do to help other people, and whether the recipients would hold these gifts in their hands or in their hearts. Class assignment is for students to think about what their gifts to the world are.',
		'https://evalwashington.blob.core.windows.net/asset-36c900fb-db0a-4afb-9e05-fb9f959b2619/Lipp_Karen_K_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A57Z&se=2016-04-14T04%3A17%3A57Z&sr=c&si=ec39eb35-1e9e-43c0-9b8f-c416d43696f2&sig=jxle8h17egz2RvCIpDAg7zC95Ms1DhF%2FN5Omdff1%2B3c%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-c936025f-3158-4e86-b9fb-661a3df2c6c8/Lipp_Karen_K_English_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.0370575.jpg?sv=2012-02-12&se=2029-05-03T06:04:07Z&sr=c&si=439c047e-7ec2-4734-ad86-71551ccdef3a&sig=Gv4OaR9jG%2Flk1t9LvSXESJjftPAUCqarqPnwX%2FbrFMU%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')
		
/* Kellie Mays Grade 4 Math Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Kellie Mays Grade 4 Math Post Part2', '18:44', 
		'Math Post - Part 2',
		'This 4th grade math lesson begins midway through class. Teacher asks students to split up in groups and discuss their answers together. Students then work independently to answer equation problems, and come together again to discuss the answers as a group. Students then are asked to write and solve their own equations.',
		'https://evalwashington.blob.core.windows.net/asset-ebbf8a92-3a16-4891-bd05-973b58e8b554/Mays_Kelli_4_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A47Z&se=2016-04-14T04%3A17%3A47Z&sr=c&si=13e18cbd-e88d-4f52-86f5-c9f01af276b3&sig=0oaYtlM6YykSsOwdtqsYqpuphOz%2FdR5h%2BEyDkFS8pZM%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-8e5e2fd2-6004-47d4-8a35-c97f1002837d/Mays_Kelli_4_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.2486747.jpg?sv=2012-02-12&se=2029-05-03T06:07:45Z&sr=c&si=0d7022fb-1a54-4b76-89c8-59b5151c169d&sig=wIqDSir3F3%2F6jyo22NkvMQvrLA7sFE1LDmZQ0TnjbYQ%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')

/* Krista Calvin Grade 3 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Krista Calvin Grade 3 Math Post Part1', '18:31', 
		'Math Post - Part 1',
		'3rd grade math class uses known facts to find products with 6 and 7 as factors. Teacher first reviews vocabulary words with students. Students discuss how they could use what they know about 2 x 7 to figure out 4 x 7. Teacher shows video on breaking part arrays.',
		'https://evalwashington.blob.core.windows.net/asset-1bd32801-994a-4384-a587-1fa1780822da/Calvin_Krista_3_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A36Z&se=2016-04-14T04%3A17%3A36Z&sr=c&si=f7690a88-825b-4591-aa63-c947e5dddfee&sig=OUokoMcMJmb2KZcZGb%2BXXn455ZlrATZ9koa47B8uMIY%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-0a05225f-4421-4d0c-9683-600145d07497/Calvin_Krista_3_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.1198041.jpg?sv=2012-02-12&se=2029-05-03T06:06:28Z&sr=c&si=8b169dfe-ef14-4545-a510-fb5c6f9de545&sig=a01Vrl5Tgq3%2FyEkb2%2FmPknG7rJocilEaVlU4hQzMcPU%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')
		
/* Krista Calvin Grade 3 Math Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Krista Calvin Grade 3 Math Post Part2', '16:07', 
		'Math Post - Part 2',
		'Students work with partners to figure out multiplication story problems using any strategy they would like to use. Students then work on workbook problems individually. Finally, students pair up and discuss how they will use this type of math outside of the classroom.',
		'https://evalwashington.blob.core.windows.net/asset-47fc553a-be39-43b3-9d72-0f3f8872522f/Calvin_Krista_3_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A33Z&se=2016-04-14T04%3A17%3A33Z&sr=c&si=3dae9cdb-e0e6-42a8-bb1b-71dfcfc08243&sig=pyY593z0dgZM8yD6wnMWqEVNUFW5b7%2B1sUCacvLlbLM%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-f47da99c-8ceb-4400-87b9-63ca648b5c92/Calvin_Krista_3_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.6755228.jpg?sv=2012-02-12&se=2029-05-03T06:05:12Z&sr=c&si=37f683fd-1e8a-40bc-aef4-0a7c0b685395&sig=9PRylGkZ4PTBViPZQ%2FOaKJy5gIicZA1Y0pc3CZFVNlI%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Intermediate', 'BERC Group')

/* Kristin Hera Grade 6 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Kristin Hera Grade 6 Math Post Part1 Revised', '18:31', 
		'Math Post - Part 1 Revised',
		'6th grade math lesson focuses on classifying triangles. Teacher first has students use string to review angles. Class tells teacher what they already know about triangles. Students use white boards and string to demonstrate their understanding of triangles. Students draw triangles and have their partners decide the type of angles.',
		'https://evalwashington.blob.core.windows.net/asset-9709399d-3e42-42b2-8d5b-7e08a4430173/Hera_Kristin_6_Math_Post_Part1_Revised_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A42Z&se=2016-04-14T04%3A17%3A42Z&sr=c&si=806a990a-0ac2-49d0-b581-273f5965fd3f&sig=3xTGHTDxp412ymk7Sh5T45BFXzU2uVileCEzQAl1Eek%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-f2c8f401-27c5-4d66-8f5b-893451c7164d/Hera_Kristin_6_Math_Post_Part1_Revised_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.8793941.jpg?sv=2012-02-12&se=2029-05-03T06:01:41Z&sr=c&si=09c0b491-206f-48b3-86e8-058ce3372722&sig=kW4uZnAF0ZF%2FUjtrx3uvJnk90iRxGtf%2F18cSuqDGEyA%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')


/* Kristin Sheridan Grade 7 Science Pre Part1 v2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Kristin Sheridan Grade 7 Science Pre Part1 v2', '16:36', 
		'Science Pre - Part 1 v2',
		'7th grade science class learns about microbes. Students move between 9 different stations to sample different foods and drinks that have microbes in them. Students are to read informational card, taste the substance, then fill out a chart with a description of the item.',
		'https://evalwashington.blob.core.windows.net/asset-9e15d530-6757-4d62-b5ae-87e69aa63959/Sheridan_Kristin_7_Science_Pre_Part1_v2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A17%3A28Z&se=2016-04-14T04%3A17%3A28Z&sr=c&si=8a86f35b-c74f-4c5b-b3c3-44033b81b6f8&sig=nfQOqqijs1BrgcGh7FOayl3UjWpwFJ5%2FbOwfrf%2BER%2F0%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-e54c9862-64c1-4c02-87a6-192b7179a757/Sheridan_Kristin_7_Science_Pre_Part1_v2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.9699518.jpg?sv=2012-02-12&se=2029-05-03T06:00:46Z&sr=c&si=4b16c4de-3b26-4b6d-9a6d-53e1ee4a5586&sig=UZS2duabm0AbttNxg1xggftCbT8cycemCyrAr25xZxQ%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')

		
/* Kristin Sheridan Grade 7 Science Pre Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Kristin Sheridan Grade 7 Science Pre Part2', '16:13', 
		'Science Pre - Part 2',
		'Students finish the lab, then discuss as a class.',
		'https://evalwashington.blob.core.windows.net/asset-47958ee7-2861-41be-9b2c-0ec8b48bb692/Sheridan_Kristin_7_Science_Pre_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A44Z&se=2016-04-14T04%3A16%3A44Z&sr=c&si=bc0a0f42-b692-4ee6-bc30-4715863d9bba&sig=AtHpx79kWzaKG1nSHGjq89j%2B%2FiSe5YAg8MC5wAMIYKY%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-0afb5fa3-9597-4573-842d-a5193e11049c/Sheridan_Kristin_7_Science_Pre_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.7363592.jpg?sv=2012-02-12&se=2029-05-03T05:59:36Z&sr=c&si=605d5f26-f53d-427b-becd-20223090e23f&sig=nJf5xuXkktz%2FCSx9oY%2BPtozjjHByzm9aFWy6HwqMCGc%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
	
/* Kyna Williams Grade 6 Math Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Kyna Williams Grade 6 Math Post Part1', '13:54', 
		'Math Post - Part 1',
		'6th grade math class learns about experimental probability. Students break into groups and flip a coin. They are instructed to decide how exactly they will flip their coin.',
		'https://evalwashington.blob.core.windows.net/asset-37280915-e483-44be-a281-cfa684f456a6/Williams_Kyna_6_Math_Post_Part1_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A29Z&se=2016-04-14T04%3A16%3A29Z&sr=c&si=f3ce8896-9e92-4161-bd2b-c2abfcc5beb1&sig=lb2%2FkW5RMhf6nTJ59vudUvrSwdF69jyJ9xzXr%2FCykyE%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-642a1a33-09d2-440d-8250-6097044099d8/Williams_Kyna_6_Math_Post_Part1_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.3403755.jpg?sv=2012-02-12&se=2029-05-03T05:58:20Z&sr=c&si=3ce4f367-9c62-4b2e-acef-f54097b4b193&sig=yIrWX03unZXK1WBDzsiyhYSl5rvwJ0k8tBAoh9T0T%2FA%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
	
/* Kyna Williams Grade 6 Math Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Kyna Williams Grade 6 Math Post Part2', '13:43', 
		'Math Post - Part 2',
		'Students finish lab. Students share results with neighbor groups, then discuss as a class. Teacher then has students write down what they think theoretical probability and experimental probability might mean, then the teacher gives actual definitions and gives examples with one student’s data. Students then come up with experimental and theoretical probability for their own data. Teacher adds entire class’s data and finds experimental and theoretical probability.',
		'https://evalwashington.blob.core.windows.net/asset-b4338e4a-e84d-46ab-95ab-edac7361b27e/Williams_Kyna_6_Math_Post_Part2_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A26Z&se=2016-04-14T04%3A16%3A26Z&sr=c&si=354a8bf0-cb15-44d3-acd3-0b1a9693e3ab&sig=%2BHsHMqFRZsMDDx8swMmZWoyMI%2Bd%2Bg8xcSXR7HTtdsqE%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-985d219b-7980-484a-8bc5-b82b6414f850/Williams_Kyna_6_Math_Post_Part2_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.2319383.jpg?sv=2012-02-12&se=2029-05-03T05:57:10Z&sr=c&si=846c48e1-0889-4f84-87f4-66e4c0539f36&sig=BNf%2BJiP4tq3dFG2ToQ%2FMgQW13sOZKCHi28o3Yr2rzEQ%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
	
		
/* Kyna Williams Grade 6 Math Post Part3 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Kyna Williams Grade 6 Math Post Part3', '13:57', 
		'Math Post - Part 3',
		'Teacher continues to discuss differences between experimental and theoretical probability. Teacher asks what would make the two different types of probability the same and students discuss. Students work with the formula for experimental probability. Teacher then discusses the Law of Large Numbers and demonstrates with class data. Finally, teacher has students answer two questions about the Law of Large Numbers.',
		'https://evalwashington.blob.core.windows.net/asset-6d3a97c3-c87e-4db0-8bf4-90187544f429/Williams_Kyna_6_Math_Post_Part3_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A22Z&se=2016-04-14T04%3A16%3A22Z&sr=c&si=d5ffed23-8613-460e-8cb7-1a3851ea9274&sig=ZMCHdz73tWPyl3uzQIOVw99dVoD44srVOtL8De4hN7k%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-4d6320d9-c3c3-4a76-9500-554cc5665924/Williams_Kyna_6_Math_Post_Part3_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.3786884.jpg?sv=2012-02-12&se=2029-05-03T05:56:14Z&sr=c&si=5f298dfe-2620-44c2-9a90-691a8a42388c&sig=olRMkqrmOCeghoRdByuhzFF%2F1yozKc4rXAnVsfDW3cw%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')


/* Lori England Grade 11 Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Lori England Grade 11 Post Part1', '18:23', 
		'England Post - Part 1',
		'11th grade American Sign Language class reviews food vocabulary. Students work in partners or groups and come up with an ASL scenario to present in front of the class.',
		'https://evalwashington.blob.core.windows.net/asset-486dd641-b8c8-4709-95ec-b1822db51009/England_Lori_11_England_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A53Z&se=2016-04-14T04%3A16%3A53Z&sr=c&si=d5ec81b5-8167-4eb2-88a1-7b67bbe125a6&sig=eG2%2B843m9HIAB6xi%2BH4Hhb5QaW5eBQUHjulyTWpQkSA%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-e5a1b190-5b0a-4d18-8372-27738e048e3c/England_Lori_11_England_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.0364444.jpg?sv=2012-02-12&se=2029-05-03T05:55:10Z&sr=c&si=9177bae1-2059-4aa9-9149-54ac9f41143c&sig=ACPYQU1U6doyBgMQxuSz5RyFJjORda3PXt3XzvyIDiA%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')
	
/* Lori England Grade 11 Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Lori England Grade 11 Post Part2', '19:23', 
		'English Post - Part 2',
		'Groups present their scenarios to the rest of the class. Teacher gives feedback to presenters.',
		'https://evalwashington.blob.core.windows.net/asset-137d4e94-3248-4aed-a313-ab68b88af230/England_Lori_11_England_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A50Z&se=2016-04-14T04%3A16%3A50Z&sr=c&si=7b14fdf9-4b14-428d-b54d-c0dd410d8ca0&sig=9cE27f5TfaRMjBL2Iur9kBemRUy4VpTiJg54qPwfqKc%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-dfd48cce-a667-400c-abdc-e8c0c4ae4803/England_Lori_11_England_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.6304108.jpg?sv=2012-02-12&se=2029-05-03T05:53:56Z&sr=c&si=2acf2efd-ac08-482f-8748-920815483d74&sig=qyxNkx0Sc%2BDNJzD0RgJUiJnPDKpDCbf2Wp7GIg9UZZ8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')
		
/* Malia Sakamoto Grade 1 English Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Malia Sakamoto Grade 1 English Post Part2', '13:08', 
		'English Post - Part 2',
		'Students discuss what happened at the beginning, middle, and end of the story. Class then makes a Venn Diagram to compare and contrast the hermit crab’s two shells. Finally, students practice words with the “sh” and “ch” sound.',
		'https://evalwashington.blob.core.windows.net/asset-44bed320-750b-4646-a938-2ca1a2779d13/Sakamoto_Malia_1_English_Post_Part2_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A03Z&se=2016-04-14T04%3A16%3A03Z&sr=c&si=6ce82f29-e3e7-4588-a2fe-922136f07294&sig=c1JO3op%2BLgF1lDtZ%2FUI%2BYTdlMeSgF16%2BnNqFB5UU3h8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-19bef428-6c30-49b3-8c70-58af6e24d78c/Sakamoto_Malia_1_English_Post_Part2_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps_00.00.07.8873542.jpg?sv=2012-02-12&se=2029-05-03T05:52:48Z&sr=c&si=928464e4-d309-469a-ab35-980a57c49354&sig=CH55dFvWIdNbQWCb1VmQPlZv48SYdiqeJryOmxugtao%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')

/* Megan Newhouse Grade 9 English Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Megan Newhouse Grade 9 English Post Part2', '18:01', 
		'English Post - Part 2',
		'Video begins midway through class. In this 9th grade grade English class, students are reading an article individually and filling out a chart about traits/conflicts, evidence, and techniques. Students share with their groups the answers that they found. Each group then shares one item with the whole class.',
		'https://evalwashington.blob.core.windows.net/asset-8f91e596-3c7c-4974-bf94-044b3cf9dd11/Newhouse_Megan_9_English_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A15%3A57Z&se=2016-04-14T04%3A15%3A57Z&sr=c&si=f427a10b-affa-425a-92dc-e5e24a123fe3&sig=8xolSlg3duhQBAimMozti1Rkf7l5gN6J6KyRoZo1zk4%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-b831f9c0-14ec-41d0-979e-010cb0178cd8/Newhouse_Megan_9_English_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.8188734.jpg?sv=2012-02-12&se=2029-05-03T05:51:53Z&sr=c&si=4bc8e6c2-3954-46cb-bb1b-9d96e77a5510&sig=fTamQnXmKS86NfohEviMXzUqlKIY9qcWupAUIHx43kA%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')

/* Michelle Fujie Grade 8 Math Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Michelle Fujie Grade 8 Math Post Part1', '16:24', 
		'Math Post - Part 1',
		'8th grade math class starts off with students answering a think question about how the Pythagorean Theorem applies to real life. Class discusses, then teacher reviews concepts with students. Students then work on math problems individually.',
		'https://evalwashington.blob.core.windows.net/asset-4bb37408-149e-4d3a-8a9d-456cebdb4bb1/Fujie_Michelle_8_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A15%3A39Z&se=2016-04-14T04%3A15%3A39Z&sr=c&si=e7bd0043-6811-4ce6-8c26-0efc05816572&sig=WXIFysj4DBxwi5ALHAY6OR2jbwn9j7o8hqfkras%2BwKM%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-d190158a-4727-414a-ac56-74869dca1721/Fujie_Michelle_8_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.8401523.jpg?sv=2012-02-12&se=2029-05-03T05:50:42Z&sr=c&si=f23c138c-4b83-4b99-8c82-6db357514cf8&sig=5W7JOTDqE%2Ffm9DPJ%2B41dQlzMsaLUrNYGUz9S%2FFM6P%2B8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
		
/* Michelle Fujie Grade 8 Math Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Michelle Fujie Grade 8 Math Post Part2', '14:55', 
		'Math Post - Part 2',
		'Class discusses where they would see right angles in real life. Class then uses two real-life situations demonstrating the Pythagorean Theorem.',
		'https://evalwashington.blob.core.windows.net/asset-4649734a-ce33-43a2-9613-d3baa9a6f29c/Fujie_Michelle_8_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A15%3A32Z&se=2016-04-14T04%3A15%3A32Z&sr=c&si=322d8c16-5c30-4e93-9252-d7ec29cf0c31&sig=JBGafMi8Qt9BOgaEX65oLGU5qtT1sEvzbEZEAH0dJLo%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-f973c333-fa44-416d-8157-6397ba929638/Fujie_Michelle_8_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.9505958.jpg?sv=2012-02-12&se=2029-05-03T05:49:44Z&sr=c&si=664a24dd-7525-4094-be7c-814c865050c6&sig=sHTgymyDJ3vptRMjgLzfCjcU4U9Ksp4yjjEZfkLStoM%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
	
/* Nate Rozema Grade 6 English Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Nate Rozema Grade 6 English Post Part1', '16:11', 
		'English Post - Part 1',
		'6th grade English class talks about the importance of summarizing. Students then summarize the introduction of the story they’re reading. Class comes up with their own summaries of each section of the story.',
		'https://evalwashington.blob.core.windows.net/asset-dffbc744-d6ab-4f5a-b3a9-6b4dadcc3638/Rozema_Nate_6_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A16%3A00Z&se=2016-04-14T04%3A16%3A00Z&sr=c&si=b11c57fb-762b-42e8-9235-e3d30aaf5c7b&sig=p3CIieVi9dqUIPcRfiQoNeFl9P84UQgf0jS8k04mcNI%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-569dd821-7a8f-45fa-a120-0c4a93a26bf0/Rozema_Nate_6_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.7191764.jpg?sv=2012-02-12&se=2029-05-03T05:48:28Z&sr=c&si=b04f28d4-57f7-4b1a-9eee-aff4d7d23c69&sig=dB8iqdxvc37lFFvJHenrWPIsjv4Tv4C25hWCABvG37U%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Secondary', 'BERC Group')
	
/* Nick Fletcher Grade 7 Math Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Nick Fletcher Grade 7 Math Post Part2', '15:51', 
		'Math Post - Part 1',
		'7th grade math students read word problems out loud and talk them over together. Then they work on problems in small groups to determine how best to describe a set of data.',
		'https://evalwashington.blob.core.windows.net/asset-f360398f-3315-43f0-b37d-a75a3de45099/Fletcher_Nick_7_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A15%3A54Z&se=2016-04-14T04%3A15%3A54Z&sr=c&si=f18172dc-690a-4149-a016-e72423bdd6de&sig=ajMhpwu%2FKl7Boz25FtqMIrlcRLHDX1LEFrg6Is3LLSA%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-f02dc11b-33c6-4a30-8587-15e0a4e50607/Fletcher_Nick_7_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.5157696.jpg?sv=2012-02-12&se=2029-05-03T05:47:14Z&sr=c&si=77a91c08-7482-43a9-9cec-fe9827997c6d&sig=AtZ5lXld9Z4LW7CU6phSy2lRPBV8nB65YSgzJ2E4j3g%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
	
/* Pamelia Valentine Grade 9 Art Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Pamelia Valentine Grade 9 Art Post Part1', '16:51', 
		'Art Post - Part 1',
		'9th grade art lesson appears to begin midway through class. Students are divided into pairs and one person sits facing away from the screen at the front of the room. The other student stands facing the screen, reading the name of an artist, and describes that artist’s works, styles, etc., so the student who is sitting can guess the name of the artist that the standing student is describing. Later, the teacher walks the students through evaluating their own work according to a rubric. Finally, students work on their own sculptures.',
		'https://evalwashington.blob.core.windows.net/asset-f6adb72d-acb1-4984-ac30-d3f52773e28a/Valentine_Pamelia_9_Art_Post_Part1_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A58Z&se=2016-04-14T04%3A14%3A58Z&sr=c&si=71fe28f9-2c21-46ea-b71a-216df8c5d3db&sig=tnIJnDaxXgfRQYDNbFG1Yr93B8o5wuq7v0%2FZ1vR8AxY%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-985f2aec-dd3e-4633-9d68-cc9ca78a511e/Valentine_Pamelia_9_Art_Post_Part1_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.1187918.jpg?sv=2012-02-12&se=2029-05-03T05:46:01Z&sr=c&si=08768824-4434-469f-a004-3eeb4e692c2c&sig=xNsqxiO%2F%2B%2BOEaL5dEr8l9X%2FZl3syZq9Iu3ftXHiXBO8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Secondary', 'BERC Group')
		
/* Pamelia Valentine Grade 9 Art Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Pamelia Valentine Grade 9 Art Post Part2', '19:40', 
		'Art Post - Part 2',
		'Students evaluate the work of other students, and discuss with each other. The teacher has the students fill out progress forms before they leave class, regarding their sense of their own progress.',
		'https://evalwashington.blob.core.windows.net/asset-81ff80b6-2298-46fd-a32e-17c990ae0f1a/Valentine_Pamelia_9_Art_Post_Part2_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A54Z&se=2016-04-14T04%3A14%3A54Z&sr=c&si=b9820bdc-75eb-4b0f-9843-5731da468c82&sig=HoxgOFVbMP3xn6JRPQ5rhxjew%2FEujJ1OUBgus%2F5%2B2IM%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-16de32f4-4312-46ec-a3e4-34bd445ed31a/Valentine_Pamelia_9_Art_Post_Part2_480p_1200k.mp4_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.8033995.jpg?sv=2012-02-12&se=2029-05-03T05:45:09Z&sr=c&si=9cd49a8f-8c2b-47d5-9fb0-27b73a147db9&sig=2uOUDHc84Iwe%2FpxcSdqu0w1EpfzRatYAtD0tbAPxvHw%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Art', 'Secondary', 'BERC Group')

/* Richard Salboro Grade 11 Science Post Part1a */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Richard Salboro Grade 11 Science Post Part1a', '16:40', 
		'Science Post - Part 1a',
		'This 11th grade science class begins with explaining two benchmarks for reaching standard for the day: distinguish between two types of waves and describe vibrations and waves. The teacher shows a video of dancing corn starch (really!) and asks students to answer, “What do you think is causing the “ublek” to dance?” Students discuss their answers after the video.',
		'https://evalwashington.blob.core.windows.net/asset-5b158462-dad7-4c91-96e9-bf88c77b1fd9/Salboro_Richard_11_Science_Post_Part1a_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A47Z&se=2016-04-14T04%3A14%3A47Z&sr=c&si=026cad42-7766-4b6a-8696-212855a60c0e&sig=z50L%2FImQsU8Jkd3OT4klrdpm3A6%2FlUa%2FdNk607HQj7A%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-900299dd-0e3e-47e4-b076-cc14d7018daf/Salboro_Richard_11_Science_Post_Part1a_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.0036208.jpg?sv=2012-02-12&se=2029-05-03T05:44:07Z&sr=c&si=23e2fe99-cc17-4ccd-b4d7-53ebf9392095&sig=8ku%2Bv62wz0B4o3lb44jOqkj8ocOePWktv1x21j4j8So%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
		

/* Russ Hermann Grade 11 CTE Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Russ Hermann Grade 11 CTE Part1', '19:34', 
		'CTE Post - Part 1',
		'In this 11th grade CTE class, the teacher is working with a class to design homeless shelters, focusing on making the airflow such that the temperature inside each shelter remains at 60 degrees. The students divide into teams to begin constructing scale models of the shelters out of cardboard.',
		'https://evalwashington.blob.core.windows.net/asset-3fa62ca8-a9b2-4525-ae0d-d8e29553053d/Herman_Russ_11_CTE_Part1_360p_500k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-16T22%3A29%3A31Z&se=2016-04-15T22%3A29%3A31Z&sr=c&si=17b09f3e-ba55-41bc-afc0-842b6f156cd5&sig=CORt9pksIgiSOQctNj4QqGlmQdNLtS4y3NQm2cbouV8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-9df73b44-7238-4532-a891-b3d3b88cdd5f/Herman_Russ_11_CTE_Part1_360p_500k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.11.7467428.jpg?sv=2012-02-12&se=2029-05-04T05:27:15Z&sr=c&si=0641b48e-bc29-40b7-87a2-0c1f17d5b0b9&sig=nVI1anE4AqWFTseiOmDila24G8wpRukJhVlRM9Y%2FDUc%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('CTE', 'Secondary', 'BERC Group')


/* Russ Hermann Grade 11 CTE Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Russ Hermann Grade 11 CTE Part2', '20:28', 
		'CTE Post - Part 2',
		'Students work in their groups to come up with plans for their homeless shelters as the teacher circulates to answer questions and provide feedback. Finally, the class tests out their shelters in the school’s freezer to see which group’s construction maintains a 60 degree temperature most successfully.',
		'https://evalwashington.blob.core.windows.net/asset-8ce562e6-34d7-4252-9b92-1808183c73a6/Herman_Russ_11_CTE_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-16T22%3A29%3A38Z&se=2016-04-15T22%3A29%3A38Z&sr=c&si=94e672bb-e13b-4a78-8385-edb3ef23b638&sig=CnkxnVvTYbIUQsn2093ILuu7WpZISCa3GpGg7%2Ffgbyg%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-5253015e-bcd6-410e-8ab4-dd18b2ddf224/Herman_Russ_11_CTE_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.12.2854457.jpg?sv=2012-02-12&se=2029-05-03T05:36:08Z&sr=c&si=abecf68f-51da-420a-9ece-b00f3d58ace4&sig=nBqR7G5vH%2Bgg5WEpQc6Hw0S4dz%2FskSl5lf%2F6iVaCJ0c%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('CTE', 'Secondary', 'BERC Group')

	
/* Ryan Grant Grade 1 Social Studies Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Ryan Grant Grade 1 Social Studies Post Part1', '14:16', 
		'Social Studies Post - Part 1',
		'1st grade social studies teacher recaps all the year’s holidays and goes on to talk about all the members of the family in preparation for a class on Father’s Day. Students list “Dadjectives” about their fathers.',
		'https://evalwashington.blob.core.windows.net/asset-1c061400-80b0-4564-87d6-2b66b03ff439/Grant_Ryan_1_Social_Studies_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A33Z&se=2016-04-14T04%3A14%3A33Z&sr=c&si=d56287e6-80b8-4098-8973-d1c4b94e82b2&sig=f%2BEGgNqbTQq7a8TpSFsZ2UIP0k9JyfEdCK4K4fqUY%2Bo%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-f4e5942a-ca29-4894-88c0-4b2451b7c356/Grant_Ryan_1_Social_Studies_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.5623582.jpg?sv=2012-02-12&se=2029-05-03T05:43:07Z&sr=c&si=3bb52041-78cf-4908-88ea-ec582fd343b7&sig=Wmo1KYpZ5IgIbAFfDJUPvuSVMNAx3ZEMsKvdK%2B8Gw3c%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Primary', 'BERC Group')
	
/* Ryan Grant Grade 1 Social Studies Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Ryan Grant Grade 1 Social Studies Post Part2', '13:24', 
		'Social Studies Post - Part 2',
		'The teacher explains how to create similes to compare the students’ dads to someone or something else. The students split into pairs to fill in the blanks for eight similes, and finally the teacher brings the class back together to go over all of their answers as a group.',
		'https://evalwashington.blob.core.windows.net/asset-5c8786eb-e4cc-4906-b5e3-47bc70c501a5/Grant_Ryan_1_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A30Z&se=2016-04-14T04%3A14%3A30Z&sr=c&si=aad47c39-1a82-4050-b756-0a378ac9d49b&sig=ZVpWLcYuF6K0RjjB7jgHzRv5JF0%2BmXfbX58kdzikpHk%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-b54176af-cbc8-43c5-ba33-5d52805ca601/Grant_Ryan_1_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.0454821.jpg?sv=2012-02-12&se=2029-05-03T05:41:57Z&sr=c&si=58cbe174-ef3d-4af8-8a6f-2f892c24facd&sig=kAqP%2Blkw56F0o7zxE1vbyn%2B8VYRp650bB9NX9jtvg14%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Primary', 'BERC Group')

	
/* Sandi Speedy Grade 4 Social Studies Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Sandi Speedy Grade 4 Social Studies Post Part1', '15:12', 
		'Social Studies Post - Part 1',
		'This 4th grade social studies class begins by recapping the previous day’s class and then turns to a discussion of the Constitution. The students split into groups to decide why the Constitution was created, with the teacher prompting them to think about a set of rules in their own families, and why those rules are important. Finally, the class reads through the Preamble to the Constitution.',
		'https://evalwashington.blob.core.windows.net/asset-ab72f32b-6a37-4367-93a1-c90aea755290/Speedy_Sandi_4_Social_Studies_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A26Z&se=2016-04-14T04%3A14%3A26Z&sr=c&si=fb840215-be1f-4e4b-91a4-a23aed6f55fa&sig=F8YQ4pZracgeXejRcTkNCazASwEOmVHXhPjBygVUuMk%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-67e7bdb3-deed-4f46-9e35-ebcb96ee88e8/Speedy_Sandi_4_Social_Studies_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.1275320.jpg?sv=2012-02-12&se=2029-05-03T05:40:52Z&sr=c&si=49f9b49b-a325-44b4-b3c7-d54178d679b2&sig=nagMNsFxokxkERt5Glkyr7gF9usRjSyolcJR3kUh5Bc%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Intermediate', 'BERC Group')

/* Shelly Nagle Grade 10 Science Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Shelly Nagle Grade 10 Science Post Part1', '16:32', 
		'Science Post - Part 1',
		'10th grade science students begin by creating a Venn diagram of lytic and lysogenic cycles, and then the teacher compiles the responses on the board. The class splits into small groups and each group is tasked with coming up with a medication for a mystery virus and explaining how it affects each cycle.',
		'https://evalwashington.blob.core.windows.net/asset-7ce66451-e724-4193-b2ae-f46b7b71c4d2/Nagle_Shelly_10_Science_Post_Part1_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A23Z&se=2016-04-14T04%3A14%3A23Z&sr=c&si=21f01e76-9714-406a-9d45-d7fad14f03b4&sig=n%2B4jJms3CZojlKFxR1%2F9OKbuXh9EvBMefYs02hD0O9E%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-5facccf1-5461-46e4-91f8-0adb175d811f/Nagle_Shelly_10_Science_Post_Part1_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.9286204.jpg?sv=2012-02-12&se=2029-05-03T05:39:42Z&sr=c&si=2e816599-0baf-4004-b3cb-a5fbd35c794b&sig=%2F%2F8ujvOSv9eoOwySNTtoMZsNihVgd98Xl08gh9maQ%2FE%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')

/* Shelly Nagle Grade 10 Science Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Shelly Nagle Grade 10 Science Post Part2', '15:32', 
		'Science Post - Part 2',
		'Already split into smaller groups, the students work on creating the medication for a virus they’ve invented. Then, the students present their work to the class. Each of the students then votes on which medication he thinks will have the greatest chance of curing the disease.',
		'https://evalwashington.blob.core.windows.net/asset-f0cfa129-564f-4364-b581-922632c9638f/Nagle_Shelly_10_Science_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A19Z&se=2016-04-14T04%3A14%3A19Z&sr=c&si=981348ae-536f-4c5b-8d69-db87b62fd076&sig=kCsFpf2vwEv%2Fn6%2FpMYco5aq%2BdoBs9Sd6utTbxJLx5KA%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-8d581851-df64-4720-b6a6-dde526bb34dc/Nagle_Shelly_10_Science_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.3288490.jpg?sv=2012-02-12&se=2029-05-03T05:38:25Z&sr=c&si=515822f4-a214-4126-82ed-784056eb07d4&sig=k3SnG5qv%2FRwD8dcOXpWFJJxERWiGid3wIMki4BvcgSU%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
	
/* Sherri Rico Grade 4 Social Studies Post Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Sherri Rico Grade 4 Social Studies Post Part2', '15:31', 
		'Social Studies Post - Part 2',
		'4th grade social studies teacher assigns roles to each student, and the students, divided into groups of about five, read through a passage in an American History book.',
		'https://evalwashington.blob.core.windows.net/asset-8e7f2f23-0b4e-4889-88c8-9f1daaee423d/Rico_Sherri_4_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-15T04%3A14%3A53Z&se=2016-04-14T04%3A14%3A53Z&sr=c&si=778d1179-8171-48e4-97c5-e39c2ca81f83&sig=MDqJT6sJ3ySOTCTRbRDSXaOHB3%2Fb4Ug8kOkPxrK%2FMuM%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-a50c7cd6-2ee7-4a23-81f3-0bc2a3389f17/Rico_Sherri_4_Social_Studies_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.3179355.jpg?sv=2012-02-12&se=2029-05-03T05:37:24Z&sr=c&si=863dd639-fd67-4ee8-bbac-002b5e46be9f&sig=lGxkk7JczUH2FqqFANv8W6hXh5IbWOEPCyMo9kSUrmY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Social Studies', 'Intermediate', 'BERC Group')

/* Tammy Mendoza Grade 6 Science Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tammy Mendoza Grade 6 Science Post Part1', '15:22', 
		'Science Post - Part 1',
		'6th grade science teacher asks the students what will happen when a sewer line is removed from a nearby watershed area, and the students come up with answers in small groups. Some of the students then present their answers.',
		'https://evalwashington.blob.core.windows.net/asset-2ecfee19-0984-4f0f-a0df-76925e88549c/Mendoza_Tammy_6_Science_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-16T23%3A45%3A01Z&se=2016-04-15T23%3A45%3A01Z&sr=c&si=b60c5b32-a839-48ee-9fc3-d15bc568a23a&sig=Geld4FABpYK%2FJAVsai2AsDa%2BRwvr%2Fg6sYyRaxTpSwK8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-cd85377e-35a1-4c11-b745-cae97355fcbf/Mendoza_Tammy_6_Science_Post_Part1_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.2201795.jpg?sv=2012-02-12&se=2029-05-03T05:32:42Z&sr=c&si=1a4a2794-f76a-4220-8b9d-27503671135b&sig=tpeuYWc2FevlKIWPnxA0owMfTLcM7ahc2y%2BFkeh5ihs%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
		
/* Tammy Mendoza Grade 6 Science Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tammy Mendoza Grade 6 Science Post Part2', '14:59', 
		'Science Post - Part 2',
		'Students jot notes down about their experiments and the data they have gathered. Then they being to work with their creek replicas.',
		'https://evalwashington.blob.core.windows.net/asset-34bca8e6-fdb2-44f8-8345-cd4dfc264a48/Mendoza_Tammy_6_Science_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-16T23%3A44%3A58Z&se=2016-04-15T23%3A44%3A58Z&sr=c&si=da6cfa45-6699-4d13-8f4f-81ed12fa8498&sig=k%2FdHT%2F9qUyGu0MPfJ%2B3pr5pNn0YUUq7c86KryenXuEc%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-9fce43e4-4cec-4916-ac60-1d487c0cd9b2/Mendoza_Tammy_6_Science_Post_Part2_4x3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.9907664.jpg?sv=2012-02-12&se=2029-05-03T05:33:48Z&sr=c&si=ee31a47c-a297-4aec-80d2-2d971b7fc301&sig=cLjhhEFV6vaLg7yqBnk3ZF9s2q58FUalN19pg993cjY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Science', 'Secondary', 'BERC Group')
		
/* Tania Will Grade K Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tania Will Grade K Math Post Part1', '10:51', 
		'Math Post - Part 1',
		'This Kindergarten math class discusses taking away to subtract. Teacher reads Ten Flashing Fireflies. Students use the paper fireflies they created in a previous class to demonstrate their understanding of subtraction. Students write number sentences on the board. Students review various math concepts (patterns, math books, etc.) in math centers and teacher visits each group.',
		'https://evalwashington.blob.core.windows.net/asset-5b4e4ee3-afbd-4dab-8cbf-7b7dc2a55f8f/Will_Tania_K_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T16%3A14%3A25Z&se=2016-04-16T16%3A14%3A25Z&sr=c&si=2d1ca518-ad73-4246-8366-dea80ed3a6ef&sig=JKcJJcw7uWNS2CEwFqmmv2YnwnmJ1Wvf85u1nPZ4U08%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-ba02c4fa-0187-47f7-a6e6-d686cea99df1/Will_Tania_K_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.06.5194666.jpg?sv=2012-02-12&se=2029-05-03T05:30:43Z&sr=c&si=b23b009f-02db-4199-9567-220e2cbc2a99&sig=x9nudcUZaKuzA0C1JS5mBkmHLUd%2Fg%2FYWbuy6VQgTHGI%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'BERC Group')

/* Tania Will Grade K English Post Part1*/
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tania Will Grade K English Post Part1', '11:36', 
		'English Post - Part 1',
		'Kindergarten English teacher begins by reading idea maps that the students created about books they’ve read in the current month. One student catches the class up on what happened in their latest book the day before, and the teacher continues reading.',
		'https://evalwashington.blob.core.windows.net/asset-2b7ab07b-d829-4365-b5b4-598c74bab804/Will_Tania_K_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T16%3A14%3A21Z&se=2016-04-16T16%3A14%3A21Z&sr=c&si=b0fa55dc-0392-4b84-9801-a681f4ae4b7b&sig=OSI8cP26XN4rmoik9duw855GW%2BxbR67NC1a8T2z7b%2Bs%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-855b194e-360e-4b50-a785-1944771cffc9/Will_Tania_K_English_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.06.9608780.jpg?sv=2012-02-12&se=2029-05-03T05:31:45Z&sr=c&si=9643a0a4-044d-4475-aa29-98ad6250dfda&sig=rocshSmmNsuBd7JxXzWo00%2FCvGiL%2FKaRyWbm0iJ5FU8%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')
		
		
/* Tania Will Grade K English Post Part3 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tania Will Grade K English Post Part3', '13:55', 
		'English Post - Part 3',
		'The students write in their journals and show their drawings and illustrations to the teacher, who selects a few particularly great examples and shows them to the class. Finally,  the students share with each other something from the class that they most appreciated.',
		'https://evalwashington.blob.core.windows.net/asset-040b6b0c-5308-472c-a965-c7f6cb45d90c/Will_Tania_K_English_Post_Part3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T16%3A14%3A29Z&se=2016-04-16T16%3A14%3A29Z&sr=c&si=011ac310-fc6e-45d7-9489-43d1cf13a381&sig=cTjm8me74DcrA7Rzl03AxDmF0tb%2F7l3YaWufudXRQ%2Fc%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-4c337304-cc49-467b-9100-edb2be398cf5/Will_Tania_K_English_Post_Part3_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.3580226.jpg?sv=2012-02-12&se=2029-05-03T05:29:54Z&sr=c&si=25617fa8-bfda-4ff6-8793-71adc3216f59&sig=rnUadG2xZc%2Bytvo2H3ABTR4%2BS5X8BB0z8MdgN31eWfY%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('English/Language Arts', 'Primary', 'BERC Group')

/* Tanya Rolfs Grade 1 Math Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tanya Rolfs Grade 1 Math Post Part2', '17:04', 
		'Math Post - Part 2',
		'Begins midway through class. 1st grade math students work on counting, with the teacher checking each student’s work. The class is divided into several sections, and each section works on a different sort of math problem.',
		'https://evalwashington.blob.core.windows.net/asset-edd4348e-3bf2-451e-ba43-14c4961cf2b1/Rolfs_Tanya_1_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T16%3A13%3A33Z&se=2016-04-16T16%3A13%3A33Z&sr=c&si=6e49e10f-173d-442e-9853-423ac8ca0f04&sig=hRBOWUIXh7au935gM30MMfONWiXuP6NHLLQ81RsIbV8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7414bb23-0e1a-4efa-a996-28185c64591a/Rolfs_Tanya_1_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.2488235.jpg?sv=2012-02-12&se=2029-05-03T05:28:48Z&sr=c&si=d3b0dbba-a54a-4dbc-b2fb-bde439229a84&sig=l8Y0WyJiEHngBv9eWHU6DY5r8gJfme8ysQ1tCqQUe8g%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Primary', 'BERC Group')
		
/* Tess Kaji Grade 11 Math Pre Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tess Kaji Grade 11 Math Pre Part1', '15:12', 
		'Math Pre - Part 1',
		'In this 11th grade math class, the focus is set on “How can the height of an object be determined using trigonometric functions?” The teacher works with a class first to predict and then mathematically to solve how high the ceiling is in the classroom.',
		'https://evalwashington.blob.core.windows.net/asset-ed3beaff-8621-40e2-b28e-91f794a08035/Kaji_Tess_11_Math_Pre_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T16%3A19%3A42Z&se=2016-04-16T16%3A19%3A42Z&sr=c&si=f37da465-2b8d-4624-8904-44ffad57b41e&sig=MjJNYxpDNcm6HuRcxooeLxUga%2BDHNb8xKmWISDy2iOs%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-2cc4b8eb-30b2-4d20-bd5b-5ab0c758d5da/Kaji_Tess_11_Math_Pre_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.06.1909043.jpg?sv=2012-02-12&se=2029-05-03T05:27:40Z&sr=c&si=9c0e3a2a-d006-4811-beed-be70a7bfaf68&sig=XMgDGZdW7qKPP1PCS77XqXMkvKUldD6rL8SZI53kQf0%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
		
/* Tess Kaji Grade 11 Math Pre Part2 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tess Kaji Grade 11 Math Pre Part2', '14:05', 
		'Math Pre - Part 2',
		'The class goes outside and splits into small groups to determine the height of a flagpole. Then the students explain to each other and the class how they arrived at their answers.',
		'https://evalwashington.blob.core.windows.net/asset-c4e533fd-e5cb-4b31-a76c-58b9f8db256d/Kaji_Tess_11_Math_Pre_Part2_480p_2000k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T16%3A19%3A45Z&se=2016-04-16T16%3A19%3A45Z&sr=c&si=9c41ed12-958f-4f70-be8a-96fc5594b095&sig=OJpF4Mmz3lIS4mCfF3KO6G%2FT3A2YVAH5FHgIO%2BBA5os%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-7d86ea07-fc92-4f03-bdc7-c5d9959b3442/Kaji_Tess_11_Math_Pre_Part2_480p_2000k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.08.4587973.jpg?sv=2012-02-12&se=2029-05-03T05:26:48Z&sr=c&si=4ad8333b-7565-4991-b4a5-4e7eb14efbc2&sig=d0ebxqOocCnEy%2BQTYP%2FEecvFt4D4Odl1MNU4WIqT30w%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
 		
/* Tess Kaji Grade 11 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tess Kaji Grade 11 Math Post Part1', '16:10', 
		'Math Post - Part 1',
		'11th grade math students solve problems at first on their own and then on the board. The teacher and students go over all of the problems. They talk about how to use trigonometric functions to find an unknown height.',
		'https://evalwashington.blob.core.windows.net/asset-1b5d57fb-c83c-48e4-964f-a50a4f3cba86/Kaji_Tess_11_Math_Post_Part1_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T16%3A19%3A50Z&se=2016-04-16T16%3A19%3A50Z&sr=c&si=cc4643b7-dd89-4b63-9976-fdac3ba6c872&sig=z52viEBzKZTBtc0%2FA5cTeOGmfCQXXf6soIE9Yp2kOk8%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-02c00237-a025-4aef-ba65-9cd8af605705/Kaji_Tess_11_Math_Post_Part1_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.7059410.jpg?sv=2012-02-12&se=2029-05-03T05:25:43Z&sr=c&si=a4cdfaf7-0605-4e41-8bcf-ca1e73d799eb&sig=EfAaG4e%2B5RlXe4irttPqNcZ1ZzvZSFXL66gYmqMgJ%2Bk%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
		
/* Tess Kaji Grade 11 Math Post Part2 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tess Kaji Grade 11 Math Post Part2', '15:28', 
		'Math Post - Part 2',
		'First, the class solves word problems on the board together, and then the students work on problems individually at their desks.',
		'https://evalwashington.blob.core.windows.net/asset-2e2b3504-9d98-44ce-bbd0-65b7a011bdff/Kaji_Tess_11_Math_Post_Part2_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-18T00%3A17%3A22Z&se=2016-04-17T00%3A17%3A22Z&sr=c&si=ffd416a9-ecae-412e-88dc-49fcb50016c3&sig=Sjqck1beanqrfkTfLCkvB4O5gebbSIeUYap3iHgk9qw%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-72041e6b-1bf4-4fd6-8f27-b3ef596394c1/Kaji_Tess_11_Math_Post_Part2_16x9_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.2810158.jpg?sv=2012-02-12&se=2029-05-03T04:59:32Z&sr=c&si=e7b90ee9-3e33-433e-af85-f76581f57b3d&sig=7WPgaardMQNe6ErwuWWd5Y5817mwuVZbJ%2B1K5HNEf3M%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
 		
/* Tracy Dickinson Grade 6 Math Post Part1 */	
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Tracy Dickinson Grade 6 Math Post Part2', '17:16', 
		'Math Post - Part 2',
		'6th grade math teacher introduces students to the surface area of a cylinder, and then the class is split up into groups to determine the surface areas of various solid objects. The teacher goes from group to group to help and give advice, and then calls the class back together to talk about what everyone learned.',
		'https://evalwashington.blob.core.windows.net/asset-d5430b01-ea77-43e7-adfa-736d9a93417d/Dickinson_Tracy_6_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T23%3A54%3A37Z&se=2016-04-16T23%3A54%3A37Z&sr=c&si=14082c94-dd3b-423e-a10b-6fca1bcaea10&sig=qTNQibi58S6V6Cw4WXT8iHZdX4vHrvycDHwksiztX0M%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-cdb324a8-6921-41d6-9f4d-6d8ae1a2a444/Dickinson_Tracy_6_Math_Post_Part2_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.10.3667810.jpg?sv=2012-02-12&se=2029-05-03T05:24:34Z&sr=c&si=af3a7896-8acd-4377-807b-7ad523e27423&sig=D21EbWNVcafsCJM9YoGy0EjMN%2BPsbRhGeGkVrG2KnNo%3D'
		)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')
	
/* Travis Geving Grade 7 Math Post Part1 */
INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
VALUES(1, 0, 'Travis Geving Grade 7 Math Post Part1', '16:07', 
		'Math Post - Part 1',
		'7th grade math students split into pairs to match math diagrams – tables, charts, etc. – with a problem to which each diagram might apply. Then the class works on coming up with tables from provided word problems, and going the other way – understanding the context from a graph or table.',
		'https://evalwashington.blob.core.windows.net/asset-920b5a26-282f-4739-941d-c97c202fd5d3/Geving_Travis_7_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps.mp4?sv=2012-02-12&st=2014-04-17T23%3A55%3A11Z&se=2016-04-16T23%3A55%3A11Z&sr=c&si=36ede7cb-6ac8-4dde-b7de-fbc7389a153e&sig=E5XYPSEcMuzmMgUwvUSpQpGHfdlEJdWhQFv%2BmVi1D0g%3D',
		'',
		'https://evalwashington.blob.core.windows.net/asset-6380133d-9c1f-4894-bd6c-53d5d6306577/Geving_Travis_7_Math_Post_Part1_480p_1200k_H264_4500kbps_AAC_und_ch2_128kbps_00.00.09.6799346.jpg?sv=2012-02-12&se=2029-05-03T05:23:33Z&sr=c&si=9ae6a028-ffd3-4ef1-9db6-d9f344cb0522&sig=jgX3MqHzsZ3U48Q3wmvTWOVtgPDxBrgP3OQX11Eyf2M%3D'
	)
SELECT @ProtocolID=SCOPE_IDENTITY()
INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
SELECT @ProtocolID,
       lb.TrainingProtocolLabelID
  FROM dbo.SETrainingProtocolLabel lb
 WHERE lb.Name in ('Math', 'Secondary', 'BERC Group')


/* Set all the old ones */
UPDATE dbo.SETrainingProtocol SET IncludeInPublicSite=1, IncludeInVideoLibrary=1 WHERE TrainingProtocolID<5
/* Set all the new ones */
UPDATE dbo.SETrainingProtocol SET IncludeInPublicSite=0, IncludeInVideoLibrary=1 WHERE TrainingProtocolID>4
	

/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


