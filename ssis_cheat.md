# SSIS Cheat Sheet

## How to...

### Deploy a package to SQL Server, MSDB

In this example, we deploy the package in MSDB, under folder "integration".

```
REM deploys a package with password
dtutil.exe /FILE C:\dev\github\ssis\template\template\bin\Development\security_test_pass_is_banana.dtsx /DestServer localhost /Decrypt banana /COPY DTS;MSDB\integration\security_test_pass_is_banana

REM regenerates package GUID
dtutil.exe /Decrypt banana /IDRegenerate /DTS MSDB\integration\security_test_pass_is_banana

```


## Things to remember

### Package Protection Level

- DontSaveSensitive: All sensitive data is deleted, developer needs to retype data. Sensitive data needs to be supplyied in config
- EncryptSensitiveWithUserKey (default): sensitive data is encrypted using developer key; should not use this when going to production (runner user is different, will fail).
- EncryptSensitiveWithPassword: when multiple users needs to use a package; use a common password
- EncryptAllWithPassword: when multiple users needs to use a package; use a common password. You lose the package if you lose the password.
- EncryptAllWithUserKey: only the developer can open it, don't use this in production
