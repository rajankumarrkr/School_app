import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user profile stored in Firestore `users/<uid>`.
///
/// This model is used for authentication role verification,
/// profile display, and profile editing. It is not a replacement
/// for [StudentModel], [TeacherModel], or [AdminModel] which
/// contain additional mock/legacy profile details.
class AppUser {
  final String uid;
  final String userId; // School ID: STU001, TCH001, ADM001
  final String role; // "student" | "teacher" | "admin"
  final String name;
  final String email; // Personal email for display/contact
  final bool active;

  // Student-specific fields (nullable for teachers/admins)
  final String? className;
  final String? section;
  final int? rollNumber;

  // Profile fields
  final String? dateOfBirth;
  final String? parentName;
  final String? parentMobile;
  final String? address;
  final bool profileCompleted;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const AppUser({
    required this.uid,
    required this.userId,
    required this.role,
    required this.name,
    required this.email,
    required this.active,
    this.className,
    this.section,
    this.rollNumber,
    this.dateOfBirth,
    this.parentName,
    this.parentMobile,
    this.address,
    this.profileCompleted = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates an [AppUser] from a Firestore document snapshot.
  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AppUser(
      uid: doc.id,
      userId: data['userId'] as String? ?? '',
      role: data['role'] as String? ?? '',
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      active: data['active'] as bool? ?? false,
      className: data['className'] as String?,
      section: data['section'] as String?,
      rollNumber: data['rollNumber'] as int?,
      dateOfBirth: data['dateOfBirth'] as String?,
      parentName: data['parentName'] as String?,
      parentMobile: data['parentMobile'] as String?,
      address: data['address'] as String?,
      profileCompleted: data['profileCompleted'] as bool? ?? false,
      createdAt: data['createdAt'] as Timestamp?,
      updatedAt: data['updatedAt'] as Timestamp?,
    );
  }

  /// Converts this [AppUser] to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'role': role,
      'name': name,
      'email': email,
      'active': active,
      if (className != null) 'className': className,
      if (section != null) 'section': section,
      if (rollNumber != null) 'rollNumber': rollNumber,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (parentName != null) 'parentName': parentName,
      if (parentMobile != null) 'parentMobile': parentMobile,
      if (address != null) 'address': address,
      'profileCompleted': profileCompleted,
      // createdAt and updatedAt are set via FieldValue.serverTimestamp()
    };
  }
}
