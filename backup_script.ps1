#######################################################################################################
# This script uploads all the files that were modified until yesterday. Once the file is uploaded,
# the script deletes the file from the local disk.
# If an upload file fails, the script is going to retry depending on how the $Retries variable is set
#######################################################################################################

#Variables, only Change here
$DestinationBucket = "bucketName"
$DestinationFolder = "destination\folder" #Copy the Files to this Location
$BackupDir = "C:\Directory\to\backup"
$Retries = 3

# No changes from here....
$Files = Get-ChildItem -Recurse $BackupDir | Where-Object LastWriteTime -le (Get-Date).AddDays(-1).Date | Where { ! $_.PSIsContainer }
foreach($file in $Files) {
    $DestinationKey = Join-Path -Path $DestinationFolder -ChildPath $file.Fullname.Replace($BackupDir, "")
    $DestinationKey = $DestinationKey.Replace('\', '/')
    $FileFullname = $file.FullName
    echo $FileFullname
    echo $DestinationKey
    if(-Not (Get-S3Object -BucketName $DestinationBucket -Key $DestinationKey)) {
        $Flag = $true
        $CurrentAttempt = 1
        do {
            try {
                Write-Output "Command: Write-S3Object -BucketName ${DestinationBucket} -Key ${DestinationKey} -File ${FileFullname}"
                Write-S3Object -BucketName $DestinationBucket -Key "$DestinationKey" -File "$FileFullname"
                Write-Output "Removing ${FileFullname}"
                Remove-Item -LiteralPath "$FileFullname"
                $Flag = $false
            }
            catch {
                $CurrentAttempt = $CurrentAttempt +1
                if ($CurrentAttempt -gt $Retries) {
                    $Flag = $false
                    Write-Output "Couldn't upload file: ${FileFullname}"
                }
            }
        }
        While ($Flag)
    }
}
