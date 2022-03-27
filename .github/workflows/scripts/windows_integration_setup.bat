@echo off

curl https://cdn.azul.com/zulu/bin/zulu17.32.13-ca-jdk17.0.2-win_x64.zip -o java17.zip
tar -xf java17.zip
@REM set JAVA_17=%PROJECT_PATH%\zulu17.32.13-ca-jdk17.0.2-win_x64\bin\java.exe


curl https://cdn.azul.com/zulu/bin/zulu8.60.0.21-ca-jdk8.0.322-win_x64.zip -o java8.zip
tar -xf java8.zip
@REM set JAVA_8=%PROJECT_PATH%\zulu8.60.0.21-ca-jdk8.0.322-win_x64\bin\java.exe
