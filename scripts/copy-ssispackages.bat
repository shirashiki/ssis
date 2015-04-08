REM ======================================
REM Executes bulk copy of packages to MSDB
REM

REM for each file, runs dtutil, deploying package in MSDB using only filename (%%~nf)
for %%f in (C:\dev\github\ssis\template\template\bin\Development\*.dtsx) do dtutil.exe /FILE %%f /DestServer localhost /COPY DTS;MSDB\integration\%%~nf

REM for each package in the SSIS Package store, in folder integration, generates a new GUID for the package
REM so the logging can trace the new version (/I = /IDRegenerate)
for %%f in (C:\dev\github\ssis\template\template\bin\Development\*.dtsx) do dtutil.exe /I /DTS MSDB\integration\%%~nf
