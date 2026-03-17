# cuDSS is a prebuilt binary distribution from NVIDIA.
# Only dynamic (shared) libraries are provided.
vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

set(CUDSS_VERSION "${VERSION}")
set(CUDSS_CUDA_VERSION "12")

if(VCPKG_TARGET_IS_WINDOWS)
    set(CUDSS_PLATFORM "windows-x86_64")
    set(CUDSS_ARCHIVE_EXT ".zip")
    set(CUDSS_SHA512 "5a38db12ae087a1713dfac820726e81832ffeeefbe1921fd6dda91531c57392e3c8958a3236dd42d7373bb539a0651ae53181ef2d31e8c08c79af5628b8a7e9a")
elseif(VCPKG_TARGET_IS_LINUX)
    set(CUDSS_PLATFORM "linux-x86_64")
    set(CUDSS_ARCHIVE_EXT ".tar.xz")
    set(CUDSS_SHA512 "0170727b7587ee88ee3ca1d7d8eca2cf1c976b8a746a61271079b93a3c46aa7753dfa6bb1a80b2b0a720ba5f8c768a6d7a99aba3c1fe0932f5692492bd17e4db")
else()
    message(FATAL_ERROR "Unsupported platform for cuDSS")
endif()

set(CUDSS_ARCHIVE_NAME "libcudss-${CUDSS_PLATFORM}-${CUDSS_VERSION}_cuda${CUDSS_CUDA_VERSION}-archive")
set(CUDSS_URL "https://developer.download.nvidia.com/compute/cudss/redist/libcudss/${CUDSS_PLATFORM}/${CUDSS_ARCHIVE_NAME}${CUDSS_ARCHIVE_EXT}")

vcpkg_download_distfile(ARCHIVE
    URLS "${CUDSS_URL}"
    FILENAME "${CUDSS_ARCHIVE_NAME}${CUDSS_ARCHIVE_EXT}"
    SHA512 "${CUDSS_SHA512}"
)

vcpkg_extract_source_archive(SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    NO_REMOVE_ONE_LEVEL
)

# The archive extracts to a subdirectory named libcudss-<platform>-<version>_cuda<ver>-archive
file(GLOB ARCHIVE_SUBDIRS "${SOURCE_PATH}/libcudss-*")
list(GET ARCHIVE_SUBDIRS 0 CUDSS_ROOT)

# Install headers
file(INSTALL "${CUDSS_ROOT}/include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

# Install import libraries
if(VCPKG_TARGET_IS_WINDOWS)
    file(INSTALL "${CUDSS_ROOT}/lib/" DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
        FILES_MATCHING PATTERN "*.lib"
    )
    file(INSTALL "${CUDSS_ROOT}/bin/" DESTINATION "${CURRENT_PACKAGES_DIR}/bin"
        FILES_MATCHING PATTERN "*.dll"
    )
else()
    file(INSTALL "${CUDSS_ROOT}/lib/" DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
        FILES_MATCHING
        PATTERN "*.so"
        PATTERN "*.so.*"
        PATTERN "cmake" EXCLUDE
    )
endif()

# Install CMake config files into share/cudss (vcpkg convention)
# The shipped config uses relative paths from its location to find headers/libs,
# so it works from share/cudss/ since ../../include and ../../lib resolve correctly.
file(INSTALL "${CUDSS_ROOT}/lib/cmake/cudss/" DESTINATION "${CURRENT_PACKAGES_DIR}/share/cudss")

# For debug, reuse the release binaries (cuDSS only ships release)
if(NOT VCPKG_BUILD_TYPE)
    if(VCPKG_TARGET_IS_WINDOWS)
        file(INSTALL "${CUDSS_ROOT}/lib/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
            FILES_MATCHING PATTERN "*.lib"
        )
        file(INSTALL "${CUDSS_ROOT}/bin/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/bin"
            FILES_MATCHING PATTERN "*.dll"
        )
    else()
        file(INSTALL "${CUDSS_ROOT}/lib/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
            FILES_MATCHING
            PATTERN "*.so"
            PATTERN "*.so.*"
            PATTERN "cmake" EXCLUDE
        )
    endif()
endif()

# Install license
vcpkg_install_copyright(FILE_LIST "${CUDSS_ROOT}/LICENSE")
