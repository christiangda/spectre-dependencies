cmake_minimum_required(VERSION 3.25.1)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_C_COMPILER "/usr/bin/clang" CACHE INTERNAL "clang compiler" FORCE)
set(CMAKE_CXX_COMPILER "/usr/bin/clang++" CACHE INTERNAL "clang++ compiler" FORCE)

project(spectre-dependencies
      VERSION 0.0.1
      DESCRIPTION "This project is used to install the dependencies of the Spectre project"
      LANGUAGES C CXX
)

# set the default install directory for the dependencies
set(SPECTRE_DEPENDENCIES_INSTALL_DIR)
if (WIN32)
  # cmake is not detecting environment variables on windows
  # set(SPECTRE_DEPENDENCIES_INSTALL_DIR "$ENV{USERPROFILE}\\spectre-dependencies" CACHE STRING "The directory where the dependencies will be installed")
  set(SPECTRE_DEPENDENCIES_INSTALL_DIR "C:\\spectre-dependencies" CACHE STRING "The directory where the dependencies will be installed")
else()
  set(SPECTRE_DEPENDENCIES_INSTALL_DIR "$ENV{HOME}/spectre-dependencies" CACHE STRING "The directory where the dependencies will be installed")
endif()

message("The dependencies will be installed in: ${SPECTRE_DEPENDENCIES_INSTALL_DIR}")

# create directory if this does not exist
file(MAKE_DIRECTORY ${SPECTRE_DEPENDENCIES_INSTALL_DIR})

# set the version of the dependencies
set(SPECTRE_BOOST_VERSION 1.85.0 CACHE STRING "The version of the boost library to install")
set(SPECTRE_OPENSSL_VERSION 3.3.1 CACHE STRING "The version of the openssl library to install")
set(SPECTRE_OPENCV_VERSION 4.9.0 CACHE STRING "The version of the opencv library to install")
set(SPECTRE_DEPTHAI_VERSION 2.26.0 CACHE STRING "The version of the depthai library to install")
set(SPECTRE_ASYNC_MQTT5_VERSION master CACHE STRING "The version of the async-mqtt5 library to install")

# include the cmake file to install the dependencies
include(cmake/ExternalProject-boost.cmake)
include(cmake/ExternalProject-openssl.cmake)
include(cmake/ExternalProject-opencv.cmake)
include(cmake/ExternalProject-depthai.cmake)
include(cmake/ExternalProject-async-mqtt5.cmake)

# set the search path for the dependencies
set(CMAKE_PREFIX_PATH ${SPECTRE_DEPENDENCIES_INSTALL_DIR})

# set the environment variables for the dependencies
# these are filled by the cmake files that install the dependencies
set(SPECTRE_DEPENDENCY_BOOST_INSTALL_DIR)
set(SPECTRE_DEPENDENCY_DEPTHAI_INSTALL_DIR)
set(SPECTRE_DEPENDENCY_OPENSSL_INSTALL_DIR)
set(SPECTRE_DEPENDENCY_OPENCV_INSTALL_DIR)
set(SPECTRE_DEPENDENCY_ASYNC_MQTT5_INSTALL_DIR)
