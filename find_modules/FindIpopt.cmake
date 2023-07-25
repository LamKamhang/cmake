if (NOT TARGET Ipopt)
  find_path(IPOPT_INCLUDES
    NAMES coin-or/IpNLP.hpp
    PATHS
    /usr/include/
    ${Ipopt_INSTALL_DIR}/include
    ${IPOPT_DIR}
  )

  find_library(IPOPT_LIBRARIES
    NAMES ipopt
    PATHS
    ${Ipopt_INSTALL_DIR}/lib
  )
  if (${IPOPT_LIBRARIES} MATCHES "NOTFOUND")
    message("\n*NOT* using IPOPT.\n")
    set(Ipopt_FOUND FALSE)
  else()
    message("Using Ipopt library at ${IPOPT_LIBRARIES}")
    message("      Ipopt include: ${IPOPT_INCLUDES}")
    add_library(Ipopt INTERFACE)
    target_include_directories(Ipopt INTERFACE ${IPOPT_INCLUDES})
    target_link_libraries(Ipopt INTERFACE ${IPOPT_LIBRARIES})
    set(Ipopt_FOUND TRUE)
  endif()
endif()
