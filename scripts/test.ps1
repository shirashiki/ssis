Set-Location "z:\git\ssis"
get-childitem | where-object {$_.length -gt 1kb}
