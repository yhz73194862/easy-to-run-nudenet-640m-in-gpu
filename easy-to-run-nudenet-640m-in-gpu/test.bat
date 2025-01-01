@echo off
:: 设置编码为 UTF-8
chcp 65001 >nul

:: 设置工作目录为脚本所在目录
cd /d "%~dp0"

:: 设置 WinPython 路径
set WINPYTHON_PATH=WPy64-31241\python-3.12.4.amd64
set PATH=%WINPYTHON_PATH%;%WINPYTHON_PATH%\Scripts;%PATH%

:: 激活虚拟环境
call .venv\Scripts\activate

:: 检查是否通过拖放提供了文件路径
if "%~1"=="" (
    echo 错误：未提供文件路径。
    echo 请将图片或视频文件拖放到此脚本上。
    pause
    exit /b 1
)

:: 获取拖放的文件路径
set FILE_PATH=%~1

:: 检查文件是否存在
if not exist "%FILE_PATH%" (
    echo 错误：文件不存在。
    pause
    exit /b 1
)

:: 获取文件扩展名
for %%i in ("%FILE_PATH%") do set EXT=%%~xi

:: 转换为小写
set EXT=%EXT:~1%
set EXT=%EXT: =%
set EXT=%EXT:.=%

:: 判断文件类型
if "%EXT%"=="jpg" (
    echo 检测到图像文件，开始推理...
    python test.py --source "%FILE_PATH%" --output-dir "output"
    goto END
)

if "%EXT%"=="png" (
    echo 检测到图像文件，开始推理...
    python test.py --source "%FILE_PATH%" --output-dir "output"
    goto END
)

if "%EXT%"=="mp4" (
    echo 检测到视频文件，开始推理...
    python test.py --source "%FILE_PATH%" --output-dir "output"
    goto END
)

if "%EXT%"=="avi" (
    echo 检测到视频文件，开始推理...
    python test.py --source "%FILE_PATH%" --output-dir "output"
    goto END
)

:: 如果文件类型不支持
echo 错误：不支持的文件类型。
echo 支持的格式：jpg, png, mp4, avi
pause
exit /b 1

:END
echo 推理完成。
pause