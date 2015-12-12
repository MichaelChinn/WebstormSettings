/* Jessica Mariscal : 1410, 154009_edsUser - DONE */

UPDATE SEEvalSession SET EvaluateeUserID=1410 WHERE EvalSessionID=61398
UPDATE SEEvalSession SET EvaluateeUserID=1410 WHERE EvalSessionID=66118
UPDATE SEEvalSession SET EvaluateeUserID=1410 WHERE EvalSessionID=79252

/* move over userpromptresponse records associated with the moved evalsessions */
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=563177
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=563179
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=528480
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=663374
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=528478
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=663372
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=528479
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=663373
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=563176
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=528481
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=663375
UPDATE SEUserPromptResponse SET EvaluateeID=1410 WHERE UserPromptResponseID=563178

/***************************************************************************************/

/* Brett Munsell, 3201, 155193_edsUser - DONE */

UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=421035
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=587318
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=640134
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=421034
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=587317
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=640137
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=421033
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=587316
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=640136
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=421036
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=587319
UPDATE SEUserPromptResponse SET EvaluateeID=3201 WHERE UserPromptResponseID=640135

UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=55509
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=55510
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=55511
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=55512
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=55513
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=55514
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=169497
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=169499
UPDATE MessageHeader SET RecipientID=3201 WHERE MessageID=178670

UPDATE SEEvalSession SET EvaluateeUserID=3201 WHERE EvalSessionID=69472
UPDATE SEEvalSession SET EvaluateeUserID=3201 WHERE EvalSessionID=47274
UPDATE SEEvalSession SET EvaluateeUserID=3201 WHERE EvalSessionID=76483

/***************************************************************************************/

/* Candice Rutherford - 27245, 190279_edsUser - DONE */
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=27245 WHERE RepositoryItemID=84834
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=27245 WHERE RepositoryItemID=84848
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=27245 WHERE RepositoryItemID=84852
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=27245 WHERE RepositoryItemID=84856
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=27245 WHERE RepositoryItemID=84962
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=27245 WHERE RepositoryItemID=85819

UPDATE SEArtifact SET UserID=27245 WHERE ArtifactID=83821
UPDATE SEArtifact SET UserID=27245 WHERE ArtifactID=84662
UPDATE SEArtifact SET UserID=27245 WHERE ArtifactID=83694
UPDATE SEArtifact SET UserID=27245 WHERE ArtifactID=83707
UPDATE SEArtifact SET UserID=27245 WHERE ArtifactID=83711
UPDATE SEArtifact SET UserID=27245 WHERE ArtifactID=83715

UPDATE SEUserPromptResponse SET EvaluateeID=27245 WHERE UserPromptResponseID=679187
UPDATE SEUserPromptResponse SET EvaluateeID=27245 WHERE UserPromptResponseID=679212
UPDATE SEUserPromptResponse SET EvaluateeID=27245 WHERE UserPromptResponseID=679216
UPDATE SEUserPromptResponse SET EvaluateeID=27245 WHERE UserPromptResponseID=679236
UPDATE SEUserPromptResponse SET EvaluateeID=27245 WHERE UserPromptResponseID=679688
UPDATE SEUserPromptResponse SET EvaluateeID=27245 WHERE UserPromptResponseID=681877

UPDATE Message SET SenderID=27245 WHERE MessageID=197753
UPDATE Message SET SenderID=27245 WHERE MessageID=197754
UPDATE Message SET SenderID=27245 WHERE MessageID=197755
UPDATE Message SET SenderID=27245 WHERE MessageID=197756
UPDATE Message SET SenderID=27245 WHERE MessageID=197812
UPDATE Message SET SenderID=27245 WHERE MessageID=199834

UPDATE MessageHeader SET SenderID=27245 WHERE MessageID=197812
UPDATE MessageHeader SET SenderID=27245 WHERE MessageID=197753
UPDATE MessageHeader SET SenderID=27245 WHERE MessageID=197754
UPDATE MessageHeader SET SenderID=27245 WHERE MessageID=197755
UPDATE MessageHeader SET SenderID=27245 WHERE MessageID=197756
UPDATE MessageHeader SET SenderID=27245 WHERE MessageID=199834

/***************************************************************************************/

/* Jessica Proctor/Roy - 30188, 800352_edsUser - DONE */

