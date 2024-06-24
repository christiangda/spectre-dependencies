include(ExternalProject)

set(DEPENDENCY_NAME "OpenCV")

message("Configuring External Dependency: ${DEPENDENCY_NAME}")

set(OPENCV_GIT_URL "https://github.com/opencv/opencv.git")
set(OPENCV_GIT_TAG "${SPECTRE_OPENCV_VERSION}")

# set(OPENCV_INCLUDE_LIBRARIES
#   opencv_calib3d
#   opencv_core
#   opencv_dnn
#   opencv_features2d
#   opencv_flann
#   opencv_gapi
#   opencv_highgui
#   opencv_imgcodecs
#   opencv_imgproc
#   opencv_ml
#   opencv_objdetect
#   opencv_photo
#   opencv_shape
#   opencv_stitching
#   opencv_video
#   opencv_videoio
#   opencv_videostab
# )

# set(OPENCV_INCLUDE_LIBRARIES_3RDPARTY
#   ade
#   ittnotify
#   libjpeg-turbo
#   libopenjp2
#   libpng
#   libprotobuf
#   libtiff
#   libwebp
#   tegra_hal
#   zlib
# )

# set(CUSTOM_CMAKE_ARGS)
# foreach(LIBRARY ${OPENCV_INCLUDE_LIBRARIES})
#   list(APPEND CUSTOM_CMAKE_ARGS -D BUILD_${LIBRARY}=ON)
# endforeach()

set(OPENCV_PREFIX_DIR ${SPECTRE_INSTALL_DIR}/${DEPENDENCY_NAME})

ExternalProject_Add( ${DEPENDENCY_NAME}
  PREFIX         ${OPENCV_PREFIX_DIR}

  GIT_REPOSITORY ${OPENCV_GIT_URL}
  GIT_TAG        ${OPENCV_GIT_TAG}
  GIT_PROGRESS   TRUE
  GIT_SHALLOW    TRUE

  USES_TERMINAL_DOWNLOAD TRUE

  TEST_COMMAND ""
  UPDATE_COMMAND ""
  PATCH_COMMAND ""

  CMAKE_ARGS
    -D CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -D CMAKE_INSTALL_PREFIX=${OPENCV_PREFIX_DIR}
    -D BUILD_SHARED_LIBS=OFF
    -D BUILD_DOCS=OFF
    -D BUILD_TESTS=OFF
    -D BUILD_PERF_TESTS=OFF
    -D BUILD_EXAMPLES=OFF
    -D BUILD_JAVA=OFF
    -D OPENCV_FORCE_3RDPARTY_BUILD=ON
    -D OPENCV_IPP_ENABLE_ALL=ON
    -D WITH_CAROTENE=ON
    -D WITH_KLEIDICV=ON
    -D WITH_CPUFEATURES=ON
    -D WITH_EIGEN=OFF
    -D WITH_OPENVX=ON
    -D WITH_DIRECTX=ON
    -D WITH_VA=ON
    -D WITH_LAPACK=ON
    -D WITH_QUIRC=ON
    -D BUILD_ZLIB=ON
    -D BUILD_ITT=ON
    -D WITH_IPP=ON
    -D BUILD_IPP_IW=ON
    # -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules
    # ${CUSTOM_CMAKE_ARGS}
)

file(MAKE_DIRECTORY ${OPENCV_PREFIX_DIR}/include/opencv4)
file(MAKE_DIRECTORY ${OPENCV_PREFIX_DIR}/lib)
file(MAKE_DIRECTORY ${OPENCV_PREFIX_DIR}/lib/opencv4/3rdparty)

set(PACKAGE_VERSION ${OPENCV_GIT_TAG})

# include all headers
set(__OpenCV_INCLUDE_DIRS "${OPENCV_PREFIX_DIR}/include/opencv4")

set(OpenCV_INCLUDE_DIRS "")
foreach(d ${__OpenCV_INCLUDE_DIRS})
  get_filename_component(__d "${d}" REALPATH)
  if(NOT EXISTS "${__d}")
    message(WARNING "OpenCV: Include directory doesn't exist: '${d}'. OpenCV installation may be broken. Skip...")
  else()
    message(STATUS "OpenCV: Include directory: '${__d}'")
    list(APPEND OpenCV_INCLUDE_DIRS "${__d}")
  endif()
endforeach()
unset(__d)


# Add dependencies
foreach(LIBRARY ${OPENCV_INCLUDE_LIBRARIES})
  add_library(${LIBRARY} STATIC IMPORTED GLOBAL)

  set_target_properties(${LIBRARY} PROPERTIES
        IMPORTED_LOCATION
          ${OPENCV_PREFIX_DIR}/lib/lib${LIBRARY}.${OPENCV_LIBRARY_SUFFIX}
        INTERFACE_INCLUDE_DIRECTORIES "${OpenCV_INCLUDE_DIRS}"
  )
  message("Adding library: ${LIBRARY}")

  add_dependencies( ${DEPENDENCY_NAME} ${LIBRARY} )
endforeach()
unset(LIBRARY)

# Add 3rdparty dependencies
foreach(LIBRARY ${OPENCV_INCLUDE_LIBRARIES_3RDPARTY})
  add_library(${LIBRARY} STATIC IMPORTED GLOBAL)

  set_target_properties(${LIBRARY} PROPERTIES
        IMPORTED_LOCATION
          ${OPENCV_PREFIX_DIR}/lib/opencv4/3rdparty/lib${LIBRARY}.${OPENCV_LIBRARY_SUFFIX}
        INTERFACE_INCLUDE_DIRECTORIES "${OpenCV_INCLUDE_DIRS}"
  )
  message("Adding 3rdparty library: ${OPENCV_PREFIX_DIR}/lib/opencv4/3rdparty/lib${LIBRARY}.${OPENCV_LIBRARY_SUFFIX}")

  add_dependencies( ${DEPENDENCY_NAME} ${LIBRARY} )
endforeach()
unset(LIBRARY)

set(OPENCV_INCLUDE_DIRS ${OPENCV_PREFIX_DIR}/include/opencv4)
set(OpenCV_DIR ${OPENCV_PREFIX_DIR}/lib/cmake/opencv4)

message("Configuring External Dependency: ${DEPENDENCY_NAME} - DONE")
