if (NOT DEFINED BOGUS_DIR)
  set(BOGUS_DIR ${PROJECT_SOURCE_DIR}/3rd/bogus)
endif()

if (NOT TARGET bogus)
  find_library(BOGUS_LIBRARIES
    NAMES bogus
    PATHS
    ${PROJECT_SOURCE_DIR}/3rd/lib
  )
  if (${BOGUS_LIBRARIES} MATCHES "NOTFOUND")
    message("\n*NOT* using BOGUS.\n")
    set(bogus_FOUND FALSE)
  else()
    message("Using BOGUS library at ${BOGUS_LIBRARIES}")
    message("      BOGUS include: ${BOGUS_INCLUDES}")
    add_library(bogus INTERFACE)
    target_include_directories(bogus INTERFACE ${BOGUS_INCLUDES})
    target_link_libraries(bogus INTERFACE ${BOGUS_LIBRARIES})
    set(bogus_FOUND TRUE)
  endif()
endif()
