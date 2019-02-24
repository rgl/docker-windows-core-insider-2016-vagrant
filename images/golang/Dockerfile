# escape=`
FROM powershell:6.1.3 AS builder
SHELL ["pwsh.exe", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
WORKDIR C:/Windows/TEMP
RUN function Install-Artifact($url, $hash, $to) { `
        Write-Host ('Downloading {0}...' -f $url); `
        Invoke-WebRequest -Uri $url -OutFile artifact.zip; `
        Write-Host ('Verifying if the hash is {0}...' -f $hash); `
        if ((Get-FileHash artifact.zip -Algorithm sha256).Hash -ne $hash) { `
            Write-Host 'FAILED!'; `
            Exit 1; `
        }; `
        Write-Host 'Expanding...'; `
        mkdir -Force $to | Out-Null; `
        Expand-Archive artifact.zip $to; `
        Write-Host 'Removing...'; `
        Remove-Item artifact.zip -Force; `
        Write-Host 'Done.'; `
    }; `
    Install-Artifact `
        'https://dl.google.com/go/go1.11.5.windows-amd64.zip' `
        '1c734fe614fa052f44694e993f2d06f24a56b6703ee46fdfb2b9bf277819fe40' `
        '.'; `
    Install-Artifact `
        'https://github.com/git-for-windows/git/releases/download/v2.20.1.windows.1/MinGit-2.20.1-64-bit.zip' `
        '02328f37eeefe8d8f5396553ac8f91c98d09e533d49d93c617a4643915a76552' `
        'git';
RUN ./git/cmd/git config --file git/mingw64/etc/gitconfig core.autocrlf false;

FROM powershell:6.1.3
COPY --from=builder C:/Windows/TEMP/go C:/go
COPY --from=builder C:/Windows/TEMP/git C:/git
ENV PATH='C:\Windows\System32;C:\Windows;C:\Program Files\PowerShell;C:\go\bin;C:\git\cmd'
