# escape=`
FROM powershell:6.1.3 as builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
RUN cd $env:TMP; `
    $url = 'https://frippery.org/files/busybox/busybox-w64-FRP-2962-g9aae70405.exe'; `
    $sha256 = 'adb2360905f737cb7e58c915056f18f7b1e0843e99474ed5ce6f4bde042943ef'; `
    Write-Host ('Downloading {0}...' -f $url); `
    Invoke-WebRequest -Uri $url -OutFile busybox.exe; `
    Write-Host ('Verifying sha256 ({0})...' -f $sha256); `
    if ((Get-FileHash busybox.exe -Algorithm sha256).Hash -ne $sha256) { `
        Write-Host 'FAILED!'; `
        Exit 1; `
    };

FROM mcr.microsoft.com/windows/nanoserver:1809
COPY --from=builder /Windows/TEMP/busybox.exe /Windows/System32/
