if(__logger)
  return()
endif()
set(__logger YES)

string(TIMESTAMP DATETIME "%Y%m%d")
set(LOGFILE_NAME "${DATETIME}_log.txt")
set(CONSOLE_LOGGER OFF)
set(FILE_LOGGER OFF)


function(logger_on)
  message("Logger on")
  set(CONSOLE_LOGGER ON PARENT_SCOPE)
  set(FILE_LOGGER ON PARENT_SCOPE)
endfunction()

function(logger_off)
  message("Logger off")
  set(CONSOLE_LOGGER OFF PARENT_SCOPE)
  set(FILE_LOGGER OFF PARENT_SCOPE)
endfunction()


function(log msg)
  if(CONSOLE_LOGGER)
    message(${msg})
  endif()  

  if(FILE_LOGGER)
    log_file(${msg})
  endif()
endfunction()


function(log_file msg)
  string(TIMESTAMP DATETIME "%H:%M:%S")
  file(APPEND "${CMAKE_BINARY_DIR}/${LOGFILE_NAME}" "${DATETIME}:${msg}\n")
endfunction()

