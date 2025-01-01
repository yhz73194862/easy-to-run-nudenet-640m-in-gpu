# 此项目为windows环境（由于是winpython，可改），支持对象nvdia，cuda>=12.1。

### 先运行run_detection.bat，后将图片拖到test.bat测试。通过了就是完成部署。

请将640m拖到根目录下。
它将会下载好win-python。对应的cuda以确保高兼容性。如需更改，您可以选择自己更改.txt和run_detection.bat

/*1. Python 和 PyTorch 版本
Python 版本：3.12.4（通过 WinPython 安装）。
PyTorch 版本：2.3.0（通过 pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121 安装）。
CUDA 版本：12.1（通过 nvidia-cuda-runtime-cu12==12.5.82 安装）。
2. 支持的 CUDA 版本
PyTorch 2.3.0 支持以下 CUDA 版本：
CUDA 11.8
CUDA 12.1
你的项目明确使用了 CUDA 12.1，因此需要确保系统中安装了 CUDA 12.1 或更高版本。
3. 支持的显卡
CUDA 12.1 支持的显卡包括：
NVIDIA Ampere 架构（如 RTX 30 系列：RTX 3090、RTX 3080 等）。
NVIDIA Ada Lovelace 架构（如 RTX 40 系列：RTX 4090、RTX 4080 等）。
NVIDIA Turing 架构（如 RTX 20 系列：RTX 2080、RTX 2070 等）。
NVIDIA Volta 架构（如 V100）。
NVIDIA Pascal 架构（如 GTX 10 系列：GTX 1080、GTX 1070 等）。
最低要求：
显卡的算力（Compute Capability）必须 ≥ 3.5。
驱动程序版本必须 ≥ 525.60.13（CUDA 12.1 的最低驱动要求）。
4. 项目使用的框架和库
Ultralytics YOLO
你的项目中使用了 Ultralytics 的 YOLO 模型（from ultralytics import YOLO）。
Ultralytics YOLO 是基于 PyTorch 实现的，支持 GPU 加速和 CUDA。
模型是 640m.pt，这是一个基于 PyTorch 的 YOLO 模型文件。
*/ai总结，可能有误。


## 后端功能未完成
