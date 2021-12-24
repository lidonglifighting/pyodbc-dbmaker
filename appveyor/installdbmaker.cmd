set DBMAKERPATH=%cd%
echo %DBMAKERPATH%

FOR /F "tokens=* USEBACKQ" %%F IN (`%PYTHON_HOME%\python -c "import sys; sys.stdout.write(str(sys.version_info.major))"`) DO (
SET PYTHON_MAJOR_VERSION=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`%PYTHON_HOME%\python -c "import sys; sys.stdout.write('64' if sys.maxsize > 2**32 else '32')"`) DO (
SET PYTHON_ARCH=%%F
)

IF %PYTHON_ARCH% EQU 32 (
  echo "install 32bit dbmaker"
  powershell curl -o dbmaker.zip https://www.dbmaker.com/download/5.4.4Beta/dbmaker-5.4.4Bundle-WIN32.zip
) ELSE (
  echo "install 64bit dbmaker"
  powershell curl -o dbmaker.zip https://www.dbmaker.com/download/5.4.4Beta/dbmaker-5.4.4Bundle-WIN64.zip
)
powershell -command "Expand-Archive -Force 'dbmaker.zip' %DBMAKERPATH%"
echo set path=
set path=%DBMAKERPATH%\bundle;%path%
echo "Installing the driver..."
IF %PYTHON_ARCH% EQU 32 (
echo "32bit odbc driver"
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v Driver /t REG_EXPAND_SZ /d %DBMAKERPATH%\bundle\DMAPI54.DLL /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v Setup /t REG_EXPAND_SZ /d %DBMAKERPATH%\bundle\DMSET.DLL /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v APILevel /t REG_EXPAND_SZ /d 1 /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v ConnectFunctions /t REG_EXPAND_SZ /d YYN /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v DriverODBCVer /t REG_EXPAND_SZ /d 03.00 /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v FileUsage /t REG_EXPAND_SZ /d 0 /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v SQLLevel /t REG_EXPAND_SZ /d 1 /f

REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBCINST.INI\ODBC Drivers" /v "DBMaker 5.4 bundle Driver" /t REG_EXPAND_SZ /d Installed /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBC.INI\ODBC Data Sources" /v UTF8DB /t REG_EXPAND_SZ /d "DBMaker 5.4 bundle Driver" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBC.INI\UTF8DB" /v Driver /t REG_EXPAND_SZ /d %DBMAKERPATH%\bundle\DMAPI54.DLL /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBC\ODBC.INI\UTF8DB" /v Database /t REG_EXPAND_SZ /d UTF8DB /f

)ELSE (
echo "64bit odbc driver"
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v Driver /t REG_EXPAND_SZ /d %DBMAKERPATH%\bundle\DMAPI54.DLL /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v Setup /t REG_EXPAND_SZ /d %DBMAKERPATH%\bundle\DMSET.DLL /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v APILevel /t REG_EXPAND_SZ /d 1 /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v ConnectFunctions /t REG_EXPAND_SZ /d YYN /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v DriverODBCVer /t REG_EXPAND_SZ /d 03.00 /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v FileUsage /t REG_EXPAND_SZ /d 0 /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\DBMaker 5.4 bundle Driver" /v SQLLevel /t REG_EXPAND_SZ /d 1 /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers" /v "DBMaker 5.4 bundle Driver" /t REG_EXPAND_SZ /d Installed /f
REG ADD  "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources" /v UTF8DB /t REG_EXPAND_SZ /d "DBMaker 5.4 bundle Driver" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\UTF8DB" /v Driver /t REG_EXPAND_SZ /d %DBMAKERPATH%\bundle\DMAPI54.DLL /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\UTF8DB" /v Database /t REG_EXPAND_SZ /d UTF8DB /f

)
