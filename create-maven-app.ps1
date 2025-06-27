# Shantanu Ramanujapuram 21-06-2025
# Teething build script for developers coming from node.js 

$mvnCMDpath = "D:\Applications\JetBrains\IntelliJ IDEA Community Edition 2024.3.4.1\plugins\maven\lib\maven3\bin"

$projectName = Read-Host "Enter the name of the Maven project (e.g., My App)"
$artifactId = Read-Host "Enter the artifact ID (e.g., my-app) — do not use spaces"
$groupId = Read-Host "Enter the group ID (e.g., com.example)"
$version = Read-Host "Enter version (default: 1.0.0)"
if ([string]::IsNullOrWhiteSpace($version)) {
    $version = "1.0.0"
}
# $mvn = "$mvnCMDpath\mvn.cmd"

if (Test-Path $mvnCMDpath) {
    Write-Host "Using Maven from path: $mvnCMDpath" -ForegroundColor Green
    $mvn = "$mvnCMDpath\mvn.cmd"
} else {
    Write-Host "Maven path not found at $mvnCMDpath. Using default Maven command." -ForegroundColor Yellow
    Write-Host "Ensure Maven is installed and available in your PATH." -ForegroundColor Yellow
    $mvn = "mvn.cmd"
}

function escapedFilePath($mvnPath) {
    return $mvnPath -replace "\\","/"
}

# if (-Not (Test-Path $mvn)) {
#     Write-Host "Maven command not found at $mvnCMDpath. Please check the path."
#     exit 1
# }

Write-Host "Creating Maven project..." -ForegroundColor Cyan
Start-Process -FilePath $mvn -ArgumentList "archetype:generate", "-DgroupId=$groupId", "-DartifactId=$artifactId", "-DarchetypeArtifactId=maven-archetype-quickstart", "-DinteractiveMode=false" -NoNewWindow -Wait
Write-Host "Maven project '$artifactId' created successfully." -ForegroundColor Green

Set-Location $artifactId

$mvnEscaped = escapedFilePath($mvn)

# Generate jproject.json
$template = @"
{
    "name": "$projectName",
    "version": "$version",
    "description": "A simple Maven project",
    "groupId": "$groupId",
    "artifactId": "$artifactId",
    "mainClass": "$groupId.App",
    "buildTool": "Maven",
    "sourceDirectory": "src/main/java",
    "testDirectory": "src/test/java",
    "resourcesDirectory": "src/main/resources",
    "targetDirectory": "target",
    "scripts": {
        "build": "&'$mvnEscaped' clean package",
        "test": "&'$mvnEscaped' test",
        "run": "`$__tmp__=(Resolve-Path 'target/$artifactId-*.jar').path;java -cp `$__tmp__ $groupId.App"
    }
}
"@
$template | Out-File -Encoding UTF8 -FilePath "jproject.json"

# Generate jpscript.ps1
$jpscript = @"
param(
    [Parameter(Mandatory=`$true)]
    [string] `$command
)

`$config = Get-Content -Raw -Path "jproject.json" | ConvertFrom-Json

if (-Not `$config.scripts.`$command) {
    Write-Host "Command '`$command' not found in jproject.json."
    exit 1
}

`$exec = `$config.scripts.`$command
Write-Host "Executing: `$exec"
Invoke-Expression `$exec
"@

# $jpscript | Out-File -Encoding UTF8 -FilePath "jpscript.ps1"
# Write-Host "`njproject.json and jpscript.ps1 created successfully." -ForegroundColor Green

try {
    $jpscript | Out-File -Encoding UTF8 -FilePath "jpscript.ps1"
    Write-Host "`njproject.json and jpscript.ps1 created successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to write jpscript.ps1: $_" -ForegroundColor Red
}