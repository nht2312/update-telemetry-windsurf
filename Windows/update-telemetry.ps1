try {
    # Set error preference to stop on errors
    $ErrorActionPreference = "Stop"
    
    # Define file paths
    $file = "C:\Users\DevNHT Asus\AppData\Roaming\Windsurf\User\globalStorage\storage.json"
    $tmp = "$file.tmp"
    
    # Check if file exists
    if (-Not (Test-Path $file)) {
        throw "File does not exist: $file"
    }
    
    # Backup the original file
    Copy-Item -Path $file -Destination "$file.bak" -Force
    
    # Generate random values for the telemetry fields
    $machineId = -join ((48..57 + 97..102) | Get-Random -Count 64 | ForEach-Object {[char]$_})
    $sqmId = [guid]::NewGuid().ToString()
    $deviceId = [guid]::NewGuid().ToString()
    
    # Load the JSON content
    $json = Get-Content -Raw -Path $file
    
    # Replace telemetry fields in the JSON - fixing the replacement syntax
    $json = $json -replace '"telemetry\.machineId"\s*:\s*"[^"]+"', ('"telemetry.machineId": "' + $machineId + '"')
    $json = $json -replace '"telemetry\.sqmId"\s*:\s*"[^"]+"', ('"telemetry.sqmId": "{' + $sqmId + '}"')
    $json = $json -replace '"telemetry\.devDeviceId"\s*:\s*"[^"]+"', ('"telemetry.devDeviceId": "' + $deviceId + '"')
    
    # Write the modified JSON to a temporary file
    $json | Out-File -Encoding utf8 -FilePath $tmp
    
    # Replace the original file with the modified content
    if (Test-Path $tmp) {
        Move-Item -Path $tmp -Destination $file -Force
        Write-Host "`nTelemetry updated successfully!" -ForegroundColor Green
        Write-Host "machineId : $machineId"
        Write-Host "sqmId     : {$sqmId}"
        Write-Host "deviceId  : $deviceId"
    } else {
        throw "Failed to create temporary file."
    }
} catch {
    Write-Host "`nAn error occurred:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}

# Keep the window open
Write-Host "`nPress Enter to exit..."
Read-Host