cmake_minimum_required(VERSION 3.12)

project(manage3rd)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)

add_custom_target(update_all3rd)

function(gt_add_package)
  add_package(${ARGV} GENERATE_TARGET_ONLY)
endfunction()

gt_add_package(OpenVolumeMesh "ssh://git@ryon.ren:10022/mirrors/OpenVolumeMesh.git" GIT_TAG "v2.1")
gt_add_package(amgcl "git@github.com:ddemidov/amgcl.git" GIT_TAG "1.4.3")
gt_add_package(assimp "git@github.com:assimp/assimp.git" GIT_TAG "v5.2.3")
gt_add_package(Catch2 "ssh://git@ryon.ren:10022/mirrors/Catch2.git"  GIT_TAG "v2.13.7")
gt_add_package(eigen3   "ssh://git@ryon.ren:10022/mirrors/eigen3.git" GIT_TAG "3.4.0")
gt_add_package(autodiff "ssh://git@ryon.ren:10022/mirrors/autodiff.git" GIT_TAG "v0.6.8"
  CMAKE_ARGS "-DAUTODIFF_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_PYTHON=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_DOCS=OFF"
  )
gt_add_package(bullet3 "git@github.com:bulletphysics/bullet3.git" GIT_TAG "3.17")
gt_add_package(cgal "git@github.com:CGAL/cgal.git" GIT_TAG "v5.4")
gt_add_package(cli11 "ssh://git@ryon.ren:10022/mirrors/CLI11.git" GIT_TAG "v2.2.0"
  CMAKE_ARGS "-DCLI11_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_DOCS=OFF"
  )
gt_add_package(fmt "ssh://git@ryon.ren:10022/mirrors/fmt.git" GIT_TAG "8.0.1")
gt_add_package(glfw3 "ssh://git@ryon.ren:10022/mirrors/glfw.git" GIT_TAG "3.3.4")
gt_add_package(OpenMesh "ssh://git@ryon.ren:10022/mirrors/OpenMesh.git" GIT_TAG "OpenMesh-8.1")
gt_add_package(pybind11 "git@github.com:pybind/pybind11.git" GIT_TAG "v2.9.2")
# gt_add_package(rapidjson "git@github.com:Tencent/rapidjson.git" "00dbcf2c") # 2021.8.13
gt_add_package(nlohmann_json "git@github.com:nlohmann/json.git" GIT_TAG "v3.10.5")
# gt_add_package(toml11  "git@github.com:ToruNiina/toml11.git" "v3.7.0")
gt_add_package(spdlog "ssh://git@ryon.ren:10022/mirrors/spdlog.git" GIT_TAG "v1.9.2")
gt_add_package(spectra "git@github.com:yixuan/spectra.git" GIT_TAG "v1.0.0")
gt_add_package(LBFGSpp "ssh://git@ryon.ren:10022/mirrors/LBFGSpp.git" GIT_TAG "v0.1.0" DOWNLOAD_ONLY)
gt_add_package(tinyobjloader "git@github.com:tinyobjloader/tinyobjloader.git" GIT_TAG "3e401b55a") # 2021.8.27
gt_add_package(voro "git@github.com:chr1shr/voro.git" GIT_TAG "aa5f72233") # 2021.7.4
gt_add_package(suitesparse_wrapper "git@github.com:LamKamhang/suitesparse-wrapper.git" GIT_TAG  "b5977fb")
gt_add_package(nlopt "git@github.com:stevengj/nlopt.git" GIT_TAG "304137ff") # 2021.7.19

gt_add_package(Trilinos "git@github.com:trilinos/Trilinos.git" GIT_TAG "trilinos-release-13-0-1" DOWNLOAD_ONLY)
gt_add_package(TriWild "https://github.com/wildmeshing/TriWild" GIT_TAG "d85ec7a" DOWNLOAD_ONLY)
gt_add_package(TetWild "https://github.com/Yixin-Hu/TetWild" GIT_TAG "f6ca5d9" DOWNLOAD_ONLY)
gt_add_package(fTetWild "git@github.com:wildmeshing/fTetWild.git" GIT_TAG "c0be02c" DOWNLOAD_ONLY)
gt_add_package(ccls "git@github.com:MaskRay/ccls.git" GIT_TAG "0.20210330" DOWNLOAD_ONLY)
gt_add_package(libigl  "ssh://git@ryon.ren:10022/mirrors/libigl.git"  GIT_TAG  "v2.3.0" DOWNLOAD_ONLY)
gt_add_package(ImGuizmo "ssh://git@ryon.ren:10022/mirrors/ImGuizmo.git" GIT_TAG "8afa1d70"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/libigl/external/imguizmo"
  DOWNLOAD_ONLY
  )
gt_add_package(libigl-imgui "ssh://git@ryon.ren:10022/mirrors/libigl-imgui.git" GIT_TAG "7e1053e7"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/libigl/external/libigl-imgui"
  DOWNLOAD_ONLY
  )
gt_add_package(glm "git@github.com:g-truc/glm.git" GIT_TAG "6ad79aae" DOWNLOAD_ONLY) # 2021.9.2
gt_add_package(benchmark "git@github.com:google/benchmark.git" GIT_TAG "v1.5.6" DOWNLOAD_ONLY)
gt_add_package(ceres-solver "git@github.com:ceres-solver/ceres-solver.git" GIT_TAG "09ec499"
  CMAKE_ARGS "-DBUILD_TESTING=OFF"
  CMAKE_ARGS "-DBUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DBUILD_BENCHMARKS=OFF"
  CMAKE_ARGS "-DMINIGLOG=ON"
  ) # 2022.2.18
