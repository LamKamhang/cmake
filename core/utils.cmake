include_guard()

# check toplevel_project
function(lam_check_toplevel_project out_name)
  if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    set(${out_name} ON PARENT_SCOPE)
  else()
    set(${out_name} OFF PARENT_SCOPE)
  endif()
endfunction()

macro(assert_not_build_in_source_path)
  if (PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(FATAL_ERROR "In-source builds are not allowed")
  endif()
endmacro()

macro(lam_may_include file)
  if (EXISTS ${file})
    message(DEBUG "[cmake/utility] may_include: ${file}")
    include(${file})
  endif()
endmacro()
