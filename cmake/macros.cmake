set(GHDL_FLAGS --std=08 --ieee=synopsys -fcolor-diagnostics)

# Add sources macro
macro (add_sources)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGN})
        if (_relPath)
            list (APPEND VHDL_SOURCES "${CMAKE_SOURCE_DIR}/${_relPath}/${_src}")
            message("-- Adding VHDL Source: ${CMAKE_SOURCE_DIR}/${_relPath}/${_src}")
        else()
            list (APPEND VHDL_SOURCES "${CMAKE_SOURCE_DIR}/${_src}")
            message("-- Adding VHDL Source: ${CMAKE_SOURCE_DIR}/${_src}")
        endif()
    endforeach()

    if (_relPath)
        # propagate SRCS to parent directory
        set (VHDL_SOURCES ${VHDL_SOURCES} PARENT_SCOPE)
    endif()
endmacro()

# Add source directory macro
macro (add_sources_directory)
  file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
  foreach (_src ${ARGN})
      add_subdirectory(${_src})
      # propagate SRCS to parent directory
      set (VHDL_SOURCES ${VHDL_SOURCES} PARENT_SCOPE)
  endforeach()
endmacro()
