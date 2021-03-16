# CMake modules library
A collection of useful cmake modules.

## Usage
  * clone project
  * set CMAKE_MODULE_PATH variable to the path of the library root
  * include module to use

### Example
```cmake
  set(CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/cmake-modules" CACHE PATH "List of directories specifying a search path for CMake modules to be loaded")
  include(Logger)
  logger_on()
  log("log with Logger")
```

