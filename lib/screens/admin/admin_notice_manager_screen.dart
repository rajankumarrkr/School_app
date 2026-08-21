import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/notice_model.dart';
import '../../repositories/mock_school_repository.dart';
import '../../widgets/app_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AdminNoticeManagerScreen extends StatefulWidget {
  const AdminNoticeManagerScreen({super.key});

  @override
  State<AdminNoticeManagerScreen> createState() => _AdminNoticeManagerScreenState();
}

class _AdminNoticeManagerScreenState extends State<AdminNoticeManagerScreen> {
  final MockSchoolRepository _repository = MockSchoolRepository();
  List<NoticeModel> _notices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    setState(() => _isLoading = true);
    final list = await _repository.getNotices();
    setState(() {
      _notices = list;
      _isLoading = false;
    });
  }

  void _showPublishNoticeSheet() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    NoticeCategory selectedCategory = NoticeCategory.academic;
    NoticePriority selectedPriority = NoticePriority.normal;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Publish Official Notice',
                        style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category & Priority Row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<NoticeCategory>(
                          value: selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            filled: true,
                            fillColor: AppColors.surfaceSecondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: NoticeCategory.values
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
                                  ))
                              .toList(),
                          onChanged: (val) => setSheetState(() => selectedCategory = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<NoticePriority>(
                          value: selectedPriority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            filled: true,
                            fillColor: AppColors.surfaceSecondary,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: NoticePriority.values
                              .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
                                  ))
                              .toList(),
                          onChanged: (val) => setSheetState(() => selectedPriority = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  CustomTextField(
                    label: 'Notice Title / Headline',
                    hint: 'e.g. Schedule for Half-Yearly Examinations 2026',
                    controller: titleController,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 14),

                  // Details
                  CustomTextField(
                    label: 'Full Notice Description & Directives',
                    hint: 'Provide complete details, timings, and instructions...',
                    controller: descController,
                    maxLines: 4,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Please enter description' : null,
                  ),
                  const SizedBox(height: 20),

                  // Publish Button
                  CustomButton(
                    text: 'Broadcast to Students & Faculty',
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final admin = _repository.getActiveAdmin();
                      final newNotice = NoticeModel(
                        id: 'NTC${DateTime.now().millisecondsSinceEpoch}',
                        title: titleController.text.trim(),
                        description: descController.text.trim(),
                        category: selectedCategory,
                        priority: selectedPriority,
                        date: DateTime.now(),
                        issuedBy: admin?.fullName ?? 'School Administration',
                      );
                      await _repository.publishNotice(newNotice);
                      if (!mounted) return;
                      Navigator.pop(context);
                      _loadNotices();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Official notice broadcasted successfully!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: Icons.campaign_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'Notice & Circular Manager',
          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_rounded, color: AppColors.accentBlue),
            onPressed: _showPublishNoticeSheet,
            tooltip: 'Publish Circular',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNotices,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notices.length,
                itemBuilder: (context, index) {
                  final n = _notices[index];
                  final isHigh = n.priority == NoticePriority.urgent || n.priority == NoticePriority.high;

                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isHigh
                                    ? AppColors.errorLight
                                    : AppColors.primaryNavy.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                n.category.name.toUpperCase(),
                                style: TextStyle(
                                  color: isHigh ? AppColors.error : AppColors.primaryNavy,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${n.date.day}/${n.date.month}/${n.date.year}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          n.title,
                          style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          n.description,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'By: ${n.issuedBy}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                              onPressed: () {
                                setState(() {
                                  _notices.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Circular removed from broadcast feed.')),
                                );
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryNavy,
        onPressed: _showPublishNoticeSheet,
        icon: const Icon(Icons.campaign_rounded, color: Colors.white),
        label: const Text('Publish Notice', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
