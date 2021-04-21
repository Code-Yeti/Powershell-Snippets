# One liner to remove all files but the last 7 days
get-childitem "C:\Path\To\Folder" | Where-Object {$_.LastWriteTime -lt (get-date).adddays(-7)} | Remove-Item

# Function version with path checking
Function Clear-Logs{
    param(
        [Parameter(Mandatory=$true)]
        [string]$Location,
        [Parameter(Mandatory=$true)]
        [int]$DaysToKeep
    )

    if(Test-Path $Location){
        get-childitem $Location | Where-Object {$_.LastWriteTime -lt (get-date).adddays(-$DaysToKeep)} | Remove-Item
    }
}