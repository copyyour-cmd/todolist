#!/bin/bash

# TodoList API 测试脚本
BASE_URL="http://192.168.88.209:3000"

echo "======================================"
echo "TodoList API 测试"
echo "======================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. 健康检查
echo -e "${BLUE}1. 健康检查${NC}"
curl -s $BASE_URL/health | jq '.'
echo ""

# 2. 注册新用户
echo -e "${BLUE}2. 注册新用户${NC}"
REGISTER_RESPONSE=$(curl -s -X POST $BASE_URL/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser001",
    "email": "test001@example.com",
    "password": "password123",
    "nickname": "测试用户001",
    "deviceType": "android"
  }')

echo $REGISTER_RESPONSE | jq '.'

# 提取 token
TOKEN=$(echo $REGISTER_RESPONSE | jq -r '.data.token')
REFRESH_TOKEN=$(echo $REGISTER_RESPONSE | jq -r '.data.refreshToken')
echo ""

# 3. 用户登录
echo -e "${BLUE}3. 用户登录${NC}"
LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser001",
    "password": "password123",
    "deviceType": "android"
  }')

echo $LOGIN_RESPONSE | jq '.'

# 更新 token（使用登录返回的）
TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.data.token')
REFRESH_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.data.refreshToken')
echo ""

# 4. 获取当前用户信息
echo -e "${BLUE}4. 获取当前用户信息${NC}"
curl -s -X GET $BASE_URL/api/auth/me \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""

# 5. 刷新令牌
echo -e "${BLUE}5. 刷新令牌${NC}"
REFRESH_RESPONSE=$(curl -s -X POST $BASE_URL/api/auth/refresh-token \
  -H "Content-Type: application/json" \
  -d "{
    \"refreshToken\": \"$REFRESH_TOKEN\"
  }")

echo $REFRESH_RESPONSE | jq '.'

# 更新 token
NEW_TOKEN=$(echo $REFRESH_RESPONSE | jq -r '.data.token')
echo ""

# 6. 使用新令牌获取用户信息
echo -e "${BLUE}6. 使用新令牌获取用户信息${NC}"
curl -s -X GET $BASE_URL/api/auth/me \
  -H "Authorization: Bearer $NEW_TOKEN" | jq '.'
echo ""

# 7. 退出登录
echo -e "${BLUE}7. 退出登录${NC}"
curl -s -X POST $BASE_URL/api/auth/logout \
  -H "Authorization: Bearer $NEW_TOKEN" | jq '.'
echo ""

# 8. 验证登出后无法访问（应该返回401）
echo -e "${BLUE}8. 验证登出后无法访问（应该返回401）${NC}"
curl -s -X GET $BASE_URL/api/auth/me \
  -H "Authorization: Bearer $NEW_TOKEN" | jq '.'
echo ""

echo -e "${GREEN}======================================"
echo "测试完成！"
echo "======================================${NC}"
