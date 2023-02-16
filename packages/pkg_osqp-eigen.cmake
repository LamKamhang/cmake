include_guard()

# if OsqpEigen::OsqpEigen has been found
if (TARGET OsqpEigen::OsqpEigen)
  return()
endif()

message(STATUS "[package/OsqpEigen]: OsqpEigen::OsqpEigen")

set(osqp-eigen_VERSION 0.8.0 CACHE STRING "OsqpEigen customized version")

require_package(OsqpEigen "gh:robotology/osqp-eigen#v${osqp-eigen_VERSION}")
