include_guard()

# if SuiteSparse::CHOLMOD has been found
if (TARGET SuiteSparse::CHOLMOD)
  return()
endif()

message(STATUS "[package/SuiteSparse]: SuiteSparse::AMD SuiteSparse::BTF SuiteSparse::CAMD SuiteSparse::CCOLAMD SuiteSparse::COLAMD SuiteSparse::UMFPACK SuiteSparse::KLU SuiteSparse::LDL SuiteSparse::Config SuiteSparse::CHOLMOD SuiteSparse::Partition SuiteSparse::SPQR SuiteSparse::gpuruntime SuiteSparse::gpuqrengine")

enable_language(C)

if (NOT DEFINED suitesparse_VERSION)
  set(suitesparse_VERSION "5.13.0")
endif()
if (NOT DEFINED suitesparse_TAG)
  set(suitesparse_TAG "${suitesparse_VERSION}-cmake.3")
endif()

lam_add_package_maybe_prebuild(
  "gh:sergiud/SuiteSparse#${suitesparse_TAG}"
  CMAKE_ARGS "-DWITH_DEMOS=OFF"
  # for user customize.
  ${suitesparse_USER_CUSTOMIZE_ARGS}
)
