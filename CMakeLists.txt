cmake_minimum_required(VERSION 2.8)
project(ruby_wrapper)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

set(CMAKE_PREFIX_PATH ${SymEngine_DIR} ${CMAKE_PREFIX_PATH})
find_package(SymEngine 0.2.0 REQUIRED CONFIG
             PATH_SUFFIXES lib/cmake/symengine CMake/)
set(CMAKE_BUILD_TYPE ${SYMENGINE_BUILD_TYPE})
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
message("SymEngine directory: ${SymEngine_DIR}")
include_directories(${SYMENGINE_INCLUDE_DIRS})

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")
find_package(Ruby REQUIRED)

add_subdirectory(ext/symengine)
