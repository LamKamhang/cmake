if (NOT DEFINED LUABRIDGE_DIR)
  set(LUABRIDGE_DIR ${PROJECT_SOURCE_DIR}/3rd/LuaBridge)
endif()

if (EXISTS ${LUABRIDGE_DIR})
  message(STATUS "LuaBridge find: ${LUABRIDGE_DIR}")
  if (NOT TARGET LuaBridge)
    add_library(LuaBridge INTERFACE)
    target_include_directories(LuaBridge
      INTERFACE
      ${LUABRIDGE_DIR}/Source/
      ${PROJECT_SOURCE_DIR}/cmake/luajit
      )
    target_link_libraries(LuaBridge INTERFACE luajit-5.1)
  endif()
  set(LuaBridge_FOUND TRUE)
else()
  message(WARNING "LuaBridge not found! please set {LUABRIDGE_DIR} correctly!")
  set(LuaBridge_FOUND FALSE)
endif()
