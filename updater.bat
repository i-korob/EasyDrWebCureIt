@echo off
SET ver=%1
pushd "%~dp0"
del cureit.exe
@echo on
wget.exe http://download.geo.drweb.com/pub/drweb/cureit/cureit.exe
@echo off
if %ver% == lite (
start "" schtasks.exe /run /tn cureit_as_admin_lite
) 
if %ver% == fast (
start "" schtasks.exe /run /tn cureit_as_admin_fast
) 
if %ver% == full (
start "" schtasks.exe /run /tn cureit_as_admin_full
) 
