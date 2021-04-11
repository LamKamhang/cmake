if (NOT DEFINED PARDISO_DIR)
  set(PARDISO_DIR ${PROJECT_SOURCE_DIR}/3rd/pardiso)
endif()

if (EXISTS ${PARDISO_DIR})
  message(STATUS "pardiso find: ${PARDISO_DIR}")
  if (NOT TARGET pardiso)
    find_library(PARDISO
      pardiso
      # pardiso500-INTEL1301-X86-64
      # pardiso500-GNU461-X86-64
      # pardiso500-GNU472-X86-64
      # pardiso500-GNU481-X86-64
      # pardiso500-MPI-INTEL1301-X86-64
      # pardiso500-MPI-GNU450-X86-64
      # pardiso500-MPI-GNU461-X86-64
      # pardiso500-MPI-GNU463-X86-64
      # pardiso500-MPI-GNU472-X86-64
      # pardiso500-WIN-X86-64
      # pardiso500-MACOS-X86-64
      # pardiso600-GNU800-X86-64
      PATHS ${PARDISO_DIR}
      )
    if (${PARDISO} MATCHES "NOTFOUND")
      message("\n*NOT* using PARDISO.\n")
      set(pardiso_FOUND FALSE)
    else()
      message("Using PARDISO library at ${PARDISO}")
      find_package(OpenMP REQUIRED)
      add_library(pardiso INTERFACE)
      target_link_directories(pardiso INTERFACE
        ${PARDISO_DIR})
      target_link_libraries(pardiso INTERFACE
        ${PARDISO}
        OpenMP::OpenMP_CXX
        lapack
        )
        set(pardiso_FOUND TRUE)
    endif()
  endif()
else()
  message(WARNING "pardiso not found! please set {PARDISO_DIR} correctly!")
  set(pardiso_FOUND FALSE)
endif()
