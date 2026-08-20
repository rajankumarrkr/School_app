class StudentModel {
  final String id;
  final String admissionNo;
  final String fullName;
  final String rollNumber;
  final String className;
  final String section;
  final String dateOfBirth;
  final String gender;
  final String bloodGroup;
  final String email;
  final String phone;
  final String address;
  final String fatherName;
  final String fatherOccupation;
  final String fatherPhone;
  final String motherName;
  final String motherOccupation;
  final String motherPhone;
  final String avatarUrl;
  final String academicYear;
  final String houseName;

  const StudentModel({
    required this.id,
    required this.admissionNo,
    required this.fullName,
    required this.rollNumber,
    required this.className,
    required this.section,
    required this.dateOfBirth,
    required this.gender,
    required this.bloodGroup,
    required this.email,
    required this.phone,
    required this.address,
    required this.fatherName,
    required this.fatherOccupation,
    required this.fatherPhone,
    required this.motherName,
    required this.motherOccupation,
    required this.motherPhone,
    required this.avatarUrl,
    required this.academicYear,
    required this.houseName,
  });

  StudentModel copyWith({
    String? id,
    String? admissionNo,
    String? fullName,
    String? rollNumber,
    String? className,
    String? section,
    String? dateOfBirth,
    String? gender,
    String? bloodGroup,
    String? email,
    String? phone,
    String? address,
    String? fatherName,
    String? fatherOccupation,
    String? fatherPhone,
    String? motherName,
    String? motherOccupation,
    String? motherPhone,
    String? avatarUrl,
    String? academicYear,
    String? houseName,
  }) {
    return StudentModel(
      id: id ?? this.id,
      admissionNo: admissionNo ?? this.admissionNo,
      fullName: fullName ?? this.fullName,
      rollNumber: rollNumber ?? this.rollNumber,
      className: className ?? this.className,
      section: section ?? this.section,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      fatherName: fatherName ?? this.fatherName,
      fatherOccupation: fatherOccupation ?? this.fatherOccupation,
      fatherPhone: fatherPhone ?? this.fatherPhone,
      motherName: motherName ?? this.motherName,
      motherOccupation: motherOccupation ?? this.motherOccupation,
      motherPhone: motherPhone ?? this.motherPhone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      academicYear: academicYear ?? this.academicYear,
      houseName: houseName ?? this.houseName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admissionNo': admissionNo,
      'fullName': fullName,
      'rollNumber': rollNumber,
      'className': className,
      'section': section,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'email': email,
      'phone': phone,
      'address': address,
      'fatherName': fatherName,
      'fatherOccupation': fatherOccupation,
      'fatherPhone': fatherPhone,
      'motherName': motherName,
      'motherOccupation': motherOccupation,
      'motherPhone': motherPhone,
      'avatarUrl': avatarUrl,
      'academicYear': academicYear,
      'houseName': houseName,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      admissionNo: json['admissionNo'] as String,
      fullName: json['fullName'] as String,
      rollNumber: json['rollNumber'] as String,
      className: json['className'] as String,
      section: json['section'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      gender: json['gender'] as String,
      bloodGroup: json['bloodGroup'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      fatherName: json['fatherName'] as String,
      fatherOccupation: json['fatherOccupation'] as String,
      fatherPhone: json['fatherPhone'] as String,
      motherName: json['motherName'] as String,
      motherOccupation: json['motherOccupation'] as String,
      motherPhone: json['motherPhone'] as String,
      avatarUrl: json['avatarUrl'] as String,
      academicYear: json['academicYear'] as String,
      houseName: json['houseName'] as String,
    );
  }
}
