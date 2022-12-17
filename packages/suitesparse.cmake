include_guard()

message(STATUS "[package/SuiteSparse]: SuiteSparse::AMD SuiteSparse::BTF SuiteSparse::CAMD SuiteSparse::CCOLAMD SuiteSparse::COLAMD SuiteSparse::UMFPACK SuiteSparse::KLU SuiteSparse::LDL SuiteSparse::Config SuiteSparse::CHOLMOD SuiteSparse::Partition SuiteSparse::SPQR SuiteSparse::gpuruntime SuiteSparse::gpuqrengine")

require_package(SuiteSparse "gh:sergiud/SuiteSparse.git#5.13.0-cmake.3"
  CMAKE_ARGS "-DBUILD_SHARED_LIBS=ON"
  CMAKE_ARGS "-DWITH_DEMOS=OFF")
