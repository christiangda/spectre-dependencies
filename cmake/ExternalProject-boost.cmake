include(ExternalProject)

set(DEPENDENCY_NAME "boost")

message("Configuring External Dependency: ${DEPENDENCY_NAME}")

set(BOOST_GIT_URL "https://github.com/boostorg/boost.git")
set(BOOST_GIT_TAG "boost-${SPECTRE_BOOST_VERSION}")

string(TOLOWER ${CMAKE_BUILD_TYPE} BOOST_BUILD_TYPE)

# boost options
set(BOOST_PREFIX_DIR ${SPECTRE_DEPENDENCIES_INSTALL_DIR}/${DEPENDENCY_NAME})
set(Boost_USE_STATIC_LIBS    OFF)
set(Boost_USE_MULTITHREADED  OFF)
set(Boost_USE_STATIC_RUNTIME OFF)

set(BOOST_CONFIGURE_COMMAND)
set(BOOST_BUILD_COMMAND)
if (WIN32)
    set(BOOST_CONFIGURE_COMMAND "${BOOST_PREFIX_DIR}\\src\\${DEPENDENCY_NAME}\\bootstrap.bat")
    set(BOOST_BUILD_COMMAND "${BOOST_PREFIX_DIR}\\src\\${DEPENDENCY_NAME}\\b2.exe")
else()
    set(BOOST_CONFIGURE_COMMAND "${BOOST_PREFIX_DIR}/src/${DEPENDENCY_NAME}/bootstrap.sh")
    set(BOOST_BUILD_COMMAND "${BOOST_PREFIX_DIR}/src/${DEPENDENCY_NAME}/b2")
endif()

ExternalProject_Add( ${DEPENDENCY_NAME}
  PREFIX          ${BOOST_PREFIX_DIR}

  BUILD_IN_SOURCE TRUE # we need to build in source because of the bootstrap.sh script

  GIT_REPOSITORY ${BOOST_GIT_URL}
  GIT_TAG        ${BOOST_GIT_TAG}
  GIT_PROGRESS   TRUE
  GIT_SHALLOW    TRUE

  USES_TERMINAL_DOWNLOAD TRUE

  TEST_COMMAND ""
  UPDATE_COMMAND ""
  PATCH_COMMAND ""

  CONFIGURE_COMMAND
    ${BOOST_CONFIGURE_COMMAND}
      --prefix=${BOOST_PREFIX_DIR}

  BUILD_COMMAND
    ${BOOST_BUILD_COMMAND}
      --prefix=${BOOST_PREFIX_DIR}
      --build-type=complete
      --layout=tagged
      variant=${BOOST_BUILD_TYPE}
    stage

  INSTALL_COMMAND
    ${BOOST_BUILD_COMMAND}
      --prefix=${BOOST_PREFIX_DIR}
      --build-type=complete
      --layout=tagged
      variant=${BOOST_BUILD_TYPE}
    install
)

set(SPECTRE_DEPENDENCY_BOOST_INSTALL_DIR ${BOOST_PREFIX_DIR} CACHE INTERNAL "Path to Boost install directory")

message("Configuring External Dependency: ${DEPENDENCY_NAME} - DONE")