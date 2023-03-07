include_guard()

include(${CMAKE_CURRENT_LIST_DIR}/cmake-core-assert.cmake)

# Use CPM.cmake instead.
if (NOT DEFINED ENV{CPM_SOURCE_CACHE})
  set(ENV{CPM_SOURCE_CACHE} ${CMAKE_SOURCE_DIR}/3rd)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/CPM.cmake)

function(is_version out v)
  # major[.minor[.patch[.tweak]]]
  string(REGEX MATCH "^[0-9]+(.[0-9]+)?(.[0-9]+)?(.[0-9]+)?$" _ ${v})

  if(_)
    set(${out} YES PARENT_SCOPE)
  else()
    set(${out} NO PARENT_SCOPE)
  endif()
endfunction()

function(infer_version_from_tag out tag)
  DEBUG_MSG("Test.Case: ${tag}")

  if(${tag} MATCHES "^[^0-9]*([0-9]+[0-9.]*)([^0-9]+.*)*$")
    is_version(_ ${CMAKE_MATCH_1})

    if(_)
      DEBUG_MSG("infer.version: ${CMAKE_MATCH_1}")
      set(${out} ${CMAKE_MATCH_1} PARENT_SCOPE)
    else()
      unset(${out} PARENT_SCOPE)
    endif()
  else()
    unset(${out} PARENT_SCOPE)
  endif()
endfunction()

