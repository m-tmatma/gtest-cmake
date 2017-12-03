include (../../runtime.cmake)

# define a variable SRC with file GLOB
file(GLOB SRC ../test*.cpp ../*.h)

# add include directories
include_directories(../../googletest/googletest/include)
include_directories(../../src)

# add include directory for ${project_name}_Export.h
include_directories(${PROJECT_BINARY_DIR}/src)

# define sources files of an executable
if (CUSTOM_MAIN)
  add_executable(${project_name} ${SRC} ../main.cpp)
else()
  add_executable(${project_name} ${SRC})
endif (CUSTOM_MAIN)

# use shared library version
# this is required when using parameterized test
if (BUILD_SHARED_LIBS)
  # fix linker error "class testing::internal::Mutex testing::internal::g_linked_ptr_mutex"
  target_compile_definitions(${project_name} PUBLIC -DGTEST_LINKED_AS_SHARED_LIBRARY=1)

  # suppress warning
  if (MSVC)
    target_compile_options(${project_name}   PUBLIC /wd4251 PUBLIC /wd4275)
  endif(MSVC)
endif (BUILD_SHARED_LIBS)

# link libraries
target_link_libraries(${project_name} gtest)
if (NOT CUSTOM_MAIN)
  target_link_libraries(${project_name} gtest_main)
endif (NOT CUSTOM_MAIN)
target_link_libraries(${project_name} calc)
