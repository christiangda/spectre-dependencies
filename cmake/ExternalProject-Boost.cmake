include(ExternalProject)

set(DEPENDENCY_NAME "boost")

message("Configuring External Dependency: ${DEPENDENCY_NAME}")

set(BOOST_GIT_URL "https://github.com/boostorg/boost.git")
set(BOOST_GIT_TAG "boost-${SPECTRE_BOOST_VERSION}")

# set(BOOST_INCLUDE_LIBRARIES
#     asio
#     beast
#     core
#     system
#     program_options
#     filesystem
#     log
#     atomic
#     headers
#     regex
# )
string(TOLOWER ${CMAKE_BUILD_TYPE} BOOST_BUILD_TYPE)

# boost options
set(BOOST_PREFIX_DIR ${SPECTRE_INSTALL_DIR}/${DEPENDENCY_NAME})
set(Boost_USE_STATIC_LIBS    ON)
set(Boost_USE_MULTITHREADED  ON)
set(Boost_USE_STATIC_RUNTIME ON)

set(BOOST_CONFIGURE_COMMAND)
set(BOOST_BUILD_COMMAND)
if (WIN32)
    set(BOOST_CONFIGURE_COMMAND "${BOOST_PREFIX_DIR}\\src\\${DEPENDENCY_NAME}\\bootstrap.bat")
    set(BOOST_BUILD_COMMAND "${BOOST_PREFIX_DIR}\\src\\${DEPENDENCY_NAME}\\b2.exe")
else()
    set(BOOST_CONFIGURE_COMMAND "${BOOST_PREFIX_DIR}/src/${DEPENDENCY_NAME}/bootstrap.sh")
    set(BOOST_BUILD_COMMAND "${BOOST_PREFIX_DIR}/src/${DEPENDENCY_NAME}/b2")
endif()

# Convert list to string comma separated
# list(JOIN BOOST_INCLUDE_LIBRARIES "," BOOST_INCLUDE_LIBRARIES_STRING_LIST)

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
      # --with-libraries=${BOOST_INCLUDE_LIBRARIES_STRING_LIST}

  BUILD_COMMAND
    ${BOOST_BUILD_COMMAND}
      --prefix=${BOOST_PREFIX_DIR}
      --build-type=complete
      --layout=tagged
      variant=${BOOST_BUILD_TYPE}
      link=static
      runtime-link=static
    stage

  INSTALL_COMMAND
    ${BOOST_BUILD_COMMAND}
      --prefix=${BOOST_PREFIX_DIR}
      --build-type=complete
      --layout=tagged
      variant=${BOOST_BUILD_TYPE}
      link=static
      runtime-link=static
    install
)

message("Configuring External Dependency: ${DEPENDENCY_NAME} - DONE")
