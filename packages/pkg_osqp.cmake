include_guard()

if (TARGET osqp::osqp)
  return()
endif()

message(STATUS "[package/osqp]: osqp::osqp")

set(osqp_VERSION 0.6.2 CACHE STRING "osqp customized version")

require_package(osqp "gh:osqp/osqp#v${osqp_VERSION}@")

if (NOT TARGET osqp::osqp)
  if (TARGET osqp)
    add_library(osqp::osqp ALIAS osqp)
  endif()
endif()

if (NOT TARGET osqp::osqpstatic)
  if (TARGET osqpstatic)
    add_library(osqp::osqpstatic ALIAS osqpstatic)
  endif()
endif()
