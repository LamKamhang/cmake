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

require_package(Spectra "gh:yixuan/spectra#${spectra_TAG}")

if (NOT TARGET Spectra::Spectra)
  add_library(Spectra::Spectra ALIAS Spectra)
endif()
