For pkg_xxx.cmake

some variable can be used to control the building pipeline.

- xxx_VERSION: used to define a specific version.
- xxx_TAG: used to defined a specific tag.
- xxx_USE_PREBUILD: prefer prebuild version if the package provide a install target.
- xxx_USER_CMAKE_ARGS: used to set more cmake-args in the user end.
