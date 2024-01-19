include_guard()

function(add_symlink src dest)
  message(STATUS "mklink ${src} -> ${dest}")
  file(TO_NATIVE_PATH "${dest}" _dstDir)
  file(TO_NATIVE_PATH "${src}" _srcDir)

  # if(WIN32)
  #   execute_process(COMMAND cmd.exe /c mklink /J "${_dstDir}" "${_srcDir}")
  # else()
  #   execute_process(COMMAND "${CMAKE_COMMAND}" -E create_symlink "${_srcDir}" "${_dstDir}")
  # endif()
  # New in Version 3.14
  file(CREATE_LINK "${_srcDir}" "${_dstDir}" SYMBOLIC)
endfunction()
