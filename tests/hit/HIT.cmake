include(CTest)
find_package(HIP REQUIRED)

set(HIP_CTEST_CONFIG_DEFAULT "default")
set(HIP_CTEST_CONFIG_PERFORMANCE "performance")

#-------------------------------------------------------------------------------
# Helper macro to parse BUILD instructions
macro(PARSE_BUILD_COMMAND _target _sources _hipcc_options _hcc_options _clang_options _nvcc_options _link_options _exclude_platforms _exclude_runtime _exclude_compiler _depends _dir)
    set(${_target})
    set(${_sources})
    set(${_hipcc_options})
    set(${_hcc_options})
    set(${_clang_options})
    set(${_nvcc_options})
    set(${_link_options})
    set(${_exclude_platforms})
    set(${_exclude_runtime})
    set(${_exclude_compiler})
    set(${_depends})
    set(_target_found FALSE)
    set(_hipcc_options_found FALSE)
    set(_hcc_options_found FALSE)
    set(_clang_options_found FALSE)
    set(_nvcc_options_found FALSE)
    set(_link_options_found FALSE)
    set(_exclude_platforms_found FALSE)
    set(_exclude_runtime_found FALSE)
    set(_exclude_compiler_found FALSE)
    set(_depends_found FALSE)
    foreach(arg ${ARGN})
        if(NOT _target_found)
            set(_target_found TRUE)
            set(${_target} ${arg})
        elseif("x${arg}" STREQUAL "xHIPCC_OPTIONS")
            set(_hipcc_options_found TRUE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xHCC_OPTIONS")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found TRUE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xCLANG_OPTIONS")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found TRUE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xNVCC_OPTIONS")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found TRUE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xLINK_OPTIONS")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found TRUE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_PLATFORM")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found TRUE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_RUNTIME")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found TRUE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_COMPILER")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found TRUE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xDEPENDS")
            set(_hipcc_options_found FALSE)
            set(_hcc_options_found FALSE)
            set(_clang_options_found FALSE)
            set(_nvcc_options_found FALSE)
            set(_link_options_found FALSE)
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found TRUE)
        else()
            if(_hipcc_options_found)
                list(APPEND ${_hipcc_options} ${arg})
            elseif(_hcc_options_found)
                list(APPEND ${_hcc_options} ${arg})
            elseif(_clang_options_found)
                list(APPEND ${_clang_options} ${arg})
            elseif(_nvcc_options_found)
                list(APPEND ${_nvcc_options} ${arg})
            elseif(_link_options_found)
                list(APPEND ${_link_options} ${arg})
            elseif(_exclude_platforms_found)
                list(APPEND ${_exclude_platforms} ${arg})
            elseif(_exclude_runtime_found)
                list(APPEND ${_exclude_runtime} ${arg})
            elseif(_exclude_compiler_found)
                list(APPEND ${_exclude_compiler} ${arg})
            elseif(_depends_found)
                list(APPEND ${_depends} ${arg})
            else()
                list(APPEND ${_sources} "${_dir}/${arg}")
            endif()
        endif()
    endforeach()
endmacro()

# Helper macro to parse CUSTOM BUILD instructions
macro(PARSE_CUSTOMBUILD_COMMAND _target _buildcmd _exclude_platforms _exclude_runtime _exclude_compiler _depends)
    set(${_target})
    set(${_buildcmd} " ")
    set(${_exclude_platforms})
    set(${_depends})
    set(_target_found FALSE)
    set(_exclude_platforms_found FALSE)
    set(_exclude_runtime_found FALSE)
    set(_exclude_compiler_found FALSE)
    set(_depends_found FALSE)
    foreach(arg ${ARGN})
        if(NOT _target_found)
            set(_target_found TRUE)
            set(${_target} ${arg})
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_PLATFORM")
            set(_exclude_platforms_found TRUE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_RUNTIME")
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found TRUE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_COMPILER")
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found TRUE)
            set(_depends_found FALSE)
        elseif("x${arg}" STREQUAL "xDEPENDS")
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
            set(_depends_found TRUE)
        else()
            if(_exclude_platforms_found)
                list(APPEND ${_exclude_platforms} ${arg})
            elseif(_exclude_runtime_found)
                list(APPEND ${_exclude_runtime} ${arg})
            elseif(_exclude_compiler_found)
                list(APPEND ${_exclude_compiler} ${arg})
            elseif(_depends_found)
                list(APPEND ${_depends} ${arg})
            else()
                list(APPEND ${_buildcmd} ${arg})
            endif()
        endif()
    endforeach()
endmacro()

