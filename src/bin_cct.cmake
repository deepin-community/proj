set(CCT_SRC
  apps/cct.cpp
  apps/proj_strtod.cpp
  apps/proj_strtod.h
)
set(CCT_INCLUDE apps/optargpm.h)

source_group("Source Files\\Bin" FILES ${CCT_SRC})

add_executable(cct ${CCT_SRC} ${CCT_INCLUDE})
target_link_libraries(cct PRIVATE ${PROJ_LIBRARIES})
target_compile_options(cct PRIVATE ${PROJ_CXX_WARN_FLAGS})

install(TARGETS cct
  DESTINATION ${BINDIR})
