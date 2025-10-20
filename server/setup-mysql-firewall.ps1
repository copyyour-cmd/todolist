# MySQL远程访问防火墙配置脚本
# 需要以管理员身份运行

Write-Host "正在配置MySQL远程访问..." -ForegroundColor Green

# 添加MySQL 3306端口的入站规则
try {
    New-NetFirewallRule -DisplayName "MySQL Port 3306" `
        -Direction Inbound `
        -Protocol TCP `
        -LocalPort 3306 `
        -Action Allow `
        -Profile Any `
        -ErrorAction Stop

    Write-Host "✓ 防火墙规则添加成功" -ForegroundColor Green
    Write-Host "  规则名称: MySQL Port 3306" -ForegroundColor Cyan
    Write-Host "  端口: 3306" -ForegroundColor Cyan
    Write-Host "  方向: 入站" -ForegroundColor Cyan
    Write-Host "  协议: TCP" -ForegroundColor Cyan
} catch {
    if ($_.Exception.Message -like "*already exists*") {
        Write-Host "✓ 防火墙规则已存在" -ForegroundColor Yellow
    } else {
        Write-Host "✗ 添加防火墙规则失败: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# 验证规则
Write-Host "`n验证防火墙规则..." -ForegroundColor Green
Get-NetFirewallRule -DisplayName "MySQL Port 3306" | Format-Table -AutoSize

Write-Host "`n配置完成！现在可以从远程主机访问MySQL了。" -ForegroundColor Green
Write-Host "测试命令: mysql -h <本机IP> -u root -p" -ForegroundColor Cyan
