if (NOT DEFINED ALGLIB_DIR)
  set(ALGLIB_DIR ${PROJECT_SOURCE_DIR}/3rd/alglib)
endif()

if (NOT TARGET alglib)
  find_path(ALGLIB_INCLUDES
    alglibinternal.h
    alglibmisc.h
    ap.h
    dataanalysis.h
    diffequations.h
    fasttransforms.h
    integration.h
    interpolation.h
    linalg.h
    optimization.h
    solvers.h
    specialfunctions.h
    statistics.h
    stdafx.h
    PATHS
    /usr/include/
    /usr/include/libalglib
    ${ALGLIB_DIR}
    )

  find_library(ALGLIB_LIBRARIES
    NAMES alglib
    )
  if (${ALGLIB_LIBRARIES} MATCHES "NOTFOUND")
    message("\n*NOT* using ALGLIB.\n")
    set(alglib_FOUND FALSE)
  else()
    message("Using ALGLIB library at ${ALGLIB_LIBRARIES}")
    message("      ALGLIB include: ${ALGLIB_INCLUDES}")
    add_library(alglib INTERFACE)
    target_include_directories(alglib INTERFACE ${ALGLIB_INCLUDES})
    target_link_libraries(alglib INTERFACE ${ALGLIB_LIBRARIES})
    set(alglib_FOUND TRUE)
  endif()
endif()
