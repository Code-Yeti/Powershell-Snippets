<#
    .SYNOPSIS
    Creates a folder and sets persmissions.
    .DESCRIPTION
    Creates a folder and sets persmissions:
    Admins: Full Control
    Users: Read, Write, Execute on the main folder
    Users: Modify on sub folders and files
    Owner: Is set to own the base folder
#>
Function New-SecureFolder{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string[]]$Admins,
        [Parameter(Mandatory=$true)]
        [string[]]$Users,
        [Parameter(Mandatory=$true)]
        [string]$Owner
    )

    $ACL = New-Object System.Security.AccessControl.DirectorySecurity
    $ACL.SetAccessRuleProtection($true, $true) #Only use permissions we set, remove inherited permissions

    ForEach($Admin in $Admins){
        Try{
            $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($Admin,"FullControl","Allow")))
        }
        Catch {
            Write-Host "Error adding Admin: $Admin.  Aborting."
            return $null
        }
    }

    ForEach($User in $Users){
        Try{
            $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($User,"Delete","None","None","Deny")))
            $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($User,"Modify, Synchronize", "ContainerInherit, ObjectInherit","InheritOnly","Allow")))
            $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($User,"ReadAndExecute, Write","None","None","Allow")))
        }
        Catch {
            Write-Host "Error adding User: $User.  Aborting."
            return $null
        }
    }

    Try{
        $ACL.SetOwner([System.Security.Principal.NTAccount]$Owner)
    }
    Catch{
        Write-Host "Error setting the owner, check account/group exists"
        return $null
    }
    

    if(Test-Path $Path){
        $ACL | Set-Acl $Path
    } else {
        Try{
            New-Item $Path -ItemType directory
            $ACL | Set-Acl $Path
        }
        Catch {
            Write-Host "A problem was found, most likely the path ($Path) is not valid"
            $_
            return $null
        }
    }
    return $true
}

# USAGE
New-SecureFolder -Path "C:\PATH\TO\FOLDER" -Admins "BUILTIN\Administrators", "DOMAIN\ACCOUNT" -Users "DOMAIN\ACCOUNT", "DOMAIN\ACCOUNT"  -Owner "DOMAIN\ACCOUNT"