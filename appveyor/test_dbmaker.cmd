:dbmaker
ECHO.
ECHO ############################################################
ECHO # DBMaker
ECHO ############################################################
set DBMAKERPATH=%cd%
echo %DBMAKERPATH%
cd %DBMAKERPATH%\bundle
echo [utf8db] >>dmconfig.ini
echo db_lcode=10 >>dmconfig.ini
echo db_clilcode=utf-8>>dmconfig.ini
echo db_ptnum=2222>>dmconfig.ini
echo db_svadr=127.0.0.1>>dmconfig.ini
echo create db utf8db; > createutf8db.sql
echo terminate db; >> createutf8db.sql
echo q; >> createutf8db.sql
echo dmsql32.exe createutf8db.sql >createutf8db.bat
echo dmserver.exe UTF8DB \a >>createutf8db.bat
echo exit; >> createutf8db.bat
start createutf8db.bat
cd ..
IF %PYTHON_MAJOR_VERSION% EQU 2 (
    SET TESTS_DIR=tests2
) ELSE (
    SET TESTS_DIR=tests3
)
SET CONN_STR=Driver=DBMaker 5.4 bundle Driver;Database=utf8db; uid=sysadm; pwd=;
ECHO.
ECHO *** Run tests using driver: "DBMaker 5.4 bundle Driver"
copy %DBMAKERPATH%\bundle\dmconfig.ini dmconfig.ini
echo %PYTHON_HOME%\python appveyor\test_connect.py "Driver=DBMaker 5.4 bundle Driver;Database=utf8db; uid=sysadm; pwd="
"%PYTHON_HOME%\python" appveyor\test_connect.py "Driver=DBMaker 5.4 bundle Driver;Database=utf8db; uid=sysadm; pwd="
IF ERRORLEVEL 1 (
  ECHO *** ERROR: Could not connect using the connection string:
  ECHO "%CONN_STR%"
  SET OVERALL_RESULT=1
  GOTO :end
)
echo %PYTHON_HOME%\python %TESTS_DIR%\dbmakertests.py -v "Driver=DBMaker 5.4 bundle Driver;Database=utf8db; uid=sysadm; pwd="
"%PYTHON_HOME%\python" "%TESTS_DIR%\dbmakertests.py" -v "Driver=DBMaker 5.4 bundle Driver;Database=utf8db; uid=sysadm; pwd="
IF ERRORLEVEL 1 SET OVERALL_RESULT=1

echo delete dbmaker bundle
cd %DBMAKERPATH%\bundle
echo connect to utf8db sysadm; > termutf8db.sql
echo terminate db; >> termutf8db.sql
echo q; >> termutf8db.sql
echo terminate db
dmsql32.exe termutf8db.sql
echo del utf8db
del UTF8DB.*
cd ..
echo rd bundle
RD /S /Q "bundle"
echo del dbmaker.zip
del dbmaker.zip
echo dbmaker over