# Set the context to the storage account
$storageAccountName = "ofvaultbackup"
$resourceGroupName = "OptoFidelity"
$containerName = "vault"
$storageKey = "KEY_GOES_HERE"  # Or use SAS token
$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageKey

# Create a timestamp for the zip file
# timestamp with clear formatting
$timestamp = Get-Date -Format "yyyy-MM-dd-HH"
$zipFileName = "backup_$timestamp.zip"
$zipPath = Join-Path -Path $env:TEMP -ChildPath $zipFileName

# Specify the source and destination folders
$sourceFolder = "F:\Aras\Vault\OF_DEV_2023_06_30"
$destinationFolder = $timestamp  # Use a folder structure within the container

# Zip the source folder
Compress-Archive -Path $sourceFolder -DestinationPath $zipPath -Force

# Upload the zip file to Blob Storage
$blobName = "$destinationFolder/$zipFileName"
Set-AzStorageBlobContent -Context $context -Container $containerName -File $zipPath -Blob $blobName -Force

# Remove the temporary zip file
Remove-Item -Path $zipPath -Force