vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO AcademySoftwareFoundation/MaterialX
  REF v1.38.5
  SHA512 df689153594265014c0f678295a67c8011e27bb0aed4e50d89e48b8ac003976d11225304ad7933452645942c3fed391c08c36e522ae4309db1678991c82102a3
  HEAD_REF main
)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME "materialx" CONFIG_PATH "lib/cmake/materialx")

file(REMOVE_RECURSE 
  "${CURRENT_PACKAGES_DIR}/debug/include"
  "${CURRENT_PACKAGES_DIR}/include/MaterialXGenMdl/mdl"
  "${CURRENT_PACKAGES_DIR}/include/MaterialXRender/External/OpenImageIO"
)

file(REMOVE 
  "${CURRENT_PACKAGES_DIR}/CHANGELOG.md"
  "${CURRENT_PACKAGES_DIR}/LICENSE"
  "${CURRENT_PACKAGES_DIR}/README.md"
  "${CURRENT_PACKAGES_DIR}/THIRD-PARTY.md"
  "${CURRENT_PACKAGES_DIR}/debug/CHANGELOG.md"
  "${CURRENT_PACKAGES_DIR}/debug/LICENSE"
  "${CURRENT_PACKAGES_DIR}/debug/README.md"
  "${CURRENT_PACKAGES_DIR}/debug/THIRD-PARTY.md"
)

file(
  INSTALL "${SOURCE_PATH}/LICENSE"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)
  file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")