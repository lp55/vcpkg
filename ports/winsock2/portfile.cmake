include(vcpkg_common_functions)

vcpkg_get_program_files_32_bit(PROGRAM_FILES_32_BIT)
vcpkg_get_windows_sdk(WINDOWS_SDK)

if (WINDOWS_SDK MATCHES "10.")
    set(LIBFILEPATH "${PROGRAM_FILES_32_BIT}\\Windows Kits\\10\\Lib\\${WINDOWS_SDK}\\um\\${TRIPLET_SYSTEM_ARCH}\\Ws2_32.Lib")
    set(LICENSEPATH "${PROGRAM_FILES_32_BIT}\\Windows Kits\\10\\Licenses\\${WINDOWS_SDK}\\sdk_license.rtf")
    set(HEADERSPATH "${PROGRAM_FILES_32_BIT}\\Windows Kits\\10\\Include\\${WINDOWS_SDK}\\um")
elseif(WINDOWS_SDK MATCHES "8.")
    set(LIBFILEPATH "${PROGRAM_FILES_32_BIT}\\Windows Kits\\8.1\\Lib\\winv6.3\\um\\${TRIPLET_SYSTEM_ARCH}\\Ws2_32.Lib")
    set(HEADERSPATH "${PROGRAM_FILES_32_BIT}\\Windows Kits\\8.1\\Include\\um")
else()
    message(FATAL_ERROR "Portfile not yet configured for Windows SDK with version: ${WINDOWS_SDK}")
endif()

if (NOT EXISTS "${LIBFILEPATH}")
    message(FATAL_ERROR "Cannot find Windows ${WINDOWS_SDK} SDK. File does not exist: ${LIBFILEPATH}")
endif()

file(MAKE_DIRECTORY
    ${CURRENT_PACKAGES_DIR}/include
    ${CURRENT_PACKAGES_DIR}/lib
    ${CURRENT_PACKAGES_DIR}/debug/lib
    ${CURRENT_PACKAGES_DIR}/share/winsock2
)

file(COPY
    "${HEADERSPATH}\\Winsock2.h"
    DESTINATION ${CURRENT_PACKAGES_DIR}/include
    )
file(COPY ${LIBFILEPATH} DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
file(COPY ${LIBFILEPATH} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)

if (DEFINED LICENSEPATH)
    file(COPY ${LICENSEPATH} DESTINATION ${CURRENT_PACKAGES_DIR}/share/winsock2)
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/winsock2/copyright "See the accompanying sdk_license.rtf")
else()
    file(WRITE ${CURRENT_PACKAGES_DIR}/share/winsock2/copyright "See https://developer.microsoft.com/en-us/windows/downloads/windows-8-1-sdk for the Windows 8.1 SDK license")
endif()