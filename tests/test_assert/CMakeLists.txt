cmake_minimum_required(VERSION 3.14)

project(test_assert)

set(LAM_ENABLE_ERROR_KEEP_GOING ON)
include(${CMAKE_CURRENT_LIST_DIR}/../../core/assert.cmake)

lam_assert_num_equal("1" 1) # passed.
# lam_assert_num_equal("" 1) # failed.
# lam_assert_num_equal("a" "a") #failed.

lam_assert_not_num_equal("1" 2) # passed.
# lam_assert_not_num_equal("1" 1) # failed.
lam_assert_not_num_equal("a" "a") # passed.
lam_assert_not_num_equal("a" "b") # passed.

lam_assert_num_lt(1 2) # passed.
# lam_assert_num_lt(2 1) # failed.
# lam_assert_num_lt(2 2) # failed.

# lam_assert_num_gt(1 2) # failed.
lam_assert_num_gt(2 1) # passed.
# lam_assert_num_gt(2 2) # failed.

lam_assert_num_le(1 2) # passed.
# lam_assert_num_le(2 1) # failed.
lam_assert_num_le(2 2) # passed.

# lam_assert_num_ge(1 2) # failed.
lam_assert_num_ge(2 1) # passed.
lam_assert_num_ge(2 2) # passed.

lam_assert_str_equal("a" a) # passed.
lam_assert_str_equal(1 1) # passed.
# lam_assert_str_equal(2 1) # failed.
# lam_assert_str_equal(2 "a") # failed.

# lam_assert_str_not_equal("a" a) # failed.
# lam_assert_str_not_equal(1 1) # failed.
lam_assert_str_not_equal(2 1) # passed.
lam_assert_str_not_equal(2 "a") # passed.

# lexical order.
lam_assert_str_lt("abc" "acc") # passed.
lam_assert_str_lt("123" "2") # passed.
# lam_assert_str_lt("acc" "abc") # failed.
# lam_assert_str_lt("2" "123") # failed.
# lam_assert_num_lt(123 2) # failed.

# lam_assert_str_gt("abc" "acc") # failed.
# lam_assert_str_gt("123" "2") # faeild.
lam_assert_str_gt("acc" "abc") # passed.
lam_assert_str_gt("2" "123") # passed.
# lam_assert_num_gt(2 123) # failed.

lam_assert_list_size("a;b;c" 3) # passed.
# lam_assert_list_size("a;b;c" 2) # failed.

set(my_list a b c)
lam_assert_list_size_var(my_list 3) # passed.
# lam_assert_list_size_var(my_list 2) # failed.

lam_assert_not_empty_var(my_list) # passed.
# lam_assert_not_empty_var(empty) # failed.

lam_assert_defined(my_list) # passed.
lam_assert_not_defined(empty) # passed.
# lam_assert_not_defined(my_list) # failed.
# lam_assert_defined(empty) # failed.

lam_assert_exists(${CMAKE_CURRENT_LIST_FILE}) # passed.
lam_assert_exists(${CMAKE_CURRENT_LIST_DIR}) # passed.
lam_assert_file_exists(${CMAKE_CURRENT_LIST_FILE}) # passed.
# lam_assert_file_exists(${CMAKE_CURRENT_LIST_DIR}) # failed.
# lam_assert_dir_exists(${CMAKE_CURRENT_LIST_FILE}) # failed.

function(check_equal)
  # for number.
  lam_assert_num_equal(10 10)
  set(v1 10)
  lam_assert_num_equal(${v1} 10)
  # lam_assert_num_equal(v1 10) # failed.
  # lam_assert_str_equal(v1 10) # failed.
  lam_assert_not_equal(${v1} 11)
  lam_assert_not_equal(v1 11)

  # for string.
  set(v2 hello)
  lam_assert_str_equal(${v2} "hello")
  lam_assert_not_equal(${v2} "hello2")
  lam_assert_not_equal(v2 "hello2")
endfunction()
check_equal()

function(check_empty_defined)
  lam_assert_not_defined(hello)

  set(v1 ${hello}) # since hello is undefined. thus, this is identical to unset.
  # lam_assert_not_empty_var(v1) # failed.
  lam_assert_not_defined(v1)

  set(v2 "")
  # lam_assert_not_empty_var(v2) # failed.
  lam_assert_defined(v2)

  set(v3 ${v2}) # since v2 is empty, thus this is identical to unset.
  # lam_assert_not_empty_var(v3) # failed.
  lam_assert_not_defined(v3)

  set(v4 a)
  lam_assert_not_empty_var(v4)
  lam_assert_defined(v4)
endfunction()
check_empty_defined()

function(check_boolean)
  lam_assert_truthy(On)
  lam_assert_truthy(ON)
  lam_assert_truthy(TRUE)
  lam_assert_truthy(1)
  lam_assert_truthy(YES)
  lam_assert_truthy(Y)
  set(var YES)
  lam_assert_truthy(var)
  set(var NO)
  # lam_assert_truthy(var) # failed.

  lam_assert_falsy(NO)
  lam_assert_falsy(No)
  lam_assert_falsy(OFF)
  lam_assert_falsy(Off)
  lam_assert_falsy(N)
  lam_assert_falsy(False)
  lam_assert_falsy(FALSE)
  set(var NO)
  lam_assert_falsy(var)
  lam_assert_falsy(${var})
  set(var YES)
  # lam_assert_falsy(var) # failed.
  # lam_assert_falsy(${var}) # failed.
endfunction()
check_boolean()

function(check_target_defined)
  add_library(hello INTERFACE)
  lam_assert_target_defined(hello)
  lam_assert_target_not_defined(world)
endfunction()
check_target_defined()
