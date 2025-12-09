@echo off
setlocal enabledelayedexpansion

echo ===== WatchStore Clean and Deploy Script =====

REM Set paths
set "TOMCAT_HOME=C:\Program Files\Apache Software Foundation\Tomcat 9.0_Tomcat9"
set "PROJECT_HOME=%~dp0"
set "TARGET_DIR=%PROJECT_HOME%target"
set "TOMCAT_PORT=8081"

echo Step 1: Stopping Tomcat...
call "%TOMCAT_HOME%\bin\shutdown.bat"
timeout /t 5 /nobreak

echo Step 2: Cleaning locked files...
REM Kill any Java processes that might be locking the files
taskkill /F /IM java.exe /T 2>nul
timeout /t 2 /nobreak

REM Remove target directory with force
if exist "%TARGET_DIR%" (
    echo Removing target directory...
    rd /s /q "%TARGET_DIR%" 2>nul
    if exist "%TARGET_DIR%" (
        echo Force removing target directory...
        rmdir /s /q "%TARGET_DIR%" 2>nul
    )
)

echo Step 3: Building project...
call mvn clean package -DskipTests

if %ERRORLEVEL% neq 0 (
    echo Build failed. Please check the error messages above.
    pause
    exit /b 1
)

echo Step 4: Deploying to Tomcat...
REM Clean Tomcat webapps
if exist "%TOMCAT_HOME%\webapps\WatchStore" (
    rd /s /q "%TOMCAT_HOME%\webapps\WatchStore"
)
if exist "%TOMCAT_HOME%\webapps\WatchStore.war" (
    del /f /q "%TOMCAT_HOME%\webapps\WatchStore.war"
)

REM Copy new WAR
copy "%TARGET_DIR%\WatchStore.war" "%TOMCAT_HOME%\webapps\"

echo Step 5: Starting Tomcat...
call "%TOMCAT_HOME%\bin\startup.bat"

echo Step 6: Waiting for Tomcat to start...
timeout /t 10 /nobreak

echo Step 7: Opening application...
start http://localhost:%TOMCAT_PORT%/WatchStore

echo ===== Deployment Complete =====
echo If you encounter any issues, please check:
echo 1. Tomcat logs at: %TOMCAT_HOME%\logs\catalina.out
echo 2. Project logs at: %TARGET_DIR%\WatchStore\WEB-INF\logs
echo 3. Application URL: http://localhost:%TOMCAT_PORT%/WatchStore
pause 