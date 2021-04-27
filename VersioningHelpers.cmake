#
# VersioningHelpers
#
# This module provides functions that simplify
# versioning of libraries and dependency management.
#
# Dependencies:
# * lib/GitVersionFetcher.cmake
# * Logger.cmake
#

cmake_minimum_required(VERSION 3.10)

if(__versioning_helpers)
  return()
endif()
set(__versioning_helpers YES)



#
# Includes
include(Logger)
include(lib/GitVersionFetcher)



#
# Simple logging function used in this module only.
function(write_log string)
  log("[VersioningHelpers.cmake]: ${string}")
endfunction(write_log string)



#
# Fetches the version information from git and sets the following global variables:
# LIBRARY_VERSION
#
# Usage: setLibraryVersion()
#
function(setLibraryVersion)
  fetch_version_from_git()
  set(VERSION_MAJOR ${VERSION_MAJOR} PARENT_SCOPE)
  set(VERSION_MINOR ${VERSION_MINOR} PARENT_SCOPE)
  set(VERSION_PATCH ${VERSION_PATCH} PARENT_SCOPE)
  set(VERSION_TWEAK ${VERSION_TWEAK} PARENT_SCOPE)
  set(LIBRARY_VERSION "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}.${VERSION_TWEAK}" PARENT_SCOPE)
endfunction(setLibraryVersion)



#
# Creates the package config and package version files.
#
# The <projectName>Config.cmake.in is expected to be found in the cmake directory
# inside of the project root directory. The inFileName parameter provides its name.
#
# Parameter:
# inFileName        - the name of the <projectName>Config.cmake.in file
# includeInstallDir - the path of the include directory, relative to the root install dir
# libInstallDir     - the path of the lib directory, relative to the root install dir
#
#
# Usage: createPackageFiles("MyProjectConfig.cmake.in" "/include" "/lib")
#
function(createPackageFiles inFileName includeInstallDir libInstallDir)
  set(INCLUDE_INSTALL_DIR ${includeInstallDir})
  set(LIB_INSTALL_DIR ${libInstallDir})

  include(CMakePackageConfigHelpers)

  configure_package_config_file("cmake/${inFileName}"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION "${LIB_INSTALL_DIR}/${PROJECT_NAME}/cmake"
    PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR)

  write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    VERSION ${LIBRARY_VERSION}
    COMPATIBILITY ExactVersion)

  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
    DESTINATION ${LIB_INSTALL_DIR}/${PROJECT_NAME}/cmake)
endfunction(createPackageFiles)



#
# Checks the requiredVersion variable if it is a valid version string
# and sets it to the VERSION_TO_FIND variable.
# Uses the recommendedVersion variable otherwise.
#
# Parameter:
# modulename         - the name of the module, used for log messages
# variablename       - the name of the required variable, used for log messages
# recommendedVersion - the version string, which is used if the required isn't valid
# requiredVersion    - fourth variable (optional); the required version string
#
# Sets the following global variables:
# VERSION_TO_FIND
#
# Usage: set(RECOMMENDED_MYLIB_VERSION 1.0.0.0)
#        setVersionToFind("my-lib" "REQUIRED_MYLIB_VERSION"
#                       ${RECOMMENDED_MYLIB_VERSION} ${REQUIRED_MYLIB_VERSION})
#        find_package(my-lib ${VERSION_TO_FIND} EXACT)
#
# Note: The requiredVersion must take the form major.minor[.patch[.tweak]]. This means
#       the patch and tweak numbers are optional.
#
function(setVersionToFind modulename variablename recommendedVersion)
  if(NOT ${ARGC} EQUAL 4 OR
     NOT ${ARGV3} MATCHES
       "^(0|[1-9][0-9]*)[.](0|[1-9][0-9]*)([.](0|[1-9][0-9]*))?([.](0|[1-9][0-9]*))?$")

    write_log("${variablename} variable was not set or is no valid version number")
    write_log("Using recommended ${modulename} version, which is: v${recommendedVersion}")
    set(VERSION_TO_FIND ${recommendedVersion} PARENT_SCOPE)

  else()
    set(requiredVersion ${ARGV3})

    if(NOT ${requiredVersion} VERSION_EQUAL ${recommendedVersion})
      write_log("You are not using the recommended ${modulename} version, which would be: v${recommendedVersion}")
    endif()

    set(VERSION_TO_FIND ${requiredVersion} PARENT_SCOPE)
  endif()
endfunction(setVersionToFind requiredVersion recommendedVersion modulename)



#
# Checks if the module was found by evaluating the MY_LIB_FOUND variable.
# The MY_LIB_FOUND variable is set by the cmake function "find_package(..)"
#
# Parameter:
# modulename         - the name of the module, used for log messages
# variablename       - the name of the required variable, used for log messages
#
# Triggers a FATAL_ERROR if the MY_LIB_FOUND variable is not set.
#
# Usage: find_package(my-lib ${VERSION_TO_FIND} EXACT)
#        checkIfModuleFound("my-lib" "REQUIRED_MY_LIB_VERSION")
#
#
function(checkIfModuleFound modulename variablename)
  if(${modulename}_FOUND) # set by find_package()
     write_log("Version check done; v${VERSION_TO_FIND} found.")

  else()
    message(FATAL_ERROR "Make sure the required ${modulename} version is available "
            "or set the ${variablename} variable appropriately.")

  endif()
endfunction(checkIfModuleFound modulename)



#
# Checks the version compatibility up to a desired degree
#
# Parameter:
# version1           - the version one to comapare
# version1           - the version two to comapare
# degree             - the desired degree to check the version compatibility
#
# Triggers a FATAL_ERROR if the versions do not match
#
# Usage: checkVersionCompatibility("1.0" "1.0.2" 2)
#
function(checkVersionCompatibility version1 version2 degree)
    write_log("check version compatibility of v${version1} and v${version2}")
    # create lists with the version elements
    string(REPLACE "." ";" VERS1 ${version1})
    string(REPLACE "." ";" VERS2 ${version2})

    # loop and compare
    math(EXPR LOOP_DEGREE "${degree}-1")
    foreach(i RANGE ${LOOP_DEGREE})
      list(GET V1 ${i} VERS1)
      list(GET V2 ${i} VERS1)
      if(NOT ${V1} EQUAL ${V2})
        message(FATAL_ERROR "Version v${version1} does not match "
                " v${version2} to the required degree of ${degree}.")
      endif()
    endforeach()
    write_log("version check passed to a degree of ${degree}.")
endfunction(checkVersionCompatibility modulename degree)

