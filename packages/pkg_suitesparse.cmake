include_guard()

# if SuiteSparse::CHOLMOD has been found
if(TARGET SuiteSparse::CHOLMOD)
  return()
endif()

message(
  STATUS
    "[package/SuiteSparse]: SuiteSparse::AMD SuiteSparse::BTF SuiteSparse::CAMD SuiteSparse::CCOLAMD SuiteSparse::COLAMD SuiteSparse::UMFPACK SuiteSparse::KLU SuiteSparse::LDL SuiteSparse::Config SuiteSparse::CHOLMOD SuiteSparse::Partition SuiteSparse::SPQR SuiteSparse::gpuruntime SuiteSparse::gpuqrengine"
)

enable_language(C)

if(NOT DEFINED suitesparse_VERSION)
  set(suitesparse_VERSION "5.13.0")
endif()
if(NOT DEFINED suitesparse_TAG)
  if(${suitesparse_VERSION} VERSION_GREATER_EQUAL "7.6.0")
    set(suitesparse_TAG "v${suitesparse_VERSION}")
  else()
    set(suitesparse_TAG "${suitesparse_VERSION}-cmake.4")
  endif()
endif()

if(${suitesparse_TAG} MATCHES "cmake")
  lam_add_package_maybe_prebuilt(
    suitesparse
    "gh:sergiud/SuiteSparse#${suitesparse_TAG}"
    CMAKE_ARGS
    "-DWITH_DEMOS=OFF"
    # for user customize.
    ${suitesparse_USER_CUSTOM_ARGS})
else()
  message(STATUS "[package/SuiteSparse] use official cmake.")
  lam_add_package_maybe_prebuilt(suitesparse
    "https://github.com/DrTimothyAldenDavis/SuiteSparse.git#${suitesparse_TAG}"
    NAME CHOLMOD
    CMAKE_ARGS "-DSUITESPARSE_DEMOS=OFF"
    CMAKE_ARGS "-DBUILD_TESTING=OFF"
    CMAKE_ARGS "-DSUITESPARSE_USE_OPENMP=ON"
    CMAKE_ARGS "-DBUILD_STATIC_LIBS=OFF"
    CMAKE_ARGS "-DBUILD_SHARED_LIBS=ON"
    # for user customize.
    ${suitesparse_USER_CUSTOM_ARGS}
  )
endif()
