@echo off
echo ========================================
echo GraniVPN Admin Panel - Build Script
echo ========================================
echo.

echo [1/4] Checking Node.js...
node --version
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found! Please install Node.js first.
    pause
    exit /b 1
)

echo.
echo [2/4] Installing dependencies...
cd admin-panel
call npm install
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies!
    pause
    exit /b 1
)

echo.
echo [3/4] Building project...
call npm run build
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [4/4] Build completed successfully!
echo.
echo ========================================
echo NEXT STEPS:
echo ========================================
echo 1. Go to https://netlify.com
echo 2. Click "New site from Git"
echo 3. Connect your repository
echo 4. Set build command: npm run build
echo 5. Set publish directory: build
echo 6. Deploy!
echo.
echo Your admin panel will be available at:
echo https://your-site-name.netlify.app
echo.
echo Login credentials:
echo Email: admin@granivpn.com
echo Password: admin123
echo ========================================
pause





