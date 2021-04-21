# Get all VMs in a cluster
Get-ClusterNode | ForEach-Object { get-vm -ComputerName $_.Name }

# Get a property from each VM in a cluster such as mounted ISO
Get-ClusterNode | ForEach-Object { get-vm -ComputerName $_.Name | Get-VMDvdDrive}
