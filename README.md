# windows-backup-script

### Purpose
Powershell script that backups a given directory in an S3 bucket. After a file is safelly uploaded, it's removed from local disk to prevent filling up. 

**Note:** The aws-S3 client has to be already configured. Please [follow this instruccion](https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html)

### Variables you can configure
 - `DestinationBucket = bucketName` Name of the bucket
 - `DestinationFolder = "app_server_backups\prd"` Copy files to this location inside the bucket
 - `BackupDir = "C:\Logs"` Local directory will be backed up
 - `Retries = 3` Number of retries to upload a file if it fails
