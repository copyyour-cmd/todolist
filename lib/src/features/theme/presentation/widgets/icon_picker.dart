import 'package:flutter/material.dart';
import 'package:todolist/src/core/constants/app_icons.dart';

class IconPicker extends StatelessWidget {
  const IconPicker({
    required this.onIconSelected,
    this.selectedIcon,
    super.key,
  });

  final ValueChanged<IconData> onIconSelected;
  final IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: SizedBox(
        width: 500,
        height: 600,
        child: Column(
          children: [
            AppBar(
              title: const Text('选择图标'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: DefaultTabController(
                length: AppIcons.categories.length + 1,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        const Tab(text: '常用'),
                        ...AppIcons.categories.keys.map((category) =>
                            Tab(text: category)),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildIconGrid(theme, AppIcons.popular),
                          ...AppIcons.categories.values.map((icons) =>
                              _buildIconGrid(theme, icons)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconGrid(ThemeData theme, List<IconData> icons) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final icon = icons[index];
        final isSelected = selectedIcon?.codePoint == icon.codePoint;

        return InkWell(
          onTap: () {
            onIconSelected(icon);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : null,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        );
      },
    );
  }

  static Future<IconData?> show(
    BuildContext context, {
    IconData? selectedIcon,
  }) async {
    IconData? result;
    await showDialog(
      context: context,
      builder: (context) => IconPicker(
        selectedIcon: selectedIcon,
        onIconSelected: (icon) => result = icon,
      ),
    );
    return result;
  }
}
