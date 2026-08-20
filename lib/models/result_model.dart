class SubjectScoreModel {
  final String subjectName;
  final double marksObtained;
  final double totalMarks;
  final String grade;
  final String remarks;
  final double classAverage;

  const SubjectScoreModel({
    required this.subjectName,
    required this.marksObtained,
    required this.totalMarks,
    required this.grade,
    required this.remarks,
    this.classAverage = 75.0,
  });

  double get percentage => (marksObtained / totalMarks) * 100;

  Map<String, dynamic> toJson() {
    return {
      'subjectName': subjectName,
      'marksObtained': marksObtained,
      'totalMarks': totalMarks,
      'grade': grade,
      'remarks': remarks,
      'classAverage': classAverage,
    };
  }

  factory SubjectScoreModel.fromJson(Map<String, dynamic> json) {
    return SubjectScoreModel(
      subjectName: json['subjectName'] as String,
      marksObtained: (json['marksObtained'] as num).toDouble(),
      totalMarks: (json['totalMarks'] as num).toDouble(),
      grade: json['grade'] as String,
      remarks: json['remarks'] as String,
      classAverage: (json['classAverage'] as num?)?.toDouble() ?? 75.0,
    );
  }
}

class ExamResultModel {
  final String id;
  final String examTitle; // e.g. "Term 1 Examination", "Unit Test 1"
  final String academicYear;
  final String semester;
  final List<SubjectScoreModel> subjects;
  final String overallGrade;
  final int classRank;
  final int totalStudentsInClass;
  final String teacherRemarks;
  final String publishedDate;

  const ExamResultModel({
    required this.id,
    required this.examTitle,
    required this.academicYear,
    required this.semester,
    required this.subjects,
    required this.overallGrade,
    required this.classRank,
    required this.totalStudentsInClass,
    required this.teacherRemarks,
    required this.publishedDate,
  });

  double get totalObtained => subjects.fold(0.0, (sum, item) => sum + item.marksObtained);
  double get maxPossible => subjects.fold(0.0, (sum, item) => sum + item.totalMarks);
  double get overallPercentage => maxPossible > 0 ? (totalObtained / maxPossible) * 100 : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examTitle': examTitle,
      'academicYear': academicYear,
      'semester': semester,
      'subjects': subjects.map((e) => e.toJson()).toList(),
      'overallGrade': overallGrade,
      'classRank': classRank,
      'totalStudentsInClass': totalStudentsInClass,
      'teacherRemarks': teacherRemarks,
      'publishedDate': publishedDate,
    };
  }

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      id: json['id'] as String,
      examTitle: json['examTitle'] as String,
      academicYear: json['academicYear'] as String,
      semester: json['semester'] as String,
      subjects: (json['subjects'] as List<dynamic>)
          .map((e) => SubjectScoreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallGrade: json['overallGrade'] as String,
      classRank: json['classRank'] as int,
      totalStudentsInClass: json['totalStudentsInClass'] as int,
      teacherRemarks: json['teacherRemarks'] as String,
      publishedDate: json['publishedDate'] as String,
    );
  }
}
