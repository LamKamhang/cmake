cmake_minimum_required(VERSION 3.14)

project(test_package)

include(${CMAKE_CURRENT_LIST_DIR}/../../utility.cmake)

set(cases
  add_package
  install_and_find_package
  install_and_find_package_diff_version
)

function(run_test name)
  execute_process(
    COMMAND ${CMAKE_COMMAND}
    -S ${CMAKE_CURRENT_LIST_DIR}/cases/${name}
    -B ${CMAKE_BINARY_DIR}/cases/${name}
    -G${CMAKE_GENERATOR}
    -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}
    -DCMAKE_GENERATOR_PLATFORM=${CMAKE_GENERATOR_PLATFORM}
    -DCMAKE_MESSAGE_LOG_LEVEL=${CMAKE_MESSAGE_LOG_LEVEL}
    -DCMAKE_MODULE_PATH=${CMAKE_CURRENT_LIST_DIR}/../../
    -DCPM_SOURCE_CACHE=${CMAKE_CURRENT_LIST_DIR}/external
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/cases/${name}
    RESULT_VARIABLE result
  )
  if (result)
    lam_error("[lam_package.test] case: ${name} failed: ${result}")
  endif()
endfunction()

foreach(case ${cases})
  run_test(${case})
endforeach()
