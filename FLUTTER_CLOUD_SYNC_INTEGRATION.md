# Flutter 云同步集成文档

## ✅ 已完成的功能

### 1. **云服务层 (Cloud Services)**

#### TaskCloudService - 任务云端服务
- ✅ `getTasks()` - 获取云端任务列表（支持分页、过滤、增量同步）
- ✅ `getTask()` - 获取单个任务详情
- ✅ `createTask()` - 创建云端任务
- ✅ `updateTask()` - 更新云端任务（支持版本冲突检测）
- ✅ `deleteTask()` - 删除任务（软删除/永久删除）
- ✅ `restoreTask()` - 恢复已删除任务
- ✅ `batchUpdateTasks()` - 批量更新任务

#### ListCloudService - 列表云端服务
- ✅ `getAllLists()` - 通过同步接口获取所有列表
- ✅ `listToJson()` - 列表序列化

#### TagCloudService - 标签云端服务
- ✅ `getAllTags()` - 通过同步接口获取所有标签
- ✅ `tagToJson()` - 标签序列化

### 2. **云同步管理器 (CloudSyncManager)**

#### 核心功能
- ✅ 统一管理任务、列表、标签的云同步
- ✅ 自动同步机制（每5分钟）
- ✅ 增量同步支持
- ✅ 版本冲突检测
- ✅ 冲突解决策略
- ✅ 同步状态管理
- ✅ 强制全量同步
- ✅ 离线队列支持

#### 同步状态
```dart
enum SyncStatus {
  idle,      // 空闲
  syncing,   // 同步中
  success,   // 成功
  failed,    // 失败
  conflict,  // 有冲突
}
```

#### 主要方法
- `syncAll()` - 执行完整同步
- `forceFullSync()` - 强制全量同步
- `resolveConflictWithServer()` - 使用服务器版本解决冲突
- `resolveConflictWithClient()` - 使用客户端版本解决冲突
- `setAutoSync()` - 设置自动同步
- `getSyncStatus()` - 获取同步状态

### 3. **UI组件**

#### SyncConflictDialog - 冲突解决对话框
- ✅ 可视化显示冲突的两个版本
- ✅ 对比任务标题、描述、优先级、状态
- ✅ 显示版本号和更新时间
- ✅ 一键选择保留版本

#### SyncStatusIndicator - 同步状态指示器
- ✅ 实时显示同步状态
- ✅ 上次同步时间
- ✅ 错误信息提示
- ✅ 冲突数量提示

#### SyncFloatingButton - 浮动同步按钮
- ✅ 一键触发同步
- ✅ 同步中状态显示

#### SyncSettingsPage - 同步设置页面
- ✅ 同步状态查看
- ✅ 立即同步按钮
- ✅ 强制全量同步
- ✅ 自动同步开关
- ✅ 冲突列表管理
- ✅ 同步历史查看
- ✅ 帮助信息

### 4. **Riverpod集成**

#### Providers
```dart
- dioClientProvider           // HTTP客户端
- authServiceProvider          // 认证服务
- syncServiceProvider          // 同步服务
- taskCloudServiceProvider     // 任务云端服务
- listCloudServiceProvider     // 列表云端服务
- tagCloudServiceProvider      // 标签云端服务
- cloudSyncManagerProvider     // 云同步管理器
- autoSyncEnabledProvider      // 自动同步状态
- syncStatusProvider           // 同步状态
- hasConflictsProvider         // 是否有冲突
```

---

## 📦 新增文件列表

### 服务层
1. `lib/src/infrastructure/services/task_cloud_service.dart`
2. `lib/src/infrastructure/services/list_cloud_service.dart`
3. `lib/src/infrastructure/services/tag_cloud_service.dart`
4. `lib/src/infrastructure/services/cloud_sync_manager.dart`
5. `lib/src/infrastructure/services/cloud_sync_provider.dart`

### UI组件
6. `lib/src/features/sync/presentation/widgets/sync_conflict_dialog.dart`
7. `lib/src/features/sync/presentation/widgets/sync_status_indicator.dart`
8. `lib/src/features/sync/presentation/pages/sync_settings_page.dart`

---

## 🚀 使用指南

### 1. 在主页面集成同步状态显示

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'infrastructure/services/cloud_sync_provider.dart';
import 'features/sync/presentation/widgets/sync_status_indicator.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncManager = ref.watch(cloudSyncManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('待办事项'),
        actions: [
          // 同步状态指示器
          SyncStatusIndicator(
            syncManager: syncManager,
            onTap: () {
              // 跳转到同步设置页面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SyncSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: SyncFloatingButton(
        syncManager: syncManager,
        onPressed: () => syncManager.syncAll(),
      ),
      // ...
    );
  }
}
```

### 2. 在应用启动时初始化同步

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 应用启动时执行首次同步
    ref.listen(cloudSyncManagerProvider, (previous, next) {
      if (previous == null) {
        next.syncAll();
      }
    });

    return MaterialApp(
      // ...
    );
  }
}
```

### 3. 处理同步冲突

