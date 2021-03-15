# CMake modules library
A collection of useful cmake modules.

## Usage
  * clone project
  * set CMAKE_MODULES_LIB_PATH variable to the path of the library root
  * include module to use

### Example
```cmake
  set(CMAKE_MODULES_LIB_PATH "${CMAKE_BINARY_DIR}/cmake-modules" CACHE PATH "The path to the cmake-modules library")
  include("${CMAKE_MODULES_LIB_PATH}/Logger.cmake")
  logger_on()
  log("log with Logger")
```

