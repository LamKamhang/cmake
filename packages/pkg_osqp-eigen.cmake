include_guard()

# if OsqpEigen::OsqpEigen has been found
if (TARGET OsqpEigen::OsqpEigen)
  return()
endif()

message(STATUS "[package/OsqpEigen]: OsqpEigen::OsqpEigen")

if (NOT DEFINED osqp-eigen_VERSION)
  set(osqp-eigen_VERSION "0.8.0")
endif()
if (NOT DEFINED osqp-eigen_TAG)
  set(osqp-eigen_TAG "v${osqp-eigen_VERSION}")
endif()

require_package(OsqpEigen "gh:robotology/osqp-eigen#${osqp-eigen_TAG}")