```dart
final syncManager = ref.watch(cloudSyncManagerProvider);

// 监听冲突
if (syncManager.hasConflicts) {
  for (final conflict in syncManager.conflicts) {
    showDialog(
      context: context,
      builder: (_) => SyncConflictDialog(
        conflict: conflict,
        onResolveWithServer: () {
          syncManager.resolveConflictWithServer(conflict);
        },
        onResolveWithClient: () {
          syncManager.resolveConflictWithClient(conflict);
        },
      ),
    );
  }
}
```

### 4. 任务操作时触发同步

```dart
// 创建任务后同步
await taskRepository.add(newTask);
await syncManager.syncAll();

// 更新任务后同步
await taskRepository.update(updatedTask);
await syncManager.syncAll();

// 删除任务后标记并同步
await taskRepository.delete(taskId);
await syncManager.markTaskAsDeleted(taskId);
await syncManager.syncAll();
```

---

## ⚙️ 配置说明

### 自动同步间隔

默认每5分钟自动同步一次，可在 `CloudSyncManager` 构造函数中修改：

```dart
Timer.periodic(
  const Duration(minutes: 5),  // 修改这里
  (_) => syncAll(),
);
```

### 同步策略

#### 增量同步（默认）
- 只同步自上次同步以来变更的数据
- 使用 `updatedAfter` 参数
- 节省流量，速度快

#### 全量同步
- 下载服务器所有数据
- 覆盖本地数据
- 用于解决严重冲突或数据损坏

```dart
// 强制全量同步
await syncManager.forceFullSync();
```

---

## 🔧 故障排查

### 1. 同步失败

**检查项**:
- ✅ 用户是否已登录
- ✅ 网络连接是否正常
- ✅ 服务器是否运行
- ✅ Token是否过期

```dart
// 查看错误信息
if (syncManager.status == SyncStatus.failed) {
  print('同步失败: ${syncManager.errorMessage}');
}
```

### 2. 冲突处理

**冲突产生原因**:
- 多个设备同时修改同一任务
- 版本号不一致

**解决方案**:
1. 自动解决：选择服务器版本或客户端版本
2. 手动解决：在冲突对话框中选择

### 3. 版本冲突异常

```dart
try {
  await taskCloudService.updateTask(task);
} on TaskVersionConflictException catch (e) {
  print('版本冲突: 客户端${e.clientVersion} vs 服务器${e.serverVersion}');
  // 使用服务器版本
  await taskRepository.update(e.serverTask);
}
```

---

## 📊 性能优化

### 1. 减少同步频率

对于数据变化不频繁的场景，可以延长自动同步间隔：

```dart
Timer.periodic(
  const Duration(minutes: 15),  // 15分钟同步一次
  (_) => syncAll(),
);
```

### 2. 批量操作

使用批量更新API减少网络请求：

```dart
await taskCloudService.batchUpdateTasks(
  taskIds,
  {'status': 'completed'},
);
```

### 3. 离线队列

本地操作自动保存到队列，网络恢复后自动同步：

```dart
// 删除任务时标记
await syncManager.markTaskAsDeleted(taskId);

// 稍后同步时自动处理
await syncManager.syncAll();
```

---

## 🔐 安全建议

### 1. Token刷新

Token会自动刷新，无需手动处理：

```dart
// AuthInterceptor已自动处理401错误
// 自动刷新token并重试请求
```

### 2. 数据验证

同步前验证数据完整性：

```dart
if (task.title.isEmpty) {
  throw Exception('任务标题不能为空');
}
```

---

## 📝 开发检查清单

- [x] TaskCloudService创建完成
- [x] ListCloudService创建完成
- [x] TagCloudService创建完成
- [x] CloudSyncManager创建完成
- [x] 冲突解决UI创建完成
- [x] 同步状态指示器创建完成
- [x] 同步设置页面创建完成
- [x] Riverpod Provider集成完成
- [x] 代码生成运行成功
- [ ] 集成到主应用
- [ ] 测试完整同步流程
- [ ] 测试冲突解决流程
- [ ] 测试离线队列

---

## 🎯 下一步工作

### 必须完成
1. **集成到主应用** - 在主页面添加同步功能
2. **完整测试** - 多设备同步测试
3. **错误处理** - 完善异常处理逻辑

### 可选增强
4. **列表和标签API** - 补充独立的CRUD接口
5. **WebSocket实时同步** - 推送实时更新
6. **同步进度显示** - 显示上传/下载进度
7. **同步日志** - 记录详细同步日志

---

## 📚 相关文档

- [API_NEW_FEATURES.md](./server/API_NEW_FEATURES.md) - 后端API文档
- [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) - 部署指南
- [DEVELOPMENT_SUMMARY.md](./DEVELOPMENT_SUMMARY.md) - 开发总结

---

## ✨ 总结

Flutter云同步集成已完成核心功能：

- ✅ **8个新文件** - 完整的云同步系统
- ✅ **3大服务** - Task/List/Tag云端服务
- ✅ **统一管理器** - CloudSyncManager
- ✅ **完整UI** - 冲突解决、状态显示、设置页面
- ✅ **自动同步** - 5分钟间隔自动同步
- ✅ **冲突检测** - 版本冲突自动检测
- ✅ **离线支持** - 离线队列机制

现在只需要**集成到主应用**并**测试**即可投入使用！🎉