# Helper macro to parse TEST instructions
macro(PARSE_TEST_COMMAND _target _arguments _exclude_platforms _exclude_runtime _exclude_compiler)
    set(${_target})
    set(${_arguments} " ")
    set(${_exclude_platforms})
    set(${_exclude_runtime})
    set(${_exclude_compiler})
    set(_target_found FALSE)
    set(_exclude_platforms_found FALSE)
    set(_exclude_runtime_found FALSE)
    set(_exclude_compiler_found FALSE)
    foreach(arg ${ARGN})
        if(NOT _target_found)
            set(_target_found TRUE)
            set(${_target} ${arg})
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_PLATFORM")
            set(_exclude_platforms_found TRUE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_RUNTIME")
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found TRUE)
            set(_exclude_compiler_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_COMPILER")
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found TRUE)
        else()
            if(_exclude_platforms_found)
                list(APPEND ${_exclude_platforms} ${arg})
            elseif(_exclude_runtime_found)
                list(APPEND ${_exclude_runtime} ${arg})
            elseif(_exclude_compiler_found)
                list(APPEND ${_exclude_compiler} ${arg})
            else()
                list(APPEND ${_arguments} ${arg})
            endif()
        endif()
    endforeach()
endmacro()

# Helper macro to parse TEST_NAMED instructions
macro(PARSE_TEST_NAMED_COMMAND _target _testname _arguments _exclude_platforms _exclude_runtime _exclude_compiler)
    set(${_target})
    set(${_arguments} " ")
    set(${_exclude_platforms})
    set(_target_found FALSE)
    set(_testname_found FALSE)
    set(_exclude_platforms_found FALSE)
    set(_exclude_runtime_found FALSE)
    set(_exclude_compiler_found FALSE)
    foreach(arg ${ARGN})
        if(NOT _target_found)
            set(_target_found TRUE)
            set(${_target} ${arg})
        elseif(NOT _testname_found)
            set(_testname_found TRUE)
            set(${_testname} ${arg})
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_PLATFORM")
            set(_exclude_platforms_found TRUE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_RUNTIME")
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found TRUE)
            set(_exclude_compiler_found FALSE)
        elseif("x${arg}" STREQUAL "xEXCLUDE_HIP_COMPILER")
            set(_exclude_platforms_found FALSE)
            set(_exclude_runtime_found FALSE)
            set(_exclude_compiler_found TRUE)
        else()
            if(_exclude_platforms_found)
                list(APPEND ${_exclude_platforms} ${arg})
            elseif(_exclude_runtime_found)
                list(APPEND ${_exclude_runtime} ${arg})
            elseif(_exclude_compiler_found)
                list(APPEND ${_exclude_compiler} ${arg})
            else()
                list(APPEND ${_arguments} ${arg})
            endif()
        endif()
    endforeach()
endmacro()

# Helper macro to insert key/value pair into "hashmap"
macro(INSERT_INTO_MAP _map _key _value)
    set("${_map}_${_key}" "${_value}")
endmacro()

# Helper macro to read key/value pair from "hashmap"
macro(READ_FROM_MAP _map _key _value)
    set(${_value} "${${_map}_${_key}}")
endmacro()

# Helper macro to create a test
macro(MAKE_TEST _config exe)
    string(REPLACE " " "" smush_args ${ARGN})
    set(testname ${exe}${smush_args}.tst)
    if(${_config} STREQUAL ${HIP_CTEST_CONFIG_DEFAULT})
        add_test(NAME ${testname} COMMAND ${PROJECT_BINARY_DIR}/${exe} ${ARGN})
    else()
        add_test(NAME ${testname} CONFIGURATIONS ${_config} COMMAND ${PROJECT_BINARY_DIR}/${exe} ${ARGN})
    endif()
    set_tests_properties(${testname} PROPERTIES PASS_REGULAR_EXPRESSION "PASSED" ENVIRONMENT HIP_PATH=${HIP_ROOT_DIR})
    set_tests_properties(${testname} PROPERTIES SKIP_RETURN_CODE 127 ENVIRONMENT HIP_PATH=${HIP_ROOT_DIR})
endmacro()

macro(MAKE_NAMED_TEST _config exe testname)
    if(${_config} STREQUAL ${HIP_CTEST_CONFIG_DEFAULT})
        add_test(NAME ${testname} COMMAND ${PROJECT_BINARY_DIR}/${exe} ${ARGN})
    else()
        add_test(NAME ${testname} CONFIGURATIONS ${_config} COMMAND ${PROJECT_BINARY_DIR}/${exe} ${ARGN})
    endif()
    set_tests_properties(${testname} PROPERTIES PASS_REGULAR_EXPRESSION "PASSED" ENVIRONMENT HIP_PATH=${HIP_ROOT_DIR})
endmacro()
#-------------------------------------------------------------------------------

