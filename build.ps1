# restore and builds all projects as release.
# creates NuGet package at \artifacts
dotnet --version

$versionPrefix = "6.0.2"
$versionSuffix = ""
$versionFile = $versionPrefix + "." + ${env:APPVEYOR_BUILD_NUMBER}
$versionProduct = $versionPrefix;

if ($env:APPVEYOR_PULL_REQUEST_NUMBER) {
    $versionPrefix = $versionFile
    $versionSuffix = "PR" + $env:APPVEYOR_PULL_REQUEST_NUMBER
}

if (-Not $versionSuffix.Equals("")) { 
    $versionProduct = $versionProduct + "-" + $versionSuffix 
}

dotnet restore .\src\NLog.Extensions.Logging\
if (-Not $LastExitCode -eq 0) {
    exit $LastExitCode 
}

dotnet restore .\src\NLog.Extensions.Hosting\
if (-Not $LastExitCode -eq 0) {
    exit $LastExitCode 
}

msbuild /t:Pack .\src\NLog.Extensions.Logging\ /p:VersionPrefix=$versionPrefix /p:VersionSuffix=$versionSuffix /p:FileVersion=$versionFile /p:ProductVersion=$versionProduct /p:Configuration=Release /p:IncludeSymbols=true /p:SymbolPackageFormat=snupkg /p:PackageOutputPath=..\..\artifacts /verbosity:minimal /p:ContinuousIntegrationBuild=true
if (-Not $LastExitCode -eq 0) {
    exit $LastExitCode 
}

msbuild /t:Pack .\src\NLog.Extensions.Hosting\ /p:VersionPrefix=$versionPrefix /p:VersionSuffix=$versionSuffix /p:FileVersion=$versionFile /p:ProductVersion=$versionProduct /p:Configuration=Release /p:IncludeSymbols=true /p:SymbolPackageFormat=snupkg /p:PackageOutputPath=..\..\artifacts /verbosity:minimal /p:ContinuousIntegrationBuild=true
if (-Not $LastExitCode -eq 0) {
    exit $LastExitCode 
}

exit $LastExitCode
