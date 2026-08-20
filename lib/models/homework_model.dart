enum HomeworkStatus { pending, completed, overdue }

class HomeworkModel {
  final String id;
  final String subject;
  final String title;
  final String description;
  final String teacherName;
  final DateTime assignedDate;
  final DateTime dueDate;
  final HomeworkStatus status;
  final String? submissionNote;
  final String? attachmentName;
  final int maxMarks;

  const HomeworkModel({
    required this.id,
    required this.subject,
    required this.title,
    required this.description,
    required this.teacherName,
    required this.assignedDate,
    required this.dueDate,
    required this.status,
    this.submissionNote,
    this.attachmentName,
    this.maxMarks = 20,
  });

  HomeworkModel copyWith({
    String? id,
    String? subject,
    String? title,
    String? description,
    String? teacherName,
    DateTime? assignedDate,
    DateTime? dueDate,
    HomeworkStatus? status,
    String? submissionNote,
    String? attachmentName,
    int? maxMarks,
  }) {
    return HomeworkModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      description: description ?? this.description,
      teacherName: teacherName ?? this.teacherName,
      assignedDate: assignedDate ?? this.assignedDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      submissionNote: submissionNote ?? this.submissionNote,
      attachmentName: attachmentName ?? this.attachmentName,
      maxMarks: maxMarks ?? this.maxMarks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'title': title,
      'description': description,
      'teacherName': teacherName,
      'assignedDate': assignedDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'submissionNote': submissionNote,
      'attachmentName': attachmentName,
      'maxMarks': maxMarks,
    };
  }

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      id: json['id'] as String,
      subject: json['subject'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      teacherName: json['teacherName'] as String,
      assignedDate: DateTime.parse(json['assignedDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: HomeworkStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => HomeworkStatus.pending,
      ),
      submissionNote: json['submissionNote'] as String?,
      attachmentName: json['attachmentName'] as String?,
      maxMarks: json['maxMarks'] as int? ?? 20,
    );
  }
}
