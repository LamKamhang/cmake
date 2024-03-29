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
  set(osqp_VERSION "1.0.0.beta1")
endif()
if (NOT DEFINED osqp_TAG)
  set(osqp_TAG "v${osqp_VERSION}")
endif()

# TODO. make it prebuilt.
lam_add_package("gh:osqp/osqp#${osqp_TAG}"
  # for user customize.
  ${osqp_USER_CUSTOM_ARGS}
)

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