# gt_add_package(FlameGraph "git@github.com:brendangregg/FlameGraph.git" "810687f" DOWNLOAD_ONLY)
gt_add_package(geometry-central "git@github.com:nmwsharp/geometry-central.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(glad "git@github.com:LamKamhang/glad.git" GIT_TAG "6ee1551" DOWNLOAD_ONLY)
gt_add_package(IPC "git@github.com:ipc-sim/IPC.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
# gt_add_package(nonmanifold-laplacian "git@github.com:nmwsharp/nonmanifold-laplacian.git" "origin/master" DOWNLOAD_ONLY)
gt_add_package(onedrive "git@github.com:abraunegg/onedrive.git" GIT_TAG "v2.4.19" DOWNLOAD_ONLY)
gt_add_package(penrose "git@github.com:penrose/penrose.git" GIT_TAG "f56d55f5" DOWNLOAD_ONLY)
gt_add_package(polyscope "git@github.com:nmwsharp/polyscope.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(qt-mvvm "git@github.com:gpospelov/qt-mvvm.git" GIT_TAG "59f8083e" DOWNLOAD_ONLY)
gt_add_package(rectpack2D "git@github.com:TeamHypersomnia/rectpack2D.git" GIT_TAG "9c7fe5d" DOWNLOAD_ONLY)
# gt_add_package(sage "git://trac.sagemath.org/sage.git" "53285707f0" DOWNLOAD_ONLY)
gt_add_package(stb "git@github.com:nothings/stb.git" GIT_TAG "c0c9826" DOWNLOAD_ONLY)
# gt_add_package(Ipopt "git@github.com:coin-or/Ipopt.git" "releases/3.14.5" DOWNLOAD_ONLY)
# gt_add_package(ThirdParty-ASL "git@github.com:coin-or-tools/ThirdParty-ASL.git" "releases/2.0.0" DOWNLOAD_ONLY)
# gt_add_package(ThirdParty-HSL "git@github.com:coin-or-tools/ThirdParty-HSL.git" "9d85805" DOWNLOAD_ONLY) # releases/2.2.1
# gt_add_package(ThirdParty-Metis "git@github.com:coin-or-tools/ThirdParty-Metis.git" "releases/2.0.0" DOWNLOAD_ONLY)
# gt_add_package(ThirdParty-Mumps "git@github.com:coin-or-tools/ThirdParty-Mumps.git" "releases/3.0.2" DOWNLOAD_ONLY)
gt_add_package(Ipopt "git@github.com:LamKamhang/Ipopt-cmake-wrapper.git" GIT_TAG "origin/master")
gt_add_package(variational-surface-cutting "git@github.com:nmwsharp/variational-surface-cutting.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(imgui "git@github.com:ocornut/imgui.git" GIT_TAG "v1.84.2"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/imgui_wrapper/imgui"
  DOWNLOAD_ONLY
  )
gt_add_package(CoMISo "https://www.graphics.rwth-aachen.de:9000/CoMISo/CoMISo.git" GIT_TAG "49a044a"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/CoMISo_wrapper/CoMISo"
  DOWNLOAD_ONLY
  )
gt_add_package(apic2d "git@github.com:nepluno/apic2d.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(elmerfem "git@github.com:ElmerCSC/elmerfem.git" GIT_TAG "origin/devel" DOWNLOAD_ONLY)
gt_add_package(femus "git@github.com:FeMTTU/femus.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(nanoflann "git@github.com:jlblancoc/nanoflann.git" GIT_TAG "v1.4.2")
gt_add_package(raytracing.github.io "git@github.com:RayTracing/raytracing.github.io.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
# gt_add_package(jiong-group-seminar "ssh://git@ryon.ren:10022/JiongCHEN/group-seminar.git" "origin/master" DOWNLOAD_ONLY)
gt_add_package(pardiso "git@github.com:LamKamhang/pardiso.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(pagmo2 "git@github.com:esa/pagmo2.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(pygmo2 "git@github.com:esa/pygmo2.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(heyoka "git@github.com:bluescarni/heyoka.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(ARCSim "http://graphics.berkeley.edu/resources/ARCSim/arcsim-0.3.1.tar.gz" DOWNLOAD_ONLY)
gt_add_package(CPM.cmake "git@github.com:cpm-cmake/CPM.cmake.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(MeshFEM "git@github.com:MeshFEM/MeshFEM.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(osqp "git@github.com:osqp/osqp.git" GIT_TAG "1a2f2d32")
gt_add_package(OsqpEigen "git@github.com:robotology/osqp-eigen.git" GIT_TAG "v0.7.0")
gt_add_package(osqp-cpp "git@github.com:google/osqp-cpp.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(alglib "git@github.com:LamKamhang/alglib-cmake-wrapper.git" GIT_TAG "origin/master")
gt_add_package(wechat-uos "https://aur.archlinux.org/wechat-uos.git" GIT_TAG "ae476e0" DOWNLOAD_ONLY)
gt_add_package(ifopt "git@github.com:ethz-adrl/ifopt.git" GIT_TAG "2.1.3" DOWNLOAD_ONLY)
gt_add_package(bogus "https://bitbucket.org/gdaviet/so-bogus.git" GIT_TAG "origin/master"
  CMAKE_ARGS "-DTESTS=OFF"
  CMAKE_ARGS "-DAPPS=OFF"
  CMAKE_ARGS "-DCPP11=ON"
)
gt_add_package(elasty "git@github.com:yuki-koyama/elasty.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
gt_add_package(sofa "git@github.com:sofa-framework/sofa.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
