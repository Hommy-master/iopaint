# 第一阶段：构建前端
FROM node:22-alpine AS frontend-builder

# 第二阶段：构建后端
FROM python:3.11-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 复制后端代码和依赖文件
COPY . .

RUN cd web_app && npm install && npm run build && cd -

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 暴露端口
EXPOSE 8080

# 设置环境变量，指定uv缓存目录和用户主目录
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH" \
    HOME="/root"

# 启动命令
CMD ["python", "main.py", "start", "--model", "lama", "--port", "8080"]
