# Copyright 2017 Pedro Cuadra <pjcuadra@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
