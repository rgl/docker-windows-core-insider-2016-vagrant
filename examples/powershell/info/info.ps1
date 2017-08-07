$FormatEnumerationLimit = -1

function Write-Title($title) {
    Write-Output "#`n# $title`n#"
}

Write-Title 'PowerShell version'
$PSVersionTable.GetEnumerator() `
    | Sort-Object Name `
    | Format-Table -AutoSize `
    | Out-String -Stream -Width ([int]::MaxValue) `
    | ForEach-Object {$_.TrimEnd()}

Write-Title 'Loaded Assemblies'
[AppDomain]::CurrentDomain.GetAssemblies() `
    | ForEach-Object {
        New-Object PSObject -Property @{
            Location = $_.Location
            Version = $_.FullName -replace '.+ Version=(.+), Culture=.+','$1'
        }
    } `
    | Sort-Object Location `
    | Format-Table -AutoSize -Property Location,Version `
    | Out-String -Stream -Width ([int]::MaxValue) `
    | ForEach-Object {$_.TrimEnd()}

Write-Title 'Environment Variables'
dir env: `
    | Sort-Object -Property Name `
    | Format-Table -AutoSize `
    | Out-String -Stream -Width ([int]::MaxValue) `
    | ForEach-Object {$_.TrimEnd()}

Write-Title 'Who Am I'
.\whoami.ps1
