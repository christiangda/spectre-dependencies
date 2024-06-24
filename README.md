# spectre-dependencies

This is the project used to build and install the dependencies for the Spectre project.

The dependencies are:

- Boost 1.85.0
- OpenSSL 3.3.1
- OpenCV 4.9.0
- depthai-core 2.26.0

NOTE: This project is designed to be compiled on Linux, MacOS and Windows using clang and cmake.

## Build and install the dependencies

### Linux

Update the system

```bash
sudo apt update -y && sudo apt upgrade -y
sudo apt full-upgrade -y
sudo reboot
```

Configure clang and cmake on Raspberry Pi

```bash
sudo apt-get install build-essential -y
sudo apt install -y git curl wget

sudo apt-get install cmake
sudo apt-get install clang-15 llvm-15
sudo apt install -y clang-format
sudo apt install -y clang-tidy
sudo apt autoremove -y

# set clang-15 as default
sudo ./ubuntu-clang.sh 15 10
sudo update-alternatives --config c++
sudo update-alternatives --config cc
```

```bash
git clone
cd spectre-dependencies

# default SPECTRE_DEPENDENCIES_INSTALL_DIR=$HOME/spectre-dependencies
rm -rf buid
cmake -S . -B build -D CMAKE_BUILD_TYPE=Release -D SPECTRE_DEPENDENCIES_INSTALL_DIR=<path to install spectre dependencies>
cmake --build build --parallel <number of cores you want to use>
```

### Windows

```powershell
.\bootstrap.bat --prefix=C:\spectre-dependencies\boost
.\b2.exe --prefix=C:\spectre-dependencies\boost --layout=system variant=release link=static stage
.\b2.exe --prefix=C:\spectre-dependencies\boost --layout=system variant=release link=static install
```

### MacOS

```bash
brew install cmake
brew install llvm
brew install clang-format
brew install clang-tidy
```
