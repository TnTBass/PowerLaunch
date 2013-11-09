How to Install
--------------
One time only
Start Powershell as administrator
Run: "Set-ExecutionPolicy unrestricted" and hit "Y" when prompted.
* PowerShell by default expects signed scripts only.  Setting this to unrestricted allows unsigned scripts to run.
* While I would love to publicly sign this script, a 2 year certificate comes at a $550 cost (at least).  

Once the above is done, you never need to do it again for that system.

<dl>
  <dt>If using GitHub release</dt>
  <dd>Unzip to a folder of your choice.</dd>
  <dd>Run launch.ps1 to generate config files.</dd>
  <dd>Stop the server.  Upon relaunch of the server, the new values will be picked up.</dd>
  <dd></dd>
  <dt>If copying and pasting the launch.ps1 from GitHub</dt>
  <dd>Run launch.ps1 to generate config files.</dd>
  <dd>Ensure config.txt has the values desired.  Edit it and save.</dd>
  <dd>Stop the server.  Upon relaunch of the server or script, the new values will be picked up.</dd>
</dl>

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
SERVER_LOCATION - The folder for the server.  This can be set to enable the launch.ps1 to be located anywhere on the system.  Cannot be empty.  
BACKUP_LOCATION - The folder where backups are placed.  Can be empty if TAKE_BACKUP is set to false.  
CRAFTBUKKIT - The server jar file.  If you name your server cb.jar, modify this to reflect the same name.  Cannot be empty.  
JAVA_FLAGS - Set the min/max/initial heap size here. This can also be used to set other java flags (such as garbage collection).  
CRAFTBUKKIT_OPTIONS - Set the command line options to use to launch the server.  Can be empty.  
TEST_DEPENDENCIES - Checks to ensure .NET 4.5 and PowerShell 3 are installed.  If not, it will provide download links.  
DELETE_LOG - Allows the script to delete the server.log file if backup is enabled.  
TAKE_BACKUP - Enables the script to take a backup of the server upon shutting down the server.  
RESTART_PAUSE - How long to wait before automatically relaunching the server when stopped.  