cmake_minimum_required(VERSION 3.12)

project(show-diff-source-dir)

message("--Root.Source.dir: ${CMAKE_SOURCE_DIR}")
message("--Root.CSource.dir: ${CMAKE_CURRENT_SOURCE_DIR}")
message("--Root.Binary.dir: ${CMAKE_BINARY_DIR}")
message("--Root.CBinary.dir: ${CMAKE_CURRENT_BINARY_DIR}")
message("--Root.Project.Source.dir: ${PROJECT_SOURCE_DIR}")
message("--Root.Project.Binary.dir: ${PROJECT_BINARY_DIR}")

add_subdirectory(subdir)
add_subdirectory(subproj)
