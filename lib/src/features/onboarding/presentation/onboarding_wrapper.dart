import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/src/features/onboarding/presentation/onboarding_page.dart';

/// Onboarding 包装器
/// 检查是否首次启动,并在完成引导后自动切换到主应用
class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({
    super.key,
    required this.child,
    required this.sharedPreferences,
  });

  final Widget child;
  final SharedPreferences sharedPreferences;

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  late bool _isFirstLaunch;

  @override
  void initState() {
    super.initState();
    _isFirstLaunch = widget.sharedPreferences.getBool('is_first_launch') ?? true;
  }

  void _onOnboardingComplete() {
    setState(() {
      _isFirstLaunch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstLaunch) {
      return OnboardingPageWithCallback(
        onComplete: _onOnboardingComplete,
      );
    }
    return widget.child;
  }
}

/// 带回调的 Onboarding 页面
class OnboardingPageWithCallback extends StatelessWidget {
  const OnboardingPageWithCallback({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _OnboardingPageInternal(onComplete: onComplete),
    );
  }
}

class _OnboardingPageInternal extends StatefulWidget {
  const _OnboardingPageInternal({required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<_OnboardingPageInternal> createState() => _OnboardingPageInternalState();
}

class _OnboardingPageInternalState extends State<_OnboardingPageInternal> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.task_alt,
      title: '轻松管理任务',
      description: '创建任务、设置提醒、跟踪进度\n一切尽在掌握',
      color: Colors.blue,
    ),
    OnboardingData(
      icon: Icons.mic,
      title: '语音输入',
      description: '用语音快速创建任务\nAI智能解析时间和优先级',
      color: Colors.orange,
    ),
    OnboardingData(
      icon: Icons.note,
      title: '灵感笔记',
      description: '随时记录灵感\nMarkdown格式支持',
      color: Colors.green,
    ),
    OnboardingData(
      icon: Icons.cloud_done,
      title: '云端同步',
      description: '多设备自动同步\n数据永不丢失',
      color: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);
    widget.onComplete();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text('跳过'),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Icon
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Icon(
                                page.icon,
                                size: 120,
                                color: page.color,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),

                        // Title
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          page.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.blue
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Previous Button
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        child: const Text('上一步'),
                      ),
                    )
                  else
                    const Spacer(),

                  const SizedBox(width: 16),

                  // Next/Finish Button
                  Expanded(
                    child: FilledButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage < _pages.length - 1 ? '下一步' : '开始使用',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
