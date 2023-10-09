# Define colors for console output
$separatorColor = [System.ConsoleColor]::Cyan
$infoColor = [System.ConsoleColor]::Green

# Function to write text with specified color
function Write-ColoredText {
    param(
        [string]$text,
        [System.ConsoleColor]$color
    )
    $originalColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $color
    Write-Host $text
    $Host.UI.RawUI.ForegroundColor = $originalColor
}

# Display a separator line
Write-ColoredText "=====================================" $separatorColor
Write-ColoredText "Starting Backup and Deletion Process" $separatorColor
Write-ColoredText "=====================================" $separatorColor

# Get the current timestamp
$currentTimestamp = Get-Date -Format "yyyy-MM-dd"

Write-ColoredText "Current timestamp: $currentTimestamp" $infoColor

# Define the Azure Storage Account URL and Shared Access Signature (SAS) token without an expiration date
$storageAccountUrl = "PUT_STORAGE_ACCOUNT_URL_HERE"
$sasToken = "PUT_SAS_TOKEN_HERE"

# Display a separator line
Write-ColoredText "-------------------------------" $separatorColor
Write-ColoredText "Performing Backup" $separatorColor
Write-ColoredText "-------------------------------" $separatorColor

# Define the destination for the backup with today's timestamp
$destination = "${storageAccountUrl}/${currentTimestamp}${sasToken}"
Write-ColoredText "Backup destination: $destination" $infoColor

# Perform the backup
Write-ColoredText "Performing backup..." $infoColor
azcopy copy "E:\Vault\ARASPROD" $destination --recursive=true
Write-ColoredText "Backup completed successfully." $infoColor

# Display a separator line
Write-ColoredText "---------------------------------" $separatorColor
Write-ColoredText "Deleting Old Backup (if applicable)" $separatorColor
Write-ColoredText "---------------------------------" $separatorColor

# Calculate the timestamp from approximately 30 days ago
$thirtyDaysAgo = (Get-Date).AddDays(-30).ToString("yyyy-MM-dd")
Write-ColoredText "Timestamp from approximately 30 days ago: $thirtyDaysAgo" $infoColor

# Delete the backup from approximately 30 days ago
$backupToDelete = "${storageAccountUrl}/${thirtyDaysAgo}${sasToken}"
Write-ColoredText "Deleting backup from approximately 30 days ago: $backupToDelete" $infoColor
azcopy rm $backupToDelete --recursive=true
Write-ColoredText "Deleted backup from approximately 30 days ago." $infoColor

# Display a separator line
Write-ColoredText "=====================================" $separatorColor
Write-ColoredText "Backup and Deletion Process Complete" $separatorColor
Write-ColoredText "=====================================" $separatorColor
