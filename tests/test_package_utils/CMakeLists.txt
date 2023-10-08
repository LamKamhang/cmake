cmake_minimum_required(VERSION 3.14)

project(test_package_utils)

include(${CMAKE_CURRENT_LIST_DIR}/../../utility.cmake)

function(check_version)
  lam_is_version(out "1.2.0")
  lam_assert_truthy(out)
  # lam_assert_falsy(out) # failed.

  lam_is_version(out "v1.2.0")
  lam_assert_falsy(out)
  # lam_assert_truthy(out) # failed.
endfunction()
check_version()

function(check_infer_version_from_tag)
  lam_infer_version_from_tag(out "v1.2.0")
  lam_assert_equal(${out} "1.2.0")

  lam_infer_version_from_tag(out "vabc")
  lam_assert_not_defined(out)

  lam_infer_version_from_tag(out "v1") # at least two part.
  lam_assert_not_defined(out)

  lam_infer_version_from_tag(out "v1.2")
  lam_assert_equal(${out} "1.2")
endfunction()
check_infer_version_from_tag()

function(check_valid_uri)
  lam_assert_valid_uri("gh:libeigen/eigen")
  lam_assert_valid_uri("gh:libeigen/eigen#3.4.0")
  lam_assert_valid_uri("gh:libeigen/eigen#v3.4.0")
  lam_assert_valid_uri("gh:libeigen/eigen#v3.4.0@3.4")
  lam_assert_valid_uri("gh:libeigen/eigen@3.4#3.4.0")
  # lam_assert_valid_uri("gh:libeigen/eigen@3.4#3.4.0@3.4") # failed.
  # lam_assert_valid_uri("gh: WITH SPACE") # faeild.
  # lam_assert_valid_uri("gh:libeigen/eigen##") # failed.
endfunction()
check_valid_uri()

function(check_split_uri)
  lam_split_uri("gl:libeigen/eigen")
  lam_assert_defined(lam_pkg_url)
  lam_assert_not_defined(lam_pkg_tag lam_pkg_version)
  # lam_assert_not_defined(lam_pkg_url) # failed.
  # lam_assert_defined(lam_pkg_tag lam_pkg_version) # failed.
  lam_assert_equal(${lam_pkg_url} "gl:libeigen/eigen")

  lam_split_uri("gl:libeigen/eigen#origin/master")
  lam_assert_defined(lam_pkg_url lam_pkg_tag)
  lam_assert_not_defined(lam_pkg_version)
  lam_assert_equal(${lam_pkg_url} "gl:libeigen/eigen")
  lam_assert_equal(${lam_pkg_tag} "origin/master")

  lam_split_uri("gl:libeigen/eigen#")
  lam_assert_defined(lam_pkg_url)
  lam_assert_not_defined(lam_pkg_tag lam_pkg_version)
  lam_assert_equal(${lam_pkg_url} "gl:libeigen/eigen")

  lam_split_uri("gl:libeigen/eigen#v3.4.0")
  lam_assert_defined(lam_pkg_url lam_pkg_tag lam_pkg_version)
  lam_assert_equal(${lam_pkg_url} "gl:libeigen/eigen")
  lam_assert_equal(${lam_pkg_tag} "v3.4.0")
  lam_assert_equal(${lam_pkg_version} "3.4.0")

  lam_split_uri("gl:libeigen/eigen#v3.4.0@")
  lam_assert_defined(lam_pkg_url lam_pkg_tag)
  lam_assert_not_defined(lam_pkg_version)
  lam_assert_equal(${lam_pkg_url} "gl:libeigen/eigen")
  lam_assert_equal(${lam_pkg_tag} "v3.4.0")

  lam_split_uri("gl:libeigen/eigen#v3.4.0@3.4")
  lam_assert_defined(lam_pkg_url lam_pkg_tag lam_pkg_version)
  lam_assert_equal(${lam_pkg_url} "gl:libeigen/eigen")
  lam_assert_equal(${lam_pkg_tag} "v3.4.0")
  lam_assert_equal(${lam_pkg_version} "3.4")
endfunction()
check_split_uri()


