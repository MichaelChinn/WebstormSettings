cd ..\tools\prototypes\src\sql
build_db.wsf /run /rebuild
cd ..\..\..\..\repository\sql
build_db.wsf /run /really_rebuild /db:stateEval_repo /app_user:webApplication /app_password:fingleGommit
cd ..\..\sql
build_db.wsf /run /rebuild /customization:custom\test /app_user:webApplication /app_password:fingleGommit