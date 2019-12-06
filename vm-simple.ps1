$VMName = "vm"

 $VM = @{
     Name = $VMName
     MemoryStartupBytes = 2147483648
     Generation = 2
     NewVHDPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\$VMName.vhdx"
     NewVHDSizeBytes = 53687091200
     BootDevice = "VHD"
     Path = "C:\ProgramData\Microsoft\Windows\Hyper-V"
     SwitchName = "Default Switch"
 }

 New-VM @VM