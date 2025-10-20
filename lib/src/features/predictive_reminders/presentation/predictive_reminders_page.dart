import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 预测性提醒页面
class PredictiveRemindersPage extends ConsumerStatefulWidget {
  const PredictiveRemindersPage({super.key});

  static const routePath = '/predictive-reminders';
  static const routeName = 'predictive-reminders';

  @override
  ConsumerState<PredictiveRemindersPage> createState() => _PredictiveRemindersPageState();
}

class _PredictiveRemindersPageState extends ConsumerState<PredictiveRemindersPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('🔮'),
            SizedBox(width: 8),
            Text('预测性提醒'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 功能介绍卡片
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        '智能预测提醒',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '本小姐实现的高级功能可以根据天气和交通情况，智能地提醒您完成任务和出发时间！',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 天气提醒功能
          _FeatureCard(
            icon: '🌦️',
            title: '天气智能提醒',
            description: '下雨天自动提醒带伞相关任务',
            features: const [
              '• 自动检测天气关键词（雨、伞、户外等）',
              '• 根据天气状况发送提醒',
              '• 极端天气警告提醒',
            ],
            status: _FeatureStatus.available,
            onTap: () => _showWeatherSetup(context),
          ),
          const SizedBox(height: 12),

          // 交通预测功能
          _FeatureCard(
            icon: '🚗',
            title: '交通智能预测',
            description: '根据实时路况提前提醒出发时间',
            features: const [
              '• 实时路况监控',
              '• 智能计算出发时间',
              '• 拥堵路段自动预警',
            ],
            status: _FeatureStatus.available,
            onTap: () => _showTrafficSetup(context),
          ),
          const SizedBox(height: 12),

          // 位置场景识别（未来功能）
          _FeatureCard(
            icon: '📍',
            title: '位置场景识别',
            description: '到达特定位置时自动提醒相关任务',
            features: const [
              '• 地理围栏监听',
              '• 场景自动识别',
              '• 位置提醒历史',
            ],
            status: _FeatureStatus.comingSoon,
            onTap: () => _showComingSoonDialog(context, '位置场景识别'),
          ),
          const SizedBox(height: 24),

          // API配置说明
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'API 配置说明',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '本功能需要配置以下API密钥：\n\n'
                    '🌤️ 天气服务（二选一）：\n'
                    '  • OpenWeatherMap API（免费，国际）\n'
                    '  • 和风天气 API（推荐，国内准确）\n\n'
                    '🗺️ 地图服务（二选一）：\n'
                    '  • Google Maps API（国际）\n'
                    '  • 高德地图 API（推荐，国内准确）\n\n'
                    '如未配置，将使用模拟数据进行演示。',
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _showAPIConfiguration(context),
                      icon: const Icon(Icons.settings),
                      label: const Text('配置 API'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWeatherSetup(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🌦️'),
            SizedBox(width: 8),
            Text('天气智能提醒'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '如何使用：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. 在任务标题或备注中包含天气关键词'),
              Text('   例如：带雨伞、户外运动、防晒等'),
              SizedBox(height: 8),
              Text('2. 系统会自动检测当前天气'),
              SizedBox(height: 8),
              Text('3. 当天气符合条件时，自动发送提醒'),
              SizedBox(height: 16),
              Text(
                '支持的天气条件：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('☀️ 晴天'),
              Text('☁️ 多云'),
              Text('🌧️ 雨天'),
              Text('⛈️ 雷暴'),
              Text('❄️ 雪天'),
              Text('🌫️ 雾天'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  void _showTrafficSetup(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🚗'),
            SizedBox(width: 8),
            Text('交通智能预测'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '如何使用：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. 在任务中设置目的地位置'),
              Text('2. 设置约定到达时间'),
              Text('3. 系统自动监控实时路况'),
              Text('4. 智能计算最佳出发时间'),
              Text('5. 提前10分钟发送出发提醒'),
              SizedBox(height: 16),
              Text(
                '智能预测特性：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('🟢 路况畅通 - 按正常时间提醒'),
              Text('🟡 一般拥堵 - 提前10分钟'),
              Text('🟠 严重拥堵 - 提前20分钟'),
              Text('🔴 极度拥堵 - 提前30分钟'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String featureName) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('🚧'),
            SizedBox(width: 8),
            Text('敬请期待'),
          ],
        ),
        content: Text('$featureName 功能正在开发中，敬请期待！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showAPIConfiguration(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 8),
            Text('API 配置'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '获取 API 密钥：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('🌤️ 和风天气 API:'),
              Text('  访问 dev.qweather.com 注册获取'),
              SizedBox(height: 8),
              Text('🌐 OpenWeatherMap API:'),
              Text('  访问 openweathermap.org 注册获取'),
              SizedBox(height: 8),
              Text('🗺️ 高德地图 API:'),
              Text('  访问 lbs.amap.com 注册获取'),
              SizedBox(height: 8),
              Text('🌍 Google Maps API:'),
              Text('  访问 console.cloud.google.com 注册获取'),
              SizedBox(height: 16),
              Text(
                '注意：免费版API有调用次数限制，请合理使用。',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

enum _FeatureStatus {
  available,
  comingSoon,
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.status,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String description;
  final List<String> features;
  final _FeatureStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = status == _FeatureStatus.available;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isAvailable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '敬请期待',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '可用',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    feature,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isAvailable ? Colors.black87 : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
