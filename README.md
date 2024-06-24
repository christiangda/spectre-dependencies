# spectre-dependencies

This is the project used to install the spectre project dependencies in the OS

## Installation

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
sudo update-alternatives --config c++
sudo apt autoremove -y


sudo update-alternatives \
  --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 \
  --slave /usr/bin/clang clang /usr/bin/clang-15

```

```bash
git clone
cd spectre-dependencies

# on raspbian only
# export CC=/usr/bin/clang
# export CXX=/usr/bin/clang++

# default SPECTRE_DEPENDENCIES_INSTALL_DIR=$HOME/spectre-dependencies
rm -rf buid
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DSPECTRE_DEPENDENCIES_INSTALL_DIR=<path to install spectre dependencies>
cmake --build build --parallel <number of cores you want to use>
```

### Build and install the dependencies

Windows

```powershell
.\bootstrap.bat --prefix=C:\spectre-dependencies\boost
.\b2.exe --prefix=C:\spectre-dependencies\boost --layout=system variant=release link=static stage
.\b2.exe --prefix=C:\spectre-dependencies\boost --layout=system variant=release link=static install
```
