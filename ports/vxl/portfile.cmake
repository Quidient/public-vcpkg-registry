set(VXL_BUILD_CORE_IMAGING OFF)
if("core-imaging" IN_LIST FEATURES)
  set(VXL_BUILD_CORE_IMAGING ON)
  if(EXISTS "${CURRENT_INSTALLED_DIR}/include/openjpeg.h")
    set(VXL_BUILD_CORE_IMAGING OFF)
    message(WARNING "Can't build VXL CORE_IMAGING features with non built-in OpenJpeg. Please remove OpenJpeg, and try install VXL again if you need them.")
  endif()
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO vxl/vxl
    REF v3.5.0
    SHA512 0b33e12557315058e7786c2049af3b01f1208e50660ccbc45f4d9a4dba4eeadfa5e3125380d8781eed2a9abf1d153ffb71c416ed2d196ab4194f5b3722fe6f2b
    HEAD_REF master
)

set(USE_WIN_WCHAR_T OFF)
if(VCPKG_TARGET_IS_WINDOWS)
    set(USE_WIN_WCHAR_T ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    -DVXL_BUILD_CORE_IMAGING=OFF
    -DVXL_BUILD_CORE_GEOMETRY=OFF
    -DBUILD_TESTING=OFF
    -DVXL_BUILD_CORE_UTILITIES=OFF
    -DVXL_BUILD_CORE_SERIALISATION=OFF
    -DVXL_USE_WIN_WCHAR_T=OFF 
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(PACKAGE_NAME VXL NO_PREFIX_CORRECTION)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
# Remove tests which assume that the source dir still exists
file(REMOVE "${CURRENT_PACKAGES_DIR}/include/vxl/vcl/vcl_where_root_dir.h")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/vxl/core/testlib")

vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/vxl/cmake/VXLConfig.cmake" "${CURRENT_BUILDTREES_DIR}" "") # only used in comment

file(INSTALL "${SOURCE_PATH}/core/vxl_copyright.h" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")