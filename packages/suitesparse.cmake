include_guard()

message(STATUS "[package/SuiteSparse]: SuiteSparse::AMD SuiteSparse::BTF SuiteSparse::CAMD SuiteSparse::CCOLAMD SuiteSparse::COLAMD SuiteSparse::UMFPACK SuiteSparse::KLU SuiteSparse::LDL SuiteSparse::Config SuiteSparse::CHOLMOD SuiteSparse::Partition SuiteSparse::SPQR SuiteSparse::gpuruntime SuiteSparse::gpuqrengine")

option(SUITESPARSE_IMPORT_AS_SUBDIR "Import as subdirectory instead of install && find_package" OFF)

enable_language(C)

if (NOT SUITESPARSE_IMPORT_AS_SUBDIR)
  require_package(SuiteSparse "gh:sergiud/SuiteSparse.git#5.13.0-cmake.3"
    GIT_PATCH "${CMAKE_UTILITY_PATCH_DIR}/suitesparse.cholmod.patch"
    CMAKE_ARGS "-DWITH_DEMOS=OFF")
else()
  require_package(SuiteSparse "gh:sergiud/SuiteSparse.git#5.13.0-cmake.3"
    SUBDIR_ONLY
    SUB_BINARY "${CMAKE_BINARY_DIR}/3rd/suitesparse"
    CMAKE_ARGS "-DWITH_DEMOS=OFF")
endif()
