include_guard()

if (TARGET alglib)
  return()
endif()

message(STATUS "[package/alglib]: alglib")

require_package(alglib "gh:LamKamhang/alglib#origin/master" SUBDIR_ONLY)
