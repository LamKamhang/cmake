# Top level:
# Enhanced version of find_package with externalproject_add.
#
# Why not use fetchcontent but wrap it with externalproject_add?
# Because I don't want to import all the targets of external libraries
# through add_submodule, environment isolation is required.
#
# find_package(<PackageName> [version] [EXACT] [QUIET]
#              [REQUIRED] [[COMPONENTS] [components...]]
#              [OPTIONAL_COMPONENTS components...]
#              [CONFIG|NO_MODULE]
#              [GLOBAL]
#              [NO_POLICY_SCOPE]
#              [BYPASS_PROVIDER]
#              [NAMES name1 [name2 ...]]
#              [CONFIGS config1 [config2 ...]]
#              [HINTS path1 [path2 ... ]]
#              [PATHS path1 [path2 ... ]]
#              [REGISTRY_VIEW  (64|32|64_32|32_64|HOST|TARGET|BOTH)]
#              [PATH_SUFFIXES suffix1 [suffix2 ...]]
#              [NO_DEFAULT_PATH]
#              [NO_PACKAGE_ROOT_PATH]
#              [NO_CMAKE_PATH]
#              [NO_CMAKE_ENVIRONMENT_PATH]
#              [NO_SYSTEM_ENVIRONMENT_PATH]
#              [NO_CMAKE_PACKAGE_REGISTRY]
#              [NO_CMAKE_BUILDS_PATH] # Deprecated; does nothing.
#              [NO_CMAKE_SYSTEM_PATH]
#              [NO_CMAKE_INSTALL_PREFIX]
#              [NO_CMAKE_SYSTEM_PACKAGE_REGISTRY]
#              [CMAKE_FIND_ROOT_PATH_BOTH |
#               ONLY_CMAKE_FIND_ROOT_PATH |
#               NO_CMAKE_FIND_ROOT_PATH])
#
# default, require_package is set to REQUIRED.
function(require_package PackageName)
  set(options "REQUIRED;NOT_REQUIRED;")
  set(oneValueArgs "PREFIX;SOURCE_DIR;INSTALL_DIR")
  set(multiValueArgs "")

  cmake_parse_arguments(pkg "${options}" "" "" ${ARGN})
  message(STATUS "require.package.ARGN: ${ARGN}")
  message(STATUS "require.package.UNPARSE: ${pkg_UNPARSED_ARGUMENTS}")
  set(pkg_FOUND ${PackageName}_FOUND)
  set(pkg_VERSION ${PackageName}_VERSION)
  find_package(${PackageName} ${pkg_UNPARSED_ARGUMENTS})
  message(STATUS "pkg: ${${pkg_FOUND}}")
  message(STATUS "pkg: ${${pkg_VERSION}}")
  find_package(${PackageName} ${ARGN})
  message(STATUS "direct.pkg: ${${pkg_FOUND}}")
  message(STATUS "direct.pkg: ${${pkg_VERSION}}")
endfunction()
