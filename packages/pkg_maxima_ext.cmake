include_guard()

if (COMMAND add_maxima_f90_library)
  return()
endif()

enable_language(Fortran)

message(STATUS "[package/maxima_helper]: add_maxima_f90_library")

option(maxima_ext_DOWNLOAD_MAXIMA_EXT "Download chaos-maxima(which may require authentication)" OFF)

if (maxima_ext_DOWNLOAD_MAXIMA_EXT)
  lam_add_package("git@github.com:suitechaos/chaos-maxima#origin/master"
    NAME maxima_ext
  )
  lam_assert_file_exists(${maxima_ext_SOURCE_DIR}/CMakeLists.txt)
  return()
endif()

# provide a customized command which does not need authentication.
function(add_maxima_f90_library target)
  cmake_parse_arguments(MAC2F90 "" "MAC;F90;HH" "" ${ARGN})
  # refine.
  if (NOT DEFINED MAC2F90_F90)
    set(MAC2F90_F90 ${target}.f90)
  endif()
  # check.
  string(REGEX MATCH ".*\\.f90$" out ${MAC2F90_F90})
  if (NOT out)
    message(FATAL_ERROR "<${MAC2F90_F90}> should be like <*.f90>!")
  endif()

  if (NOT DEFINED MAC2F90_HH)
    set(MAC2F90_HH ${MAC2F90_F90}.h)
  endif()
  # change F90/MAC to absolute path for locate file.
  file(REAL_PATH ${MAC2F90_F90} MAC2F90_F90)
  file(REAL_PATH ${MAC2F90_HH} MAC2F90_HH)

  message(STATUS "MAC2F90.f90: ${MAC2F90_F90}")
  message(STATUS "MAC2F90.h  : ${MAC2F90_HH}")

  # add library.
  add_library(${target} ${MAC2F90_F90})
  if (NOT EXISTS ${MAC2F90_F90})
    # error prompt.
    message(FATAL_ERROR "${MAC2F90_F90} not found!")
  endif()
endfunction()
