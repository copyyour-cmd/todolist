#!/bin/bash

# 安全修复自动化脚本
# 使用方法: bash scripts/apply-security-fixes.sh

set -e  # 遇到错误立即退出

echo "========================================"
echo "🔒 TodoList 安全修复部署脚本"
echo "========================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否在server目录
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ 错误: 请在server目录下运行此脚本${NC}"
    exit 1
fi

echo "📋 步骤1: 安装安全依赖..."
npm install express-rate-limit helmet xss-clean express-validator express-mongo-sanitize

echo -e "${GREEN}✅ 依赖安装完成${NC}"
echo ""

echo "📋 步骤2: 生成强密钥..."
JWT_SECRET=$(openssl rand -base64 32)
DB_PASSWORD=$(openssl rand -base64 16 | tr -d "=+/" | cut -c1-20)

echo -e "${GREEN}✅ 密钥生成完成${NC}"
echo ""

echo "📋 步骤3: 更新环境变量..."
cat > .env.new << EOF
# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=todolist_cloud

# JWT配置 - 强密钥
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRES_IN=15m
REFRESH_TOKEN_EXPIRES_IN=7d

# 服务器配置
PORT=3000
NODE_ENV=production

# 文件上传配置
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=10485760

# CORS配置 - 请修改为实际域名
ALLOWED_ORIGINS=https://your-app.com,https://app.your-domain.com
EOF

echo -e "${YELLOW}⚠️  新的环境变量已保存到 .env.new${NC}"
echo -e "${YELLOW}⚠️  请手动检查并重命名: mv .env.new .env${NC}"
echo ""
echo "生成的密钥:"
echo "  JWT_SECRET: ${JWT_SECRET}"
echo "  DB_PASSWORD: ${DB_PASSWORD}"
echo ""

echo "📋 步骤4: 备份现有配置..."
if [ -f "server.js" ]; then
    cp server.js server.js.backup
    echo -e "${GREEN}✅ 已备份 server.js -> server.js.backup${NC}"
fi
echo ""

echo "📋 步骤5: 检查中间件文件..."
MIDDLEWARE_DIR="middleware"
if [ ! -d "$MIDDLEWARE_DIR" ]; then
    mkdir -p "$MIDDLEWARE_DIR"
    echo -e "${GREEN}✅ 创建 middleware 目录${NC}"
fi

required_files=(
    "validators.js"
    "rateLimiter.js"
    "corsConfig.js"
    "secureUpload.js"
)

for file in "${required_files[@]}"; do
    if [ -f "$MIDDLEWARE_DIR/$file" ]; then
        echo -e "${GREEN}✅ $file 已存在${NC}"
    else
        echo -e "${RED}❌ 缺少 $file${NC}"
    fi
done
echo ""

echo "📋 步骤6: 更新数据库密码..."
echo -e "${YELLOW}⚠️  请手动执行以下SQL命令更新数据库密码:${NC}"
echo ""
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
echo "FLUSH PRIVILEGES;"
echo ""

echo "📋 步骤7: 安全检查清单..."
echo ""
echo "请确认以下安全配置:"
echo "  [ ] JWT_SECRET已更新为强密钥"
echo "  [ ] DB_PASSWORD已更新"
echo "  [ ] .env文件在.gitignore中"
echo "  [ ] CORS配置了允许的域名"
echo "  [ ] 生产环境启用HTTPS"
echo "  [ ] 所有中间件文件已创建"
echo ""

echo "========================================"
echo "🎉 安全修复准备完成!"
echo "========================================"
echo ""
echo "后续步骤:"
echo "1. 检查并重命名 .env.new 为 .env"
echo "2. 更新数据库密码"
echo "3. 修改ALLOWED_ORIGINS为实际域名"
echo "4. 测试应用: npm run dev"
echo "5. 部署前配置HTTPS"
echo ""
echo -e "${GREEN}完整文档请查看: SECURITY_FIX.md${NC}"
echo "========================================"
