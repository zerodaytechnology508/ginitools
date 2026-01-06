$path = "E:\Coding Projects\Code With Antigravity\Galaxy Professional Tool-GPT"
Set-Location $path

# Create the FileSystemWatcher
$fsw = New-Object System.IO.FileSystemWatcher $path
$fsw.IncludeSubdirectories = $true
$fsw.Filter = "*.*"
$fsw.EnableRaisingEvents = $true

# Function to auto-commit and push
function Sync-Git {
    git add .
    git commit -m "Auto update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-Null
    git push origin main | Out-Null
}

# Register events separately (works on all Windows PowerShell versions)
Register-ObjectEvent -InputObject $fsw -EventName "Changed" -Action { Sync-Git }
Register-ObjectEvent -InputObject $fsw -EventName "Created" -Action { Sync-Git }
Register-ObjectEvent -InputObject $fsw -EventName "Deleted" -Action { Sync-Git }
Register-ObjectEvent -InputObject $fsw -EventName "Renamed" -Action { Sync-Git }

Write-Host "Auto-sync watcher is running..."
# Keep the script alive
while ($true) { Start-Sleep -Seconds 1 }
