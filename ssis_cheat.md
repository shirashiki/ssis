# SSIS Cheat Sheet

## How to...

### Make packages portable

Portable here means you can create a solution in a way other developers can open and change in their workstations with minimal pain.

#### Prevent broken file connections
You created a file connection pointing to c:\work\solutions\invoice.csv, but this path will probably not exist in another developer workstation or in other environments (QA, Production, etc), preventing your package running.

*Steps:*
- Create a variable in package scope to hold the folder path, for example, package_path.
- In the file connection, go to Expressions. Create an expression building the complete file path using the variable and file name, and assigning to the ConnectionString property of the connection.
```
@[User::package_path] + "sql_auth.dtsx"
```
- When moving to other environments, or if a colleague is maintaining your project, just change the value of the package_path variable.

*Example:*
- See package master_dev.dtsx, connection sql_auth.dtsx.


### Declare a Database Connection in SQL Server Authentication mode

In this mode, user and password are part of the connection string. Steps:
- Package has security mode DontSaveSensitive
- Create a variable to store the connection string.
- Copy the connection string to this variable. SSIS will generate a connection string without the password.
- Create a variable to store the password, assign the password to its value
- In the connection, create expressions to substitute the ConnectionString and Password properties with the variable values.


*Notes*
- The password will be visible when you browse the variable values in SSDT.
- you can supply values throught package configurations (file, database, parent package).
- See the template project, package sql_auth.dtsx for a usage example.



### Deploy a package to SQL Server, MSDB

In this example, we deploy the package in MSDB, under folder "integration". The package has security EncryptAllWithPassword, and the password is "banana".

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
