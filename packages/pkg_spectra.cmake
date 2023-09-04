include_guard()

# if Spectra::Spectra has been found
if (TARGET Spectra)
  if (NOT TARGET Spectra::Spectra)
    add_library(Spectra::Spectra ALIAS Spectra)
  endif()
  return()
endif()

message(STATUS "[package/Spectra]: Spectra::Spectra")

if (NOT DEFINED spectra_VERSION)
  set(spectra_VERSION "1.0.1")
endif()
if (NOT DEFINED spectra_TAG)
  set(spectra_TAG "v${spectra_VERSION}")
endif()

lam_add_package_maybe_prebuild(spectra
  "gh:yixuan/spectra#${spectra_TAG}"
  NAME Spectra
  # for user customize.
  ${spectra_USER_CUSTOM_ARGS}
)

if (NOT TARGET Spectra::Spectra)
  add_library(Spectra::Spectra ALIAS Spectra)
endif()
