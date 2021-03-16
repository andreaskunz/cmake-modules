cmake_minimum_required(VERSION 3.10)

if(__cmake_modules_lib)
  return()
endif()
set(__cmake_modules_lib YES)

# Includes
include(Logger)


# Checks out the specified version of the library
function(checkout_cmake_modules_lib_version version)
  execute_process(COMMAND ${GIT_EXECUTABLE} checkout ${version}
                  WORKING_DIRECTORY ${CMAKE_MODULES_LIB_PATH}
                  RESULT_VARIABLE CMAKE_MODULES_LIB_CHECKOUT_RESULT
                  ERROR_VARIABLE CMAKE_MODULES_LIB_CHECKOUT_OUTPUT)
  if(NOT CMAKE_MODULES_LIB_CHECKOUT_RESULT EQUAL "0")
    message(FATAL_ERROR "failed command: git checkout ${version}\n ${CMAKE_MODULES_LIB_CHECKOUT_OUTPUT}")
  endif()
  log("Using cmake-modules library version:${version}")
endfunction()

