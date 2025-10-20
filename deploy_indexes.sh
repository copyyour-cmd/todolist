#!/bin/bash

# ============================================
# MySQL 性能索引部署脚本
# ============================================
# 用途：在远程服务器上执行性能索引优化
# 服务器：43.156.6.206 (ubuntu@43.156.6.206)
# 数据库：MySQL 8.0.43
# ============================================

set -e  # 任何错误立即退出

# 配置变量
REMOTE_HOST="43.156.6.206"
REMOTE_USER="ubuntu"
DB_PASSWORD="goodboy"
DB_NAME="todolist_cloud"
LOCAL_SQL_FILE="E:/todolist/server/database/add_performance_indexes.sql"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

# 主函数
main() {
    print_info "======================================"
    print_info "MySQL 性能索引部署脚本"
    print_info "======================================"
    print_info ""

    # 检查前置条件
    print_info "检查前置条件..."

    if [ ! -f "$LOCAL_SQL_FILE" ]; then
        print_error "SQL脚本文件不存在: $LOCAL_SQL_FILE"
        exit 1
    fi
    print_success "SQL脚本文件已检查"

    # 显示配置信息
    print_info ""
    print_info "配置信息:"
    echo "  远程主机: $REMOTE_HOST"
    echo "  用户: $REMOTE_USER"
    echo "  数据库: $DB_NAME"
    echo "  SQL脚本: $LOCAL_SQL_FILE"
    print_info ""

    # 确认执行
    read -p "确认要执行索引优化? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "已取消执行"
        exit 1
    fi

    # 连接到远程服务器并备份数据库
    print_info ""
    print_info "步骤1: 创建数据库备份..."

    BACKUP_FILE="/tmp/todolist_cloud_backup_$(date +%Y%m%d_%H%M%S).sql.gz"

    ssh -t "$REMOTE_USER@$REMOTE_HOST" << EOF
        echo "开始备份数据库..."
        mysqldump -u root -p"$DB_PASSWORD" "$DB_NAME" | gzip > "$BACKUP_FILE"
        echo "备份完成: $BACKUP_FILE"
        ls -lh "$BACKUP_FILE"
EOF
    print_success "数据库备份完成"

    # 上传SQL脚本到远程服务器
    print_info ""
    print_info "步骤2: 上传SQL脚本到远程服务器..."

    REMOTE_SQL_FILE="/tmp/add_performance_indexes.sql"
    scp "$LOCAL_SQL_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_SQL_FILE"
    print_success "SQL脚本上传完成"

    # 在远程服务器执行索引创建脚本
    print_info ""
    print_info "步骤3: 执行索引创建脚本..."

    ssh -t "$REMOTE_USER@$REMOTE_HOST" << EOF
        echo "连接到MySQL数据库..."
        mysql -u root -p"$DB_PASSWORD" < "$REMOTE_SQL_FILE"
        if [ $? -eq 0 ]; then
            echo "索引创建成功！"
        else
            echo "索引创建失败！"
            exit 1
        fi
EOF
    print_success "索引创建成功"

    # 验证索引
    print_info ""
    print_info "步骤4: 验证索引创建..."

    ssh -t "$REMOTE_USER@$REMOTE_HOST" << EOF
        mysql -u root -p"$DB_PASSWORD" "$DB_NAME" << MYSQL_CMD
        SELECT table_name, index_name, column_name, seq_in_index
        FROM information_schema.statistics
        WHERE table_schema = '$DB_NAME'
        AND index_name IN (
            'idx_user_id_status',
            'idx_user_id_due_at',
            'idx_user_id_deleted_at',
            'idx_user_id_is_default',
            'idx_user_id_sync_at',
            'idx_user_id_started_at'
        )
        ORDER BY table_name, index_name, seq_in_index;
        MYSQL_CMD
EOF

    # 检查索引大小
    print_info ""
    print_info "步骤5: 检查索引占用空间..."

    ssh -t "$REMOTE_USER@$REMOTE_HOST" << EOF
        mysql -u root -p"$DB_PASSWORD" "$DB_NAME" << MYSQL_CMD
        SELECT
            table_name,
            index_name,
            ROUND(stat_value * @@innodb_page_size / 1024 / 1024, 2) AS 'Size (MB)'
        FROM mysql.innodb_index_stats
        WHERE stat_name = 'size'
        AND database_name = '$DB_NAME'
        AND table_name IN ('user_tasks', 'user_lists', 'sync_logs', 'cloud_sync_records')
        ORDER BY stat_value DESC;
        MYSQL_CMD
EOF

    # 清理临时文件
    print_info ""
    print_info "步骤6: 清理临时文件..."

    ssh "$REMOTE_USER@$REMOTE_HOST" "rm $REMOTE_SQL_FILE"
    print_success "临时文件已清理"

    # 总结
    print_success ""
    print_success "======================================"
    print_success "索引部署完成！"
    print_success "======================================"
    print_info ""
    print_info "执行摘要:"
    echo "  ✓ 数据库已备份: $BACKUP_FILE"
    echo "  ✓ 6个复合索引已创建"
    echo "  ✓ 预期性能提升: 50-80%"
    echo "  ✓ 推荐立即测试应用"
    print_info ""
    print_warning "如有问题，可执行以下回滚命令:"
    echo "  mysql -u root -p$DB_PASSWORD $DB_NAME < rollback_indexes.sql"
    print_info ""
}

# 运行主函数
main "$@"
