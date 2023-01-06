include_guard()

# if Spectra::Spectra has been found.
if (TARGET Spectra::Spectra)
  return()
endif()

message(STATUS "[package/Spectra]: Spectra::Spectra")

set(spectra_VERSION 1.0.1 CACHE STRING "Spectra customized version")

require_package(Spectra "gh:yixuan/spectra#v${spectra_VERSION}")
