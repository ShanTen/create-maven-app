param(
    [Parameter(Mandatory=$true)]
    [string] $command
)

$config = Get-Content -Raw -Path "jproject.json" | ConvertFrom-Json

if (-Not $config.scripts.$command) {
    Write-Host "Command '$command' not found in jproject.json."
    exit 1
}

$exec = $config.scripts.$command
Write-Host "Executing: $exec"
Invoke-Expression $exec
