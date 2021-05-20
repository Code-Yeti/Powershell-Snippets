using namespace System.Drawing
Add-Type -AssemblyName System.Drawing
Function Resize-Image{
    param(
        [Parameter(Mandatory=$True)]
        [System.Drawing.Bitmap]$Image,
        [Parameter(Mandatory=$False)]
        [int]$maxSize=192
    )

    # Image resize settings
    [System.Drawing.Drawing2D.InterpolationMode]$InterpolationMode = "HighQualityBicubic"
    [System.Drawing.Drawing2D.SmoothingMode]$SmoothingMode = "HighQuality"
    [System.Drawing.Drawing2D.InterpolationMode]$InterpolationMode = "HighQualityBicubic"
    [System.Drawing.Drawing2D.PixelOffsetMode]$PixelOffsetMode = "HighQuality"

    # If image is too small return null
    if($Image.Width -lt $minSize -and $Image.Height -lt $minSize){
        Write-Host "Images is smaller than the resize value"
        return $null
    }

    # Calculate apsect ratio
    $ratioX = $maxSize / $Image.Width
    $ratioY = $maxSize / $Image.Height

    $ratio = if($ratioX -lt $ratioY){$ratioX} else {$ratioY}  

    # Calculate resized image dimensions
    $newWidth = [int]($Image.Width * $ratio)
    $newHeight = [int]($Image.Height * $ratio)

    # Create resized image
    $ResizedBitmap = New-Object -TypeName System.Drawing.Bitmap -ArgumentList $newWidth, $newHeight
    $ResizedImage = [System.Drawing.Graphics]::FromImage($ResizedBitmap)
    $ResizedImage.SmoothingMode = $SmoothingMode
    $ResizedImage.InterpolationMode = $InterpolationMode
    $ResizedImage.PixelOffsetMode = $PixelOffsetMode
    $ResizedImage.DrawImage($Image, $(New-Object -TypeName System.Drawing.Rectangle -ArgumentList 0, 0, $newWidth, $newHeight))

    return $ResizedBitmap
}

Function Add-Border{
    param(
        [Parameter(Mandatory=$True)]
        [System.Drawing.Bitmap]$Image,
        [Parameter(Mandatory=$False)]
        [int]$BorderWidth = 1
    )
        $tmpImage = $Image #Make a copy or reference gets updated
        #Draw border
        $mypen = new-object -TypeName Drawing.Pen  -ArgumentList black
        $mypen.width = $BorderWidth
        $NewImage = [System.Drawing.Graphics]::FromImage($tmpImage)
        $NewImage.DrawLine($mypen,0,0,$Image.Width,0)
        $NewImage.DrawLine($mypen,$tmpImage.Width-1,0,$tmpImage.Width-1,$tmpImage.Height-1)
        $NewImage.DrawLine($mypen,$tmpImage.Width-1,$tmpImage.Height-1,1,$tmpImage.Height-1)
        $NewImage.DrawLine($mypen,0,$tmpImage.Height-1,0,0)
        return $tmpImage
}

Function BitmapToBinary{
    param(
        [Parameter(Mandatory=$True)]
        [System.Drawing.Bitmap]$Image
    )
        # Save image to memory stream
        $memory = New-Object System.IO.MemoryStream
        $null = $Image.Save($memory,[System.Drawing.Imaging.ImageFormat]::Jpeg)
        $Image.Dispose()
        [byte[]]$bytes = $memory.ToArray()
        $memory.Close()
        return $bytes
}
Function Crop-Image{
    param(
        [Parameter(Mandatory=$True)]
        [System.Drawing.Bitmap]$Image,
        [Parameter(Mandatory=$True)]
        [int]$X=0,
        [Parameter(Mandatory=$True)]
        [int]$Y=0,
        [Parameter(Mandatory=$True)]
        [int]$Width=192,
        [Parameter(Mandatory=$True)]
        [int]$Height=192
    )

    if(($X + $Width) -gt $Image.Width -or ($Y + $Height) -gt $Image.Height){
        Write-Host "Crop is outside the bounds of the image"
        return $null
    }
    $rect = New-Object -TypeName System.Drawing.Rectangle -ArgumentList $X,$Y,$Width,$Height
    return ($Image.Clone($rect,$Image.PixelFormat))

}

Function Load-Image{
    param(
        [Parameter(Mandatory=$True)]
        [string]$FilePath
    )
    return (New-Object -TypeName System.Drawing.Bitmap -ArgumentList $FilePath)
}

Export-ModuleMember -Function Crop-Image
Export-ModuleMember -Function BitmapToBinary
Export-ModuleMember -Function Add-Border
Export-ModuleMember -Function Resize-Image
Export-ModuleMember -Function Load-Image
