set(CS2CS_SRC
  apps/cs2cs.cpp
  apps/emess.cpp
  apps/utils.cpp
)

source_group("Source Files\\Bin" FILES ${CS2CS_SRC})

add_executable(cs2cs ${CS2CS_SRC} ${CS2CS_INCLUDE})
target_link_libraries(cs2cs PRIVATE ${PROJ_LIBRARIES})
target_compile_options(cs2cs PRIVATE ${PROJ_CXX_WARN_FLAGS})

install(TARGETS cs2cs
  DESTINATION ${BINDIR})