function(infer_args_from_uri out_args uri)
  cmake_parse_arguments("" "NO_VERSION" "" "" ${ARGN})
  DEBUG_MSG("-----Current.uri: ${uri}")

  # split uri to url#tagversion
  if(${uri} MATCHES "^([^# ]+)(#[^# ]*)?$")
    set(url ${CMAKE_MATCH_1})

    if(CMAKE_MATCH_2)
      string(SUBSTRING ${CMAKE_MATCH_2} 1 -1 tagversion)
    endif()
  else()
    ERROR_MSG("Unvalid URI Format(^[^# ]+(#[^# ]*)?$): ${uri}")
  endif()

  # split tagversion: tag@version
  if(tagversion)
    if(tagversion MATCHES "^([^@]*)(@[0-9.]*)?$")
      set(tag ${CMAKE_MATCH_1})

      # infer version.
      if(NOT _NO_VERSION)
        if(CMAKE_MATCH_2)
          string(SUBSTRING ${CMAKE_MATCH_2} 1 -1 version)
        else()
          infer_version_from_tag(version ${tag})
        endif()
      endif()
    else()
      ERROR_MSG("Unvalid TagVersion Format([^@]*@[0-9.]*): ${tagversion}")
    endif()
  endif()

  DEBUG_MSG("tag: ${tag}")
  DEBUG_MSG("version: ${version}")

  # infer scheme from url.
  # scheme:path
  if(${url} MATCHES "^([^: ]+):(.+)$")
    string(TOLOWER ${CMAKE_MATCH_1} scheme)
    set(path ${CMAKE_MATCH_2})
    DEBUG_MSG("Current.Match.Scheme: ${scheme}")
    DEBUG_MSG("Current.Match.Path: ${path}")
  endif()

  # some special schemes
  if(scheme STREQUAL "rom") # ryon.ren:mirrors
    if(${path} MATCHES "([^/]+)$")
      set(out GIT_REPOSITORY
        ssh://git@ryon.ren:10022/mirrors/${CMAKE_MATCH_1})
    else()
      ERROR_MSG("Unable to infer repo name: ${path}")
    endif()

    set(type git)
  elseif(scheme STREQUAL "gh") # github
    set(out GIT_REPOSITORY https://github.com/${path})
    set(type git)
  elseif(scheme STREQUAL "gl") # gitlab
    set(out GIT_REPOSITORY https://gitlab.com/${path})
    set(type git)
  elseif(scheme STREQUAL "bb") # bitbucket
    set(out GIT_REPOSITORY https://bitbucket.org/${path})
    set(type git)
  else() # normal test.
    # FIXME: Too Ugly!!!
    if(${url} MATCHES ".*\\.git$" # end with **.git**
      OR ${url} MATCHES "^(ssh://)?git@" # start with [ssh://]git@

      # https://github/gitlab.com/Username/RepoName
      OR ${url} MATCHES "^https://github\\.com/[^/ ]+/[^/ ]+$"
      OR ${url} MATCHES "^https://gitlab\\.com/[^/ ]+/[^/ ]+$"
      OR ${url} MATCHES "^https://funannongwu\\.com/[^/ ]+/[^/ ]+$"

      # https://ryon.ren
      OR ${url} MATCHES "^https://ryon\\.ren:2443/[^/ ]+/[^/ ]+$"

      # https://bitbucket.org
      OR ${url} MATCHES "^https://bitbucket\\.org/[^/ ]+/[^/ ]+$"
    )
      set(out GIT_REPOSITORY ${url})
      set(type git)
    else() # FIXME: other protocol: svn. cvs
      set(out URL ${url})
    endif()
  endif()

  if(tag)
    if(${type} STREQUAL git)
      set(out ${out} GIT_TAG ${tag})
    else()
      set(out ${out} URL_HASH ${tag})
    endif()
  endif()

  if(version)
    set(out ${out} VERSION ${version})
  endif()

  DEBUG_MSG("Current.Prepare.args: ${out}")

  set(${out_args} ${out} PARENT_SCOPE)
endfunction()

macro(require_package pkg uri)
  DEBUG_MSG("uri: ${uri}")
  DEBUG_MSG("args: ${ARGN}")
  # extract uri from args.
  infer_args_from_uri(extra_args "${uri}")
  DEBUG_MSG("extra_args: ${extra_args}")

  # parse CMAKE_ARGS/GIT_PATCH
  cmake_parse_arguments(PKG "" "GIT_PATCH" "CMAKE_ARGS" "${ARGN}")

  set(CPM_OPTIONS "")
  foreach(arg ${PKG_CMAKE_ARGS})
    if(${arg} MATCHES "^-D([^ ]+)(:[^ ]+)?=([^ ]+)$")
      DEBUG_MSG("Key: ${CMAKE_MATCH_1}, Value: ${CMAKE_MATCH_3}, Type: ${CMAKE_MATCH_2}")
      set(CPM_OPTIONS ${CPM_OPTIONS} "${CMAKE_MATCH_1} ${CMAKE_MATCH_3}")
    else()
      ERROR_MSG("Unknown cmake_arg: ${arg}, should be specified as: -D<var>[:<type>]=<value>")
    endif()
  endforeach()

  DEBUG_MSG("CMAKE.ARGS: ${CPM_OPTIONS}")

  if (DEFINED PKG_GIT_PATCH)
    get_filename_component(PKG_GIT_PATCH ${PKG_GIT_PATCH} ABSOLUTE BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    ASSERT_FILE_EXISTS(${PKG_GIT_PATCH})
    find_package(Git REQUIRED)
    ASSERT_DEFINED(GIT_EXECUTABLE)
    list(APPEND extra_args
      PATCH_COMMAND ${GIT_EXECUTABLE} restore . && ${GIT_EXECUTABLE} apply ${PKG_GIT_PATCH}
    )
  endif()

  CPMAddPackage(
    EXCLUDE_FROM_ALL YES
    NAME ${pkg}
    ${extra_args}
    ${PKG_UNPARSED_ARGUMENTS}
    OPTIONS ${CPM_OPTIONS}
  )
endmacro()

# for register packages.
macro(declare_pkg_deps)
  foreach(dep ${ARGV})
    # split dep into name[@version]
    if (${dep} MATCHES "^([^@ ]+)(@[^@ ]*)?$")
      if (CMAKE_MATCH_2)
        if (NOT ${CMAKE_MATCH_2} STREQUAL "@default")
          string(SUBSTRING ${CMAKE_MATCH_2} 1 -1 ${CMAKE_MATCH_1}_VERSION)
          message(DEBUG "${CMAKE_MATCH_1} use ${${CMAKE_MATCH_1}_VERSION}")
        else()
          message(DEBUG "${CMAKE_MATCH_1} use default")
        endif()
      endif()
      include(pkg_${CMAKE_MATCH_1})
    else()
      ERROR_MSG("Unvalid dep Format(^([^@ ]+)(@[^@ ]*)?$): ${dep}")
    endif()
  endforeach()
endmacro()

# ignore NO_MODULE/CONFIG
macro(find_package PKG)
  cmake_parse_arguments(ARG "NO_MODULE;CONFIG" "" "" "${ARGN}")
  _find_package(${PKG} MODULE ${ARG_UNPARSED_ARGUMENTS})
endmacro()
