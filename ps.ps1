param(
    [Parameter(Mandatory=$true)]
    [String]$script,
    [Parameter(ValueFromRemainingArguments=$true)]
    [String[]]$scriptArguments
)

Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'

trap {
    Write-Output "ERROR: $_"
    Write-Output (($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1')
    Write-Output (($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1')
    Exit 1
}

# wrap the choco command (to make sure this script aborts when it fails).
function Start-Choco([string[]]$Arguments, [int[]]$SuccessExitCodes=@(0)) {
    $command, $commandArguments = $Arguments
    if ($command -eq 'install') {
        $Arguments = @($command, '--no-progress') + $commandArguments
    }
    for ($n = 0; $n -lt 10; ++$n) {
        if ($n) {
            # NB sometimes choco fails with "The package was not found with the source(s) listed."
            #    but normally its just really a transient "network" error.
            Write-Host "Retrying choco install..."
            Start-Sleep -Seconds 3
        }
        &C:\ProgramData\chocolatey\bin\choco.exe @Arguments
        if ($SuccessExitCodes -Contains $LASTEXITCODE) {
            return
        }
    }
    throw "$(@('choco')+$Arguments | ConvertTo-Json -Compress) failed with exit code $LASTEXITCODE"
}
function choco {
    Start-Choco $Args
}

function docker {
    docker.exe @Args | Out-String -Stream -Width ([int]::MaxValue)
    if ($LASTEXITCODE) {
        throw "$(@('docker')+$Args | ConvertTo-Json -Compress) failed with exit code $LASTEXITCODE"
    }
}

Add-Type @'
using System;
using System.Runtime.InteropServices;

public static class Windows
{
    [DllImport("kernel32", SetLastError=true)]
    public static extern UInt64 GetTickCount64();

    public static TimeSpan GetUptime()
    {
        return TimeSpan.FromMilliseconds(GetTickCount64());
    }
}
'@

function time([ScriptBlock]$scriptBlock) {
    $begin = [Windows]::GetUptime()
    try {
        &$scriptBlock
    } finally {
        Write-Host "== command {$scriptBlock} executed in $(([Windows]::GetUptime() - $begin).TotalSeconds) seconds"
    }
}

cd c:/vagrant
$script = Resolve-Path $script
cd (Split-Path $script -Parent)
Write-Host "Running $script..."
. $script @scriptArguments
