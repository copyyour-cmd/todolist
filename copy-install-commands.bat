@echo off
chcp 65001 >nul
echo ========================================
echo VoltAgent 代理批量安装助手
echo ========================================
echo.
echo 此脚本将帮助您复制安装命令到剪贴板
echo 然后您可以粘贴到 Claude Code CLI 中执行
echo.
echo 总共约 150+ 个代理将被安装
echo.
pause

echo.
echo 正在将所有安装命令复制到剪贴板...
type install-all-agents-commands.txt | clip

echo.
echo ✅ 成功! 所有安装命令已复制到剪贴板
echo.
echo 下一步操作:
echo 1. 打开 Claude Code CLI
echo 2. 按 Ctrl+V 粘贴命令
echo 3. 逐行执行 (或使用快捷方式批量执行)
echo 4. 如遇到 "已存在" 提示,直接跳过即可
echo.
echo ⚠️  注意:
echo - 安装过程可能需要 10-30 分钟
echo - 确保网络连接稳定
echo - 某些代理可能不存在,会显示错误,这是正常的
echo.
pause
