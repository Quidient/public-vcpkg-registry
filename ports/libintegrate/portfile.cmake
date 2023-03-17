vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO CD3/libIntegrate
    REF v1.1
    SHA512 c1956f33402b4202a4f7e23c237459837f4f043abd6a4f033198fbde65ab7ffe2c4e76a2d1da10ca98b2a3d9e88b00377078a86ae24ebd4f285fcd5c47a4fb8c
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
       -DBUILD_TESTS=OFF
)

vcpkg_install_cmake()

file(INSTALL ${CURRENT_PACKAGES_DIR}/cmake/libIntegrateConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL ${CURRENT_PACKAGES_DIR}/cmake/libIntegrateConfigVersion.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL ${CURRENT_PACKAGES_DIR}/cmake/libIntegrateTargets.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT})
file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug ${CURRENT_PACKAGES_DIR}/lib ${CURRENT_PACKAGES_DIR}/cmake)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/libIntegrate/libIntegrate/Experimental")

vcpkg_fixup_pkgconfig()
