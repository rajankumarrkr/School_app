enum NoticePriority { low, normal, high, urgent }
enum NoticeCategory { general, academic, events, holiday, exams, sports }

class NoticeModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final NoticePriority priority;
  final NoticeCategory category;
  final String issuedBy;
  final bool isRead;
  final String? attachmentUrl;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.category,
    required this.issuedBy,
    this.isRead = false,
    this.attachmentUrl,
  });

  NoticeModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    NoticePriority? priority,
    NoticeCategory? category,
    String? issuedBy,
    bool? isRead,
    String? attachmentUrl,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      issuedBy: issuedBy ?? this.issuedBy,
      isRead: isRead ?? this.isRead,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'priority': priority.name,
      'category': category.name,
      'issuedBy': issuedBy,
      'isRead': isRead,
      'attachmentUrl': attachmentUrl,
    };
  }

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      priority: NoticePriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NoticePriority.normal,
      ),
      category: NoticeCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => NoticeCategory.general,
      ),
      issuedBy: json['issuedBy'] as String,
      isRead: json['isRead'] as bool? ?? false,
      attachmentUrl: json['attachmentUrl'] as String?,
    );
  }
}
