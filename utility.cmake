set(UTILITY_DIR ${CMAKE_CURRENT_LIST_DIR})
include(CMakeParseArguments)
# Usage: add_unit(target_name [SRC <file.cpp>] [DEFS <defs>][FTRS <ftrs>][LIBS <libs>])
# If SRC is not specified  ${target_name}.cc is used.
# DEFS are the extra definitions needed to compile the target.
# LIBS are the extra libs needed to compile the target.
function(add_unit name)
  # cmake_parse_arguments(<prefix> <options> <one_value_keywords> <multi_value_keywords> args...)
  cmake_parse_arguments("arg" "" "" "SRC;DEFS;FTRS;LIBS" ${ARGN})

  if(DEFINED arg_SRC)
    set(source ${arg_SRC})
  else()
    set(source ${name}.cc)
  endif()

  add_executable(${name} ${source})
  # target_include_directories(${name} PUBLIC
  #   $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/test/include>)

  if(DEFINED arg_DEFS)
    target_compile_definitions(${name} PRIVATE ${arg_DEFS})
  endif()

  if(DEFINED arg_FTRS)
    target_compile_features(${name} PRIVATE ${arg_FTRS})
  endif()

  if(DEFINED arg_LIBS)
    target_link_libraries(${name} PRIVATE ${arg_LIBS})
  endif()
endfunction()

function(add_symlink name src dest)
  add_custom_target(${name} ALL
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${src} ${dest}
    COMMENT "mklink ${src} -> ${dest}"
    )
endfunction()

# Usage: add_3rd_project(project_name
#            GIT_REPOSITORY "xxx"
#            GIT_TAG "xxx")
# Example:
# add_3rd_project(eigen
#   GIT_REPOSITORY "ssh://git@ryon.ren:10022/mirrors/eigen3.git"
#   GIT_TAG "0fd6b4f71dd85b2009ee4d1aeb296e2c11fc9d68"
#   )
# or
# add_git_3rd_project(eigen "ssh://git@ryon.ren:10022/mirrors/eigen3.git" "3.3.9")
function(add_3rd_project name)
  set(oneValueArgs
    PREFIX
    SOURCE_DIR
    INSTALL_DIR
    )
  set(multiValueArgs "")
  cmake_parse_arguments("EXT_PROJ" "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  message(STATUS "Downloading/updating ${name}")
  set(EXT_PROJ_NAME ${name})
  set(EXT_PROJ_TMP_DIR ${CMAKE_BINARY_DIR}/tmp)
  set(EXT_PROJ_CACHE_DIR ${CMAKE_BINARY_DIR}/.cache/${name})

  if (NOT EXT_PROJ_PREFIX)
    set(EXT_PROJ_PREFIX ${CMAKE_SOURCE_DIR}/3rd)
  else()
    get_filename_component(EXT_PROJ_PREFIX "${EXT_PROJ_PREFIX}" ABSOLUTE
      BASE_DIR "${CMAKE_CURRENT_BINARY_DIR}")
  endif()
  if (NOT EXT_PROJ_SOURCE_DIR)
    set(EXT_PROJ_SOURCE_DIR ${EXT_PROJ_PREFIX}/${EXT_PROJ_NAME})
  endif()
  if (NOT EXT_PROJ_INSTALL_DIR)
    set(EXT_PROJ_INSTALL_DIR ${EXT_PROJ_PREFIX})
  endif()
  configure_file("${UTILITY_DIR}/extproj.cmake.in"
    "${EXT_PROJ_CACHE_DIR}/CMakeLists.txt")
  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -G "${CMAKE_GENERATOR}"
    -D "CMAKE_MAKE_PROGRAM:FILE=${CMAKE_MAKE_PROGRAM}"
    .
    RESULT_VARIABLE result
    WORKING_DIRECTORY ${EXT_PROJ_CACHE_DIR}
    )
  if(result)
    message(FATAL_ERROR "CMake step for ${name} failed: ${result}")
  endif()
  execute_process(COMMAND ${CMAKE_COMMAND} --build . -j24
    RESULT_VARIABLE result
    WORKING_DIRECTORY  ${EXT_PROJ_CACHE_DIR})
  if(result)
    message(FATAL_ERROR "Build step for ${name} failed: ${result}")
  else ()
    message (STATUS "complete download and build ${name}!")
  endif()
endfunction()

function(add_git_3rd_project name url tag)
  cmake_parse_arguments("" "" "" "" ${ARGN})
  add_3rd_project(${name}
    GIT_REPOSITORY ${url}
    GIT_TAG ${tag}
    ${ARGN}
    )
endfunction()

# downloaded dependencies.
function(require_package pkg url tag)
  set(pkg_FOUND ${pkg}_FOUND)
  set(pkg_VERSION ${pkg}_VERSION)
  find_package(${pkg})
  if (NOT ${pkg_FOUND})
    message("Ready to download ${pkg}...")
    add_git_3rd_project(${pkg} ${url} ${tag})
    find_package(${pkg} REQUIRED)
  endif()
  message("Find ${pkg} version -> ${${pkg_VERSION}}")
endfunction()

function(fetch_git_3rd_project name url tag)
  cmake_parse_arguments("" "" "" "" ${ARGN})
  add_3rd_project(${name}
    GIT_REPOSITORY ${url}
    GIT_TAG ${tag}
    ${ARGN}
    CONFIGURE_COMMAND "${CMAKE_COMMAND} -E echo do nothing in configure step"
    BUILD_COMMAND  "${CMAKE_COMMAND} -E echo do nothing in build step"
    TEST_COMMAND  "${CMAKE_COMMAND} -E echo do nothing in test step"
    INSTALL_COMMAND  "${CMAKE_COMMAND} -E echo do nothing in install step"
    )
endfunction()

function(fetch_package pkg url tag)
  cmake_parse_arguments("" "" "" "" ${ARGN})
  fetch_git_3rd_project(${pkg} ${url} ${tag} ${ARGN})
endfunction()
