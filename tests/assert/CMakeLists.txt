cmake_minimum_required(VERSION 3.12)

project(require-package)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)
set(DEBUG_MODE True)

DEBUG_MSG("Echo Debug")
set(GOOD "")

ASSERT_DEFINED(GOOD)
ASSERT_EMPTY(${GOOD})

set(GOOD)
ASSERT_NOT_DEFINED(GOOD)
ASSERT_EMPTY(${GOOD})
