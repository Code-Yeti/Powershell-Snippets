# Simple logging funtion
Function Out-Log{
    Param(
        [Parameter(Mandatory=$True)]
        $Message,
        [Parameter(Mandatory=$True)]
        $LogFile,
        [Parameter(Mandatory=$False)]
        $Append = $True # Default to append, set to false to default to overwrite
    )
    if($Append){
        "$Message" -replace "`n",", " -replace "`r",", " | Out-File -FilePath $LogFile -Append 
    } else {
        "$Message" -replace "`n",", " -replace "`r",", " | Out-File -FilePath $LogFile
    }
}