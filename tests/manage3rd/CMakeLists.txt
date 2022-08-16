cmake_minimum_required(VERSION 3.12)

project(manage3rd)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/../../)
include(utility)

add_custom_target(update_all3rd)
add_custom_target(build_all3rd)
add_custom_target(install_all3rd)

add_package(OpenVolumeMesh "ssh://git@ryon.ren:10022/mirrors/OpenVolumeMesh.git" GIT_TAG "v2.1")
add_package(amgcl "git@github.com:ddemidov/amgcl.git" GIT_TAG "1.4.3")
add_package(assimp "git@github.com:assimp/assimp.git" GIT_TAG "v5.2.3")
add_package(Catch2 "ssh://git@ryon.ren:10022/mirrors/Catch2.git"  GIT_TAG "v2.13.7"
  CMAKE_ARGS "-DCATCH_BUILD_TESTING=OFF"
  CMAKE_ARGS "-DCATCH_INSTALL_DOCS=OFF"
  )
add_package(Eigen3   "ssh://git@ryon.ren:10022/mirrors/eigen3.git" GIT_TAG "3.4.0"
  CMAKE_ARGS "-DEIGEN_BUILD_DOC=OFF"
  CMAKE_ARGS "-DBUILD_TESTING=OFF"
  )
add_package(autodiff "ssh://git@ryon.ren:10022/mirrors/autodiff.git" GIT_TAG "v0.6.8"
  CMAKE_ARGS "-DAUTODIFF_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_PYTHON=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DAUTODIFF_BUILD_DOCS=OFF"
  )
add_package(bullet3 "git@github.com:bulletphysics/bullet3.git" GIT_TAG "3.17")
add_package(cgal "git@github.com:CGAL/cgal.git" GIT_TAG "v5.4")
add_package(CLI11 "ssh://git@ryon.ren:10022/mirrors/CLI11.git" GIT_TAG "v2.2.0"
  CMAKE_ARGS "-DCLI11_BUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_TESTS=OFF"
  CMAKE_ARGS "-DCLI11_BUILD_DOCS=OFF"
  )
add_package(fmt "ssh://git@ryon.ren:10022/mirrors/fmt.git" GIT_TAG "8.0.1")
add_package(glfw3 "ssh://git@ryon.ren:10022/mirrors/glfw.git" GIT_TAG "3.3.4")
add_package(OpenMesh "ssh://git@ryon.ren:10022/mirrors/OpenMesh.git" GIT_TAG "OpenMesh-8.1")
add_package(pybind11 "git@github.com:pybind/pybind11.git" GIT_TAG "v2.9.2"
  CMAKE_ARGS "-DPYBIND11_TEST=OFF"
  )
add_package(nlohmann_json "git@github.com:nlohmann/json.git" GIT_TAG "v3.10.5")
add_package(spdlog "ssh://git@ryon.ren:10022/mirrors/spdlog.git" GIT_TAG "v1.9.2")
add_package(Spectra "git@github.com:yixuan/spectra.git" GIT_TAG "v1.0.0")
add_package(LBFGSpp "ssh://git@ryon.ren:10022/mirrors/LBFGSpp.git" GIT_TAG "v0.1.0" DOWNLOAD_ONLY)
add_package(tinyobjloader "git@github.com:tinyobjloader/tinyobjloader.git" GIT_TAG "3e401b55a") # 2021.8.27
add_package(voro "git@github.com:chr1shr/voro.git" GIT_TAG "aa5f72233") # 2021.7.4
add_package(SuiteSparse "git@github.com:LamKamhang/suitesparse-wrapper.git" GIT_TAG  "b5977fb"
  CMAKE_ARGS "-DSHARED=ON"
  )
add_package(nlopt "git@github.com:stevengj/nlopt.git" GIT_TAG "304137ff") # 2021.7.19

add_package(Trilinos "git@github.com:trilinos/Trilinos.git" GIT_TAG "trilinos-release-13-0-1" DOWNLOAD_ONLY)
add_package(TriWild "https://github.com/wildmeshing/TriWild" GIT_TAG "d85ec7a" DOWNLOAD_ONLY)
add_package(TetWild "https://github.com/Yixin-Hu/TetWild" GIT_TAG "f6ca5d9" DOWNLOAD_ONLY)
add_package(fTetWild "git@github.com:wildmeshing/fTetWild.git" GIT_TAG "c0be02c" DOWNLOAD_ONLY)
add_package(ccls "git@github.com:MaskRay/ccls.git" GIT_TAG "0.20210330" DOWNLOAD_ONLY)
add_package(libigl  "ssh://git@ryon.ren:10022/mirrors/libigl.git"  GIT_TAG  "v2.3.0" DOWNLOAD_ONLY)
add_package(ImGuizmo "ssh://git@ryon.ren:10022/mirrors/ImGuizmo.git" GIT_TAG "8afa1d70"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/libigl/external/imguizmo"
  DOWNLOAD_ONLY
  )
