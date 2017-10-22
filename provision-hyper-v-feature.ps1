if ((Get-WmiObject Win32_ComputerSystemProduct Vendor).Vendor -ne 'QEMU') {
    Exit 0
}

Install-WindowsFeature Hyper-V,Hyper-V-PowerShell
