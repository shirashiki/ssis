REM Executes bulk copy of packages to MSDB
REM

for %%f in (C:\dev\github\ssis\template\template\*.dtsx) do dtutil.exe /FILE %%f /DestServer localhost /COPY DTS;MSDB\integration\%%~nf
for %%f in (C:\dev\github\ssis\template\template\*.dtsx) do dtutil.exe /I /DTS;MSDB\integration\%%~nf
