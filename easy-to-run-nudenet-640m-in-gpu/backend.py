import os
import subprocess
import sys
from flask import Flask, request, jsonify
from ultralytics import YOLO

# 检查并安装依赖
def check_dependencies():
    required_packages = ['flask', 'ultralytics', 'opencv-python']
    for package in required_packages:
        try:
            __import__(package)
        except ImportError:
            print(f"Installing missing dependency: {package}")
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', package])

check_dependencies()

app = Flask(__name__)

# 加载 YOLO 模型
model = YOLO('640m.pt')

# 设置文件保存目录
UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'output'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload_file():
    # 检查是否有文件上传
    if 'file' not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files['file']

    # 检查文件名是否为空
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    # 保存上传的文件
    file_path = os.path.join(UPLOAD_FOLDER, file.filename)
    file.save(file_path)

    # 处理文件（图像或视频）
    if file.filename.lower().endswith(('.mp4', '.avi', '.mov', '.mkv')):
        # 处理视频
        cap = cv2.VideoCapture(file_path)
        frame_width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        frame_height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        fps = int(cap.get(cv2.CAP_PROP_FPS))

        output_path = os.path.join(OUTPUT_FOLDER, file.filename)
        out = cv2.VideoWriter(output_path, cv2.VideoWriter_fourcc(*'mp4v'), fps, (frame_width, frame_height))

        while True:
            ret, frame = cap.read()
            if not ret:
                break
            results = model(frame)
            processed_frame = results[0].plot()
            out.write(processed_frame)

        cap.release()
        out.release()
        result_message = f"Processed video saved to {output_path}"

    else:
        # 处理图像
        results = model(file_path, save=True, project=OUTPUT_FOLDER, name="exp")
        result_message = f"Processed image saved to {OUTPUT_FOLDER}/exp"

    # 返回处理结果
    return jsonify({"message": result_message}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)