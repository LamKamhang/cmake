cmake_minimum_required(VERSION 3.14)

project(test_package)

include(utility)

set(eigen_USE_PREBUILD OFF)
lam_use_deps(eigen@3.4.0)
lam_assert_target_defined(Eigen3::Eigen)
