Find all "setraining", Subfolders, Find Results 1, "D:\dev\SE\trunk\src\sql\updates"
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(43):CREATE TABLE [dbo].[SETrainingProtocolLabelAssignment](
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(48):CREATE TABLE [dbo].[SETrainingProtocol](
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(59): CONSTRAINT [PK_SETrainingProtocol] PRIMARY KEY CLUSTERED 
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(65):CREATE TABLE [dbo].[SETrainingProtocolLabelGroup](
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(68): CONSTRAINT [PK_SETrainingProtocolLabelGroup] PRIMARY KEY CLUSTERED 
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(74):CREATE TABLE [dbo].[SETrainingProtocolLabel](
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(78): CONSTRAINT [PK_SETrainingProtocolLabel] PRIMARY KEY CLUSTERED 
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(84):CREATE TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment](
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(90):ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel] FOREIGN KEY([TrainingProtocolLabelID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(91):REFERENCES [dbo].[SETrainingProtocolLabel] ([TrainingProtocolLabelID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(92):ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] CHECK CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocolLabel]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(93):ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(94):REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(95):ALTER TABLE [dbo].[SETrainingProtocolLabelAssignment] CHECK CONSTRAINT [FK_SETrainingProtocolLabelAssignment_SETrainingProtocol]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(97):ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Title]  DEFAULT ('') FOR [Title]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(98):ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Summary]  DEFAULT ('') FOR [Summary]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(99):ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Description]  DEFAULT ('') FOR [Description]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(100):ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Published]  DEFAULT ((0)) FOR [Published]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(101):ALTER TABLE [dbo].[SETrainingProtocol] ADD  CONSTRAINT [DF_SETrainingProtocol_Retired]  DEFAULT ((0)) FOR [Retired]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(103):ALTER TABLE [dbo].[SETrainingProtocolLabel]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup] FOREIGN KEY([TrainingProtocolLabelGroupID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(104):REFERENCES [dbo].[SETrainingProtocolLabelGroup] ([TrainingProtocolLabelGroupID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(105):ALTER TABLE [dbo].[SETrainingProtocolLabel] CHECK CONSTRAINT [FK_SETrainingProtocolLabel_SETrainingProtocolLabelGroup]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(109):ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocol_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(110):REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(111):ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] CHECK CONSTRAINT [FK_SETrainingProtocol_SETrainingProtocol]
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(113):ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocol_SEFrameworkNode] FOREIGN KEY([FrameworkNodeID])
  D:\dev\SE\trunk\src\sql\updates\37531685_trainingProtocols.sql(115):ALTER TABLE [dbo].[SETrainingProtocolFrameworkNodeAlignment] CHECK CONSTRAINT [FK_SETrainingProtocol_SEFrameworkNode]
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(155):INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('Subject Area')
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(156):INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('Grade Level')
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(157):INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('Strategy Area')
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(160):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Reading', 1)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(161):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Math', 1)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(162):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Writing', 1)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(165):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Primary', 2)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(166):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Secondary', 2)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(170):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Content', 3)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(172):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Instructional', 3)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(173):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Assessment', 3)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(183):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(191):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(194):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(197):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(207):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(220):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(228):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(231):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(234):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(244):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(257): INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(265):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(275):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(288):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, DocName)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(296):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(299):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(302):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\37533827_trainingProtocolsData.sql(312):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\60345690_trainingProtocolsOverviews.sql(43):UPDATE dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\60345690_trainingProtocolsOverviews.sql(47):UPDATE dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\60345690_trainingProtocolsOverviews.sql(51): UPDATE dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\60345690_trainingProtocolsOverviews.sql(55): UPDATE dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(43):ALTER TABLE SETrainingProtocol 
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(46):ALTER TABLE SETrainingProtocol 
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(49):ALTER TABLE SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(52):ALTER TABLE SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(58):ALTER TABLE [dbo].[SEEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalSession_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(59):REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(73):ALTER TABLE [dbo].[SEDistrictTrainingProtocolAnchor]  WITH CHECK ADD  CONSTRAINT [FK_SEDistrictTrainingProtocolAnchor_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(74):REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(80):CREATE TABLE [dbo].[SETrainingProtocolPlaylist] (
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(84): CONSTRAINT [PK_SETrainingProtocolPlaylist] PRIMARY KEY CLUSTERED 
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(90):ALTER TABLE [dbo].[SETrainingProtocolPlaylist]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolPlaylist_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(91):REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(93):ALTER TABLE [dbo].[SETrainingProtocolPlaylist]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolPlaylist_SEUser] FOREIGN KEY([UserID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(97):CREATE TABLE [dbo].[SETrainingProtocolRatingStatusType](
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(100): CONSTRAINT [PK_SETrainingProtocolRatingStatusType] PRIMARY KEY CLUSTERED 
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(107):CREATE TABLE [dbo].[SETrainingProtocolRating] (
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(116): CONSTRAINT [PK_SETrainingProtocolRating] PRIMARY KEY CLUSTERED 
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(122):ALTER TABLE [dbo].[SETrainingProtocolRating]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolRating_SETrainingProtocol] FOREIGN KEY([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(123):REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(125):ALTER TABLE [dbo].[SETrainingProtocolRating]  WITH CHECK ADD  CONSTRAINT [FK_SETrainingProtocolRating_SEUser] FOREIGN KEY([UserID])
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(128):ALTER TABLE dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(131):ALTER TABLE dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(134):ALTER TABLE dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\66740046_Resources_VideoSchemaChanges.sql(195):REFERENCES [dbo].[SETrainingProtocol] ([TrainingProtocolID])
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(44):SELECT * FROM dbo.SETrainingProtocol
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(62):UPDATE SETrainingProtocol SET ImageName='video96.png' WHERE TrainingProtocolID=1
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(63):UPDATE SETrainingProtocol SET AvgRating=0
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(70):INSERT dbo.SETrainingProtocolRatingStatusType(Name) VALUES('InReview')
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(71):INSERT dbo.SETrainingProtocolRatingStatusType(Name) VALUES('Approved')
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(72):INSERT dbo.SETrainingProtocolRatingStatusType(Name) VALUES('Inappropriate')
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(74):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Social Studies', 1)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(75):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Science', 1)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(76):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('English/Language Arts', 1)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(77):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Art', 1)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(78):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('CTE', 1)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(80):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Intermediate', 2)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(82):INSERT dbo.SETrainingProtocolLabelGroup(Name) VALUES('ProvidedBy')
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(85):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('National Board', 4)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(86):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('BERC Group', 4)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(89):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(97):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(100):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(104):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(113):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(116):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(120):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(129):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(132):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(137):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(146):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(149):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(153):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(162):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(165):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(170):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(179):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(182):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(186):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(195):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(198):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(202):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(211):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(214):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(219):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(228):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(231):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(236):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(245):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(248):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(253):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(262):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(265):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(270):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(279):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(282):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(286):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(295):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(298):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(302):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(311):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(314):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(318):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(327):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(330):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(335):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(344):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(347):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(351):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(360):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(363):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(368):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(377):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(380):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(384):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(393):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(396):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(400):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(409):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(412):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(416):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(425):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(428):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(432):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(441):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(444):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(449):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(458):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(461):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(465):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(474):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(477):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(481):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(490):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(493):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(497):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(506):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(509):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(513):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(522):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(525):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(530):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(539):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(542):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(547):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(556):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(559):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(563):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(572):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(575):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(579):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(588):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(591):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(595):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(604):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(607):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(611):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(620):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(623):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(627):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(636):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(639):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(643):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(652):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(655):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(659):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(668):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(671):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(675):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(684):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(687):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(691):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(700):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(703):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(707):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(716):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(719):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(723):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(732):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(735):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(739):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(748):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(751):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(755):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(764):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(767):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(771):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(780):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(783):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(788):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(797):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(800):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(804):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(813):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(816):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(821):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(830):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(833):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(837):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(846):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(849):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(854):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(863):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(866):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(870):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(879):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(882):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(886):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(895):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(898):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(902):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(911):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(914):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(919):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(928):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(931):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(935):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(944):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(947):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(951):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(960):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(963):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(967):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(976):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(979):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(983):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(992):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(995):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(999):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1008):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1011):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1016):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1025):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1028):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1033):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1042):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1045):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1049):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1058):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1061):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1065):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1074):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1077):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1082):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1091):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1094):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1099):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1108):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1111):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1115):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1124):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1127):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1131):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1140):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1143):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1147):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1156):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1159):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1163):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1172):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1175):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1179):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1188):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1191):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1195):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1204):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1207):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1211):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1220):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1223):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1227):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1236):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1239):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1243):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1252):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1255):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1259):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1268):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1271):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1276):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1285):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1288):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1293):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1302):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1305):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1310):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1319):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1322):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1326):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1335):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1338):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1343):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1352):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1355):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1359):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1368):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1371):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1375):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1384):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1387):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1391):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1400):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1403):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1407):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1416):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1419):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1423):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1432):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1435):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1439):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1448):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1451):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1455):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1464):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1467):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1472):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1481):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1484):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1488):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1497):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1500):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1504):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1513):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1516):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1520):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1529):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1532):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1536):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1545):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1548):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1552):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1561):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1564):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1568):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1577):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1580):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1584):INSERT dbo.SETrainingProtocol(Published, Retired, Title, Length, Summary, Description, VideoSrc, DocName, VideoPoster)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1593):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1596):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1601):UPDATE dbo.SETrainingProtocol SET IncludeInPublicSite=1, IncludeInVideoLibrary=1 WHERE TrainingProtocolID<5
  D:\dev\SE\trunk\src\sql\updates\66740308_Resources_VideoInstanceChanges.sql(1603):UPDATE dbo.SETrainingProtocol SET IncludeInPublicSite=0, IncludeInVideoLibrary=1 WHERE TrainingProtocolID>4
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(51):DELETE dbo.SETrainingProtocolLabelAssignment WHERE TrainingProtocolID=1
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(53):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(56):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(59):UPDATE SETrainingProtocolLabel SET Sequence=1 WHERE Name='Primary'
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(60):UPDATE SETrainingProtocolLabel SET Sequence=2 WHERE Name='Intermediate'
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(61):UPDATE SETrainingProtocolLabel SET Sequence=3 WHERE Name='Secondary'
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(63):DELETE dbo.SETrainingProtocolLabel WHERE Name IN ('Reading', 'Writing')
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(65):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(68):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(71): INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(74):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(77): INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(80):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(84):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('English language learners', 1)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(85):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Health', 1)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(86):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Pre-K/K class', 1)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(87):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Music', 1)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(88):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Special Education', 1)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(103):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(118):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(121):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(124):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(134):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(154):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(169):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(172):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(175):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(185):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(204):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(219):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(222):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(225):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(235):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(254):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(269):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(272):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(275):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(285):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(304):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(319):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(322):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(325):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(335):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(354):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(369):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(372):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(375):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(385):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(404):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(419):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(422):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(425):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(435):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(454):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(469):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(472):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(475):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(485):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(504):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(519):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(522):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(525):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(535):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(551):UPDATE	dbo.SETrainingProtocol 
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(557):UPDATE	dbo.SETrainingProtocol 
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(563):UPDATE	dbo.SETrainingProtocol 
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(569):UPDATE	dbo.SETrainingProtocol 
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(584):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(599):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(602):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(605):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(615):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(633):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(648):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(651):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(654):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(664):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(682):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(697):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(700):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(703):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(713):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(731):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(746):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(749):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(752):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(762):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(781):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(796):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(799):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(802):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(812):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(830):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(845):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(848):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(851):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(861):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(879):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(894):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(897):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(900):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(910):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(929):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(944):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(947):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(950):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(960):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(979):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(994):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(997):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1000):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1010):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1028):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1043):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1046):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1049):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1059):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1078):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1093):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1096):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1099):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1109):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1128):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1143):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1146):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1149):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1159):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1179):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1194):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1197):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1200):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1210):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1230):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1245):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1248):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1251):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1261):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1280):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1295):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1298):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1301):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1311):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1330):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1345):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1348):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1351):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\68945748_trainingProtocolsData.sql(1361):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\71630088_dbCleanUp.sql(50):ALTER TABLE SETrainingProtocol DROP COLUMN VideoName
  D:\dev\SE\trunk\src\sql\updates\74014406_trainingProtocolLabelSequence.sql(48):ALTER TABLE dbo.SETrainingProtocolLabel ADD Sequence SMALLINT DEFAULT (0)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(49):INSERT dbo.SETrainingProtocolLabel(Name, TrainingProtocolLabelGroupID) VALUES('Social', 1)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(54):SELECT * FROM setrainingprotocol Where Title like '%Video 34%'
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(56):select distinct p.TrainingProtocolID, Title, p.* from setrainingprotocol p
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(57):  join SETrainingProtocolLabelAssignment a on a.TrainingProtocolID=p.TrainingProtocolID
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(58):  join setrainingprotocollabel l on l.TrainingProtocolLabelID=a.TrainingProtocolLabelID
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(65):UPDATE SETrainingProtocol SET Retired=1 WHERE TrainingProtocolID=105
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(67):UPDATE SETrainingProtocol SET Title='Video 367: Engaging in Relationship-Building Conversations With Students' WHERE TrainingProtocolID=108
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(68):UPDATE SETrainingProtocol SET Title='Video 17: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=109
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(69):UPDATE SETrainingProtocol SET Title='Video 235: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=110
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(70):UPDATE SETrainingProtocol SET Title='Video 238: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=111
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(71):UPDATE SETrainingProtocol SET Title='Video 263: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=112
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(72):UPDATE SETrainingProtocol SET Title='Video 271: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=113
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(73):UPDATE SETrainingProtocol SET Title='Video 271: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=114
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(74):UPDATE SETrainingProtocol SET Title='Video 341: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=115
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(75):UPDATE SETrainingProtocol SET Title='Video 347: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=116
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(76):UPDATE SETrainingProtocol SET Title='Video 352: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=117
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(77):UPDATE SETrainingProtocol SET Title='Video 358: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=118
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(78):UPDATE SETrainingProtocol SET Title='Video 360: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=119
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(79):UPDATE SETrainingProtocol SET Title='Video 48: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=120
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(80):UPDATE SETrainingProtocol SET Title='Video 53: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=121
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(81):UPDATE SETrainingProtocol SET Title='Video 249: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=122
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(82):UPDATE SETrainingProtocol SET Title='Video 96: Constructing Meaning Through Reading' WHERE TrainingProtocolID=1
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(83):UPDATE SETrainingProtocol SET Title='Video 217: Whole Class Math Discourse' WHERE TrainingProtocolID=2
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(84):UPDATE SETrainingProtocol SET Title='Video 74: Facilitating Interactions—Small Groups' WHERE TrainingProtocolID=3
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(85):UPDATE SETrainingProtocol SET Title='Video 214: Teaching a Lesson' WHERE TrainingProtocolID=4
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(86):UPDATE SETrainingProtocol SET Title='Video 42: Eliciting and Interpreting Individual Students’ Thinking' WHERE TrainingProtocolID=98
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(87):UPDATE SETrainingProtocol SET Title='Video 259: CCSS: Coherence and Student Conversation, Thinking and Learning' WHERE TrainingProtocolID=99
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(88):UPDATE SETrainingProtocol SET Title='Video 163: Classroom Management' WHERE TrainingProtocolID=100
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(89):UPDATE SETrainingProtocol SET Title='Video 34: Faciliating Small Groups' WHERE TrainingProtocolID=101
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(90):UPDATE SETrainingProtocol SET Title='Video 79: Making Content Explicit Through Explanation Modeling, Representations and Examples' WHERE TrainingProtocolID=102
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(91):UPDATE SETrainingProtocol SET Title='Video 175: Facilitating Organizational Routines, Procedures, Strategies' WHERE TrainingProtocolID=103
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(92):UPDATE SETrainingProtocol SET Title='Video 18: Enhancing Social Development' WHERE TrainingProtocolID=104
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(93):UPDATE SETrainingProtocol SET Title='Video 34: Enhancing Social Development' WHERE TrainingProtocolID=105
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(94):UPDATE SETrainingProtocol SET Title='Video 292: Eliciting and Interpreting Individual Student Thinking' WHERE TrainingProtocolID=106
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(95):UPDATE SETrainingProtocol SET Title='Video 51: Small-Group' WHERE TrainingProtocolID=107
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(96):UPDATE SETrainingProtocol SET Title='Video 367: Small-Group' WHERE TrainingProtocolID=108
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(98):UPDATE SETrainingProtocol SET Description='Protocol focuses on the norms and routines about how people construct knowledge.' WHERE TrainingProtocolID=1
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(99):UPDATE SETrainingProtocol SET Description='Protocol focuses on teaching a lesson or segment of instruction.' WHERE TrainingProtocolID=4
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(100):UPDATE SETrainingProtocol SET Description='Protocol focuses on leading a whole class discussion, eliciting individual student thinking and establishing norms and routines for classroom discourse.' WHERE TrainingProtocolID=2
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(101):UPDATE SETrainingProtocol SET Description='Protocol focuses on implementing organizational routines, procedures, and strategies to support a learning environment.' WHERE TrainingProtocolID=3
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(104):UPDATE SETrainingProtocol SET DocName='FINAL video 34.pdf' WHERE TrainingProtocolID=105
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(105):UPDATE SETrainingProtocol SET DocName='FINAL video 17.pdf' WHERE TrainingProtocolID=109
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(106):UPDATE SETrainingProtocol SET DocName='FINAL video 18.pdf' WHERE TrainingProtocolID=104
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(107):UPDATE SETrainingProtocol SET DocName='FINAL video 34.pdf' WHERE TrainingProtocolID=101
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(108):UPDATE SETrainingProtocol SET DocName='FINAL video 42.pdf' WHERE TrainingProtocolID=98
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(109):UPDATE SETrainingProtocol SET DocName='FINAL video 48.pdf' WHERE TrainingProtocolID=120
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(110):UPDATE SETrainingProtocol SET DocName='FINAL video 51.pdf' WHERE TrainingProtocolID=107
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(111):UPDATE SETrainingProtocol SET DocName='FINAL video 53.pdf' WHERE TrainingProtocolID=121
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(112):UPDATE SETrainingProtocol SET DocName='FINAL video 74.pdf' WHERE TrainingProtocolID=3
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(113):UPDATE SETrainingProtocol SET DocName='FINAL video 79.pdf' WHERE TrainingProtocolID=102
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(114):UPDATE SETrainingProtocol SET DocName='FINAL video 96.pdf' WHERE TrainingProtocolID=1
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(115):UPDATE SETrainingProtocol SET DocName='FINAL video 163.pdf' WHERE TrainingProtocolID=100
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(116):UPDATE SETrainingProtocol SET DocName='FINAL video 175.pdf' WHERE TrainingProtocolID=103
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(117):UPDATE SETrainingProtocol SET DocName='FINAL video 214.pdf' WHERE TrainingProtocolID=4
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(118):UPDATE SETrainingProtocol SET DocName='FINAL video 217.pdf' WHERE TrainingProtocolID=2
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(119):UPDATE SETrainingProtocol SET DocName='FINAL video 235.pdf' WHERE TrainingProtocolID=110
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(120):UPDATE SETrainingProtocol SET DocName='FINAL video 238.pdf' WHERE TrainingProtocolID=111
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(121):UPDATE SETrainingProtocol SET DocName='FINAL video 249.pdf' WHERE TrainingProtocolID=122
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(122):UPDATE SETrainingProtocol SET DocName='FINAL video 259.pdf' WHERE TrainingProtocolID=99
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(123):UPDATE SETrainingProtocol SET DocName='FINAL video 263.pdf' WHERE TrainingProtocolID=112
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(124):UPDATE SETrainingProtocol SET DocName='FINAL video 271.pdf' WHERE TrainingProtocolID=113
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(125):UPDATE SETrainingProtocol SET DocName='FINAL video 271.pdf' WHERE TrainingProtocolID=114
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(126):UPDATE SETrainingProtocol SET DocName='FINAL video 292.pdf' WHERE TrainingProtocolID=106
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(127):UPDATE SETrainingProtocol SET DocName='FINAL video 341.pdf' WHERE TrainingProtocolID=115
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(128):UPDATE SETrainingProtocol SET DocName='FINAL video 347.pdf' WHERE TrainingProtocolID=116
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(129):UPDATE SETrainingProtocol SET DocName='FINAL video 352.pdf' WHERE TrainingProtocolID=117
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(130):UPDATE SETrainingProtocol SET DocName='FINAL video 358.pdf' WHERE TrainingProtocolID=118
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(131):UPDATE SETrainingProtocol SET DocName='FINAL video 360.pdf' WHERE TrainingProtocolID=119
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(132):UPDATE SETrainingProtocol SET DocName='FINAL video 367.pdf' WHERE TrainingProtocolID=108
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(144):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(159):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(162):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(165):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(175):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(188):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(203):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(206):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(209):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(219):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(232):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(247):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(250):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(253):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(263):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(276):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(291):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(294):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(297):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(307):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(320):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(335):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(338):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(341):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(351):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(365):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(380):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(383):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(386):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(396):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(409):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(423):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(426):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(429):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(439):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(452):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(466):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(469):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(472):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(482):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(495):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(509):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(512):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(515):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(525):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(538):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(552):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(555):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(558):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(568):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(582):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(596):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(599):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(602):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(612):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(626):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(640):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(643):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(646):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(656):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(669):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(683):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(686):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(689):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(699):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(713):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(727):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(730):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(733):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(743):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(756):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(770):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(773):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(776):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(786):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(799):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(813):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(816):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(819):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(829):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(843):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(857):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(860):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(863):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(873):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(886):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(900):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(903):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(906):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(916):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(929):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(943):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(946):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(949):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(959):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(972):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(986):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(989):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(991):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1001):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1014):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1028):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1031):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1033):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1043):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1056):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1070):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1073):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1075):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1085):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1099):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1113):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1116):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1118):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1128):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1142):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1156):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1159):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1161):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1171):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1184):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1198):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1201):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1203):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1213):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1226):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1240):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1243):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1245):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1255):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1268):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1282):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1285):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1287):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1300):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1314):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1317):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1319):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1328):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1341):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1355):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1358):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1360):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1369):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1382):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1396):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1399):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1401):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1410):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1423):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1438):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1441):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1444):SELECT * FROM dbo.SETrainingProtocolLabel
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1446):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1456):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1469):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1483):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1486):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1488):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1497):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1510):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1524):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1527):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1529):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1538):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1551):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1566):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1569):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1572):SELECT * FROM dbo.SETrainingProtocolLabel
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1574):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1584):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1597):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1611):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1614):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1616):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1625):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1638):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1652):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1655):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1657):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1666):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1678):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1692):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1695):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1697):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1706):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1719):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1734):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1737):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1740):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1750):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1763):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1778):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1781):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1784):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\90551102_trainingProtocolsData.sql(1794):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(56):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(71):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(74):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(77):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(87):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(100):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(115):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(118):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(121):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(131):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(144):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(159):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(162):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(165):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(175):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(188):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(203):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(206):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(209):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(219):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(232):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(247):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(250):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(258):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(273):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(276):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(279):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(289):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(302):INSERT dbo.SETrainingProtocol(Title, Summary, Description, DocName, Length, Published, Retired, IncludeInPublicSite, IncludeInVideoLibrary, VideoPoster, VideoSrc)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(316):INSERT dbo.SETrainingProtocolLabelAssignment(TrainingProtocolID, TrainingProtocolLabelID)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(319):  FROM dbo.SETrainingProtocolLabel lb
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(322):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  D:\dev\SE\trunk\src\sql\updates\94591664_trainingProtocolsData.sql(332):INSERT SETrainingProtocolFrameworkNodeAlignment(TrainingProtocolID, FrameworkNodeID, IsStateAlignment)
  Matching lines: 827    Matching files: 10    Total files searched: 221
