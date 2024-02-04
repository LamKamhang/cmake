include_guard()
use_cmake_core_module(lam_assert)

# preserve the original configure file.
set(PRE_HEADER_CONFIGURE_FILE "${CMAKE_CURRENT_LIST_DIR}/git_meta/git_meta.hpp.in")
set(PRE_SOURCE_CONFIGURE_FILE "${CMAKE_CURRENT_LIST_DIR}/git_meta/git_meta.cpp.in")

# create a library out of the compiled post-configure file.
function(lam_generate_git_meta name)
  set(GIT_PROJECT_NAME ${name})
  set(GIT_META_OUTDIR "${CMAKE_BINARY_DIR}/_generated/src/git-meta")
  # add a more ${name} to avoid conflicts between different libraries.
  set(GIT_META_HEADER "${CMAKE_BINARY_DIR}/_generated/git-meta/${name}")

  set(POST_HEADER_CONFIGURE_FILE "${GIT_META_HEADER}/${name}/git_meta.hpp")
  set(POST_SOURCE_CONFIGURE_FILE "${GIT_META_OUTDIR}/${name}/git_meta.cpp")
  lam_assert_defined(LAM_CMAKE_UTILITY_CORE_DIR)
  include(${LAM_CMAKE_UTILITY_CORE_DIR}/git_meta/git_watcher.cmake)
  lam_git_watcher_main()

  set(target_name ${name}_git_meta)
  add_library(${target_name}
    STATIC
    ${POST_SOURCE_CONFIGURE_FILE}
    ${POST_HEADER_CONFIGURE_FILE}
  )
  add_library(${name}::git_meta ALIAS ${target_name})
  target_include_directories(${target_name}
    PUBLIC
      $<BUILD_INTERFACE:${GIT_META_HEADER}>
      # TODO. register the install_interface.
  )
  set_property(TARGET ${target_name} PROPERTY GENERATED_INCLUDE_DIRECTORIES "${GIT_META_HEADER}")
  add_dependencies(${target_name}
    ${name}_check_git
  )
endfunction()