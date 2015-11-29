@echo ON

SET currentDir=%~dp0
SET Server=%1
SET Database=%2
SET RebuildProto=%3

IF NOT DEFINED Server exit /B 1
IF NOT DEFINED Database exit /B 1
IF NOT DEFINED RebuildProto exit /B 1

IF %RebuildProto% == true (
	"%currentDir%src\tools\Prototypes\src\sql\build_db.wsf" /run /rebuild /quiet /summary_log:summary_%Database%_proto.txt /server:%Server% /db:%Database%_proto /sqldir:"%currentDir%src\tools\Prototypes\src\sql"
	IF NOT %ERRORLEVEL% == 0 (
		TYPE summary_%Database%_proto.txt
		EXIT /B 1
	)
)

"%currentDir%src\Repository\sql\build_db.wsf" /run /really_rebuild /quiet /summary_log:summary_%Database%_repo.txt /server:%Server% /db:%Database%_repo /customization:custom\Test /sqldir:"%currentDir%src\Repository\sql"
IF NOT %ERRORLEVEL% == 0 (
	TYPE summary_%Database%_repo.txt
	EXIT /B 1
)


"%currentDir%src\sql\build_db.wsf" /run /rebuild /quiet /summary_log:summary_%Database%.txt /server:%Server% /db:%Database% /customization:custom\Test /sqldir:"%currentDir%src\sql"
IF NOT %ERRORLEVEL% == 0 (
	TYPE summary_%Database%.txt
	EXIT /B 1
)
