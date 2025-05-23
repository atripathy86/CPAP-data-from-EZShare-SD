# EzShare ResMed
This script assists in using a WiFi enabled SD card by EzShare in your CPAP/BiPap device. This is coded for use with most ResMed devices from version 9 and up. Feel free to fork it for use with Philips Respironics and other devices.

The program runs on Python 3, and requires dependencies to be installed. Python versions 3.9 to 3.12 have been tested.

## Usage

### Python venv
```
cd CPAP-DATA*
python -m venv myenv
source myenv/bin/activate 
pip install -r requirements.txt
python ezshare_resmed.py --ssid ezshare --psk 88888888 --show_progress
#deactivate 
 ```

 ### Docker Build 
 - This is helpful to run manually (in a containerized environment)
 - Mounts $HOME/ezshare_resmed_data folder into container and uses host network 
 - This assumes that host is connected to ez-share SDCard and is available at 192.168.4.1 
 ```
 docker build -t ezshare-resmed . 
 docker run --rm --network host -v $HOME/ezshare_resmed_data:/ezshare_resmed_data ezshare-resmed 
 
 #To run manually/debug
 docker run --rm -it --network host -v $HOME/ezshare_resmed_data:/ezshare_resmed_data ezshare-resmed /bin/bash
 root@40a553229645:/app# python ezshare_resmed.py --url "http://192.168.4.1/dir?dir=A:" --path /ezshare_resmed_data --show_progress

 ```

 ### Docker compose Build/Run
 - This builds the container (similar to Docker Build option) except that it automates the deployment further. 
 - This sets up the container to start up and set itself a cron job to run the script daily at 12 PM noon
 - Entrypoint Command starts cron daemon in the foreground (crond -f) ensuring that the container remains running to execute scheduled tasks
 - This will connect to EZ SDcard at 192.168.4.1 everyday at 12 PM, fetch its contents into $HOME/ezshare_resmed_data
 ```
 docker-compose up -d --build
 docker-compose logs -f  
 ```
 - To debug/enter shell on the container: `docker-compose exec ezshare_resmed /bin/bash`
 - Container Log will only be populated at 12 PM everyday. This can be changed by editing cron.txt

### Options

| Argument | Description |
| --- | --- |
| `-h`, `--help` | show this help message and exit |
| `--path PATH` | set destination path, defaults to $HOME/Documents/CPAP_Data/SD_card |
| `--url URL` | set source URL, Defaults to http://192.168.4.1/dir?dir=A: |
| `--start_from START_FROM` | start from date in YYYYMMDD format, deaults to None; this will override day_count if set |
| `--day_count DAY_COUNT`, `-n DAY_COUNT` | number of days to sync, defaults to None; if both start_from and day_count are unset all files will be synced |
| `--show_progress` | show progress, defaults to True |
| `--verbose`, `-v` | verbose output, defaults to False |
| `--overwrite` | force overwriting existing files, defaults to False |
| `--keep_old` | do not overwrite even if newer version is available, defaults to False |
| `--ignore IGNORE` | case insensitive comma separated list (no spaces) of files to ignore, defaults to JOURNAL.JNL,ezshare.cfg,System Volume Information |
| `--ssid SSID` | set network SSID; WiFi connection will be attempted if set, defaults to ez Share |
| `--psk PSK` | set network pass phrase, defaults to 88888888 |
| `--retries RETRIES` | set number of retries for failed downloads, defaults to 5 |
| `--version` | show program's version number and exit |


### Example
    ezshare_resmed --ssid ezshare --psk 88888888 --show_progress

### Data Save Location
- Windows: `C:\Users\<USERNAME>\Documents\CPAP_Data`
- macOS: `/Users/<USERNAME>/Documents/CPAP_Data`
- Linux: `/home/<USERNAME>/Documents/CPAP_Data`

## Configuration
Configuration to set the default parameters is done with a `config.ini` file.

### Example `config.ini`
```
[ezshare_resmed]
path = ~/Documents/CPAP_Data/SD_card
url = http://192.168.4.1/dir?dir=A:
start_from = 20230924
day_count = 5
show_progress = True
verbose = False
overwrite = False
keep_old = False
ignore = JOURNAL.JNL,ezshare.cfg,System Volume Information
ssid = ez Share
psk = 88888888
retries = 5
```

### Configuration file locations
ezshare_resmed looks for config files in this order:
- `./ezshare_resmed.ini` - in the same directory as the script
- `./config.ini` - in the same directory as the script
- `~/.config/ezshare_resmed.ini`
- `~/.config/ezshare_resmed/ezshare_resmed.ini`
- `~/.config/ezshare_resmed/config.ini`


