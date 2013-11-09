#Script courtesy of TnT
#Version 1.0
#This script will launch your server and zip up your server directory into a folder of your choice upon the server stopping.
#No warranty is provided whatsoever.  Learn this script and what it does before using it.

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#   BEGIN STATIC VARIABLE DECLARATION   #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#Set the minimum PowerShell version this script works with. (DO NOT CHANGE).
New-Variable -Name POWERSHELL_VERSION -Option Constant -Value ([int]3)
#Set the minimum .NET Framework version this script works with. (DO NOT CHANGE).
New-Variable -Name FRAMEWORK_VERSION -Option Constant -Value ([decimal]4.5)

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#   BEGIN FUNCTION DECLARATION   #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#

#Function to create the config.txt file.  If the file exists, it will not be overwrote.
Function Create-Config() {
    If (!(Test-Path config.txt)) {
        $currentlocation=Get-Location
        $parentfolder=(get-item $currentlocation).parent.FullName
        New-Item config.txt -ItemType "file"
        Add-Content config.txt "SERVER_NAME=MyServer"
        Add-Content config.txt "SERVER_LOCATION=$currentlocation"
        Add-Content config.txt "BACKUP_LOCATION=$parentfolder\backup"
        Add-Content config.txt "CRAFTBUKKIT=craftbukkit.jar"
        Add-Content config.txt "JAVA_FLAGS=-Xmx1G"
        Add-Content config.txt "CRAFTBUKKIT_OPTIONS=-o True -p 25565"
        Add-Content config.txt "TEST_DEPENDENCIES=True"
        Add-Content config.txt "DELETE_LOG=True"
        Add-Content config.txt "TAKE_BACKUP=True"
        Add-Content config.txt "RESTART_PAUSE=5"
    }
}

#Loads all variables from the config.txt file.
Function Load-Variables() {
    $types = @{
    SERVER_NAME         = {$args[0] -as [string]}
    SERVER_LOCATION     = {$args[0] -as [string]}
    BACKUP_LOCATION     = {$args[0] -as [string]}
    CRAFTBUKKIT         = {$args[0] -as [string]}
    JAVA_FLAGS          = {
        ($args[0].split(' ')[0] -as [string]), 
        ($args[0].split(' ')[1] -as [string]),
        ($args[0].split(' ')[2] -as [string]),
        ($args[0].split(' ')[3] -as [string]),
        ($args[0].split(' ')[4] -as [string]),
        ($args[0].split(' ')[5] -as [string]),
        ($args[0].split(' ')[6] -as [string]),
        ($args[0].split(' ')[7] -as [string]),
        ($args[0].split(' ')[8] -as [string])
    }
    CRAFTBUKKIT_OPTIONS = { 
        ($args[0].split(' ')[0] -as [string]),
        ([bool]::Parse($args[0].split(' ')[1])),
        ($args[0].split(' ')[2] -as [string]),
        ($args[0].split(' ')[3] -as [int]) 
    }
    TEST_DEPENDENCIES   = {([bool]::Parse($args[0]))}
    DELETE_LOG          = {([bool]::Parse($args[0]))}
    TAKE_BACKUP         = {([bool]::Parse($args[0]))}
    RESTART_PAUSE       = {$args[0] -as [int]}
    }
    
    $ht = [ordered]@{}
    Get-Content config.txt |
    ForEach-Object {
        $parts = $_.split('=').trim()
        $ht[$parts[0]] = &$types[$parts[0]] $parts[1]
    }
    New-object PSObject -Property $ht
}

#Function to ensure the correct version of PowerShell can be found to run this script.
#If the wrong version is found, it will provide a link to the correct version.
Function Test-PowerShell([int]$minVersion) {
    $psVer = $PSVersionTable.PSVersion.Major
    If ($psVer -ge $minVersion) {
        Write-Host -foreground Green "PowerShell version $psVer is compatible"
        Return $true
    }
    
    Write-Host -foreground Red "PowerShell version $psVer is NOT compatible"
    Write-Host -foreground Red "You need to install PowerShell v$minVersion or greater."
    Write-Host -foreground Red "Get Powershell 4.0 here (Requires Windows 7 SP1 or Windows Server 2008 R2 SP1):" 
    Write-Host -foreground Red "http://www.microsoft.com/en-us/download/details.aspx?id=40855" 
    Write-Host -foreground Red "Aborting script"
    
    Return $false
}

#Function to ensure the correct version of .NET Framework is found to run this script.
#If an older version is found, it will provide a link to the correct version.
Function Test-Framework([decimal]$minVersion) {
    $frameworkVer = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Client'
    $frameworkVer = $frameworkVer.Version
    If ($frameworkVer -ge $minVersion) {
        Write-Host -foreground Green ".NET Framework $frameworkVer is compatible."
        Return $true
    }
    
    Write-Host -foreground Red ".NET Framework version $frameworkVer is NOT compatible"
    Write-Host -foreground Red "You need to install .NET Framework $minVersion or greater."
    Write-Host -foreground Red "Get .NET Framework $minVersion here (Requires Windows 7 SP1 or Windows Server 2008 R2 SP1):" 
    Write-Host -foreground Red "http://www.microsoft.com/en-ca/download/details.aspx?id=30653" 
    Write-Host -foreground Red "Aborting script"
    
    Return $false
}

