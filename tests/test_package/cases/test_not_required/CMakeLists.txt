cmake_minimum_required(VERSION 3.14)

project(test_package)

include(utility)

lam_add_prebuild_package(
  "gl:not_exists/not_exists"
  NAME NotExists
  NOT_REQUIRED
)

lam_assert_not_defined(NotExists_FOUND)
