How to Install
--------------
###One time only
Start Powershell as administrator  
Run: 
    
    Set-ExecutionPolicy unrestricted
    
Hit "Y" when prompted.  

* PowerShell by default expects signed scripts only.  Setting this to unrestricted allows unsigned scripts to run.
* While I would love to publicly sign this script, a 2 year certificate comes at a $550 cost (at least).  

Once the above is done, you never need to do it again for that system.

If you do NOT want to change your execution policy globally, you can run the script using:

    powershell.exe -ExecutionPolicy Bypass -File Launch.ps1

<dl>
  <dt>If using GitHub Download</dt>
  <dd>Unzip to a folder of your choice.</dd>
  <dd>Run launch.ps1 to generate config files.</dd>
  <dd>Stop the server.  Upon relaunch of the server, the new values will be picked up.</dd>
  <dd></dd>
  <dt>If copying and pasting the launch.ps1 from GitHub</dt>
  <dd>Run launch.ps1 to generate config files.</dd>
  <dd>Ensure config.txt has the values desired.  Edit it and save.</dd>
  <dd>Stop the server.  Upon relaunch of the server or script, the new values will be picked up.</dd>
</dl>

  [1]: https://github.com/TnTBass/PowerLaunch/releases/download/v1.0/PowerLaunch.zip        "PowerLaunch v1"

Configuration File (defaults)
------------------
    SERVER_NAME=MyServer  
    SERVER_LOCATION=  
    BACKUP_LOCATION=  
    CRAFTBUKKIT=craftbukkit.jar  
    JAVA_FLAGS=-Xmx1G  
    CRAFTBUKKIT_OPTIONS=-o true -p 25565  
    TEST_DEPENDENCIES=true  
    DELETE_LOG=true  
    TAKE_BACKUP=True  
    RESTART_PAUSE=5  

Configuration File (explanation)
--------------------------------
The name of the server.  Used in Backups.  Can be empty. 
 
    SERVER_NAME
    
The folder for the server.  This can be set to enable the launch.ps1 to be located anywhere on the system.  Cannot be empty.  

    SERVER_LOCATION
    
The folder where backups are placed.  Can be empty if TAKE_BACKUP is set to false.  

    BACKUP_LOCATION
    
The server jar file.  If you name your server cb.jar, modify this to reflect the same name.  Cannot be empty.  

    CRAFTBUKKIT

Set the min/max/initial heap size here. This can also be used to set other java flags (such as garbage collection).  

    JAVA_FLAGS

Set the command line options to use to launch the server.  Can be empty.  

    CRAFTBUKKIT_OPTIONS
    
Checks to ensure .NET 4.5 and PowerShell 3 are installed.  If not, it will provide download links.  

    TEST_DEPENDENCIES

Allows the script to delete the server.log file if backup is enabled.  

    DELETE_LOG

Enables the script to take a backup of the server upon shutting down the server.  

    TAKE_BACKUP

How long to wait before automatically relaunching the server when stopped.  

    RESTART_PAUSE
