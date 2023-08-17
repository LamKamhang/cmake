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
