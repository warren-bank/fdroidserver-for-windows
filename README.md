### [_fdroidserver_ for Windows](https://github.com/warren-bank/fdroidserver-for-windows)

Early attempt at a solution for [_fdroidserver_ issue 1112](https://gitlab.com/fdroid/fdroidserver/-/issues/1112):
* Port _fdroidserver_ to Windows

#### Scope

Only the following _fdroidserver_ functionality is tested and confirmed to work:

* `fdroid init`
* `fdroid update -c`
* `fdroid update`

All other _fdroidserver_ functionality is untested.<br>Feedback is welcome.

- - - -

#### Test Environment

* Windows 7 Ultimate 64-bit, SP1

#### External Dependencies

* `java`
  - [jdkPortable w/ Java JDK version 8 update 381](https://portableapps.com/apps/utilities/jdkportable)
    * install to any directory
      - ex: `C:\PortableApps\Java_JDK\8u381`
    * update __JAVA_HOME__ directory path in the scripts:
      - `scripts/bash/virtualenv-env.sh`
      - `scripts/cmd/virtualenv-env.bat`
* `git`
  - [PortableGit 2.16.2](https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/PortableGit-2.16.2-64-bit.7z.exe)
    * extract to any directory
      - ex: `C:\PortableApps\PortableGit\2.16.2`
* `python`
  - [WinPythonZero 3.7.1.0](https://sourceforge.net/projects/winpython/files/WinPython_3.7/3.7.1.0/WinPython64-3.7.1.0Zero.exe/download)
    * [list of packages](https://github.com/winpython/winpython/blob/master/changelogs/WinPythonZero-64bit-3.7.1.0.md)
    * install additional global packages:
      ```bash
        pip install virtualenv
      ```
    * start `bash` terminal:
      ```bash
        set winpython_home=C:\PortableApps\WinPythonZero\3.7.1.0
        set portablegit_home=C:\PortableApps\PortableGit\2.16.2

        call "%winpython_home%\scripts\env.bat"

        start "bash" "%portablegit_home%\git-bash.exe"
      ```
    * start `cmd` terminal:
      ```bash
        set winpython_home=C:\PortableApps\WinPythonZero\3.7.1.0
        set portablegit_home=C:\PortableApps\PortableGit\2.16.2

        call "%winpython_home%\scripts\env.bat"

        start "cmd" "%portablegit_home%\git-cmd.exe"
      ```

#### Install _fdroidserver_ (bash)

* start `bash` terminal
* run:
  ```bash
    fdsdir='/c/path/to/fdroidserver-for-windows'

    source "${fdsdir}/scripts/bash/install-fdroidserver-without-build-server.sh"

    # creates and writes into the directory: "${fdsdir}/virtualenv"
  ```

#### Install _fdroidserver_ (download)

* download the `virtualenv.7z` file from [releases](https://github.com/warren-bank/fdroidserver-for-windows/releases) to any directory
* use [7-Zip](https://portableapps.com/apps/utilities/7-zip_portable) to uncompress the `virtualenv.7z` file into the root directory of this repo
  - ex: extract the `virtualenv` directory into:<br>`C:\path\to\fdroidserver-for-windows`

#### Use _fdroidserver_ (bash)

* start `bash` terminal
* run:
  ```bash
    fdsdir='/c/path/to/fdroidserver-for-windows'
    fdrepo='/c/path/to/my-fdroid-repo'

    source "${fdsdir}/scripts/bash/virtualenv-activate.sh"

    cd "$fdrepo"
    fdroid init

    # edit file: "config.yml"
    # add files: "repo/APPID_VERSION.apk"
    fdroid update -c

    # edit files: "metadata/APPID.yml"
    fdroid update

    source "${fdsdir}/scripts/bash/virtualenv-deactivate.sh"
  ```

#### Use _fdroidserver_ (cmd)

* start `cmd` terminal
* run:
  ```bash
    set fdsdir=C:\path\to\fdroidserver-for-windows
    set fdrepo=C:\path\to\my-fdroid-repo

    call "%fdsdir%\scripts\cmd\virtualenv-activate.bat"

    cd /D "%fdrepo%"
    fdroid init

    rem :: edit file: "config.yml"
    rem :: add files: "repo/APPID_VERSION.apk"
    fdroid update -c

    rem :: edit files: "metadata/APPID.yml"
    fdroid update

    call "%fdsdir%\scripts\cmd\virtualenv-deactivate.bat"
  ```

- - - -

#### Legal:

* copyright: [Warren Bank](https://github.com/warren-bank)
* license: [GPL-2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)
