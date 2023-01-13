include_guard()

# if SuiteSparse::CHOLMOD has been found.
if (TARGET SuiteSparse::CHOLMOD)
  return()
endif()

message(STATUS "[package/SuiteSparse]: SuiteSparse::AMD SuiteSparse::BTF SuiteSparse::CAMD SuiteSparse::CCOLAMD SuiteSparse::COLAMD SuiteSparse::UMFPACK SuiteSparse::KLU SuiteSparse::LDL SuiteSparse::Config SuiteSparse::CHOLMOD SuiteSparse::Partition SuiteSparse::SPQR SuiteSparse::gpuruntime SuiteSparse::gpuqrengine")

option(suitesparse_IMPORT_AS_SUBDIR "Import as subdirectory instead of install && find_package" OFF)
set(suitesparse_VERSION 5.13.0 CACHE STRING "suitesparse customized version")
enable_language(C)

if (NOT suitesparse_IMPORT_AS_SUBDIR)
  require_package(SuiteSparse "gh:sergiud/SuiteSparse.git#${suitesparse_VERSION}-cmake.3"
    GIT_PATCH "${CMAKE_UTILITY_PATCH_DIR}/suitesparse.cholmod.patch"
    CMAKE_ARGS "-DWITH_DEMOS=OFF")
else()
  require_package(SuiteSparse "gh:sergiud/SuiteSparse.git#${suitesparse_VERSION}-cmake.3"
    SUBDIR_ONLY
    CMAKE_ARGS "-DWITH_DEMOS=OFF")
endif()