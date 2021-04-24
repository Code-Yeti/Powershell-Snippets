
Function Create-Password{
    Param(
        [Parameter(Mandatory=$false)]
        [int]$Length = 10,
        [Parameter(Mandatory=$false)]
        [string]$CharacterBlackList

    )
    $Blacklist = [int[]][char[]]$CharacterBlackList

    for ($i = 0; $i -lt $Length; $i++) {
        do {
            $res = [char](Get-Random -Minimum 33 -Maximum 122)
        } while ($Blacklist.Contains([int][char]$res) -eq $true)
        $output += $res
    }
    
    return $output
}

# Exmaple Function Calls
Create-Password -Length 10 -CharacterBlackList ",.0oO``'`""
Create-Password -Length 20 -CharacterBlackList ",.0oO``'`""
Create-Password -Length 30  

<# 

Function Output Samples:
------------------------------
N#PYZ7i8d-
CwP$HcYabkpMKTciYQ$J
?r1)5X=VQNu:*p)BZ@I$%a<`xU;2#<
------------------------------
#>