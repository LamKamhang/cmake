include_guard()

# if osqp::osqp has been found
if (TARGET osqp)
  if (NOT TARGET osqp::osqp)
    add_library(osqp::osqp ALIAS osqp)
  endif()
  if (NOT TARGET osqp::osqpstatic)
    add_library(osqp::osqpstatic ALIAS osqpstatic)
  endif()
  return()
endif()

message(STATUS "[package/osqp]: osqp::osqp osqp::osqpstatic")

if (NOT DEFINED osqp_VERSION)
  set(osqp_VERSION "0.6.2")
endif()
if (NOT DEFINED osqp_TAG)
  set(osqp_TAG "v${osqp_VERSION}")
endif()

require_package(osqp "gh:osqp/osqp#${osqp_TAG}")

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
