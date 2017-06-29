cmake_minimum_required(VERSION 3.6)
project(ed25519)

enable_testing()

add_library(
  ed25519
  SHARED
  src/add_scalar.c
  src/ed25519.h
  src/fe.c
  src/fe.h
  src/fixedint.h
  src/ge.c
  src/ge.h
  src/key_exchange.c
  src/keypair.c
  src/precomp_data.h
  src/sc.c
  src/sc.h
  src/seed.c
  src/sha3.c
  src/sha3.h
  src/sign.c
  src/verify.c
  )

add_library(ed25519::ed25519 ALIAS ed25519)

target_compile_options(ed25519
  PUBLIC
  -pipe
  )

target_include_directories(
  ed25519
  PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/src>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/src>
  $<INSTALL_INTERFACE:include>
  )

install(
  TARGETS ed25519
  EXPORT ed25519Targets
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
  )

install(
  EXPORT ed25519Targets
  DESTINATION lib/cmake/ed25519
  FILE ed25519Targets.cmake
  NAMESPACE ed25519
  )

add_executable(
  ed25519-test
  test.c
  )

target_link_libraries(
  ed25519-test
  PRIVATE
  ed25519
  )

add_test(
  NAME ed25519.test
  COMMAND ed25519-test
  )
