@ECHO OFF & CLS & ECHO.
NET FILE 1>NUL 2>NUL & 
IF ERRORLEVEL 1 (ECHO You must right-click and select & ECHO "RUN AS ADMINISTRATOR"  to run this batch. Exiting... & ECHO. & PAUSE & EXIT /D)

SETLOCAL ENABLEDELAYEDEXPANSION
SET LinkName=DrWebCureIt
SET Esc_LinkDest=%%HOMEDRIVE%%%%HOMEPATH%%\Desktop\!LinkName!.lnk
SET Esc_LinkTarget=%~dp0runner.bat
SET tempVBS=CreateShortcut.vbs
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
  echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
  echo oLink.IconLocation = "%~dp0cureit.exe"
  echo oLink.Save
)1>!tempVBS!
cscript //nologo .\!tempVBS!
DEL !tempVBS! /f /q
)

:: Avoid conflict with previously installed
Schtasks.exe /delete /tn cureit_as_admin_lite /f
Schtasks.exe /delete /tn cureit_as_admin_fast /f
Schtasks.exe /delete /tn cureit_as_admin_full /f
Schtasks.exe /delete /tn onstart_cureit /f
Schtasks.exe /delete /tn daily_cureit /f
Schtasks.exe /delete /tn weekly_cureit /f

Schtasks.exe /Create /RL Highest /TN cureit_as_admin_lite /TR "'%~dp0cureit.exe' /LITE /AA /QUIT" /SC ONEVENT /EC Application /MO *[System/EventID=18042016] /f
Schtasks.exe /Create /RL Highest /TN cureit_as_admin_fast /TR "'%~dp0cureit.exe' /FAST /AA /QUIT" /SC ONEVENT /EC Application /MO *[System/EventID=18042016] /f
Schtasks.exe /Create /RL Highest /TN cureit_as_admin_full /TR "'%~dp0cureit.exe' /FULL /AA /AR /AC /LN /QUIT" /SC ONEVENT /EC Application /MO *[System/EventID=18042016] /f

:: The startup scan setting
Schtasks.exe /Create /TN onstart_cureit /TR "'%~dp0runner.bat' lite" /SC ONSTART

:: Daily scan setting (set time)
Schtasks.exe /Create /TN daily_cureit /TR "'%~dp0runner.bat' fast" /SC DAILY /ST 15:00

:: Weekly scan setting (set day and time)
Schtasks.exe /Create /TN weekly_cureit /TR "'%~dp0runner.bat' full" /SC WEEKLY /D FRI /ST 18:00

