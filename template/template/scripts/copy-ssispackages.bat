REM deploys a package with password

dtutil.exe /FILE C:\dev\github\ssis\template\template\bin\Development\security_test_pass_is_banana.dtsx /DestServer localhost /Decrypt banana /COPY DTS;MSDB\integration\security_test_pass_is_banana
dtutil.exe /Decrypt banana /IDRegenerate /DTS MSDB\integration\security_test_pass_is_banana


REM 
REM Executes bulk copy of packages to MSDB database
REM
REM ========== for multiple files
REM for each file, runs dtutil, saving using only filename (%%~nf)
REM for %%f in (C:\dev\github\ssis\template\template\bin\Development\*.dtsx) do dtutil.exe /FILE %%f /DestServer localhost /COPY DTS;MSDB\integration\%%~nf
REM for %%f in (C:\dev\github\ssis\template\template\bin\Development\*.dtsx) do dtutil.exe /I /DTS MSDB\integration\%%~nf
