cmake_minimum_required(VERSION 3.10)

if(__cmake_modules_lib)
  return()
endif()
set(__cmake_modules_lib YES)

# Includes
include(Logger)


# Checks out the specified version of the library
function(checkout_cmake_modules_lib_version version)
  if(NOT LIB_CMAKE_MODULES_ROOT_PATH)
    log("Could not checkout ${version} since LIB_CMAKE_MODULES_ROOT_PATH not set.")
    return()
  endif()

  execute_process(COMMAND ${GIT_EXECUTABLE} checkout ${version}
                  WORKING_DIRECTORY ${LIB_CMAKE_MODULES_ROOT_PATH}
                  RESULT_VARIABLE LIB_CMAKE_MODULES_CHECKOUT_RESULT
                  ERROR_VARIABLE LIB_CMAKE_MODULES_CHECKOUT_OUTPUT)

  if(NOT LIB_CMAKE_MODULES_CHECKOUT_RESULT EQUAL "0")
    message(FATAL_ERROR "failed command: git checkout ${version}\n ${LIB_CMAKE_MODULES_CHECKOUT_OUTPUT}")
  endif()

  log("Using cmake-modules library version:${version}")
endfunction()

