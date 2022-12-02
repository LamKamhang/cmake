add_custom_target(hello ALL
  COMMAND echo good
  )
add_executable(child main.cc)