## Setup
1. [Install Python 3](#install-python-3)
2. Download repository
2. [Run installer script](#install-ezshare_resmed)

### Install ezshare_resmed
- [Install on Windows](#winndows-setup)
- [Install on macOS/Linux](#macoslinux-setup)

#### Winndows Setup
1. Open command window
2. Run: `cd CPAP-data-from-EZShare-SD`
3. Run: `install_ezshare.bat`
4. The program, ezshare_resmed, is installed in `%USERPROFILE%\.local\bin` which will be added to the user `%PATH%` if it was not already, in which case a new command window will need to be opened
5. Run: `ezshare_resmed`

#### macOS/Linux Setup
1. Open your **Terminal** application
2. Run: `cd CPAP-data-from-EZShare-SD`
3. Run: `./install_ezshare.sh`
4. The program, ezshare_resmed, is installed in `$HOME/.local/bin`, if it is not already in the `$PATH` run:
  - **bash**: `echo 'export PATH="\$HOME/.local/bin:\$PATH"' >> ~/.bashrc && source ~/.bashrc`
  - **zsh**: `echo 'export PATH="\$HOME/.local/bin:\$PATH"' >> ~/.zshrc && source ~/.zshrc`
5. Run: `ezshare_resmed`


### Install Python 3
A Quick Guide for Installing Python 3 on Common Operating Systems

- [Install on Windows](#windows)
- [Install on macOS](#macos)
- [Install on Linux](#linux)

#### Windows
1. Open a command window, Run: `winget install -e --id Python.Python.3.12`

2. Once Python is installed, you should be able to open a command window, type `python`, hit ENTER, and see a Python prompt opened. Type `quit()` to exit it. You should also be able to run the command `pip` and see its options. If both of these work, then you are ready to go.
  - If you cannot run `python` or `pip` from a command prompt, you may need to add the Python installation directory path to the Windows PATH variable
    - The easiest way to do this is to find the new shortcut for Python in your start menu, right-click on the shortcut, and find the folder path for the `python.exe` file
      - For Python3, this will likely be something like `C:\Users\<USERNAME>\AppData\Local\Programs\Python\Python312`
    - Open your Advanced System Settings window, navigate to the "Advanced" tab, and click the "Environment Variables" button
    - Create a new system variable:
      - Variable name: `PYTHON_HOME`
      - Variable value: <your_python_installation_directory>
    - Now modify the PATH system variable by appending the text `;%PYTHON_HOME%\;%PYTHON_HOME%;%PYTHON_HOME%\Scripts\` to the end of it.
    - Close out your windows, open a command window and make sure you can run the commands `python` and `pip`

#### macOS
macOS comes with a native version of Python but it is not recommended to use the native Python in order to not alter the system environment. There are a couple of ways we can install Python3 but this script is only tested using Homebrew.

##### Install with Homebrew
[Homebrew](https://brew.sh/) is a MacOS Linux-like package manager. Walk through the below steps to install Homebrew and an updated Python interpreter along with it.

1. Open your **Terminal** application and run: `xcode-select --install`. This will open a window. Click **'Get Xcode'** and install it from the app store.
2. Install Homebrew. Run: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
   - You can also find this command on the [Homebrew website](https://brew.sh/)
3. Install latest Python3 with `brew install python`
4. Once Python is installed, you should be able to open your **Terminal** application, type `python3`, hit ENTER, and see a Python 3.X.X prompt opened. Type `quit()` to exit it. You should also be able to run the command `pip3` and see its options. If both of these work, then you are ready to go.
  - Here are some additional resources on [Installing Python 3 on Mac OS X](https://docs.python-guide.org/starting/install3/osx/)

#### Linux
- **Raspberry Pi OS** may need Python and PIP
  - Install them: `sudo apt install -y python3-pip`
- **Debian (Ubuntu)** distributions may need Python and PIP
  - Update the list of available APT repos with `sudo apt update`
  - Install Python and PIP: `sudo apt install -y python3-pip`
- **RHEL (CentOS)** distributions usually need PIP
  - Install the EPEL package: `sudo yum install -y epel-release`
  - Install PIP: `sudo yum install -y python3-pip`
- **Arch** may need Python and PIP
  - Refresh pacman database and update system: `sudo pacman -Syu`
  - Install PIP: `sudo pacman -S python python-pip`