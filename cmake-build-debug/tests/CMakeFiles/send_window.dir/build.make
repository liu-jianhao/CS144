# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

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
CMAKE_COMMAND = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake

# The command to remove a file.
RM = /Applications/CLion.app/Contents/bin/cmake/mac/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/liujianhao/share/sponge

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/liujianhao/share/sponge/cmake-build-debug

# Include any dependencies generated for this target.
include tests/CMakeFiles/send_window.dir/depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/send_window.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/send_window.dir/flags.make

tests/CMakeFiles/send_window.dir/send_window.cc.o: tests/CMakeFiles/send_window.dir/flags.make
tests/CMakeFiles/send_window.dir/send_window.cc.o: ../tests/send_window.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/liujianhao/share/sponge/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/send_window.dir/send_window.cc.o"
	cd /Users/liujianhao/share/sponge/cmake-build-debug/tests && /Library/Developer/CommandLineTools/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/send_window.dir/send_window.cc.o -c /Users/liujianhao/share/sponge/tests/send_window.cc

tests/CMakeFiles/send_window.dir/send_window.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/send_window.dir/send_window.cc.i"
	cd /Users/liujianhao/share/sponge/cmake-build-debug/tests && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/liujianhao/share/sponge/tests/send_window.cc > CMakeFiles/send_window.dir/send_window.cc.i

tests/CMakeFiles/send_window.dir/send_window.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/send_window.dir/send_window.cc.s"
	cd /Users/liujianhao/share/sponge/cmake-build-debug/tests && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/liujianhao/share/sponge/tests/send_window.cc -o CMakeFiles/send_window.dir/send_window.cc.s

# Object files for target send_window
send_window_OBJECTS = \
"CMakeFiles/send_window.dir/send_window.cc.o"

# External object files for target send_window
send_window_EXTERNAL_OBJECTS =

tests/send_window: tests/CMakeFiles/send_window.dir/send_window.cc.o
tests/send_window: tests/CMakeFiles/send_window.dir/build.make
tests/send_window: tests/libspongechecks.a
tests/send_window: libsponge/libsponge.a
tests/send_window: tests/CMakeFiles/send_window.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/liujianhao/share/sponge/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable send_window"
	cd /Users/liujianhao/share/sponge/cmake-build-debug/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/send_window.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/send_window.dir/build: tests/send_window

.PHONY : tests/CMakeFiles/send_window.dir/build

tests/CMakeFiles/send_window.dir/clean:
	cd /Users/liujianhao/share/sponge/cmake-build-debug/tests && $(CMAKE_COMMAND) -P CMakeFiles/send_window.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/send_window.dir/clean

tests/CMakeFiles/send_window.dir/depend:
	cd /Users/liujianhao/share/sponge/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/liujianhao/share/sponge /Users/liujianhao/share/sponge/tests /Users/liujianhao/share/sponge/cmake-build-debug /Users/liujianhao/share/sponge/cmake-build-debug/tests /Users/liujianhao/share/sponge/cmake-build-debug/tests/CMakeFiles/send_window.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/send_window.dir/depend

