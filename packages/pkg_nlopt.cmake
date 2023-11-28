include_guard()

# if nlopt has been found
if (TARGET NLopt::nlopt)
  return()
endif()
if (TARGET nlopt)
  add_library(NLopt::nlopt ALIAS nlopt)
  return()
endif()

message(STATUS "[package/nlopt]: NLopt::nlopt")

if (NOT DEFINED nlopt_VERSION)
  set(nlopt_VERSION "2.7.1")
endif()
if (NOT DEFINED nlopt_TAG)
  set(nlopt_TAG "v${nlopt_VERSION}")
endif()

lam_check_prefer_prebuilt(out nlopt)
lam_add_package_maybe_prebuilt(nlopt
  "gh:stevengj/nlopt#${nlopt_TAG}"
  NAME NLopt
  CMAKE_ARGS "-DNLOPT_PYTHON=OFF"
  CMAKE_ARGS "-DNLOPT_OCTAVE=OFF"
  CMAKE_ARGS "-DNLOPT_MATLAB=OFF"
  CMAKE_ARGS "-DNLOPT_GUILE=OFF"
  CMAKE_ARGS "-DNLOPT_SWIG=OFF"
  # for user customize.
  ${nlopt_USER_CUSTOM_ARGS}
)
