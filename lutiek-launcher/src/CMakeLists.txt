add_executable(lutiek-launcher
    main.cpp
)

target_link_libraries(lutiek-launcher
    Qt5::Qml
    Qt5::Quick
    Qt5::QuickControls2
    Qt5::Config
    Qt5::Core
)

install(TARGETS lutiek-launcher DESTINATION bin)