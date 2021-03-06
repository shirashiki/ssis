<#
SSIS Setup

See: http://blogs.msdn.com/b/mattm/archive/2011/11/17/ssis-and-powershell-in-sql-server-2012.aspx

Prerequisites: 
- Enable CLR Integration
    sp_configure 'show advanced options', 1;
    GO
    RECONFIGURE;
    GO
    sp_configure 'clr enabled', 1;
    GO
    RECONFIGURE;
    GO
#>
# Load the IntegrationServices Assembly            
$loadStatus = [Reflection.Assembly]::Load("Microsoft"+            
".SqlServer.Management.IntegrationServices" +            
", Version=11.0.0.0, Culture=neutral" +            
", PublicKeyToken=89845dcd8080cc91")            
            
# Store the IntegrationServices Assembly namespace to avoid typing it every time            
$ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"            
            
Write-Host "Connecting to server ..."            
            
# Create a connection to the server            
$constr = "Data Source=localhost;Initial Catalog=master;Integrated Security=SSPI;"            
            
$con = New-Object System.Data.SqlClient.SqlConnection $constr            
            
# Create the Integration Services object            
$ssis = New-Object $ISNamespace".IntegrationServices" $con            
            
## Drop the existing catalog if it exists            
# Write-Host "Removing previous catalog ..."            
# if ($ssis.Catalogs.Count -gt 0)             
# {             
#    $ssis.Catalogs["SSISDB"].Drop()             
# }            
            
# Provision a new SSIS Catalog            
Write-Host "Creating new SSISDB Catalog ..."            
$cat = New-Object $ISNamespace".Catalog" ($ssis, "SSISDB", "Password1")            
$cat.Create()

# Create a new folder            
Write-Host "Creating Folder ..."            
$folder = New-Object $ISNamespace".CatalogFolder" ($cat, "Folder", "Description")            
$folder.Create()            
            
# Read the project file, and deploy it to the folder            
Write-Host "Deploying ExecutionDemo project ..."            
[byte[]] $projectFile = [System.IO.File]::ReadAllBytes("C:\Demos\Demo.ispac")            
$folder.DeployProject("ExecutionDemo", $projectFile)            
            
#### NEW STUFF STARTS FROM HERE ####            
            
# we can specify the value of parameters to be either constants or             
# to take the value from  environment variables            
            
$package = $project.Packages[“ComplexPackage.dtsx”]            
            
# setting value of parameter to constant            
$package.Parameters["Servername"].Set(            
    [Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Literal,            
    "Foobar");            
$package.Alter()            
            
# binding value of parameter to value of an env variable is a little more complex            
# 1) create environment            
# 2) add variable to environment            
# 3) make project refer to this environment            
# 4) make package parameter refer to this environment variable            
# These steps are shown below            
            
# 1) creating an environment            
$environment = New-Object $ISNamespace".EnvironmentInfo" ($folder, “Env1”, “Env1 Desc.”)            
$environment.Create()            
            
# 2) adding variable to our environment             
# Constructor args: variable name, type, default value, sensitivity, description            
$environment.Variables.Add(“Variable1”, [System.TypeCode]::Int32, “10”, “false”, “Desc.”)            
$environment.Alter()            
            
# 3) making project refer to this environment            
$project = $folder.Projects[$SSISProjectName]            
$project.References.Add($SSISEnv, $folder.Name)            
$project.Alter()            
            
# 4) making package parameter refer to this  environment variable            
$package.Parameters["CoolParam"].Set(            
    [Microsoft.SqlServer.Management.IntegrationServices.ParameterInfo+ParameterValueType]::Referenced,            
    $SSISEnvVar)            
$package.Alter()            
            
# retrieving environment reference            
$environmentReference = $project.References.Item($SSISEnv, $folder.Name)            
$environmentReference.Refresh()            
            
# executing with environment reference – Note: if you don’t have any env reference,            
# then you specify null as the second argument            
$package.Execute("false", $environmentReference)            
            
Write-Host "Package Execution ID: " $executionId
