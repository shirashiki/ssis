REM Executes bulk copy of packages to MSDB
REM

for %%f in (c:\myssis\*.dtsx) do dtutil.exe /FILE %%f /DestServer localhost /COPY DTS;MSDB\Testing\%%~nf
for %%f in (c:\myssis\*.dtsx) do dtutil.exe /I /DTS;MSDB\Testing\%%~nf