#Function to launch the server.  Arguments passed into this is Function is the directory of the server, the location of the server jar file
#the Java flags to use and any command line options to pass to the server.
Function Launch-Server([string]$location, [string]$jarfile, [array]$flags, [array]$options) {
    If (($location -eq "") -or ($location -eq $NULL)) {
        Write-Host ""
        Write-Host -foreground Red "Launch Aborted.  Server folder has not been specified."
        Return
    }
    
    If (!(Test-Path $location)) {
        Write-Host ""
        Write-Host -foreground Red "No server folder $location found.  You must create this folder yourself.  Launch aborted."
        Return
    }

    $jarfound = (Get-ChildItem $location -filter "*.jar").Name
    If (($jarfile -eq "") -or ($jarfile -eq $NULL)) {
        Write-Host ""
        Write-Host -foreground Red "CraftBukkit executable $jarfile not found, however, we did find:"
        Write-Host -foreground Red "$jarfound"  
        Write-Host -foreground Red "Do you have a typo in your config.txt?"
        Return
    }

    $server = Join-Path -path $location -childpath $jarfile
    $runlocation = Get-Location
    If (!(Test-Path $server)) {
        If ($jarfound -ne $NULL) {
            Write-Host -foreground Red "$server not found, however, we did find:"
            Write-Host -foreground Red "$jarfound"  
            Write-Host -foreground Red "Do you have a typo in your config.txt?"
            Return
        }
        Write-Host -foreground Red "$server not found.  Aborting."
    }
    
    Write-Host "Bukkit Servers are Fun!"
    Set-Location $location
    write-host $flags
    java $flags -jar $server $options
    Set-Location $runlocation
}

#Function to backup the contents of a directory.
#This will break If not using .NET 4.5 or above
Function Write-Backup([string]$backup, [string]$name, [string]$server) {
    $date = get-date -UFormat %Y-%m-%d-%H-%M
    If (($backup -eq "") -or ($backup -eq $NULL)) {
        Write-Host ""
        Write-Host -foreground Red "Backup Aborted.  Backup folder has not been specified."
        Return
    }

    If (!(Test-Path $backup)) {
        Write-Host ""
        Write-Host -foreground Red "No backup folder $backup found.  You must create this folder yourself.  Aborting backup."
        Return
    }
    
    If (($server -eq "") -or ($server -eq $NULL)) {
        Write-Host ""
        Write-Host -foreground Red "Backup Aborted.  Server folder has not been specified."
        Return
    }
    
    If (!(Test-Path $server)) {
        Write-Host ""
        Write-Host -foreground Red "No server folder $server found.  Backup aborted."
        Return
    }   
    
    If (($name -eq "") -or ($name -eq $NULL)) {
        $backupFile = Join-Path -path $backup -childpath ("UNNAMED" + "-" + $date + ".zip")
    }
    Else {
        $backupFile = Join-Path -path $backup -childpath ($name + "-" + $date + ".zip")
    }
    
    If (Test-Path $backupFile) {
        Write-Host ""
        Write-Host -foreground Red "Backup Aborted.  $backupFile already exists."
        Return
    }
    
    #Dump the output to null to avoid spamming the console.  Backups will still run without issue
    [Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") > $NULL
    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    [System.IO.Compression.ZipFile]::CreateFromDirectory($server, $backupFile, $compressionLevel, $false)
    Write-Host ""
    Write-Host -foreground Green "Backup Completed.  See $backupFile" 
}

#Function to quit the auto relaunch based on a time set.
Function Set-Quit([int]$delay) {
    Write-Host ""
    Write-Host -background Red "Press q to quit - you have $RESTART_PAUSE seconds to decide"
    Start-Sleep -s $delay

    If ($Host.UI.RawUI.KeyAvailable -and ("q" -eq $Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character)) {
        Write-Host -foreground Red "Exiting Script.  Good-bye."
        Return $true;
    }
    
    Return $false
}

#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#   BEGIN FUNCTION CALLS   #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
#Create the config file to be used.  
Create-Config

#Main area of the script.  This launches all functions above (PowerShell needs the functions declared before they can be ran).
#First the dependencies get tested, then the server gets launched.  
#If backups are enabled, take the backup.  Delete the server.log If that ability is enabled.
#If backups are disabled, Do not take a backup or delete the server.log
#Keep looping until the user quits the script.
Do {
    Clear-Host
    
    #Import Variables
    $HT = Load-Variables
    
    If ($HT.TEST_DEPENDENCIES) {
        If (!(Test-PowerShell ($POWERSHELL_VERSION))) {
            Break;
        }
        If (!(Test-Framework ($FRAMEWORK_VERSION))) {
            Break;
        }
    }
    
    Launch-Server $HT.SERVER_LOCATION $HT.CRAFTBUKKIT $HT.JAVA_FLAGS $HT.CRAFTBUKKIT_OPTIONS
    
    If ($HT.TAKE_BACKUP) {
        Write-Backup $HT.BACKUP_LOCATION $HT.SERVER_NAME $HT.SERVER_LOCATION
        If ($HT.DELETE_LOG) {
            $log = Join-Path -path $HT.SERVER_LOCATION -childpath "server.log"
            If (Test-Path $log) {
                Remove-Item $log
            }
            Else {
                Write-Host ""
                Write-Host -foreground Red "Deleting server.log aborted.  File $log does not exists."
            }
        }
    }
} Until (Set-Quit ($HT.RESTART_PAUSE))

Write-Host "Press any key to exit"
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") > $NULL
