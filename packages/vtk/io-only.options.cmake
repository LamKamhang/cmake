set(vtk_DEFAULT_OPTIONS
  "VTK_GROUP_ENABLE_Imaging NO"
  "VTK_GROUP_ENABLE_MPI NO"
  "VTK_GROUP_ENABLE_Qt NO"
  "VTK_GROUP_ENABLE_Rendering NO"
  "VTK_GROUP_ENABLE_StandAlone NO"
  "VTK_GROUP_ENABLE_Web NO"
  "VTK_GROUP_ENABLE_Views NO"
  "VTK_WHEEL_BUILD OFF"
  "VTK_ENABLE_WARPPING OFF"
  "VTK_ENABLE_LOGGING OFF"
  "VTK_ENABLE_REMOTE_MODULES OFF"
  "VTK_BUILD_TESTING OFF"
  "VTK_WRAP_PYTHON OFF"
  "VTK_WRAP_JAVA OFF"
  "VTK_USE_X OFF"
  "VTK_USE_TK OFF"
  "VTK_USE_MPI OFF"
  "VTK_SMP_ENABLE_STDTHREAD OFF"
  "VTK_SMP_IMPLEMENTATION_TYPE Sequential"
  #No help, variable specified on the command line.
  "VTK_MODULE_ENABLE_VTK_AcceleratorsVTKmCore DONT_WANT"

  #Enable the VTK::AcceleratorsVTKmDataModel module. VTKm data structures
  "VTK_MODULE_ENABLE_VTK_AcceleratorsVTKmDataModel DONT_WANT"

  #Enable the VTK::AcceleratorsVTKmFilters module. VTKm filters
  # and algorithms
  "VTK_MODULE_ENABLE_VTK_AcceleratorsVTKmFilters DONT_WANT"

  #Enable the VTK::ChartsCore module. Charts and plots
  "VTK_MODULE_ENABLE_VTK_ChartsCore DONT_WANT"

  #Enable the VTK::CommonArchive module.
  "VTK_MODULE_ENABLE_VTK_CommonArchive DONT_WANT"

  #Enable the VTK::CommonColor module. Color palette and named color
  # support classes
  "VTK_MODULE_ENABLE_VTK_CommonColor DONT_WANT"

  #Enable the VTK::CommonComputationalGeometry module. Parametric
  # splines and curves
  "VTK_MODULE_ENABLE_VTK_CommonComputationalGeometry DONT_WANT"

  #Enable the VTK::CommonCore module. The base VTK library
  "VTK_MODULE_ENABLE_VTK_CommonCore DONT_WANT"

  #Enable the VTK::CommonDataModel module. Core data types
  "VTK_MODULE_ENABLE_VTK_CommonDataModel DONT_WANT"

  #Enable the VTK::CommonExecutionModel module. Core algorithms
  # and execution
  "VTK_MODULE_ENABLE_VTK_CommonExecutionModel DONT_WANT"

  #Enable the VTK::CommonMath module. Linear algebra types
  "VTK_MODULE_ENABLE_VTK_CommonMath DONT_WANT"

  #Enable the VTK::CommonMisc module. Assorted utility classes
  "VTK_MODULE_ENABLE_VTK_CommonMisc DONT_WANT"

  #Enable the VTK::CommonSystem module. Filesystem and networking
  # support
  "VTK_MODULE_ENABLE_VTK_CommonSystem DONT_WANT"

  #Enable the VTK::CommonTransforms module. Linear algebra transformations
  "VTK_MODULE_ENABLE_VTK_CommonTransforms DONT_WANT"

  #Enable the VTK::DICOMParser module.
  "VTK_MODULE_ENABLE_VTK_DICOMParser DONT_WANT"

  #Enable the VTK::DomainsChemistry module. Algorithms used in chemistry
  "VTK_MODULE_ENABLE_VTK_DomainsChemistry DONT_WANT"

  #Enable the VTK::DomainsChemistryOpenGL2 module. OpenGL support
  # for chemistry data
  "VTK_MODULE_ENABLE_VTK_DomainsChemistryOpenGL2 DONT_WANT"

  #Enable the VTK::DomainsMicroscopy module. File readers for microscopy
  # file formats
  "VTK_MODULE_ENABLE_VTK_DomainsMicroscopy DONT_WANT"

  #Enable the VTK::DomainsParallelChemistry module. Parallel versions
  # of algorithms used in chemistry
  "VTK_MODULE_ENABLE_VTK_DomainsParallelChemistry DONT_WANT"

  #Enable the VTK::FiltersAMR module. Adaptive mesh refinement filters
  # and algorithms
  "VTK_MODULE_ENABLE_VTK_FiltersAMR DONT_WANT"

  #Enable the VTK::FiltersCore module. Common filters for VTK data
  # types
  "VTK_MODULE_ENABLE_VTK_FiltersCore DONT_WANT"

  #Enable the VTK::FiltersExtraction module. Filters for selecting
  # subsets data
  "VTK_MODULE_ENABLE_VTK_FiltersExtraction DONT_WANT"

  #Enable the VTK::FiltersFlowPaths module. Filters and algorithms
  # for streamlines
  "VTK_MODULE_ENABLE_VTK_FiltersFlowPaths DONT_WANT"

  #Enable the VTK::FiltersGeneral module. Filters for transforming
  # data
  "VTK_MODULE_ENABLE_VTK_FiltersGeneral DONT_WANT"

  #Enable the VTK::FiltersGeneric module. Filters for selecting
  # subsets of data at arbitrary points
  "VTK_MODULE_ENABLE_VTK_FiltersGeneric DONT_WANT"

  #Enable the VTK::FiltersGeometry module. Geometric transformation
  # filters
  "VTK_MODULE_ENABLE_VTK_FiltersGeometry DONT_WANT"

  #Enable the VTK::FiltersHybrid module.
  "VTK_MODULE_ENABLE_VTK_FiltersHybrid DONT_WANT"

  #Enable the VTK::FiltersHyperTree module. Hypertree filters and
  # algorithms
  "VTK_MODULE_ENABLE_VTK_FiltersHyperTree DONT_WANT"

  #Enable the VTK::FiltersImaging module. Filters and algorithms
  # for images
  "VTK_MODULE_ENABLE_VTK_FiltersImaging DONT_WANT"

  #Enable the VTK::FiltersModeling module.
  "VTK_MODULE_ENABLE_VTK_FiltersModeling DONT_WANT"

  #Enable the VTK::FiltersOpenTURNS module.
  "VTK_MODULE_ENABLE_VTK_FiltersOpenTURNS DONT_WANT"

  #Enable the VTK::FiltersParallel module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallel DONT_WANT"

  #Enable the VTK::FiltersParallelDIY2 module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallelDIY2 DONT_WANT"

  #Enable the VTK::FiltersParallelFlowPaths module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallelFlowPaths DONT_WANT"

  #Enable the VTK::FiltersParallelGeometry module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallelGeometry DONT_WANT"

  #Enable the VTK::FiltersParallelImaging module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallelImaging DONT_WANT"

  #Enable the VTK::FiltersParallelMPI module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallelMPI DONT_WANT"

  #Enable the VTK::FiltersParallelStatistics module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallelStatistics DONT_WANT"

  #Enable the VTK::FiltersParallelVerdict module.
  "VTK_MODULE_ENABLE_VTK_FiltersParallelVerdict DONT_WANT"

  #Enable the VTK::FiltersPoints module.
  "VTK_MODULE_ENABLE_VTK_FiltersPoints DONT_WANT"

  #Enable the VTK::FiltersProgrammable module.
  "VTK_MODULE_ENABLE_VTK_FiltersProgrammable DONT_WANT"

  #Enable the VTK::FiltersReebGraph module.
  "VTK_MODULE_ENABLE_VTK_FiltersReebGraph DONT_WANT"

  #Enable the VTK::FiltersSMP module.
  "VTK_MODULE_ENABLE_VTK_FiltersSMP DONT_WANT"

  #Enable the VTK::FiltersSelection module.
  "VTK_MODULE_ENABLE_VTK_FiltersSelection DONT_WANT"

  #Enable the VTK::FiltersSources module.
  "VTK_MODULE_ENABLE_VTK_FiltersSources DONT_WANT"

  #Enable the VTK::FiltersStatistics module.
  "VTK_MODULE_ENABLE_VTK_FiltersStatistics DONT_WANT"

  #Enable the VTK::FiltersTexture module.
  "VTK_MODULE_ENABLE_VTK_FiltersTexture DONT_WANT"

  #Enable the VTK::FiltersTopology module.
  "VTK_MODULE_ENABLE_VTK_FiltersTopology DONT_WANT"

  #Enable the VTK::FiltersVerdict module.
  "VTK_MODULE_ENABLE_VTK_FiltersVerdict DONT_WANT"

  #Enable the VTK::GUISupportQt module.
  "VTK_MODULE_ENABLE_VTK_GUISupportQt DONT_WANT"

  #Enable the VTK::GUISupportQtQuick module.
  "VTK_MODULE_ENABLE_VTK_GUISupportQtQuick DONT_WANT"

  #Enable the VTK::GUISupportQtSQL module.
  "VTK_MODULE_ENABLE_VTK_GUISupportQtSQL DONT_WANT"

  #Enable the VTK::GeovisCore module.
  "VTK_MODULE_ENABLE_VTK_GeovisCore DONT_WANT"

  #Enable the VTK::GeovisGDAL module.
  "VTK_MODULE_ENABLE_VTK_GeovisGDAL DONT_WANT"

  #Enable the VTK::IOADIOS2 module.
  "VTK_MODULE_ENABLE_VTK_IOADIOS2 DONT_WANT"

  #Enable the VTK::IOAMR module.
  "VTK_MODULE_ENABLE_VTK_IOAMR DONT_WANT"

  #Enable the VTK::IOAsynchronous module.
  "VTK_MODULE_ENABLE_VTK_IOAsynchronous DONT_WANT"

  #Enable the VTK::IOCGNSReader module.
  "VTK_MODULE_ENABLE_VTK_IOCGNSReader DONT_WANT"

  #Enable the VTK::IOCONVERGECFD module.
  "VTK_MODULE_ENABLE_VTK_IOCONVERGECFD DONT_WANT"

  #Enable the VTK::IOChemistry module. File readers used in chemistry
  "VTK_MODULE_ENABLE_VTK_IOChemistry DONT_WANT"

  #Enable the VTK::IOCityGML module.
  "VTK_MODULE_ENABLE_VTK_IOCityGML DONT_WANT"

  #Enable the VTK::IOCore module.
  "VTK_MODULE_ENABLE_VTK_IOCore DONT_WANT"

  #Enable the VTK::IOEnSight module.
  "VTK_MODULE_ENABLE_VTK_IOEnSight DONT_WANT"

  #Enable the VTK::IOExodus module.
  "VTK_MODULE_ENABLE_VTK_IOExodus DONT_WANT"

  #Enable the VTK::IOExport module.
  "VTK_MODULE_ENABLE_VTK_IOExport DONT_WANT"

  #Enable the VTK::IOExportGL2PS module.
  "VTK_MODULE_ENABLE_VTK_IOExportGL2PS DONT_WANT"

  #Enable the VTK::IOExportPDF module.
  "VTK_MODULE_ENABLE_VTK_IOExportPDF DONT_WANT"

  #Enable the VTK::IOFFMPEG module.
  "VTK_MODULE_ENABLE_VTK_IOFFMPEG DONT_WANT"

  #Enable the VTK::IOFides module. The base Fides reader library
  "VTK_MODULE_ENABLE_VTK_IOFides DONT_WANT"

  #Enable the VTK::IOGDAL module.
  "VTK_MODULE_ENABLE_VTK_IOGDAL DONT_WANT"

  #Enable the VTK::IOGeoJSON module.
  "VTK_MODULE_ENABLE_VTK_IOGeoJSON DONT_WANT"

  #Enable the VTK::IOGeometry module.
  "VTK_MODULE_ENABLE_VTK_IOGeometry DONT_WANT"

  #Enable the VTK::IOH5Rage module.
  "VTK_MODULE_ENABLE_VTK_IOH5Rage DONT_WANT"

  #Enable the VTK::IOH5part module.
  "VTK_MODULE_ENABLE_VTK_IOH5part DONT_WANT"

  #Enable the VTK::IOHDF module.
  "VTK_MODULE_ENABLE_VTK_IOHDF DONT_WANT"

  #Enable the VTK::IOIOSS module.
  "VTK_MODULE_ENABLE_VTK_IOIOSS DONT_WANT"

  #Enable the VTK::IOImage module.
  "VTK_MODULE_ENABLE_VTK_IOImage DONT_WANT"

  #Enable the VTK::IOImport module.
  "VTK_MODULE_ENABLE_VTK_IOImport DONT_WANT"

  #Enable the VTK::IOInfovis module.
  "VTK_MODULE_ENABLE_VTK_IOInfovis DONT_WANT"

  #Enable the VTK::IOLAS module.
  "VTK_MODULE_ENABLE_VTK_IOLAS DONT_WANT"

  #Enable the VTK::IOLSDyna module.
  "VTK_MODULE_ENABLE_VTK_IOLSDyna DONT_WANT"

  #Enable the VTK::IOLegacy module.
  "VTK_MODULE_ENABLE_VTK_IOLegacy WANT"

  #Enable the VTK::IOMINC module.
  "VTK_MODULE_ENABLE_VTK_IOMINC DONT_WANT"

  #Enable the VTK::IOMPIImage module.
  "VTK_MODULE_ENABLE_VTK_IOMPIImage DONT_WANT"

  #Enable the VTK::IOMPIParallel module.
  "VTK_MODULE_ENABLE_VTK_IOMPIParallel DONT_WANT"

  #Enable the VTK::IOMotionFX module.
  "VTK_MODULE_ENABLE_VTK_IOMotionFX DONT_WANT"

  #Enable the VTK::IOMovie module.
  "VTK_MODULE_ENABLE_VTK_IOMovie DONT_WANT"

  #Enable the VTK::IOMySQL module.
  "VTK_MODULE_ENABLE_VTK_IOMySQL DONT_WANT"

  #Enable the VTK::IONetCDF module.
  "VTK_MODULE_ENABLE_VTK_IONetCDF DONT_WANT"

  #Enable the VTK::IOODBC module.
  "VTK_MODULE_ENABLE_VTK_IOODBC DONT_WANT"

  #Enable the VTK::IOOMF module. The base OMF Reader library
  "VTK_MODULE_ENABLE_VTK_IOOMF DONT_WANT"

  #Enable the VTK::IOOggTheora module.
  "VTK_MODULE_ENABLE_VTK_IOOggTheora DONT_WANT"

  #Enable the VTK::IOOpenVDB module.
  "VTK_MODULE_ENABLE_VTK_IOOpenVDB DONT_WANT"

  #Enable the VTK::IOPDAL module.
  "VTK_MODULE_ENABLE_VTK_IOPDAL DONT_WANT"

  #Enable the VTK::IOPIO module.
  "VTK_MODULE_ENABLE_VTK_IOPIO DONT_WANT"

  #Enable the VTK::IOPLY module.
  "VTK_MODULE_ENABLE_VTK_IOPLY DONT_WANT"

  #Enable the VTK::IOParallel module.
  "VTK_MODULE_ENABLE_VTK_IOParallel DONT_WANT"

  #Enable the VTK::IOParallelExodus module.
  "VTK_MODULE_ENABLE_VTK_IOParallelExodus DONT_WANT"

  #Enable the VTK::IOParallelLSDyna module.
  "VTK_MODULE_ENABLE_VTK_IOParallelLSDyna DONT_WANT"

  #Enable the VTK::IOParallelNetCDF module.
  "VTK_MODULE_ENABLE_VTK_IOParallelNetCDF DONT_WANT"

  #Enable the VTK::IOParallelXML module.
  "VTK_MODULE_ENABLE_VTK_IOParallelXML WANT"

  #Enable the VTK::IOParallelXdmf3 module.
  "VTK_MODULE_ENABLE_VTK_IOParallelXdmf3 DONT_WANT"

  #Enable the VTK::IOPostgreSQL module.
  "VTK_MODULE_ENABLE_VTK_IOPostgreSQL DONT_WANT"

  #Enable the VTK::IOSQL module.
  "VTK_MODULE_ENABLE_VTK_IOSQL DONT_WANT"

  #Enable the VTK::IOSegY module.
  "VTK_MODULE_ENABLE_VTK_IOSegY DONT_WANT"

  #Enable the VTK::IOTRUCHAS module.
  "VTK_MODULE_ENABLE_VTK_IOTRUCHAS DONT_WANT"

  #Enable the VTK::IOTecplotTable module.
  "VTK_MODULE_ENABLE_VTK_IOTecplotTable DONT_WANT"

  #Enable the VTK::IOVPIC module.
  "VTK_MODULE_ENABLE_VTK_IOVPIC DONT_WANT"

  #Enable the VTK::IOVeraOut module.
  "VTK_MODULE_ENABLE_VTK_IOVeraOut DONT_WANT"

  #Enable the VTK::IOVideo module.
  "VTK_MODULE_ENABLE_VTK_IOVideo DONT_WANT"

  #Enable the VTK::IOXML module.
  "VTK_MODULE_ENABLE_VTK_IOXML DONT_WANT"

  #Enable the VTK::IOXMLParser module.
  "VTK_MODULE_ENABLE_VTK_IOXMLParser DONT_WANT"

  #Enable the VTK::IOXdmf2 module.
  "VTK_MODULE_ENABLE_VTK_IOXdmf2 DONT_WANT"

  #Enable the VTK::IOXdmf3 module.
  "VTK_MODULE_ENABLE_VTK_IOXdmf3 DONT_WANT"

  #Enable the VTK::ImagingColor module.
  "VTK_MODULE_ENABLE_VTK_ImagingColor DONT_WANT"

  #Enable the VTK::ImagingCore module.
  "VTK_MODULE_ENABLE_VTK_ImagingCore DONT_WANT"

  #Enable the VTK::ImagingFourier module.
  "VTK_MODULE_ENABLE_VTK_ImagingFourier DONT_WANT"

  #Enable the VTK::ImagingGeneral module.
  "VTK_MODULE_ENABLE_VTK_ImagingGeneral DONT_WANT"

  #Enable the VTK::ImagingHybrid module.
  "VTK_MODULE_ENABLE_VTK_ImagingHybrid DONT_WANT"

  #Enable the VTK::ImagingMath module.
  "VTK_MODULE_ENABLE_VTK_ImagingMath DONT_WANT"

  #Enable the VTK::ImagingMorphological module.
  "VTK_MODULE_ENABLE_VTK_ImagingMorphological DONT_WANT"

  #Enable the VTK::ImagingOpenGL2 module.
  "VTK_MODULE_ENABLE_VTK_ImagingOpenGL2 DONT_WANT"

  #Enable the VTK::ImagingSources module.
  "VTK_MODULE_ENABLE_VTK_ImagingSources DONT_WANT"

  #Enable the VTK::ImagingStatistics module.
  "VTK_MODULE_ENABLE_VTK_ImagingStatistics DONT_WANT"

  #Enable the VTK::ImagingStencil module.
  "VTK_MODULE_ENABLE_VTK_ImagingStencil DONT_WANT"

  #Enable the VTK::InfovisBoost module.
  "VTK_MODULE_ENABLE_VTK_InfovisBoost DONT_WANT"

  #Enable the VTK::InfovisBoostGraphAlgorithms module.
  "VTK_MODULE_ENABLE_VTK_InfovisBoostGraphAlgorithms DONT_WANT"

  #Enable the VTK::InfovisCore module.
  "VTK_MODULE_ENABLE_VTK_InfovisCore DONT_WANT"

  #Enable the VTK::InfovisLayout module.
  "VTK_MODULE_ENABLE_VTK_InfovisLayout DONT_WANT"

  #Enable the VTK::InteractionImage module.
  "VTK_MODULE_ENABLE_VTK_InteractionImage DONT_WANT"

  #Enable the VTK::InteractionStyle module.
  "VTK_MODULE_ENABLE_VTK_InteractionStyle DONT_WANT"

  #Enable the VTK::InteractionWidgets module.
  "VTK_MODULE_ENABLE_VTK_InteractionWidgets DONT_WANT"

  #Enable the VTK::ParallelCore module.
  "VTK_MODULE_ENABLE_VTK_ParallelCore DONT_WANT"

  #Enable the VTK::ParallelDIY module. DIY utility classes to simplify
  # DIY-based filters
  "VTK_MODULE_ENABLE_VTK_ParallelDIY DONT_WANT"

  #Enable the VTK::ParallelMPI module.
  "VTK_MODULE_ENABLE_VTK_ParallelMPI DONT_WANT"

  #Enable the VTK::PythonInterpreter module.
  "VTK_MODULE_ENABLE_VTK_PythonInterpreter DONT_WANT"

  #Enable the VTK::RenderingAnnotation module.
  "VTK_MODULE_ENABLE_VTK_RenderingAnnotation DONT_WANT"

  #Enable the VTK::RenderingContext2D module.
  "VTK_MODULE_ENABLE_VTK_RenderingContext2D DONT_WANT"

  #Enable the VTK::RenderingContextOpenGL2 module.
  "VTK_MODULE_ENABLE_VTK_RenderingContextOpenGL2 DONT_WANT"

  #Enable the VTK::RenderingCore module.
  "VTK_MODULE_ENABLE_VTK_RenderingCore DONT_WANT"

  #Enable the VTK::RenderingExternal module.
  "VTK_MODULE_ENABLE_VTK_RenderingExternal DONT_WANT"

  #Enable the VTK::RenderingFFMPEGOpenGL2 module.
  "VTK_MODULE_ENABLE_VTK_RenderingFFMPEGOpenGL2 DONT_WANT"

  #Enable the VTK::RenderingFreeType module.
  "VTK_MODULE_ENABLE_VTK_RenderingFreeType DONT_WANT"

  #Enable the VTK::RenderingFreeTypeFontConfig module.
  "VTK_MODULE_ENABLE_VTK_RenderingFreeTypeFontConfig DONT_WANT"

  #Enable the VTK::RenderingGL2PSOpenGL2 module.
  "VTK_MODULE_ENABLE_VTK_RenderingGL2PSOpenGL2 DONT_WANT"

  #Enable the VTK::RenderingImage module.
  "VTK_MODULE_ENABLE_VTK_RenderingImage DONT_WANT"

  #Enable the VTK::RenderingLICOpenGL2 module.
  "VTK_MODULE_ENABLE_VTK_RenderingLICOpenGL2 DONT_WANT"

  #Enable the VTK::RenderingLOD module.
  "VTK_MODULE_ENABLE_VTK_RenderingLOD DONT_WANT"

  #Enable the VTK::RenderingLabel module.
  "VTK_MODULE_ENABLE_VTK_RenderingLabel DONT_WANT"

  #Enable the VTK::RenderingMatplotlib module.
  "VTK_MODULE_ENABLE_VTK_RenderingMatplotlib DONT_WANT"

  #Enable the VTK::RenderingOpenGL2 module.
  "VTK_MODULE_ENABLE_VTK_RenderingOpenGL2 DONT_WANT"

  #Enable the VTK::RenderingOpenVR module.
  "VTK_MODULE_ENABLE_VTK_RenderingOpenVR DONT_WANT"

  #Enable the VTK::RenderingParallel module.
  "VTK_MODULE_ENABLE_VTK_RenderingParallel DONT_WANT"

  #Enable the VTK::RenderingParallelLIC module.
  "VTK_MODULE_ENABLE_VTK_RenderingParallelLIC DONT_WANT"

  #Enable the VTK::RenderingQt module.
  "VTK_MODULE_ENABLE_VTK_RenderingQt DONT_WANT"

  #Enable the VTK::RenderingRayTracing module.
  "VTK_MODULE_ENABLE_VTK_RenderingRayTracing DONT_WANT"

  #Enable the VTK::RenderingSceneGraph module.
  "VTK_MODULE_ENABLE_VTK_RenderingSceneGraph DONT_WANT"

  #Enable the VTK::RenderingUI module.
  "VTK_MODULE_ENABLE_VTK_RenderingUI DONT_WANT"

  #Enable the VTK::RenderingVR module.
  "VTK_MODULE_ENABLE_VTK_RenderingVR DONT_WANT"

  #Enable the VTK::RenderingVolume module.
  "VTK_MODULE_ENABLE_VTK_RenderingVolume DONT_WANT"

  #Enable the VTK::RenderingVolumeAMR module.
  "VTK_MODULE_ENABLE_VTK_RenderingVolumeAMR DONT_WANT"

  #Enable the VTK::RenderingVolumeOpenGL2 module.
  "VTK_MODULE_ENABLE_VTK_RenderingVolumeOpenGL2 DONT_WANT"

  #Enable the VTK::RenderingVtkJS module.
  "VTK_MODULE_ENABLE_VTK_RenderingVtkJS DONT_WANT"

  #Enable the VTK::TestingCore module.
  "VTK_MODULE_ENABLE_VTK_TestingCore DONT_WANT"

  #Enable the VTK::TestingGenericBridge module.
  "VTK_MODULE_ENABLE_VTK_TestingGenericBridge DONT_WANT"

  #Enable the VTK::TestingIOSQL module.
  "VTK_MODULE_ENABLE_VTK_TestingIOSQL DONT_WANT"

  #Enable the VTK::TestingRendering module.
  "VTK_MODULE_ENABLE_VTK_TestingRendering DONT_WANT"

  #Enable the VTK::UtilitiesBenchmarks module.
  "VTK_MODULE_ENABLE_VTK_UtilitiesBenchmarks DONT_WANT"

  #Enable the VTK::ViewsContext2D module.
  "VTK_MODULE_ENABLE_VTK_ViewsContext2D DONT_WANT"

  #Enable the VTK::ViewsCore module.
  "VTK_MODULE_ENABLE_VTK_ViewsCore DONT_WANT"

  #Enable the VTK::ViewsInfovis module.
  "VTK_MODULE_ENABLE_VTK_ViewsInfovis DONT_WANT"

  #Enable the VTK::ViewsQt module.
  "VTK_MODULE_ENABLE_VTK_ViewsQt DONT_WANT"

  #Enable the VTK::WebCore module.
  "VTK_MODULE_ENABLE_VTK_WebCore DONT_WANT"

  #Enable the VTK::WebGLExporter module.
  "VTK_MODULE_ENABLE_VTK_WebGLExporter DONT_WANT"

  #Enable the VTK::WrappingPythonCore module.
  "VTK_MODULE_ENABLE_VTK_WrappingPythonCore DONT_WANT"

  #Enable the VTK::WrappingTools module.
  "VTK_MODULE_ENABLE_VTK_WrappingTools DONT_WANT"

  #Enable the VTK::cgns module.
  "VTK_MODULE_ENABLE_VTK_cgns DONT_WANT"

  #Enable the VTK::cli11 module.
  "VTK_MODULE_ENABLE_VTK_cli11 DONT_WANT"

  #Enable the VTK::diy2 module.
  "VTK_MODULE_ENABLE_VTK_diy2 DONT_WANT"

  #Enable the VTK::doubleconversion module.
  "VTK_MODULE_ENABLE_VTK_doubleconversion DONT_WANT"

  #Enable the VTK::eigen module.
  "VTK_MODULE_ENABLE_VTK_eigen DONT_WANT"

  #Enable the VTK::exodusII module.
  "VTK_MODULE_ENABLE_VTK_exodusII DONT_WANT"

  #Enable the VTK::expat module.
  "VTK_MODULE_ENABLE_VTK_expat DONT_WANT"

  #Enable the VTK::exprtk module.
  "VTK_MODULE_ENABLE_VTK_exprtk DONT_WANT"

  #Enable the VTK::fides module.
  "VTK_MODULE_ENABLE_VTK_fides DONT_WANT"

  #Enable the VTK::fmt module.
  "VTK_MODULE_ENABLE_VTK_fmt DONT_WANT"

  #Enable the VTK::freetype module.
  "VTK_MODULE_ENABLE_VTK_freetype DONT_WANT"

  #Enable the VTK::gl2ps module.
  "VTK_MODULE_ENABLE_VTK_gl2ps DONT_WANT"

  #Enable the VTK::glew module.
  "VTK_MODULE_ENABLE_VTK_glew DONT_WANT"

  #Enable the VTK::h5part module.
  "VTK_MODULE_ENABLE_VTK_h5part DONT_WANT"

  #Enable the VTK::hdf5 module.
  "VTK_MODULE_ENABLE_VTK_hdf5 DONT_WANT"

  #Enable the VTK::ioss module.
  "VTK_MODULE_ENABLE_VTK_ioss DONT_WANT"

  #Enable the VTK::jpeg module.
  "VTK_MODULE_ENABLE_VTK_jpeg DONT_WANT"

  #Enable the VTK::jsoncpp module.
  "VTK_MODULE_ENABLE_VTK_jsoncpp DONT_WANT"

  #Enable the VTK::kissfft module.
  "VTK_MODULE_ENABLE_VTK_kissfft DONT_WANT"

  #Enable the VTK::kwiml module.
  "VTK_MODULE_ENABLE_VTK_kwiml DONT_WANT"

  #Enable the VTK::libharu module.
  "VTK_MODULE_ENABLE_VTK_libharu DONT_WANT"

  #Enable the VTK::libproj module.
  "VTK_MODULE_ENABLE_VTK_libproj DONT_WANT"

  #Enable the VTK::libxml2 module.
  "VTK_MODULE_ENABLE_VTK_libxml2 DONT_WANT"

  #Enable the VTK::lz4 module.
  "VTK_MODULE_ENABLE_VTK_lz4 DONT_WANT"

  #Enable the VTK::lzma module.
  "VTK_MODULE_ENABLE_VTK_lzma DONT_WANT"

  #Enable the VTK::metaio module.
  "VTK_MODULE_ENABLE_VTK_metaio DONT_WANT"

  #Enable the VTK::netcdf module.
  "VTK_MODULE_ENABLE_VTK_netcdf DONT_WANT"

  #Enable the VTK::octree module.
  "VTK_MODULE_ENABLE_VTK_octree DONT_WANT"

  #Enable the VTK::ogg module.
  "VTK_MODULE_ENABLE_VTK_ogg DONT_WANT"

  #Enable the VTK::opengl module.
  "VTK_MODULE_ENABLE_VTK_opengl DONT_WANT"

  #Enable the VTK::pegtl module.
  "VTK_MODULE_ENABLE_VTK_pegtl DONT_WANT"

  #Enable the VTK::png module.
  "VTK_MODULE_ENABLE_VTK_png DONT_WANT"

  #Enable the VTK::pugixml module.
  "VTK_MODULE_ENABLE_VTK_pugixml DONT_WANT"

  #Enable the VTK::sqlite module.
  "VTK_MODULE_ENABLE_VTK_sqlite DONT_WANT"

  #Enable the VTK::theora module.
  "VTK_MODULE_ENABLE_VTK_theora DONT_WANT"

  #Enable the VTK::tiff module.
  "VTK_MODULE_ENABLE_VTK_tiff DONT_WANT"

  #Enable the VTK::utf8 module.
  "VTK_MODULE_ENABLE_VTK_utf8 DONT_WANT"

  #Enable the VTK::verdict module.
  "VTK_MODULE_ENABLE_VTK_verdict DONT_WANT"

  #Enable the VTK::vpic module.
  "VTK_MODULE_ENABLE_VTK_vpic DONT_WANT"

  #Enable the VTK::vtkm module.
  "VTK_MODULE_ENABLE_VTK_vtkm DONT_WANT"

  #Enable the VTK::vtksys module.
  "VTK_MODULE_ENABLE_VTK_vtksys DONT_WANT"

  #Enable the VTK::xdmf2 module.
  "VTK_MODULE_ENABLE_VTK_xdmf2 DONT_WANT"

  #Enable the VTK::xdmf3 module.
  "VTK_MODULE_ENABLE_VTK_xdmf3 DONT_WANT"

  #Enable the VTK::zfp module.
  "VTK_MODULE_ENABLE_VTK_zfp DONT_WANT"

  #Enable the VTK::zlib module.
  "VTK_MODULE_ENABLE_VTK_zlib DONT_WANT"
)
