@echo off
:: 设置编码为 UTF-8
chcp 65001 >nul

:: 设置工作目录为脚本所在目录
cd /d "%~dp0"

:: 设置 WinPython 路径
set WINPYTHON_PATH=WPy64-31241\python-3.12.4.amd64

:: 检查 WinPython 是否已安装
if exist "%WINPYTHON_PATH%\python.exe" (
    echo WinPython 已安装，跳过下载和安装步骤。
    goto SKIP_INSTALL
)

:: 设置 WinPython 下载链接和安装路径
set WINPYTHON_URL=https://github.com/winpython/winpython/releases/download/8.2.20240618final/Winpython64-3.12.4.1dot.exe
set WINPYTHON_INSTALLER=Winpython64-3.12.4.1dot.exe

:: 1. 下载 WinPython
echo 正在下载 WinPython 8.2.20240618...
powershell -Command "Invoke-WebRequest %WINPYTHON_URL% -OutFile %WINPYTHON_INSTALLER%"
if not exist "%WINPYTHON_INSTALLER%" (
    echo 错误：下载 WinPython 失败。
    pause
    exit /b 1
)
echo 下载完成。

:: 2. 安装 WinPython
echo 正在安装 WinPython...
start /wait %WINPYTHON_INSTALLER% /SILENT /DIR=WPy64-31241
if not exist "%WINPYTHON_PATH%\python.exe" (
    echo 错误：WinPython 安装失败。
    pause
    exit /b 1
)
echo WinPython 安装完成。

:SKIP_INSTALL
:: 3. 设置 WinPython 环境变量
set PATH=%WINPYTHON_PATH%;%WINPYTHON_PATH%\Scripts;%PATH%

:: 4. 创建虚拟环境
echo 正在创建虚拟环境...
"%WINPYTHON_PATH%\python" -m venv .venv
if not exist ".venv\Scripts\activate" (
    echo 错误：虚拟环境创建失败。
    pause
    exit /b 1
)
echo 虚拟环境创建完成。

:: 5. 激活虚拟环境并安装依赖
echo 激活虚拟环境并安装依赖...
call .venv\Scripts\activate

:: 检查 requirements.txt 文件
if not exist "requirements.txt" (
    echo 错误：未找到 requirements.txt 文件。
    echo 请确保 requirements.txt 文件与脚本在同一目录下。
    pause
    exit /b 1
)

:: 安装 PyTorch 的 CUDA 版本
echo 正在安装 PyTorch 的 CUDA 版本...
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121

:: 安装其他依赖
pip install -r requirements.txt
echo 依赖安装完成。

:: 6. 执行 Python 脚本
echo 正在运行检测脚本...
if not exist "test.py" (
    echo 错误：未找到 test.py 文件。
    pause
    exit /b 1
)
python test.py
echo 检测结果已显示。

:: 脚本结束
echo 脚本执行完毕，按任意键退出...
pause