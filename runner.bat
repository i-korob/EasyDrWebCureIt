@echo off
pushd "%~dp0"
SETLOCAL ENABLEDELAYEDEXPANSION
SET ver=%1
SET startBat=updater.bat
SET tempVBS=HideCMD.vbs
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo args = WScript.Arguments^(0^)^&" %ver%"
  echo oWS.Run^ args, 0, False
)1>!tempVBS!
cscript //nologo .\!tempVBS! .\!startBat!
DEL !tempVBS! /f /q
)

