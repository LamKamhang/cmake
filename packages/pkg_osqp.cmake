include_guard()

if (TARGET osqp::osqp)
  return()
endif()

message(STATUS "[package/osqp]: osqp::osqp")

set(osqp_VERSION 0.6.2 CACHE STRING "osqp customized version")

require_package(osqp "gh:osqp/osqp#v${osqp_VERSION}@")
