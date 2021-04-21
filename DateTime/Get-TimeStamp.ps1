Function Get-TimeStamp {
    return "{0:dd/MM/yy} {0:HH:mm:ss}" -f (Get-Date)        # Returns a value that can be converted to a DateTime
}