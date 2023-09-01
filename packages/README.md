For pkg_xxx.cmake

NOTE: `xxx` should be the lower-case of the Name of the package.

some variable can be used to control the building pipeline.

- xxx_VERSION: used to define a specific version.
- xxx_TAG: used to defined a specific tag.
- xxx_USE_PREBUILD: prefer prebuild version if the package provide a install target.
- xxx_USER_CUSTOMIZE_ARGS: used to set more cmake-args/find_package_args in the user end.
