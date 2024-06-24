include(ExternalProject)

set(DEPENDENCY_NAME "depthai")

message("Configuring External Dependency: ${DEPENDENCY_NAME}")

set(DEPTHAI_GIT_URL "https://github.com/luxonis/depthai-core.git")
set(DEPTHAI_GIT_TAG "v${SPECTRE_DEPTHAI_VERSION}")

set(DEPTHAI_PREFIX_DIR ${SPECTRE_INSTALL_DIR}/${DEPENDENCY_NAME})

ExternalProject_Add( ${DEPENDENCY_NAME}
  PREFIX         ${DEPTHAI_PREFIX_DIR}

  # This depend on OpenCV ExternalProject target
  DEPENDS       opencv

  GIT_REPOSITORY ${DEPTHAI_GIT_URL}
  GIT_TAG        ${DEPTHAI_GIT_TAG}
  GIT_PROGRESS   TRUE
  GIT_SHALLOW    TRUE

  USES_TERMINAL_DOWNLOAD TRUE

  TEST_COMMAND ""
  UPDATE_COMMAND ""
  PATCH_COMMAND ""

  CMAKE_ARGS
    -D CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -D CMAKE_INSTALL_PREFIX=${DEPTHAI_PREFIX_DIR}
    -D BUILD_SHARED_LIBS=OFF
    -D DEPTHAI_BUILD_TESTS=OFF
    -D DEPTHAI_BUILD_EXAMPLES=OFF
    -D OpenCV_DIR=${OpenCV_DIR}
)

message("Configuring External Dependency: ${DEPENDENCY_NAME} - DONE")
