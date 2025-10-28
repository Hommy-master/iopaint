# 第一阶段：构建前端
FROM node:22-alpine AS frontend-builder

WORKDIR /app

# 复制前端代码
COPY web_app/ ./web_app/

# 构建前端
RUN cd web_app && \
    npm install && \
    npm run build

# 第二阶段：构建后端
FROM python:3.11-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 复制前端构建结果
COPY --from=frontend-builder /app/web_app/dist/ ./iopaint/web_app/

# 复制后端代码和依赖文件
COPY . .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 创建checkpoints目录并下载模型
RUN mkdir -p checkpoints && \
    cd checkpoints && \
    wget -O big-lama.pt "https://release-assets.githubusercontent.com/github-production-release-asset/143410310/22b2930e-5328-4ff1-8537-46332eca8550?sp=r&sv=2018-11-09&sr=b&spr=https&se=2025-10-28T12%3A11%3A09Z&rscd=attachment%3B+filename%3Dbig-lama.pt&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2025-10-28T11%3A10%3A52Z&ske=2025-10-28T12%3A11%3A09Z&sks=b&skv=2018-11-09&sig=Jg6iFB%2BYbc2p%2BxfsfO5Drkn4mJYCOCjgdBOsVhXJl20%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc2MTY1NDk3NCwibmJmIjoxNzYxNjUxMzc0LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.PuJIrKu8mk4hiUx0iqEITQ2uz6oReSf9wePI6kFobbE&response-content-disposition=attachment%3B%20filename%3Dbig-lama.pt&response-content-type=application%2Foctet-stream"

# 暴露端口
EXPOSE 8080

# 设置环境变量，指定uv缓存目录和用户主目录
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH" \
    HOME="/root"

# 启动命令
CMD ["python", "main.py", "start", "--model", "lama", "--port", "8080"]
