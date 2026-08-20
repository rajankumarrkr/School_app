import 'package:flutter/material.dart';
import '../../models/notice_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/notice_card.dart';
import '../../widgets/empty_state_view.dart';
import '../../repositories/mock_school_repository.dart';
import '../../routes/app_routes.dart';

class NoticesScreen extends StatefulWidget {
  final bool isEmbedded;

  const NoticesScreen({super.key, this.isEmbedded = false});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  final _repository = MockSchoolRepository();
  List<NoticeModel> _notices = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Academic',
    'Events',
    'Holiday',
    'Exams',
    'Sports',
  ];

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    final list = await _repository.getNotices();
    if (!mounted) return;
    setState(() {
      _notices = list;
      _isLoading = false;
    });
  }

  List<NoticeModel> _getFilteredNotices() {
    if (_selectedCategory == 'All') return _notices;
    return _notices.where((n) {
      return n.category.name.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredNotices();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Official Notices & Circulars'),
        automaticallyImplyLeading: !widget.isEmbedded,
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.primaryNavy,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Notices List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? EmptyStateView(
                        title: 'No Circulars Found',
                        message: 'There are no notices posted in this category.',
                        icon: Icons.mark_email_read_outlined,
                      )
                    : RefreshIndicator(
                        onRefresh: _loadNotices,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final notice = filtered[index];
                            return NoticeCard(
                              notice: notice,
                              onTap: () {
                                _repository.markNoticeAsRead(notice.id);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.noticeDetail,
                                  arguments: notice,
                                ).then((_) {
                                  if (mounted) {
                                    _loadNotices();
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
