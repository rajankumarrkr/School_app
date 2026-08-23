import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user_model.dart';
import '../models/user_role_model.dart';

/// Centralized Firebase Authentication + Firestore user profile service.
///
/// Handles:
/// - School ID → internal email mapping
/// - Firebase Auth sign-in / sign-out
/// - Firestore user profile lookup
/// - Role verification
/// - User-friendly error messages
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// The email domain used for internal school ID → email mapping.
  /// Change this single constant to update the mapping across the app.
  static const String _emailDomain = 'worthrmsoldierschool.app';

  /// Converts a school ID or email to the internal Firebase Auth email.
  ///
  /// Example: `STU001` → `stu001@worthrmsoldierschool.app`
  String schoolIdToEmail(String schoolId) {
    final trimmed = schoolId.trim().toLowerCase();
    if (trimmed.contains('@')) return trimmed;
    return '$trimmed@$_emailDomain';
  }

  /// Returns the currently signed-in Firebase user, or `null`.
  User? get currentUser => _auth.currentUser;

  /// Signs in with the given school ID, password, and selected role.
  ///
  /// Flow:
  /// 1. Convert school ID to internal email
  /// 2. Authenticate with Firebase Auth
  /// 3. Fetch Firestore `users/<uid>` document
  /// 4. Verify account is active
  /// 5. Verify Firestore role matches selected role
  ///
  /// Returns [AppUser] on success.
  /// Throws [FirebaseAuthServiceException] on any failure.
  Future<AppUser> signIn(
    String schoolId,
    String password,
    UserRole selectedRole,
  ) async {
    final email = schoolIdToEmail(schoolId);

    try {
      // 1. Authenticate with Firebase Auth
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthServiceException(
          'Authentication failed. Please try again.',
        );
      }

      // 2. Fetch Firestore user profile
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        // Profile not found — sign out to avoid stale session
        await _auth.signOut();
        throw FirebaseAuthServiceException(
          'Account profile not found. Please contact the school.',
        );
      }

      final appUser = AppUser.fromFirestore(docSnapshot);

      // 3. Verify account is active
      if (!appUser.active) {
        await _auth.signOut();
        throw FirebaseAuthServiceException(
          'This account has been deactivated. Please contact the school.',
        );
      }

      // 4. Verify role matches
      final expectedRole = _userRoleToString(selectedRole);
      if (appUser.role != expectedRole) {
        await _auth.signOut();
        throw FirebaseAuthServiceException(
          'This account is not registered as a ${_userRoleDisplayName(selectedRole)}.',
        );
      }

      return appUser;
    } on FirebaseAuthServiceException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthServiceException(_mapFirebaseAuthError(e.code));
    } on FirebaseException catch (_) {
      throw FirebaseAuthServiceException(
        'A server error occurred. Please try again later.',
      );
    } catch (e) {
      if (e is FirebaseAuthServiceException) rethrow;
      throw FirebaseAuthServiceException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Signs out the current Firebase user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ---------------------------------------------------------------------------
  // Registration
  // ---------------------------------------------------------------------------

  /// Verifies that a student ID exists in the school-controlled `student_registry`.
  ///
  /// Returns the registry data map on success.
  /// Throws [FirebaseAuthServiceException] if not found or registration not allowed.
  Future<Map<String, dynamic>> verifyStudentRegistry(String studentId) async {
    final trimmedId = studentId.trim().toUpperCase();

    try {
      final doc = await _firestore
          .collection('student_registry')
          .doc(trimmedId)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw FirebaseAuthServiceException(
          'Student ID not found. Please contact the school office.',
        );
      }

      final data = doc.data()!;

      if (data['active'] != true) {
        throw FirebaseAuthServiceException(
          'Student ID not found. Please contact the school office.',
        );
      }

      if (data['registrationAllowed'] != true) {
        throw FirebaseAuthServiceException(
          'Registration is currently unavailable for this Student ID. Please contact the school.',
        );
      }

      return data;
    } on FirebaseAuthServiceException {
      rethrow;
    } on FirebaseException catch (_) {
      throw FirebaseAuthServiceException(
        'Unable to verify Student ID. Please try again later.',
      );
    }
  }

  /// Verifies that entered details match the school registry record.
  ///
  /// Compares name and date of birth (case-insensitive, trimmed).
  /// Returns `true` if all details match, `false` otherwise.
  bool verifyRegistryDetails(
    Map<String, dynamic> registryData,
    String enteredName,
    String enteredDateOfBirth,
  ) {
    final registryName = (registryData['name'] as String? ?? '').trim().toLowerCase();
    final registryDob = (registryData['dateOfBirth'] as String? ?? '').trim().toLowerCase();

    final inputName = enteredName.trim().toLowerCase();
    final inputDob = enteredDateOfBirth.trim().toLowerCase();

    return registryName == inputName && registryDob == inputDob;
  }

  /// Registers a new student account.
  ///
  /// Flow:
  /// 1. Create Firebase Auth account
  /// 2. Create Firestore `users/<uid>` document under authenticated UID session
  ///
  /// Returns [AppUser] on success.
  /// Throws [FirebaseAuthServiceException] on any failure.
  Future<AppUser> registerStudent({
    required String name,
    required String email,
    required String password,
    String? studentId,
    String? dateOfBirth,
    String? parentName,
    String? parentMobile,
    String? className,
    String? section,
    int? rollNumber,
    String? address,
  }) async {
    final finalStudentId = (studentId != null && studentId.trim().isNotEmpty)
        ? studentId.trim().toUpperCase()
        : 'STU${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    final authEmail = schoolIdToEmail(finalStudentId);

    try {
      // 1. Create Firebase Auth account (this authenticates the session for Firestore writes)
      final credential = await _auth.createUserWithEmailAndPassword(
        email: authEmail,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw FirebaseAuthServiceException(
          'Account creation failed. Please try again.',
        );
      }

      // 2. Create Firestore user profile under the user's authenticated UID
      final userData = <String, dynamic>{
        'userId': finalStudentId,
        'role': 'student',
        'name': name.trim(),
        'email': email.trim(),
        if (dateOfBirth?.trim().isNotEmpty == true) 'dateOfBirth': dateOfBirth!.trim(),
        if (parentName?.trim().isNotEmpty == true) 'parentName': parentName!.trim(),
        if (parentMobile?.trim().isNotEmpty == true) 'parentMobile': parentMobile!.trim(),
        'className': (className != null && className.isNotEmpty) ? className : '10',
        'section': (section != null && section.isNotEmpty) ? section : 'A',
        if (rollNumber != null) 'rollNumber': rollNumber,
        if (address?.trim().isNotEmpty == true) 'address': address!.trim(),
        'active': true,
        'profileCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(user.uid).set(userData);

      // 3. Mark registration as used in the registry (if doc exists)
      try {
        await _firestore
            .collection('student_registry')
            .doc(finalStudentId)
            .update({'registrationAllowed': false});
      } catch (_) {
        // Ignore registry update error if registry doc is not configured
      }

      // 4. Return created AppUser instance
      return AppUser(
        uid: user.uid,
        userId: finalStudentId,
        role: 'student',
        name: name.trim(),
        email: email.trim(),
        active: true,
        className: userData['className'] as String?,
        section: userData['section'] as String?,
        rollNumber: rollNumber,
        profileCompleted: false,
      );
    } on FirebaseAuthServiceException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthServiceException(_mapRegistrationError(e.code));
    } on FirebaseException catch (e) {
      throw FirebaseAuthServiceException(
        e.message ?? 'A server error occurred. Please try again later.',
      );
    } catch (e) {
      if (e is FirebaseAuthServiceException) rethrow;
      throw FirebaseAuthServiceException(
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  /// Loads the current user's Firestore profile.
  ///
  /// Returns [AppUser] on success.
  /// Throws [FirebaseAuthServiceException] if not authenticated or profile missing.
  Future<AppUser> getUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthServiceException('Not authenticated.');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data() == null) {
      throw FirebaseAuthServiceException(
        'Profile not found. Please contact the school.',
      );
    }

    return AppUser.fromFirestore(doc);
  }

  /// Updates editable profile fields for the current user.
  ///
  /// Only personal fields are updated; protected fields (role, userId,
  /// className, section, rollNumber, active) are not sent.
  Future<void> updateUserProfile({
    required String name,
    required String parentName,
    required String parentMobile,
    required String address,
    required String email,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthServiceException('Not authenticated.');
    }

    await _firestore.collection('users').doc(user.uid).update({
      'name': name.trim(),
      'parentName': parentName.trim(),
      'parentMobile': parentMobile.trim(),
      'address': address.trim(),
      'email': email.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Maps [UserRole] enum to the Firestore role string.
  String _userRoleToString(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'student';
      case UserRole.teacher:
        return 'teacher';
      case UserRole.admin:
        return 'admin';
    }
  }

  /// Returns a user-facing display name for the role.
  String _userRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Faculty';
      case UserRole.admin:
        return 'School Admin';
    }
  }

  /// Maps Firebase Auth error codes to user-friendly messages (login).
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
      case 'invalid-email':
        return 'Invalid Student ID or password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact the school.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Unable to connect to the server. Please check your internet connection.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  /// Maps Firebase Auth error codes to user-friendly messages (registration).
  String _mapRegistrationError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This student account has already been registered. Please sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 8 characters.';
      case 'invalid-email':
        return 'Invalid Student ID format.';
      case 'network-request-failed':
        return 'Unable to connect to the server. Please check your internet connection.';
      default:
        return 'Registration failed. Please try again.';
    }
  }
}

/// Custom exception for [FirebaseAuthService] errors.
///
/// Contains a user-friendly [message] suitable for direct display.
class FirebaseAuthServiceException implements Exception {
  final String message;

  const FirebaseAuthServiceException(this.message);

  @override
  String toString() => message;
}

