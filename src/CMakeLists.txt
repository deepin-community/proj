# first include proj library
# always need
include(lib_proj.cmake)

# configure executable build
option(BUILD_APPS
  "Build PROJ applications (default value for BUILD_CCT, BUILD_CS2CS, etc.)" ON)

option(BUILD_CCT
  "Build cct (coordinate conversion and transformation tool)" "${BUILD_APPS}")
option(BUILD_CS2CS
  "Build cs2cs (coordinate systems to coordinate systems translation tool)" "${BUILD_APPS}")
option(BUILD_GEOD
  "Build geod (computation of geodesic lines)" "${BUILD_APPS}")
option(BUILD_GIE
  "Build gie (geospatial integrity investigation environment)" "${BUILD_APPS}")
option(BUILD_PROJ
  "Build proj (cartographic projection tool)" "${BUILD_APPS}")
option(BUILD_PROJINFO
  "Build projinfo (SRS and coordinate operation metadata/query tool)" "${BUILD_APPS}")
option(BUILD_PROJSYNC
  "Build projsync (synchronize transformation support data)" "${BUILD_APPS}")

if(NOT MSVC)

  if(NOT APPLE)
    # Use relative path so that package is relocatable
    set(CMAKE_INSTALL_RPATH "\$ORIGIN/../${LIBDIR}")
  else()
    set(CMAKE_INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}/${LIBDIR}")
    # TO DO: cmake 2.8.12 introduces a way to make the install tree
    # relocatable with OSX via
    # (1) set(CMAKE_MACOSX_RPATH ON) and
    # (2) setting the INSTALL_RPATH property on the executables to
    # "@loader_path/../${LIBDIR}"
  endif()

else()

    # Linking to setargv.obj enables wildcard globbing for the
    # command line utilities, when compiling with MSVC
    # https://docs.microsoft.com/cpp/c-language/expanding-wildcard-arguments
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} setargv.obj")

endif()

if(BUILD_CCT)
  include(bin_cct.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} cct)
endif()

if(BUILD_CS2CS)
  include(bin_cs2cs.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} cs2cs)
endif()

if(BUILD_GEOD)
  include(bin_geod.cmake)
  if(BUILD_TESTING)
    include(bin_geodtest.cmake)
  endif()
  set(BIN_TARGETS ${BIN_TARGETS} geod)
endif()

if(BUILD_PROJ)
  include(bin_proj.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} binproj)
endif()

if(BUILD_PROJINFO)
  include(bin_projinfo.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} binprojinfo)
endif()

# Always build gie if testing is requested
if(BUILD_GIE OR BUILD_TESTING)
  include(bin_gie.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} gie)
endif()

if(BUILD_PROJSYNC)
  if(NOT ENABLE_CURL)
    message(SEND_ERROR "projsync requires Curl")
  endif()
  include(bin_projsync.cmake)
  set(BIN_TARGETS ${BIN_TARGETS} bin_projsync)
endif()


if(MSVC OR CMAKE_CONFIGURATION_TYPES)
  if(BIN_TARGETS)
    # Add _d suffix for your debug versions of the tools
    set_target_properties(${BIN_TARGETS} PROPERTIES
      DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})
  endif()
endif()
