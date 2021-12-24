ECHO *** Environment variables:
ECHO APPVEYOR_BUILD_FOLDER      : %APPVEYOR_BUILD_FOLDER%
ECHO APPVEYOR_BUILD_WORKER_IMAGE: %APPVEYOR_BUILD_WORKER_IMAGE%
ECHO APPVEYOR_JOB_NUMBER: %APPVEYOR_JOB_NUMBER%
ECHO APPVEYOR_JOB_ID    : %APPVEYOR_JOB_ID%
ECHO APPVEYOR_JOB_NAME  : %APPVEYOR_JOB_NAME%
ECHO APVYR_RUN_TESTS         : %APVYR_RUN_TESTS%
ECHO APVYR_RUN_MSSQL_TESTS   : %APVYR_RUN_MSSQL_TESTS%
ECHO APVYR_RUN_POSTGRES_TESTS: %APVYR_RUN_POSTGRES_TESTS%
ECHO APVYR_RUN_MYSQL_TESTS   : %APVYR_RUN_MYSQL_TESTS%
ECHO APVYR_GENERATE_WHEELS   : %APVYR_GENERATE_WHEELS%
ECHO APVYR_VERBOSE           : %APVYR_VERBOSE%
ECHO PYTHON_HOME   : %PYTHON_HOME%
ECHO MSSQL_INSTANCE: %MSSQL_INSTANCE%
ECHO POSTGRES_PATH : %POSTGRES_PATH%
ECHO MYSQL_PATH    : %MYSQL_PATH%
ECHO DBMAKERPATH     : %DBMAKERPATH%\bundle

ECHO.
ECHO *** Get build info and compiler for the current Python installation:
"%PYTHON_HOME%\python" -c "import platform; print(platform.python_build(), platform.python_compiler())"

ECHO.
ECHO *** Update pip and setuptools...
"%PYTHON_HOME%\python" -m pip install --upgrade pip setuptools --quiet --no-warn-script-location
IF ERRORLEVEL 1 (
  ECHO *** ERROR: pip/setuptools update failed
  EXIT 1
)
"%PYTHON_HOME%\python" -m pip freeze --all

ECHO.
ECHO *** Building the pyodbc module...
IF NOT "%APVYR_BUILD_DBMAKER%" == "true" (
 %WITH_COMPILER% "%PYTHON_HOME%\python" setup.py build
) ELSE (
echo %WITH_COMPILER% "%PYTHON_HOME%\python" setup.py build_ext  --define DBMAKER --include-dirs %DBMAKERPATH%\bundle\include   --library-dirs %DBMAKERPATH%\bundle\lib  --libraries "dmapi54"
 %WITH_COMPILER% "%PYTHON_HOME%\python" setup.py build_ext  --define DBMAKER --include-dirs %DBMAKERPATH%\bundle\include   --library-dirs %DBMAKERPATH%\bundle\lib  --libraries "dmapi54"
)

IF ERRORLEVEL 1 (
  ECHO *** ERROR: pyodbc build failed
  EXIT 1
)

ECHO.
ECHO *** Installing pyodbc...
"%PYTHON_HOME%\python" setup.py install
IF ERRORLEVEL 1 (
  ECHO *** ERROR: pyodbc install failed
  EXIT 1
)

ECHO.
ECHO *** pip freeze...
"%PYTHON_HOME%\python" -m pip freeze --all

ECHO.
ECHO *** Get version of the built pyodbc module:
echo %path%
copy %DBMAKERPATH%\bundle\dmapi54.dll %DBMAKERPATH%\build\lib.win32-3.8\

"%PYTHON_HOME%\python" -c "import pyodbc; print(pyodbc.version)"

ECHO.
