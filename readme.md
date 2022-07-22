# This set of batch files is meant to help with creating mods for Rebel Galaxy Outlaw


## Requirements
The [rgo-lua-utils](https://github.com/sp00n/rgo-lua-utils) are required for these batch files to work, including all of their dependencies.  
Obviously you should also have Rebel Galaxy Outlaw installed.  
And since these files are batch files, they're intended to be used from the command line (terminal window), so you should be somewhat familiar with it.  


## Installation
The batch files should be placed somewhere where they can be globally reached, which is a directory that was added to you `PATH` variable.  
Theoretically they could also be placed directly inside the directory you want to use them, but then you'd have to copy them again for every mod you make.  
You will also need to set the path to these utils, and to the Rebel Galaxy Outlaw game installation, in the `rgo-variables.bat` file.  
The `UTILS_DIR` variable defines the path to the location of the rgo-lua-utils.  
The `GAME_DIR` variable defines the path to the installation of Rebel Galaxy Outlaw.  
_**Do not use any quotes or a trailing backslash for these path variables!**_  


## How to Extract and Convert all DATA.PAK files
To extract and convert all files, navigate to your game's PAKS folder and run  
`rgo-convert-all <optional_target_directory>`  
This will extract all of your `DATAX.PAK` files into the provided directory, and if non was give, into the `DATA` folder inside the `PAKS` directory of your game installation.  
After that, it will run the conversion process, creating a `.lua` representation of every `.DAT`, `.WDAT`. `.IMAGESET`, and `.LAYOUT` file inside the extracted directory.  


## How to Create a new Mod File
I'm not going into the process for actually creating a new mod, but only how to create the mod file for it.  

To make a new mod file, create a new directory with the name that your mod file should be (e.g. _"x99_New_Missile_Launcher_by_me"_), and then create a `LUA` folder inside of it.  
In this LUA directory, you'll need to copy every LUA (or image) file you wish to include in your mod, **exactly mirroring** the directory structure of the original files.  

So for example, you'd need a _`LUA\MEDIA\COMPONENTS\32_SECONDARIES_NEW_MISSILE.WDAT.lua`_ and a _`LUA\MEDIA\WEAPONS\MISSILES\15_PLAYER_NEW_MISSILE.DAT.lua`_, etc., in exactly these directories.  
After you have all the files you need, you can run `rgo-pack <optional_version_string>` to create a .PAK file from the files inside the LUA directory, which will be postfixed with a version string if you wish so.  

For example: `rgo-pack 1.0.0` run inside the _x99_New_Missile_Launcher_by_me_ directory will create a `x99_New_Missile_Launcher_by_me.v.1.0.0.pak` file.  
If you omit the optional version string, it will just create a `x99_New_Missile_Launcher_by_me.pak` file.  

`rgo-deploy <optional_version_string>` is very similar, it will create the pak mod file, but will also automatically move the file to you game's PAKS folder, so that you can immediately test the mod.  



## Description of files
> `rgo-convert-all.bat <optional_output_directory>`  
> This file unpacks all of your `DATAX.PAK` files in your game's PAKS directory into the specified output directory.  
> If no output directory was provided, it will unpack the files into the `DATA` folder within your PAKS directory.  
> Additionally, after unpacking, it will also convert all the `.DAT`, `.WDAT`. `.IMAGESET`, and `.LAYOUT` files to human-readable `.LUA` files.

> `rgo-pack.bat <optional_version_string>`  
> This will create a .pak mod file with the same name as the directory the file was run in, using the files in the `LUA` directory as the content for the mod.

> `rgo-deploy.bat <optional_version_string>`  
> This will create a .pak mod file and will move it to your game's PAKS directory.

> `rgo-variables.bat`  
> This is not an "actual" batch file, instead it holds the variables that are needed for the other batch files to work.  
> You need to adjust the `UTILS_DIR` and `GAME_DIR` parameters inside this file for the other files to work.

> `NirCmd.chm`
> Help file for the NirCmd tool.

> `nircmd.exe`
> The NirCmd tool, used to modify the date of the created .pak file (see below).  
> 
> 

### Note
This repository includes the excellent `NirCmd` by [NirSoft](https://www.nirsoft.net/utils/nircmd.html).  
From the tool's description:  
> _NirCmd is a small command-line utility that allows you to do some useful tasks without displaying any user interface. By running NirCmd with simple command-line option, you can write and delete values and keys in the Registry, write values into INI file, dial to your internet account or connect to a VPN network, restart windows or shut down the computer, create shortcut to a file, change the created/modified date of a file, change your display settings, turn off your monitor, open the door of your CD-ROM drive, and more..._  

In our case, it's used to modifiy the creation and modification date of the generated .pak file, because the game will ignore the content of any additional .pak file if the date of the additional file is earlier than those of the original .PAK files.  
Therefore date is set to the year 2099 for the newly created .pak files, which should hopefully prevent any issues.  

See the tool's page for a full description of what it can do (it's a lot!).