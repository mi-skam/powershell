<#
.SYNOPSIS
		Creates a Hyper-V Virtual Machine suitable for running Ubuntu Server.
.DESCRIPTION
		This PowerShell script creates a new Hyper-V Generation 2 Virtual Machine
		that is suitable for installing and running Ubuntu Server. The default
		hardware configuration set by this script is as follows:
				- 2 Processor Cores
				- 1GB Dynamic Memory	(512MB to 1TB)
				- 127GB Dynamic Hard Disk
				- 1 Network Adapter
		In addition, a virtual DVD device is added for to the Ubuntu Server
		installation ISO file. Secure Boot is enabled on Windows Server 2016 and 
		Windows 10 Hyper-V hosts, otherwise it is disabled.
.NOTES
		File Name		: Ubuntu_Server_Hyper-V.ps1
		Author			: Chris Lowe
		Prerequisite	: PowerShell V2
.LINK
		http://www.technologist.site
.EXAMPLE
		Ubuntu_Server_Hyper-V.ps1
#>

# Adjust the following variable values as required

$VM_Name = "Ubuntu Server"
$VM_ISO = "C:\Users\plumps\Downloads\ubuntu-18.04.3-live-server-amd64.iso"
$VM_ProcessorCores = 2
$VM_MemorySize = 1GB
$VM_MemoryMin = 512MB
$VM_MemoryMax = 1TB
$VM_DiskSize = 127GB

$VM_DiskPath = (Get-VMHost).VirtualHardDiskPath
$VM_Adapter = (Get-NetAdapter -Physical | Where-Object {$_.Status -eq 'Up'} | Sort-Object $_.LinkSpeed | Select-Object -First 1).Name
If (((Get-VMSwitch -SwitchType External).Name) -eq $null) {New-VMSwitch -Name 'External' -NetAdapterName $VM_Adapter -AllowManagementOS $true -Notes 'External Switch'}
$VM_Switch = (Get-VMSwitch -SwitchType External).Name

# Create a new Virtual Hard Disk using 1MB Block Size as per Microsoft's Recommendations
# https://technet.microsoft.com/en-us/library/dn720239.aspx

New-VHD -Path $VM_DiskPath\$VM_Name.vhdx -SizeBytes $VM_DiskSize –Dynamic –BlockSizeBytes 1MB 

# Create a new Virtual Machine

New-VM -Name $VM_Name -Generation 2 -VHDPath $VM_DiskPath\$VM_Name.vhdx -SwitchName $VM_Switch
Set-VM -VMName $VM_Name -ProcessorCount $VM_ProcessorCores -DynamicMemory -MemoryStartupBytes $VM_MemorySize -MemoryMinimumBytes $VM_MemoryMin -MemoryMaximumBytes $VM_MemoryMax -Notes "$VM_Name`r`nCreated:`t$((Get-Date).ToString())`r`nSource:`t$(Split-Path $VM_ISO -Leaf)"

# Add a virtual DVD device for the installation ISO

Add-VMDvdDrive -VMName $VM_Name -Path $VM_ISO

# Configure UEFI Firmware with "Secure Boot" On/Off depending on Host version

If ((Get-WmiObject Win32_OperatingSystem).Version -gt "10") {
	Set-VMFirmware -VMName $VM_Name -EnableSecureBoot On -SecureBootTemplate 'MicrosoftUEFICertificateAuthority' }
else {
	Set-VMFirmware -VMName $VM_Name -EnableSecureBoot Off }

# Configure UEFI Firmware to "Boot from DVD"

Set-VMFirmware -VMName $VM_Name -FirstBootDevice (Get-VMDvdDrive -VMName $VM_Name)