# Macro: HIT_ADD_FILES used to scan+add multiple files for testing.
file(GLOB HIP_LIB_FILES ${HIP_PATH}/lib/*)
macro(HIT_ADD_FILES _config _dir _label _parent)
    foreach (file ${ARGN})
        # Build tests
        execute_process(COMMAND ${HIP_SRC_PATH}/tests/hit/parser --buildCMDs ${file}
            OUTPUT_VARIABLE _contents
            ERROR_QUIET
            WORKING_DIRECTORY ${_dir}
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        string(REGEX REPLACE "\n" ";" _contents "${_contents}")
        foreach(_cmd ${_contents})
            string(REGEX REPLACE " " ";" _cmd "${_cmd}")
            parse_build_command(_target _sources _hipcc_options _hcc_options _clang_options _nvcc_options _link_options _exclude_platforms _exclude_runtime _exclude_compiler _depends ${_dir} ${_cmd})
            string(REGEX REPLACE "/" "." target ${_label}/${_target})
            if("all" IN_LIST _exclude_platforms OR ${HIP_PLATFORM} IN_LIST _exclude_platforms)
                insert_into_map("_exclude" "${target}" TRUE)
            elseif(NOT _exclude_runtime AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
                insert_into_map("_exclude" "${target}" TRUE)
            elseif(NOT _exclude_compiler AND ${HIP_RUNTIME} IN_LIST _exclude_runtime)
                insert_into_map("_exclude" "${target}" TRUE)
            elseif(_exclude_runtime STREQUAL ${HIP_RUNTIME} AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
                insert_into_map("_exclude" "${target}" TRUE)
            else()
                set_source_files_properties(${_sources} PROPERTIES HIP_SOURCE_PROPERTY_FORMAT 1)
                hip_reset_flags()
                hip_add_executable(${target} ${_sources} HIPCC_OPTIONS ${_hipcc_options} HCC_OPTIONS ${_hcc_options} CLANG_OPTIONS ${_clang_options} NVCC_OPTIONS ${_nvcc_options} EXCLUDE_FROM_ALL)
                target_link_libraries(${target} PRIVATE ${_link_options})
                set_target_properties(${target} PROPERTIES OUTPUT_NAME ${_target} RUNTIME_OUTPUT_DIRECTORY ${_label} LINK_DEPENDS "${HIP_LIB_FILES}")
                add_dependencies(${_parent} ${target})
                foreach(_dependency ${_depends})
                    string(REGEX REPLACE "/" "." _dependency ${_label}/${_dependency})
                    add_dependencies(${target} ${_dependency})
                endforeach()
            endif()
        endforeach()

        # Custom build commands
        execute_process(COMMAND ${HIP_SRC_PATH}/tests/hit/parser --customBuildCMDs ${file}
            OUTPUT_VARIABLE _contents
            ERROR_QUIET
            WORKING_DIRECTORY ${_dir}
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        string(REGEX REPLACE "\n" ";" _contents "${_contents}")
        string(REGEX REPLACE "%hc" "${HIP_HIPCC_EXECUTABLE}" _contents "${_contents}")
        string(REGEX REPLACE "%hip-path" "${HIP_ROOT_DIR}" _contents "${_contents}")
        string(REGEX REPLACE "%cc" "/usr/bin/cc" _contents "${_contents}")
        string(REGEX REPLACE "%cxx" "/usr/bin/c++" _contents "${_contents}")
        string(REGEX REPLACE "%S" ${_dir} _contents "${_contents}")
        string(REGEX REPLACE "%T" ${_label} _contents "${_contents}")
        foreach(_cmd ${_contents})
            string(REGEX REPLACE " " ";" _cmd "${_cmd}")
            parse_custombuild_command(_target _buildcmd _exclude_platforms _exclude_runtime _exclude_compiler _depends ${_cmd})
            string(REGEX REPLACE "/" "." target ${_label}/${_target})
            if("all" IN_LIST _exclude_platforms OR ${HIP_PLATFORM} IN_LIST _exclude_platforms)
                insert_into_map("_exclude" "${target}" TRUE)
            elseif(NOT _exclude_runtime AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
                insert_into_map("_exclude" "${target}" TRUE)
            elseif(NOT _exclude_compiler AND ${HIP_RUNTIME} IN_LIST _exclude_runtime)
                insert_into_map("_exclude" "${target}" TRUE)
            elseif(_exclude_runtime STREQUAL ${HIP_RUNTIME} AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
                insert_into_map("_exclude" "${target}" TRUE)
            else()
                string(REGEX REPLACE ";" " " _buildcmd "${_buildcmd}")
                #string(CONCAT buildscript ${CMAKE_CURRENT_BINARY_DIR}/${target} ".sh")
                #file(WRITE ${buildscript} ${_buildcmd})
                #add_custom_target(${target} COMMAND ${buildscript})
                add_custom_target(${target} COMMAND sh -c "${_buildcmd}")
                add_dependencies(${_parent} ${target})
                foreach(_dependency ${_depends})
                    string(REGEX REPLACE "/" "." _dependency ${_label}/${_dependency})
                    add_dependencies(${target} ${_dependency})
                endforeach()
            endif()
        endforeach()

        # Add tests
        execute_process(COMMAND ${HIP_SRC_PATH}/tests/hit/parser --testCMDs ${file}
            OUTPUT_VARIABLE _contents
            ERROR_QUIET
            WORKING_DIRECTORY ${_dir}
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        string(REGEX REPLACE "\n" ";" _contents "${_contents}")
        foreach(_cmd ${_contents})
            string(REGEX REPLACE " " ";" _cmd "${_cmd}")
            parse_test_command(_target _arguments _exclude_platforms _exclude_runtime _exclude_compiler ${_cmd})
            string(REGEX REPLACE "/" "." target ${_label}/${_target})
            read_from_map("_exclude" "${target}" _exclude_test_from_build)
            if("all" IN_LIST _exclude_platforms OR ${HIP_PLATFORM} IN_LIST _exclude_platforms)
            elseif(NOT _exclude_runtime AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
            elseif(NOT _exclude_compiler AND ${HIP_RUNTIME} IN_LIST _exclude_runtime)
            elseif(${HIP_RUNTIME} IN_LIST _exclude_runtime AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
            elseif(_exclude_test_from_build STREQUAL TRUE)
            else()
                make_test(${_config} ${_label}/${_target} ${_arguments})
            endif()
        endforeach()

        # Add named tests
        execute_process(COMMAND ${HIP_SRC_PATH}/tests/hit/parser --testNamedCMDs ${file}
            OUTPUT_VARIABLE _contents
            ERROR_QUIET
            WORKING_DIRECTORY ${_dir}
            OUTPUT_STRIP_TRAILING_WHITESPACE)
        string(REGEX REPLACE "\n" ";" _contents "${_contents}")
        foreach(_cmd ${_contents})
            string(REGEX REPLACE " " ";" _cmd "${_cmd}")
            parse_test_named_command(_target _testname _arguments _exclude_platforms _exclude_runtime _exclude_compiler ${_cmd})
            string(REGEX REPLACE "/" "." target ${_label}/${_target})
            read_from_map("_exclude" "${target}" _exclude_test_from_build)
            if("all" IN_LIST _exclude_platforms OR ${HIP_PLATFORM} IN_LIST _exclude_platforms)
            elseif(NOT _exclude_runtime AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
            elseif(NOT _exclude_compiler AND ${HIP_RUNTIME} IN_LIST _exclude_runtime)
            elseif(${HIP_RUNTIME} IN_LIST _exclude_runtime AND ${HIP_COMPILER} IN_LIST _exclude_compiler)
            elseif(_exclude_test_from_build STREQUAL TRUE)
            else()
                make_named_test(${_config} ${_label}/${_target} ${_label}/${_testname}.tst ${_arguments})
            endif()
        endforeach()
    endforeach()
endmacro()

# Macro: HIT_ADD_DIRECTORY to scan+add all files in a directory for testing
macro(HIT_ADD_DIRECTORY _dir _label)
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${_label} WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    string(REGEX REPLACE "/" "." _parent ${_label})
    add_custom_target(${_parent})
    file(GLOB files "${_dir}/*.c*")
    hit_add_files(${HIP_CTEST_CONFIG_DEFAULT} ${_dir} ${_label} ${parent} ${files})
endmacro()

# Macro: HIT_ADD_DIRECTORY_RECURSIVE to scan+add all files in a directory+subdirectories for testing
macro(HIT_ADD_DIRECTORY_RECURSIVE _config _dir _label)
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${_label} WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
    string(REGEX REPLACE "/" "." _parent ${_label})
    add_custom_target(${_parent})
    if(${ARGC} EQUAL 4)
        add_dependencies(${ARGV3} ${_parent})
    endif()
    file(GLOB children RELATIVE ${_dir} ${_dir}/*)
    set(dirlist "")
    foreach(child ${children})
        if(IS_DIRECTORY ${_dir}/${child})
            list(APPEND dirlist ${child})
        else()
            hit_add_files(${_config} ${_dir} ${_label} ${_parent} ${child})
        endif()
    endforeach()
    foreach(child ${dirlist})
        string(REGEX REPLACE "/" "." _parent ${_label})
        hit_add_directory_recursive(${_config} ${_dir}/${child} ${_label}/${child} ${_parent})
    endforeach()
endmacro()

# vim: ts=4:sw=4:expandtab:smartindent
