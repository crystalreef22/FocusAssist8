cmake_minimum_required(VERSION 3.16)

project(FocusAssist8 VERSION 0.3.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

if(WIN32)
qt_add_executable(FocusAssist8
    main.cpp
    icons/app.o
)
elseif(APPLE)
set(MACOSX_BUNDLE_ICON_FILE focusassisticon)
set(app_icon_macos "${CMAKE_CURRENT_SOURCE_DIR}/icons/focusassisticon.icns")
set_source_files_properties(${app_icon_macos} PROPERTIES
       MACOSX_PACKAGE_LOCATION "Resources")
qt_add_executable(FocusAssist8 MACOSX_BUNDLE main.cpp ${app_icon_macos})
else()
qt_add_executable(FocusAssist8
    main.cpp
)
endif()


qt_add_qml_module(FocusAssist8
    URI FocusAssist8
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        media/weird-horsecoint.png
        media/Decayingwaves.mp3
        media/pause.png
        media/anotherday.png
        media/viewmore.png
        SOURCES tasktimer.h tasktimer.cpp
        QML_FILES TimeSelectDialog.qml
        QML_FILES MyButton.qml
        QML_FILES FocusWindow.qml
        QML_FILES SmallBarTimer.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(FocusAssist8 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER com.cryref.FocusAssist8
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(FocusAssist8
    PRIVATE Qt6::Quick
)


include(GNUInstallDirs)
install(TARGETS FocusAssist8
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
