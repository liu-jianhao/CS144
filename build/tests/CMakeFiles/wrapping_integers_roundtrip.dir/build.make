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

# Include any dependencies generated for this target.
include tests/CMakeFiles/wrapping_integers_roundtrip.dir/depend.make

# Include the progress variables for this target.
include tests/CMakeFiles/wrapping_integers_roundtrip.dir/progress.make

# Include the compile flags for this target's objects.
include tests/CMakeFiles/wrapping_integers_roundtrip.dir/flags.make

tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o: tests/CMakeFiles/wrapping_integers_roundtrip.dir/flags.make
tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o: ../tests/wrapping_integers_roundtrip.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/media/sf_share/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o"
	cd /media/sf_share/sponge/build/tests && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o -c /media/sf_share/sponge/tests/wrapping_integers_roundtrip.cc

tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.i"
	cd /media/sf_share/sponge/build/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /media/sf_share/sponge/tests/wrapping_integers_roundtrip.cc > CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.i

tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.s"
	cd /media/sf_share/sponge/build/tests && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /media/sf_share/sponge/tests/wrapping_integers_roundtrip.cc -o CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.s

tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.requires:

.PHONY : tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.requires

tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.provides: tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.requires
	$(MAKE) -f tests/CMakeFiles/wrapping_integers_roundtrip.dir/build.make tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.provides.build
.PHONY : tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.provides

tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.provides.build: tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o


# Object files for target wrapping_integers_roundtrip
wrapping_integers_roundtrip_OBJECTS = \
"CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o"

# External object files for target wrapping_integers_roundtrip
wrapping_integers_roundtrip_EXTERNAL_OBJECTS =

tests/wrapping_integers_roundtrip: tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o
tests/wrapping_integers_roundtrip: tests/CMakeFiles/wrapping_integers_roundtrip.dir/build.make
tests/wrapping_integers_roundtrip: tests/libspongechecks.a
tests/wrapping_integers_roundtrip: libsponge/libsponge.a
tests/wrapping_integers_roundtrip: tests/CMakeFiles/wrapping_integers_roundtrip.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/media/sf_share/sponge/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable wrapping_integers_roundtrip"
	cd /media/sf_share/sponge/build/tests && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/wrapping_integers_roundtrip.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/CMakeFiles/wrapping_integers_roundtrip.dir/build: tests/wrapping_integers_roundtrip

.PHONY : tests/CMakeFiles/wrapping_integers_roundtrip.dir/build

tests/CMakeFiles/wrapping_integers_roundtrip.dir/requires: tests/CMakeFiles/wrapping_integers_roundtrip.dir/wrapping_integers_roundtrip.cc.o.requires

.PHONY : tests/CMakeFiles/wrapping_integers_roundtrip.dir/requires

tests/CMakeFiles/wrapping_integers_roundtrip.dir/clean:
	cd /media/sf_share/sponge/build/tests && $(CMAKE_COMMAND) -P CMakeFiles/wrapping_integers_roundtrip.dir/cmake_clean.cmake
.PHONY : tests/CMakeFiles/wrapping_integers_roundtrip.dir/clean

tests/CMakeFiles/wrapping_integers_roundtrip.dir/depend:
	cd /media/sf_share/sponge/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /media/sf_share/sponge /media/sf_share/sponge/tests /media/sf_share/sponge/build /media/sf_share/sponge/build/tests /media/sf_share/sponge/build/tests/CMakeFiles/wrapping_integers_roundtrip.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/CMakeFiles/wrapping_integers_roundtrip.dir/depend

