include_guard()

# if fmt::fmt has been found
if (TARGET fmt::fmt)
  return()
endif()

message(STATUS "[package/fmt]: fmt::fmt")

if (NOT DEFINED fmt_VERSION)
  set(fmt_VERSION "9.1.0")
endif()
if (NOT DEFINED fmt_TAG)
  set(fmt_TAG "${fmt_VERSION}")
endif()

lam_check_prefer_prebuild(out fmt)
lam_add_package_maybe_prebuild(fmt
  "gh:fmtlib/fmt#${fmt_TAG}"
  OPTIONS
  "FMT_DOC OFF"
  "FMT_TEST OFF"
  "FMT_INSTALL ${out}"
  # for user customize.
  ${fmt_USER_CUSTOM_ARGS}
)
