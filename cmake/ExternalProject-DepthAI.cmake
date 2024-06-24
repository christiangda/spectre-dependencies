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
# Set the include and library paths
# Directories must be created before adding dependencies
# this is because in the configure step, these directories are used
file(MAKE_DIRECTORY ${DEPTHAI_PREFIX_DIR}/lib)
file(MAKE_DIRECTORY ${DEPTHAI_PREFIX_DIR}/include)

#  depthai::core
add_library(depthai::core STATIC IMPORTED GLOBAL)
set_target_properties(depthai::core PROPERTIES
      IMPORTED_LOCATION ${DEPTHAI_PREFIX_DIR}/lib/libdepthai-core.${DEPTHAI_LIBRARY_SUFFIX}
      INTERFACE_INCLUDE_DIRECTORIES ${DEPTHAI_PREFIX_DIR}/include
)

add_dependencies(depthai::core ${DEPENDENCY_NAME})

#  depthai::opencv
add_library(depthai::opencv STATIC IMPORTED GLOBAL)
set_target_properties(depthai::opencv PROPERTIES
      IMPORTED_LOCATION ${DEPTHAI_PREFIX_DIR}/lib/libdepthai-opencv.${DEPTHAI_LIBRARY_SUFFIX}
      INTERFACE_INCLUDE_DIRECTORIES ${DEPTHAI_PREFIX_DIR}/include
)

add_dependencies(depthai::opencv ${DEPENDENCY_NAME})

# depthai::resources
add_library(depthai::resources STATIC IMPORTED GLOBAL)
set_target_properties(depthai::resources PROPERTIES
      IMPORTED_LOCATION ${DEPTHAI_PREFIX_DIR}/lib/libdepthai-resources.${DEPTHAI_LIBRARY_SUFFIX}
      INTERFACE_INCLUDE_DIRECTORIES ${DEPTHAI_PREFIX_DIR}/include
)

add_dependencies(depthai::resources ${DEPENDENCY_NAME})

set(DEPTHAI_INCLUDE_DIR ${DEPTHAI_PREFIX_DIR}/include)
set(DEPTHAI_LIB_DIR ${DEPTHAI_PREFIX_DIR}/lib)
set(DEPTHAI_DIR ${DEPTHAI_PREFIX_DIR}/lib/cmake/depthai)

message("Configuring External Dependency: ${DEPENDENCY_NAME} - DONE")
