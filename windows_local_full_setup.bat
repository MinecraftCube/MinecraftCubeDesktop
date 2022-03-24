@echo off

curl https://dl.dropboxusercontent.com/s/i0s17qbooewf8le/minimal_resources.zip -o minimal_resources.zip

tar -xf minimal_resources.zip

set PROJECT_PATH=%CD%
set DART_TEST_RESOURCES=%PROJECT_PATH%\minimal_resources

echo Project Path=%PROJECT_PATH%
echo TEST RESOURCES: %DART_TEST_RESOURCES%


curl https://cdn.azul.com/zulu/bin/zulu17.32.13-ca-jdk17.0.2-win_x64.zip -o java17.zip
tar -xf java17.zip
set JAVA_17=%PROJECT_PATH%\zulu17.32.13-ca-jdk17.0.2-win_x64\bin\java.exe


curl https://cdn.azul.com/zulu/bin/zulu8.60.0.21-ca-jdk8.0.322-win_x64.zip -o java8.zip
tar -xf java8.zip
set JAVA_8=%PROJECT_PATH%\zulu8.60.0.21-ca-jdk8.0.322-win_x64\bin\java.exe

set JAVA_VERSION=pass
