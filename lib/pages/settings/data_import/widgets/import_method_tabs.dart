import 'package:flutter/material.dart';

/// 导入方式枚举
enum ImportMethod {
  file('文件'),
  paste('粘贴');

  final String label;
  const ImportMethod(this.label);
}

/// 导入方式切换 Tabs
class ImportMethodTabs extends StatefulWidget {
  final ImportMethod initialMethod;
  final ValueChanged<ImportMethod> onChanged;

  const ImportMethodTabs({
    super.key,
    required this.initialMethod,
    required this.onChanged,
  });

  @override
  State<ImportMethodTabs> createState() => _ImportMethodTabsState();
}

class _ImportMethodTabsState extends State<ImportMethodTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: widget.initialMethod == ImportMethod.file ? 0 : 1,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final method = _tabController.index == 0
          ? ImportMethod.file
          : ImportMethod.paste;
      widget.onChanged(method);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '📁 选择文件'),
            Tab(text: '📋 粘贴 JSON'),
          ],
        ),
      ],
    );
  }
}
