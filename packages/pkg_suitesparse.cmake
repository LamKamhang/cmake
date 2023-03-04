include_guard()

# if SuiteSparse::CHOLMOD has been found.
if (TARGET SuiteSparse::CHOLMOD)
  return()
endif()

message(STATUS "[package/SuiteSparse]: SuiteSparse::AMD SuiteSparse::BTF SuiteSparse::CAMD SuiteSparse::CCOLAMD SuiteSparse::COLAMD SuiteSparse::UMFPACK SuiteSparse::KLU SuiteSparse::LDL SuiteSparse::Config SuiteSparse::CHOLMOD SuiteSparse::Partition SuiteSparse::SPQR SuiteSparse::gpuruntime SuiteSparse::gpuqrengine")

set(suitesparse_VERSION 5.13.0 CACHE STRING "suitesparse customized version")
enable_language(C)

require_package(SuiteSparse "gh:sergiud/SuiteSparse.git#${suitesparse_VERSION}-cmake.3"
  CMAKE_ARGS "-DWITH_DEMOS=OFF")
