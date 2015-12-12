if %1 == "" goto :GETOUT

pause
del src\web\bin\*.dll
del src\web\bin\*.pdb
del src\web\obj\debug\*.cache
del src\web\obj\debug\*.dll
del src\web\obj\debug\*.pdb

svn update

msbuild src\stateeval.sln /t:Rebuild
 s
svn commit -m%1

:GETOUT
pause

