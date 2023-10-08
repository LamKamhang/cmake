cmake_minimum_required(VERSION 3.14)

project(test_package)

include(utility)

lam_add_prebuilt_package(
  "gl:not_exists/not_exists"
  NAME NotExists
  NOT_REQUIRED
)

lam_assert_falsy(NotExists_FOUND)
