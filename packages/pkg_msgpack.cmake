include_guard()

# if msgpack-cxx has been found
if (TARGET msgpack-cxx)
  return()
endif()

message(STATUS "[package/msgpack]: msgpack-cxx")
OPTION (MSGPACK_CXX11 "Using c++11 compiler" OFF)
OPTION (MSGPACK_CXX14 "Using c++14 compiler" OFF)
OPTION (MSGPACK_CXX17 "Using c++17 compiler" OFF)
OPTION (MSGPACK_CXX20 "Using c++20 compiler" ON)

OPTION (MSGPACK_32BIT                   "32bit compile"                        OFF)
OPTION (MSGPACK_USE_BOOST               "Use Boost libraried"                  OFF)
OPTION (MSGPACK_USE_X3_PARSE            "Use Boost X3 parse"                   OFF)
OPTION (MSGPACK_BUILD_TESTS             "Build tests"                          OFF)
OPTION (MSGPACK_BUILD_DOCS              "Build Doxygen documentation"          OFF)
OPTION (MSGPACK_FUZZ_REGRESSION         "Enable regression testing"            OFF)
OPTION (MSGPACK_BUILD_EXAMPLES          "Build msgpack examples"               OFF)
OPTION (MSGPACK_GEN_COVERAGE            "Generate coverage report"             OFF)
OPTION (MSGPACK_USE_STATIC_BOOST        "Statically link with boost libraries" OFF)
OPTION (MSGPACK_CHAR_SIGN               "Char sign to use (signed or unsigned)")
OPTION (MSGPACK_USE_STD_VARIANT_ADAPTOR "Enable the adaptor for std::variant"  OFF)

if (NOT DEFINED msgpack_VERSION)
  set(msgpack_VERSION "6.1.0")
endif()
if (NOT DEFINED msgpack_TAG)
  set(msgpack_TAG "cpp-${msgpack_VERSION}")
endif()

lam_add_package("gh:msgpack/msgpack-c#${msgpack_TAG}"
  NAME msgpack
  # for user customize.
  ${msgpack_USER_CUSTOMIZE_ARGS}
)
