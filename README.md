# spectre-dependencies

This is the project used to install the spectre project dependencies in the OS

## Installation

```bash
git clone
cd spectre-dependencies

# default SPECTRE_DEPENDENCIES_INSTALL_DIR=$HOME/spectre-dependencies
cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DSPECTRE_DEPENDENCIES_INSTALL_DIR=<path to install spectre dependencies>
cmake --build build --parallel <number of cores you want to use>
```