/* for evalsession 55442 */
UPDATE SEFrameworkNodeScore SET SEUserID=30188 WHERE FrameworkNodeScoreID=125771
UPDATE SEFrameworkNodeScore SET SEUserID=30188 WHERE FrameworkNodeScoreID=125772
UPDATE SEFrameworkNodeScore SET SEUserID=30188 WHERE FrameworkNodeScoreID=125773
UPDATE SEFrameworkNodeScore SET SEUserID=30188 WHERE FrameworkNodeScoreID=125774

UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=54205
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=70675
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=59513
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=59525
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=59537
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=70854
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=70877
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=70907
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=70915
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=70920
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=79160
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=79174
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=79235
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=79545
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=80387
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=59472
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=59481
UPDATE SEArtifact SET UserID=30188 WHERE ArtifactID=71347

UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=645392
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=610287
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=610318
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=610484
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=610528
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=610578
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=642998
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=643873
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=643916
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=643993
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=644005
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=644019
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=669001
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=669065
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=669192
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=669671
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=671465
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=587309

UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=55111
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=60402
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=60411
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=60444
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=60456
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=60468
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=71712
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=71894
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=71917
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=71947
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=71955
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=71960
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=72388
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=80248
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=80262
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=80323
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=80633
UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=30188 WHERE RepositoryItemID=81491

/* ignoring two reportprintoptionuser entries - can redue on their own */

UPDATE Message SET SenderID=30188 WHERE MessageID=137155
UPDATE Message SET SenderID=30188 WHERE MessageID=150414
UPDATE Message SET SenderID=30188 WHERE MessageID=150465
UPDATE Message SET SenderID=30188 WHERE MessageID=150581
UPDATE Message SET SenderID=30188 WHERE MessageID=150619
UPDATE Message SET SenderID=30188 WHERE MessageID=150642
UPDATE Message SET SenderID=30188 WHERE MessageID=171942
UPDATE Message SET SenderID=30188 WHERE MessageID=171943
UPDATE Message SET SenderID=30188 WHERE MessageID=172057
UPDATE Message SET SenderID=30188 WHERE MessageID=172058
UPDATE Message SET SenderID=30188 WHERE MessageID=172060
UPDATE Message SET SenderID=30188 WHERE MessageID=172061
UPDATE Message SET SenderID=30188 WHERE MessageID=172726
UPDATE Message SET SenderID=30188 WHERE MessageID=172731
UPDATE Message SET SenderID=30188 WHERE MessageID=175475
UPDATE Message SET SenderID=30188 WHERE MessageID=189571
UPDATE Message SET SenderID=30188 WHERE MessageID=189573
UPDATE Message SET SenderID=30188 WHERE MessageID=189670
UPDATE Message SET SenderID=30188 WHERE MessageID=190053
UPDATE Message SET SenderID=30188 WHERE MessageID=190057
UPDATE Message SET SenderID=30188 WHERE MessageID=191459
UPDATE Message SET SenderID=30188 WHERE MessageID=191460

UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=150414
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=150465
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=150581
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=150642
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=150619
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=175475
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=189571
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=189573
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=189670
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=190057
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=190053
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=191460
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=191459
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=137155
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=171942
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=171943
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=172058
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=172057
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=172060
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=172061
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=172726
UPDATE MessageHeader SET SenderID=30188 WHERE MessageID=172731

UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=15362
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=15363
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=15364
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=15365
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=27003
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=27004
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=159052
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=175460
UPDATE MessageHeader SET RecipientID=30188 WHERE MessageID=175461

/* self-assesment */
UPDATE SEEvalSession SET EvaluatorUserID=30188 WHERE EvalSessionID=55442

/* observations */
UPDATE SEEvalSession SET EvaluateeUserID=30188 WHERE EvalSessionID=51467
UPDATE SEEvalSession SET EvaluateeUserID=30188 WHERE EvalSessionID=31090
UPDATE SEEvalSession SET EvaluateeUserID=30188 WHERE EvalSessionID=64642
UPDATE SEEvalSession SET EvaluateeUserID=30188 WHERE EvalSessionID=55442

/* userpromptresponse associated with moved evalsessions */
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=294238
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=453743
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=552021
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=294237
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=453746
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=552024
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=483983
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=294239
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=453744
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=552022
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=294240
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=453745
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=552023
UPDATE SEUserPromptResponse SET EvaluateeID=30188 WHERE UserPromptResponseID=483982





