set(GHDL_FLAGS --std=08 --ieee=synopsys --warn-default-binding --warn-binding --warn-specs --warn-delayed-checks --warn-unused)

# Add test sources macro
macro (add_test_sources)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGN})
        if (_relPath)
            set(FILE_SRC "${_relPath}/${_src}")
        else()
            set(FILE_SRC "${_src}")
        endif()

        string(REGEX REPLACE ".vhd" "" TEST_NAME "${FILE_SRC}")
        string(REGEX REPLACE "/" "." TEST_NAME "${TEST_NAME}")
        string(REGEX REPLACE ".vhd" "" ENTITY_NAME "${_src}")
        file (RELATIVE_PATH TEST_REL_PATH "${PROJECT_SOURCE_DIR}/test" "${CMAKE_CURRENT_SOURCE_DIR}")
        set(TRACE_PATH "${CMAKE_BINARY_DIR}/trace/${TEST_REL_PATH}")
        file(MAKE_DIRECTORY ${TRACE_PATH})
        set(TRACE_PATH "${TRACE_PATH}/${ENTITY_NAME}.vcd")

        add_custom_target("${TEST_NAME}" COMMAND ghdl -m -g ${GHDL_FLAGS} --workdir=${CMAKE_BINARY_DIR} ${ENTITY_NAME} DEPENDS index )
        list (APPEND VHDL_SOURCES "${CMAKE_SOURCE_DIR}/${FILE_SRC}")
        add_custom_target("${TEST_NAME}_cp_dat_files" COMMAND sh -c "ln -s ${CMAKE_BINARY_DIR}/${ENTITY_NAME}.dat ${CMAKE_CURRENT_BINARY_DIR}/memfile.dat" || true)
        add_test(NAME "${TEST_NAME}" COMMAND ghdl -r ${GHDL_FLAGS} -g --workdir=${CMAKE_BINARY_DIR} ${ENTITY_NAME} --vcd=${TRACE_PATH} --stop-time=10us)
        add_dependencies("${TEST_NAME}" "${TEST_NAME}_cp_dat_files")
        add_dependencies(check "${TEST_NAME}")

        message("-- Adding VHDL Test: ${CMAKE_SOURCE_DIR}/${FILE_SRC}")
    endforeach()
    if (_relPath)
        # propagate SRCS to parent directory
        set (VHDL_SOURCES ${VHDL_SOURCES} PARENT_SCOPE)
    endif()
endmacro()

# Add source directory macro
macro (add_test_sources_directory)
  file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
  foreach (_src ${ARGN})
      add_subdirectory(${_src})
      # propagate SRCS to parent directory
      set (VHDL_SOURCES ${VHDL_SOURCES} PARENT_SCOPE)
  endforeach()
endmacro()

# Add sources macro
macro (add_mem_init_file)
    file (RELATIVE_PATH _relPath "${PROJECT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}")
    foreach (_src ${ARGN})
        if (_relPath)
            list (APPEND MIF_SOURCES "${CMAKE_SOURCE_DIR}/${_relPath}/${_src}")
            message("-- Adding MIF Source: ${CMAKE_SOURCE_DIR}/${_relPath}/${_src}")
        else()
            list (APPEND MIF_SOURCES "${CMAKE_SOURCE_DIR}/${_src}")
            message("-- Adding MIF Source: ${CMAKE_SOURCE_DIR}/${_src}")
        endif()

        message("-- Copying ${_src} to ${CMAKE_BINARY_DIR}")
        file(COPY ${_src} DESTINATION ${CMAKE_BINARY_DIR})
    endforeach()

    if (_relPath)
        # propagate SRCS to parent directory
        set (MIF_SOURCES ${MIF_SOURCES} PARENT_SCOPE)
    endif()
endmacro()