function(check_split_url)
  block()
    lam_split_url("gl:libeigen/eigen")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url} "https://gitlab.com/libeigen/eigen")
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()
  lam_assert_not_defined(lam_pkg_url lam_pkg_type lam_pkg_name)

  block()
    lam_split_url("gh:libeigen/eigen")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url} "https://github.com/libeigen/eigen")
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  block()
    lam_split_url("bb:libeigen/eigen")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url} "https://bitbucket.org/libeigen/eigen")
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  block()
    lam_split_url("rom:libeigen/eigen")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url} "ssh://git@ryon.ren:10022/mirrors/eigen")
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  block()
    lam_split_url("https://gitlab.com/libeigen/eigen")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url} "https://gitlab.com/libeigen/eigen")
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  block()
    lam_split_url("https://github.com/libeigen/eigen")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url} "https://github.com/libeigen/eigen")
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  block()
    lam_split_url("https://bitbucket.org/libeigen/eigen")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url} "https://bitbucket.org/libeigen/eigen")
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  block()
    lam_split_url("git@gitlab.com:libeigen/eigen.git")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url}
      "git@gitlab.com:libeigen/eigen.git"
    )
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  # trigger warning.
  block()
    lam_split_url("git@gitlab.com:libeigen/eigen.git#v3.4.0")
    lam_assert_defined(lam_pkg_url lam_pkg_type lam_pkg_name)
    lam_assert_equal(${lam_pkg_url}
      "git@gitlab.com:libeigen/eigen.git"
    )
    lam_assert_equal(${lam_pkg_type} "git")
    lam_assert_equal(${lam_pkg_name} "eigen")
  endblock()

  block()
    lam_split_url("https://gitlab.com/libeigen/eigen/-/archive/master/eigen-master.zip")
    lam_assert_defined(lam_pkg_url lam_pkg_type)
    lam_assert_not_defined(lam_pkg_name)
    lam_assert_equal(${lam_pkg_url}
      "https://gitlab.com/libeigen/eigen/-/archive/master/eigen-master.zip"
    )
    lam_assert_equal(${lam_pkg_type} "archive")
  endblock()
endfunction()
check_split_url()


function(check_extract_args)
  block()
    lam_extract_args_from_uri(out "gl:libeigen/eigen#v3.4.0")
    lam_assert_defined(lam_pkg_name out)
    lam_assert_equal(${lam_pkg_name} "eigen")
    lam_assert_equal(
      "${out}"
      "GIT_REPOSITORY;https://gitlab.com/libeigen/eigen;GIT_TAG;v3.4.0;GIT_SHALLOW;ON;VERSION;3.4.0"
    )
  endblock()

  block()
    lam_extract_args_from_uri(out "gl:libeigen/eigen#v3.4.0@3.4")
    lam_assert_defined(lam_pkg_name out)
    lam_assert_equal(${lam_pkg_name} "eigen")
    lam_assert_equal(
      "${out}"
      "GIT_REPOSITORY;https://gitlab.com/libeigen/eigen;GIT_TAG;v3.4.0;GIT_SHALLOW;ON;VERSION;3.4"
    )
  endblock()

  block()
    lam_extract_args_from_uri(out "gl:libeigen/eigen#v3.4.0@")
    lam_assert_defined(lam_pkg_name out)
    lam_assert_equal(${lam_pkg_name} "eigen")
    lam_assert_equal(
      "${out}"
      "GIT_REPOSITORY;https://gitlab.com/libeigen/eigen;GIT_TAG;v3.4.0;GIT_SHALLOW;ON"
    )
  endblock()

  block()
    lam_extract_args_from_uri(out "gl:libeigen/eigen")
    lam_assert_defined(lam_pkg_name out)
    lam_assert_equal(${lam_pkg_name} "eigen")
    lam_assert_equal(
      "${out}"
      "GIT_REPOSITORY;https://gitlab.com/libeigen/eigen"
    )
  endblock()
endfunction()
check_extract_args()

