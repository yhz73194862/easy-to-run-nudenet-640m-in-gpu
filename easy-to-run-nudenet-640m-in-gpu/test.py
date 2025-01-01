from ultralytics import YOLO
import cv2
import argparse
import os

# 解析命令行参数
parser = argparse.ArgumentParser()
parser.add_argument('--source', type=str, required=True, help='输入文件路径')
parser.add_argument('--output-dir', type=str, default="output", help='推理结果保存路径')
args = parser.parse_args()

# 加载模型
model = YOLO('640m.pt')

# 检查输入文件是否为视频
if args.source.lower().endswith(('.mp4', '.avi', '.mov', '.mkv')):
    # 打开视频文件
    cap = cv2.VideoCapture(args.source)
    if not cap.isOpened():
        print(f"错误：无法打开视频文件 {args.source}")
        exit(1)

    # 获取视频信息
    frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    fps = int(cap.get(cv2.CAP_PROP_FPS))

    # 创建输出目录
    os.makedirs(args.output_dir, exist_ok=True)

    # 创建视频写入对象
    output_path = os.path.join(args.output_dir, os.path.basename(args.source))
    out = cv2.VideoWriter(output_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (frame_width, frame_height))

    # 逐帧处理视频
    while True:
        ret, frame = cap.read()
        if not ret:
            break

        # 对当前帧进行推理
        results = model(frame)

        # 获取处理后的帧
        processed_frame = results[0].plot()

        # 将处理后的帧写入输出视频
        out.write(processed_frame)

    # 释放资源
    cap.release()
    out.release()
    print(f"推理结果已保存到：{output_path}")

else:
    # 处理图像文件
    results = model(args.source, save=True, project=args.output_dir, name="exp")
    print(f"推理结果已保存到：{args.output_dir}/exp")