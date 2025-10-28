FROM node:22-bookworm

# 一次性安装 Python 3.11 及常用系统工具
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    python3-pip \
    python-is-python3 \
    build-essential \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 验证 node 和 npm 是否存在
RUN node --version && npm --version

WORKDIR /app

# 复制后端代码和依赖文件
COPY . .

# 构建前端
RUN cd web_app && \
    npm install && \
    npm run build && \
    cd - && \
    cp -rf web_app/dist iopaint/web_app && \
    rm -rf web_app/dist

# 创建并激活Python虚拟环境
RUN python -m venv /app/.venv && . /app/.venv/bin/activate && pip install --no-cache-dir -r requirements.txt && deactivate

# 暴露端口
EXPOSE 8080

# 设置环境变量，指定uv缓存目录和用户主目录
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH" \
    HOME="/root"

# 启动命令
CMD ["python", "main.py", "start", "--model", "lama", "--port", "8080"]
