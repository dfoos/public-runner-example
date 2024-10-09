$BACKUP_DIRECTORY="C:\temp\github_test\BACKUP"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

$stacks = @{
    "AT1"  = "C:\temp\github_test\at1"
    "PRD"  = "C:\temp\github_test\prd"
}
foreach ($k in $stacks.Keys) {
  #Create backup of existing
  $zip_name = $timestamp + "_" + $k + ".zip"
  Compress-Archive -Path $($stacks.Item($k)) -DestinationPath "$BACKUP_DIRECTORY/$zip_name"

  # Mirror directories
  ROBOCOPY /Mir script_folders/$k $($stacks.Item($k))
}

# Delete all previous backups older than 90 days.
$limit = (Get-Date).AddDays(-90)
Get-ChildItem -Path $BACKUP_DIRECTORY -Recurse -File | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item
