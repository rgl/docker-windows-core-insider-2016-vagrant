@echo off

call :title Windows Version
ver

call :title Environment Variables
set

call :title Network Interfaces
ipconfig /all

call :title Network Routing Table
route print

call :title Network Connections
netstat -an

call :title Services
sc query | findstr /v "WIN32_EXIT_CODE SERVICE_EXIT_CODE CHECKPOINT WAIT_HINT"

call :title Executables
dir /b /a:-d /o:n /s c:\*.com c:\*.exe c:\*.bat c:\*.cmd

exit 0

:title
echo #
echo # %*
echo #
exit /b 0
