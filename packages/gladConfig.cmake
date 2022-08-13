if (NOT DEFINED GLAD_DIR)
  set(GLAD_DIR ${PROJECT_SOURCE_DIR}/3rd/glad)
endif()

if (EXISTS ${GLAD_DIR})
  message(STATUS "glad find: ${GLAD_DIR}")
  if (NOT TARGET glad)
    set(source
      ${GLAD_DIR}/src/glad.c
      )

    set(header
      ${GLAD_DIR}/include/glad/glad.h
      ${GLAD_DIR}/include/KHR/khrplatform.h
      )

    add_library(glad ${source} ${header})

    target_include_directories(glad
      PUBLIC
      ${GLAD_DIR}/include
      )
    target_link_libraries(glad PUBLIC ${CMAKE_DL_LIBS})
  endif()
  set(glad_FOUND TRUE)
else()
  message(WARNING "glad not found! please set {GLAD_DIR} correctly!")
  set(glad_FOUND FALSE)
endif()
