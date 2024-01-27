find_package(CHOLMOD)
set(SuiteSparse_FOUND ${CHOLMOD_FOUND})
message(STATUS "[cmake/find_modules] find suitesparse: ${SuiteSparse_FOUND}")
