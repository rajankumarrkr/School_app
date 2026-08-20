import 'package:flutter/material.dart';
import '../../models/timetable_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/timetable_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../repositories/mock_school_repository.dart';

class TimetableScreen extends StatefulWidget {
  final bool isEmbedded;

  const TimetableScreen({super.key, this.isEmbedded = false});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen>
    with SingleTickerProviderStateMixin {
  final _repository = MockSchoolRepository();
  late TabController _tabController;
  Map<String, List<TimetableSlotModel>> _weeklyTimetable = {};
  bool _isLoading = true;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now().weekday; // 1 = Mon, 6 = Sat
    final initialIndex = (today >= 1 && today <= 6) ? today - 1 : 0;

    _tabController = TabController(
      length: _days.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _loadTimetable();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTimetable() async {
    final data = await _repository.getWeeklyTimetable();
    if (!mounted) return;
    setState(() {
      _weeklyTimetable = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Class Timetable'),
        automaticallyImplyLeading: !widget.isEmbedded,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryNavy,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: 'Mon'),
                Tab(text: 'Tue'),
                Tab(text: 'Wed'),
                Tab(text: 'Thu'),
                Tab(text: 'Fri'),
                Tab(text: 'Sat'),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: _days.map((day) {
                final slots = _weeklyTimetable[day] ?? [];
                if (slots.isEmpty) {
                  return EmptyStateView(
                    title: 'No Classes Scheduled',
                    message: 'Enjoy your free day or holiday! 🌟',
                    icon: Icons.event_busy_rounded,
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return TimetableCard(
                      slot: slot,
                      isCurrent: index == 0 && _isToday(day),
                    );
                  },
                );
              }).toList(),
            ),
    );
  }

  bool _isToday(String day) {
    final weekdayMap = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
    };
    return weekdayMap[DateTime.now().weekday] == day;
  }
}
