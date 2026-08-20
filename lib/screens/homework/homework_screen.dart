import 'package:flutter/material.dart';
import '../../models/homework_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/homework_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../repositories/mock_school_repository.dart';
import '../../routes/app_routes.dart';

class HomeworkScreen extends StatefulWidget {
  final bool isEmbedded;

  const HomeworkScreen({super.key, this.isEmbedded = false});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen>
    with SingleTickerProviderStateMixin {
  final _repository = MockSchoolRepository();
  late TabController _tabController;
  List<HomeworkModel> _allHomework = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadHomework();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHomework() async {
    final list = await _repository.getHomeworkList();
    if (!mounted) return;
    setState(() {
      _allHomework = list;
      _isLoading = false;
    });
  }

  List<HomeworkModel> _filterList(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return _allHomework
            .where((h) => h.status == HomeworkStatus.pending)
            .toList();
      case 2:
        return _allHomework
            .where((h) => h.status == HomeworkStatus.completed)
            .toList();
      case 3:
        return _allHomework
            .where((h) => h.status == HomeworkStatus.overdue)
            .toList();
      default:
        return _allHomework;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Homework & Assignments'),
        automaticallyImplyLeading: !widget.isEmbedded,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryNavy,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTextStyles.labelSmall,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
                Tab(text: 'Overdue'),
              ],
              onTap: (_) => setState(() {}),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildHomeworkList(_filterList(0), 'No Homework Assigned', 'You are completely caught up with all school assignments! 🎉'),
                _buildHomeworkList(_filterList(1), 'No Pending Homework', 'Great job! No assignments are waiting for submission.'),
                _buildHomeworkList(_filterList(2), 'No Completed Homework', 'Submit your assignments to see them listed here.'),
                _buildHomeworkList(_filterList(3), 'No Overdue Homework', 'Excellent discipline! None of your tasks are overdue.'),
              ],
            ),
    );
  }

  Widget _buildHomeworkList(
      List<HomeworkModel> items, String emptyTitle, String emptyMsg) {
    if (items.isEmpty) {
      return EmptyStateView(
        title: emptyTitle,
        message: emptyMsg,
        icon: Icons.assignment_turned_in_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHomework,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final hw = items[index];
          return HomeworkCard(
            homework: hw,
            onTap: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.homeworkDetail,
                arguments: hw,
              );
              if (result == true) {
                _loadHomework();
              }
            },
          );
        },
      ),
    );
  }
}
