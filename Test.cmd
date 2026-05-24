@echo off
setlocal enabledelayedexpansion
chcp 1251 >NUL
rem Identifies the current network
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /C:"Default Gateway"') do (
  set tst=%%i
  if not "!tst:~1,1!"=="" set tst2=!tst:~1,20!
)
echo Default Gateway: %tst2%
rem We obtain a C-class network
for /f "tokens=1,2,3 delims=." %%a in ("%tst2%") do set result=%%a.%%b.%%c
if exist %result%.txt del %result%.txt
echo Scan network from adress %result%.1
For /L %%A in (1,1,255) do (
  for /f "tokens=3 delims=: " %%i in ('ping %result%.%%A -n 1 -w 100 ^| find "TTL="') do (
    echo %%i
    echo %%i>> %result%.txt
  )
)