add_package(libigl-imgui "ssh://git@ryon.ren:10022/mirrors/libigl-imgui.git" GIT_TAG "7e1053e7"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/libigl/external/libigl-imgui"
  DOWNLOAD_ONLY
  )
add_dependencies(update_ImGuizmo update_libigl)
add_dependencies(update_libigl-imgui update_libigl)

add_package(glm "git@github.com:g-truc/glm.git" GIT_TAG "6ad79aae" DOWNLOAD_ONLY) # 2021.9.2
add_package(benchmark "git@github.com:google/benchmark.git" GIT_TAG "v1.5.6" DOWNLOAD_ONLY)
add_package(ceres-solver "git@github.com:ceres-solver/ceres-solver.git" GIT_TAG "09ec499"
  CMAKE_ARGS "-DBUILD_TESTING=OFF"
  CMAKE_ARGS "-DBUILD_EXAMPLES=OFF"
  CMAKE_ARGS "-DBUILD_BENCHMARKS=OFF"
  CMAKE_ARGS "-DMINIGLOG=ON"
  ) # 2022.2.18
add_package(geometry-central "git@github.com:nmwsharp/geometry-central.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(glad "git@github.com:LamKamhang/glad.git" GIT_TAG "6ee1551" DOWNLOAD_ONLY)
add_package(IPC "git@github.com:ipc-sim/IPC.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(onedrive "git@github.com:abraunegg/onedrive.git" GIT_TAG "v2.4.19" DOWNLOAD_ONLY)
add_package(penrose "git@github.com:penrose/penrose.git" GIT_TAG "f56d55f5" DOWNLOAD_ONLY)
add_package(polyscope "git@github.com:nmwsharp/polyscope.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(qt-mvvm "git@github.com:gpospelov/qt-mvvm.git" GIT_TAG "59f8083e" DOWNLOAD_ONLY)
add_package(rectpack2D "git@github.com:TeamHypersomnia/rectpack2D.git" GIT_TAG "9c7fe5d" DOWNLOAD_ONLY)
add_package(stb "git@github.com:nothings/stb.git" GIT_TAG "c0c9826" DOWNLOAD_ONLY)
add_package(Ipopt "git@github.com:LamKamhang/Ipopt-cmake-wrapper.git" GIT_TAG "origin/master")
add_package(variational-surface-cutting "git@github.com:nmwsharp/variational-surface-cutting.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(imgui "git@github.com:ocornut/imgui.git" GIT_TAG "v1.84.2"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/imgui_wrapper/imgui"
  DOWNLOAD_ONLY
  )
add_package(CoMISo "https://www.graphics.rwth-aachen.de:9000/CoMISo/CoMISo.git" GIT_TAG "49a044a"
  SOURCE_DIR "${CMAKE_SOURCE_DIR}/3rd/CoMISo_wrapper/CoMISo"
  DOWNLOAD_ONLY
  )
add_package(apic2d "git@github.com:nepluno/apic2d.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(elmerfem "git@github.com:ElmerCSC/elmerfem.git" GIT_TAG "origin/devel" DOWNLOAD_ONLY)
add_package(femus "git@github.com:FeMTTU/femus.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(nanoflann "git@github.com:jlblancoc/nanoflann.git" GIT_TAG "v1.4.2"
  CMAKE_ARGS "-DNANOFLANN_BUILD_EXAMPLES=OFF"
  )
add_package(raytracing.github.io "git@github.com:RayTracing/raytracing.github.io.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(jiong-group-seminar "ssh://git@ryon.ren:10022/JiongCHEN/group-seminar.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(pardiso "git@github.com:LamKamhang/pardiso.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(pagmo2 "git@github.com:esa/pagmo2.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(pygmo2 "git@github.com:esa/pygmo2.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(heyoka "git@github.com:bluescarni/heyoka.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(ARCSim "http://graphics.berkeley.edu/resources/ARCSim/arcsim-0.3.1.tar.gz" DOWNLOAD_ONLY)
add_package(CPM.cmake "git@github.com:cpm-cmake/CPM.cmake.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(MeshFEM "git@github.com:MeshFEM/MeshFEM.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(osqp "git@github.com:osqp/osqp.git" GIT_TAG "1a2f2d32")
add_package(OsqpEigen "git@github.com:robotology/osqp-eigen.git" GIT_TAG "v0.7.0")
add_package(osqp-cpp "git@github.com:google/osqp-cpp.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(alglib "git@github.com:LamKamhang/alglib-cmake-wrapper.git" GIT_TAG "origin/master")
# add_package(wechat-uos "https://aur.archlinux.org/wechat-uos.git" GIT_TAG "ae476e0" DOWNLOAD_ONLY)
# add_package(ifopt "git@github.com:ethz-adrl/ifopt.git" GIT_TAG "2.1.3" DOWNLOAD_ONLY)
add_package(bogus "https://bitbucket.org/gdaviet/so-bogus.git" GIT_TAG "origin/master"
  CMAKE_ARGS "-DTESTS=OFF"
  CMAKE_ARGS "-DAPPS=OFF"
  CMAKE_ARGS "-DCPP11=ON"
)
add_package(elasty "git@github.com:yuki-koyama/elasty.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)
add_package(sofa "git@github.com:sofa-framework/sofa.git" GIT_TAG "origin/master" DOWNLOAD_ONLY)

add_package(AcceleratedQuadraticProxy
  "https://github.com/shaharkov/AcceleratedQuadraticProxy.git"
  GIT_TAG "origin/master"
  DOWNLOAD_ONLY)

add_package(admm-elastic
  "git@github.com:georgbrown/admm-elastic"
  GIT_TAG "origin/master"
  DOWNLOAD_ONLY
  )
add_package(AKVFParam
  "https://gh.gcdn.mirr.one/sebastian-claici/AKVFParam.git"
  GIT_TAG "origin/master"
  DOWNLOAD_ONLY)
add_package(AutoDef
  "git@github.com:lawsonfulton/AutoDef.git"
  GIT_TAG "origin/master"
  DOWNLOAD_ONLY)
add_package(Blender-FLIP-Fluids
  "git@github.com:rlguy/Blender-FLIP-Fluids.git"
  GIT_TAG "origin/master"
    DOWNLOAD_ONLY)
  add_package(caches
    "git@github.com:vpetrigo/caches.git"
  GIT_TAG "origin/master"
  DOWNLOAD_ONLY)
# add_package(ChainSimulation DOWNLOAD_ONLY)
# add_package(CoMISo_wrapper DOWNLOAD_ONLY)
# add_package(CompMajor DOWNLOAD_ONLY)
# add_package(csb DOWNLOAD_ONLY)
# add_package(Directional DOWNLOAD_ONLY)
# add_package(entt DOWNLOAD_ONLY)
# add_package(FastCorotatedFEM DOWNLOAD_ONLY)
# add_package(Fildem DOWNLOAD_ONLY)
# add_package(GeoSimMono.jl DOWNLOAD_ONLY)
# add_package(GLSL-PathTracer DOWNLOAD_ONLY)
# add_package(HairSimulation DOWNLOAD_ONLY)
# add_package(HexaLab DOWNLOAD_ONLY)
# add_package(hsc-code DOWNLOAD_ONLY)
# add_package(HybridRenderingEngine DOWNLOAD_ONLY)
# add_package(jsoncpp DOWNLOAD_ONLY)
# add_package(KnittingShortRows2021 DOWNLOAD_ONLY)
# add_package(nonmanifold-laplacian DOWNLOAD_ONLY)
# add_package(NvCloth DOWNLOAD_ONLY)
# add_package(OpenGL_Fundamentals DOWNLOAD_ONLY)
# add_package(PBD DOWNLOAD_ONLY)
# add_package(PositionBasedDynamics DOWNLOAD_ONLY)
# add_package(progressive_embedding DOWNLOAD_ONLY)
# add_package(progressive_parametrization DOWNLOAD_ONLY)
# add_package(protobuf DOWNLOAD_ONLY)
# add_package(pytorch-beginner DOWNLOAD_ONLY)
# add_package(rapidjson DOWNLOAD_ONLY)
# add_package(ray-tracing-cuda DOWNLOAD_ONLY)
# add_package(Remesh-trunk DOWNLOAD_ONLY)
# add_package(Scalable-Locally-Injective-Mappings DOWNLOAD_ONLY)
# add_package(sequential-gallery DOWNLOAD_ONLY)
# add_package(sequential-line-search DOWNLOAD_ONLY)
# add_package(SJDXQcourseware DOWNLOAD_ONLY)
# add_package(SPlisHSPlasH DOWNLOAD_ONLY)
# add_package(tetgen DOWNLOAD_ONLY)
# add_package(wrapd DOWNLOAD_ONLY)
# add_package(wrapd-2d DOWNLOAD_ONLY)
# add_package(ZJU-nCov-Hitcarder DOWNLOAD_ONLY)
