# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /media/sf_share/sponge

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /media/sf_share/sponge/build

# Utility rule file for format.

# Include the progress variables for this target.
include CMakeFiles/format.dir/progress.make

CMakeFiles/format:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/media/sf_share/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Formatted all source files."
	clang-format-6.0 -i /media/sf_share/sponge/apps/webget.cc /media/sf_share/sponge/doctests/address_dt.cc /media/sf_share/sponge/doctests/address_example_1.cc /media/sf_share/sponge/doctests/address_example_2.cc /media/sf_share/sponge/doctests/address_example_3.cc /media/sf_share/sponge/doctests/parser_dt.cc /media/sf_share/sponge/doctests/parser_example.cc /media/sf_share/sponge/doctests/socket_dt.cc /media/sf_share/sponge/doctests/socket_example_1.cc /media/sf_share/sponge/doctests/socket_example_2.cc /media/sf_share/sponge/doctests/socket_example_3.cc /media/sf_share/sponge/libsponge/byte_stream.cc /media/sf_share/sponge/libsponge/stream_reassembler.cc /media/sf_share/sponge/libsponge/util/address.cc /media/sf_share/sponge/libsponge/util/buffer.cc /media/sf_share/sponge/libsponge/util/eventloop.cc /media/sf_share/sponge/libsponge/util/file_descriptor.cc /media/sf_share/sponge/libsponge/util/parser.cc /media/sf_share/sponge/libsponge/util/socket.cc /media/sf_share/sponge/libsponge/util/tun.cc /media/sf_share/sponge/libsponge/util/util.cc /media/sf_share/sponge/tests/byte_stream_capacity.cc /media/sf_share/sponge/tests/byte_stream_construction.cc /media/sf_share/sponge/tests/byte_stream_many_writes.cc /media/sf_share/sponge/tests/byte_stream_one_write.cc /media/sf_share/sponge/tests/byte_stream_test_harness.cc /media/sf_share/sponge/tests/byte_stream_two_writes.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_cap.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_dup.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_holes.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_many.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_overlapping.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_seq.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_single.cc /media/sf_share/sponge/tests/fsm_stream_reassembler_win.cc /media/sf_share/sponge/libsponge/byte_stream.hh /media/sf_share/sponge/libsponge/stream_reassembler.hh /media/sf_share/sponge/libsponge/util/address.hh /media/sf_share/sponge/libsponge/util/buffer.hh /media/sf_share/sponge/libsponge/util/eventloop.hh /media/sf_share/sponge/libsponge/util/file_descriptor.hh /media/sf_share/sponge/libsponge/util/parser.hh /media/sf_share/sponge/libsponge/util/socket.hh /media/sf_share/sponge/libsponge/util/tun.hh /media/sf_share/sponge/libsponge/util/util.hh /media/sf_share/sponge/tests/byte_stream_test_harness.hh /media/sf_share/sponge/tests/fsm_stream_reassembler_harness.hh /media/sf_share/sponge/tests/test_err_if.hh /media/sf_share/sponge/tests/test_should_be.hh

format: CMakeFiles/format
format: CMakeFiles/format.dir/build.make

.PHONY : format

# Rule to build all files generated by this target.
CMakeFiles/format.dir/build: format

.PHONY : CMakeFiles/format.dir/build

CMakeFiles/format.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/format.dir/cmake_clean.cmake
.PHONY : CMakeFiles/format.dir/clean

CMakeFiles/format.dir/depend:
	cd /media/sf_share/sponge/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /media/sf_share/sponge /media/sf_share/sponge /media/sf_share/sponge/build /media/sf_share/sponge/build /media/sf_share/sponge/build/CMakeFiles/format.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/format.dir/depend

