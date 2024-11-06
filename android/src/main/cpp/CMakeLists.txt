
cmake_minimum_required(VERSION 3.22.1)

project("OpacityCore")

set(OPACITY_CORE_LIB ${CMAKE_CURRENT_SOURCE_DIR}/../jniLibs/${ANDROID_ABI}/libopacity_core.a)
add_library(opacity_core STATIC IMPORTED)
set_target_properties(opacity_core PROPERTIES IMPORTED_LOCATION ${OPACITY_CORE_LIB})

add_library(${CMAKE_PROJECT_NAME} SHARED
    # List C/C++ source files with relative paths to this CMakeLists.txt.
    OpacityCore.cpp)

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC ${CMAKE_SOURCE_DIR}/../jni/include)

target_link_libraries(${CMAKE_PROJECT_NAME}
    opacity_core
    android
    log)