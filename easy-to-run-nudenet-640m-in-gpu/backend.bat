@echo off
:: 设置编码为 UTF-8
chcp 65001 >nul

:: 设置工作目录为脚本所在目录
cd /d "%~dp0"

:: 检查 Python 是否安装
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed. Please install Python first.
    pause
    exit /b 1
)

:: 检查并安装依赖
echo Checking and installing dependencies...
python -m pip install --upgrade pip
python -c "import os, subprocess, sys; required_packages = ['flask', 'ultralytics', 'opencv-python']; [subprocess.check_call([sys.executable, '-m', 'pip', 'install', package]) for package in required_packages if __import__('pkgutil').find_loader(package) is None]"

:: 激活虚拟环境（如果使用虚拟环境）
if exist ".venv\Scripts\activate" (
    call .venv\Scripts\activate
)

:: 启动 Flask 后端服务
echo Starting Flask backend on port 5000...
python backend.py

:: 保持终端打开
echo Backend is running. Press Ctrl+C to stop.
pause