include(ExternalProject)
include(ProcessorCount)

# Get the number of cores
ProcessorCount(NCores)

set(DEPENDENCY_NAME "openssl")

message(STATUS "Configuring External Dependency: ${DEPENDENCY_NAME}")
message(STATUS "Build will use ${NCores} cores")

set(OPENSSL_GIT_URL "https://github.com/openssl/openssl.git")
set(OPENSSL_GIT_TAG "openssl-${SPECTRE_OPENSSL_VERSION}")

set(OPENSSL_PREFIX_DIR ${SPECTRE_DEPENDENCIES_INSTALL_DIR}/${DEPENDENCY_NAME})

set(OPENSSL_CONFIGURE_COMMAND)
if (WIN32)
  set(OPENSSL_CONFIGURE_COMMAND "${OPENSSL_PREFIX_DIR}\\src\\${DEPENDENCY_NAME}\\Configure")
else()
  set(OPENSSL_CONFIGURE_COMMAND "${OPENSSL_PREFIX_DIR}/src/${DEPENDENCY_NAME}/Configure")
endif()

ExternalProject_Add( ${DEPENDENCY_NAME}
  PREFIX         ${OPENSSL_PREFIX_DIR}

  GIT_REPOSITORY ${OPENSSL_GIT_URL}
  GIT_TAG        ${OPENSSL_GIT_TAG}
  GIT_PROGRESS   TRUE
  GIT_SHALLOW    TRUE

  USES_TERMINAL_DOWNLOAD TRUE

  TEST_COMMAND ""
  UPDATE_COMMAND ""
  PATCH_COMMAND ""

  CONFIGURE_COMMAND
    ${OPENSSL_CONFIGURE_COMMAND}
      --prefix=${OPENSSL_PREFIX_DIR}
      --openssldir=${OPENSSL_PREFIX_DIR}
      no-shared
      no-weak-ssl-ciphers

  BUILD_COMMAND
    make -j${NCores}

  INSTALL_COMMAND
    make install_sw

  INSTALL_DIR ${OPENSSL_PREFIX_DIR}
)

set(SPECTRE_DEPENDENCY_OPENSSL_INSTALL_DIR ${OPENSSL_PREFIX_DIR} CACHE INTERNAL "Path to installed OpenSSL")

message(STATUS "Configuring External Dependency: ${DEPENDENCY_NAME} - DONE")
