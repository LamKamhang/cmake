cmake_minimum_required(VERSION 3.14)

project(test_package)

include(utility)

lam_use_deps(
  !eigen
  !autodiff
)

lam_assert_target_defined(Eigen3::Eigen)
lam_assert_target_defined(autodiff::autodiff)
