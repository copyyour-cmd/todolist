# 页面过渡动画系统

## 概述

本模块提供了一套完整的页面过渡动画解决方案,包括多种预设动画效果和自定义动画构建器。

## 已集成的动画

系统已自动应用以下页面过渡动画:

- **Android**: 淡入淡出 + 轻微上滑效果
- **iOS**: 原生Cupertino侧滑效果
- **Windows/Linux**: 淡入淡出 + 轻微上滑效果
- **macOS**: 原生Cupertino侧滑效果

### 自动生效

无需额外配置,所有使用`Navigator.push`、`context.push`等标准导航方法的页面跳转都会自动使用上述动画。

## 动画类型

### 1. CustomPageTransitionsBuilder (默认)
**效果**: 淡入淡出 + 轻微上滑(3%)
**特点**: 现代、流畅、不突兀
**适用场景**: 大部分页面跳转

```dart
// 自动应用,无需手动配置
Navigator.push(context, MaterialPageRoute(builder: (_) => NewPage()));
```

### 2. SlideRightTransitionsBuilder
**效果**: 从右侧滑入
**特点**: 类似iOS的原生效果
**适用场景**: 详情页、设置页

```dart
// 需要手动使用
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideRightTransitionsBuilder().buildTransitions(
        MaterialPageRoute(builder: (_) => child),
        context,
        animation,
        secondaryAnimation,
        child,
      );
    },
  ),
);
```

### 3. ScaleFadeTransitionsBuilder
**效果**: 缩放(0.9→1.0) + 淡入
**特点**: 有弹性感,轻盈
**适用场景**: 对话框风格的页面、弹出式页面

## 辅助方法

`PageTransitionHelpers` 提供了一系列便捷方法:

### 1. Hero动画路由

```dart
// 创建带Hero动画的页面跳转
Navigator.push(
  context,
  PageTransitionHelpers.createHeroRoute(
    page: DetailPage(item: item),
    heroTag: 'item-${item.id}',
  ),
);

// 在页面中使用Hero widget
Hero(
  tag: 'item-${item.id}',
  child: Image.network(item.imageUrl),
)
```

### 2. 底部滑入路由(模态框)

```dart
// 类似showModalBottomSheet的效果
Navigator.push(
  context,
  PageTransitionHelpers.createBottomSheetRoute(
    page: SettingsPage(),
    fullscreenDialog: true,
  ),
);
```

### 3. 纯淡入淡出路由

```dart
// 快速淡入淡出
Navigator.push(
  context,
  PageTransitionHelpers.createFadeRoute(
    page: LoadingPage(),
    duration: Duration(milliseconds: 150),
  ),
);
```

### 4. 旋转+缩放路由(特殊效果)

```dart
// 适合庆祝页面、成就解锁等场景
Navigator.push(
  context,
  PageTransitionHelpers.createRotateScaleRoute(
    page: SuccessPage(),
  ),
);
```

## 实际应用示例

### 示例1: 任务详情页(Hero动画)

```dart
// 列表页
ListView.builder(
  itemBuilder: (context, index) {
    final task = tasks[index];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransitionHelpers.createHeroRoute(
            page: TaskDetailPage(task: task),
            heroTag: 'task-${task.id}',
          ),
        );
      },
      child: Hero(
        tag: 'task-${task.id}',
        child: TaskCard(task: task),
      ),
    );
  },
)

// 详情页
class TaskDetailPage extends StatelessWidget {
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'task-${task.id}',
        child: TaskDetailCard(task: task),
      ),
    );
  }
}
```

### 示例2: 设置页(底部滑入)

```dart
// 从底部滑入的设置页
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {
    Navigator.push(
      context,
      PageTransitionHelpers.createBottomSheetRoute(
        page: SettingsPage(),
        fullscreenDialog: true,
      ),
    );
  },
)
```

### 示例3: 快捷操作菜单(淡入)

```dart
// 快速淡入的菜单
void showQuickMenu() {
  Navigator.push(
    context,
    PageTransitionHelpers.createFadeRoute(
      page: QuickActionMenu(),
      duration: Duration(milliseconds: 200),
    ),
  );
}
```

## 性能优化建议

1. **避免过度使用复杂动画**
   - 旋转+缩放动画仅用于特殊场景
   - 大部分页面使用默认的淡入+上滑即可

2. **Hero动画注意事项**
   - 确保源和目标Hero的tag一致
   - 避免在Hero中使用过于复杂的widget树

3. **动画时长建议**
   - 快速操作: 150-250ms
   - 标准页面: 250-350ms
   - 强调效果: 350-500ms
   - 避免超过600ms

## 动画曲线说明

| 曲线 | 效果 | 适用场景 |
|------|------|---------|
| `Curves.easeOutCubic` | 快速开始,缓慢结束 | 页面进入 |
| `Curves.easeOutQuart` | 更加明显的减速效果 | 侧滑效果 |
| `Curves.easeOutBack` | 轻微回弹效果 | 缩放动画 |
| `Curves.elasticOut` | 弹性效果 | 特殊强调 |

## 调试技巧

### 查看动画效果

```dart
// 开启动画网格(显示重绘区域)
void main() {
  debugPaintSizeEnabled = true; // 显示尺寸
  runApp(MyApp());
}

// 或在开发者选项中开启
// 设置 > 开发者选项 > 显示GPU过度绘制
```

### 性能监控

```dart
// 监控动画帧率
import 'package:flutter/scheduler.dart';

void checkPerformance() {
  SchedulerBinding.instance.addTimingsCallback((timings) {
    for (final timing in timings) {
      print('Frame duration: ${timing.totalSpan.inMilliseconds}ms');
      if (timing.totalSpan.inMilliseconds > 16) {
        print('⚠️ Frame drop detected!');
      }
    }
  });
}
```

## 常见问题

### Q1: 为什么我的页面没有动画?
A: 检查是否使用了`MaterialPageRoute`或标准的导航方法。某些第三方路由库可能需要单独配置。

### Q2: 如何禁用某个页面的过渡动画?
```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewPage(),
    transitionDuration: Duration.zero, // 禁用动画
  ),
);
```

### Q3: 动画卡顿怎么办?
- 检查widget树是否过深
- 使用`RepaintBoundary`隔离重绘区域
- 避免在动画中执行耗时操作

## 未来计划

- [ ] 添加更多预设动画效果
- [ ] 支持自定义动画参数配置
- [ ] 添加手势驱动的页面关闭动画
- [ ] 提供动画录制和回放功能(调试用)

## 参考资料

- [Flutter动画官方文档](https://flutter.dev/docs/development/ui/animations)
- [Material Design动画指南](https://material.io/design/motion)
- [iOS人机界面指南-动画](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/animation/)