function(check_check_prefer_prebuilt)
  # global default mode is ON.
  set(LAM_PACKAGE_PREFER_PREBUILT ON)
  # package mode is ON.
  set(eigen_USE_PREBUILT ON)
  lam_check_prefer_prebuilt(out eigen)
  lam_assert_truthy(out)

  # package mode is OFF
  set(eigen_USE_PREBUILT OFF)
  lam_check_prefer_prebuilt(out eigen)
  lam_assert_falsy(out)

  # package mode is undef.
  unset(eigen_USE_PREBUILT)
  lam_check_prefer_prebuilt(out eigen)
  lam_assert_truthy(out)

  # global default mode is ON.
  set(LAM_PACKAGE_PREFER_PREBUILT OFF)
  # package mode is ON.
  set(eigen_USE_PREBUILT ON)
  lam_check_prefer_prebuilt(out eigen)
  lam_assert_truthy(out)

  # package mode is OFF
  set(eigen_USE_PREBUILT OFF)
  lam_check_prefer_prebuilt(out eigen)
  lam_assert_falsy(out)

  # package mode is undef.
  unset(eigen_USE_PREBUILT)
  lam_check_prefer_prebuilt(out eigen)
  lam_assert_falsy(out)
endfunction()
check_check_prefer_prebuilt()

function(check_parse_deps_format)
  lam_parse_deps_format(~eigen1 out)
  lam_assert_defined(out eigen1_IS_OPTIONAL)
  lam_assert_equal(${out} "eigen1")
  lam_assert_truthy(eigen1_IS_OPTIONAL)
  lam_assert_not_defined(eigen1_USE_PREBUILT eigen1_TAG eigen1_VERSION)

  lam_parse_deps_format(eigen2 out)
  lam_assert_defined(out)
  lam_assert_equal(${out} "eigen2")
  lam_assert_not_defined(eigen2_IS_OPTIONAL eigen2_USE_PREBUILT eigen2_TAG eigen2_VERSION)

  lam_parse_deps_format("!eigen#v3.4.0@" out)
  lam_assert_defined(out eigen_USE_PREBUILT eigen_TAG)
  lam_assert_equal(${out} "eigen")
  lam_assert_truthy(eigen_USE_PREBUILT)
  lam_assert_equal(${eigen_TAG} "v3.4.0@")
  lam_assert_not_defined(eigen_IS_OPTIONAL eigen_VERSION)

  lam_parse_deps_format("!eigen#v3.4.0@3.4" out)
  lam_assert_defined(out eigen_USE_PREBUILT eigen_TAG)
  lam_assert_equal(${out} "eigen")
  lam_assert_truthy(eigen_USE_PREBUILT)
  lam_assert_equal(${eigen_TAG} "v3.4.0@3.4")
  lam_assert_not_defined(eigen_IS_OPTIONAL eigen_VERSION)

  lam_parse_deps_format("~!eigen#v3.4.0@3.4" out)
  lam_assert_defined(out eigen_USE_PREBUILT eigen_TAG eigen_IS_OPTIONAL)
  lam_assert_equal(${out} "eigen")
  lam_assert_truthy(eigen_USE_PREBUILT)
  lam_assert_truthy(eigen_IS_OPTIONAL)
  lam_assert_equal(${eigen_TAG} "v3.4.0@3.4")
  lam_assert_not_defined(eigen_VERSION)

  lam_parse_deps_format(!eigen@3.4.0 out)
  lam_assert_defined(out eigen_USE_PREBUILT eigen_VERSION)
  lam_assert_equal(${out} "eigen")
  lam_assert_truthy(eigen_USE_PREBUILT)
  lam_assert_equal(${eigen_VERSION} "3.4.0")
  lam_assert_not_defined(eigen_IS_OPTIONAL eigen_TAG)

  lam_parse_deps_format(!!eigen@3.4.0 out)
  lam_assert_defined(out eigen_USE_PREBUILT eigen_VERSION)
  lam_assert_equal(${out} "eigen")
  lam_assert_falsy(eigen_USE_PREBUILT)
  lam_assert_equal(${eigen_VERSION} "3.4.0")
  lam_assert_not_defined(eigen_IS_OPTIONAL eigen_TAG)

  # lam_parse_deps_format("!eigen@v3.4.0@" out) # failed.
endfunction()
check_parse_deps_format()
