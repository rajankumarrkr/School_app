import '../models/student_model.dart';

class DummyStudentData {
  static final List<StudentModel> detailedStudents = [
    const StudentModel(
      id: 'STU001',
      admissionNo: 'WRM/2020/1042',
      fullName: 'Rahul Kumar',
      rollNumber: '12',
      className: '10',
      section: 'A',
      dateOfBirth: '12 May 2010',
      gender: 'Male',
      bloodGroup: 'O+',
      email: 'rahul.kumar@worthrm.edu.in',
      phone: '+91 98765 43210',
      address: 'House No. 42, Green Avenue, Sector 14, New Delhi',
      fatherName: 'Rajesh Kumar',
      fatherOccupation: 'Senior Project Manager, Tech Mahindra',
      fatherPhone: '+91 98111 22334',
      motherName: 'Sunita Kumar',
      motherOccupation: 'Assistant Professor, Delhi University',
      motherPhone: '+91 98222 33445',
      avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&auto=format&fit=crop&q=80',
      academicYear: '2026-2027',
      houseName: 'Shivaji House (Red)',
    ),
    const StudentModel(
      id: 'STU002',
      admissionNo: 'WRM/2020/1045',
      fullName: 'Ananya Sharma',
      rollNumber: '04',
      className: '10',
      section: 'A',
      dateOfBirth: '24 August 2010',
      gender: 'Female',
      bloodGroup: 'B+',
      email: 'ananya.sharma@worthrm.edu.in',
      phone: '+91 97654 32109',
      address: 'Plot 18, Defence Colony, New Delhi',
      fatherName: 'Col. Vikram Sharma',
      fatherOccupation: 'Indian Army Officer (Retd)',
      fatherPhone: '+91 98333 44556',
      motherName: 'Meenakshi Sharma',
      motherOccupation: 'School Principal',
      motherPhone: '+91 98444 55667',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80',
      academicYear: '2026-2027',
      houseName: 'Tagore House (Blue)',
    ),
    const StudentModel(
      id: 'STU003',
      admissionNo: 'WRM/2020/1051',
      fullName: 'Arjun Verma',
      rollNumber: '08',
      className: '10',
      section: 'A',
      dateOfBirth: '05 November 2009',
      gender: 'Male',
      bloodGroup: 'A+',
      email: 'arjun.verma@worthrm.edu.in',
      phone: '+91 96543 21098',
      address: 'B-204, Royal Palms Residency, Gurugram',
      fatherName: 'Dr. Alok Verma',
      fatherOccupation: 'Chief Surgeon, Max Healthcare',
      fatherPhone: '+91 98555 66778',
      motherName: 'Dr. Radhika Verma',
      motherOccupation: 'Dentist',
      motherPhone: '+91 98666 77889',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
      academicYear: '2026-2027',
      houseName: 'Ashoka House (Green)',
    ),
    const StudentModel(
      id: 'STU004',
      admissionNo: 'WRM/2020/1063',
      fullName: 'Pooja Patel',
      rollNumber: '22',
      className: '10',
      section: 'B',
      dateOfBirth: '19 January 2010',
      gender: 'Female',
      bloodGroup: 'AB+',
      email: 'pooja.patel@worthrm.edu.in',
      phone: '+91 95432 10987',
      address: '77, Lotus Boulevard, Sector 100, Noida',
      fatherName: 'Hasmukh Patel',
      fatherOccupation: 'Chartered Accountant',
      fatherPhone: '+91 98777 88990',
      motherName: 'Kavita Patel',
      motherOccupation: 'Interior Designer',
      motherPhone: '+91 98888 99001',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=80',
      academicYear: '2026-2027',
      houseName: 'Raman House (Yellow)',
    ),
    const StudentModel(
      id: 'STU005',
      admissionNo: 'WRM/2020/1077',
      fullName: 'Rohan Singh',
      rollNumber: '31',
      className: '10',
      section: 'B',
      dateOfBirth: '30 March 2010',
      gender: 'Male',
      bloodGroup: 'O-',
      email: 'rohan.singh@worthrm.edu.in',
      phone: '+91 94321 09876',
      address: 'C-12, Officers Enclave, Delhi Cantt',
      fatherName: 'Maj. General Harpreet Singh',
      fatherOccupation: 'Armed Forces Commander',
      fatherPhone: '+91 98999 00112',
      motherName: 'Gurpreet Kaur',
      motherOccupation: 'Lawyer, High Court',
      motherPhone: '+91 99000 11223',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
      academicYear: '2026-2027',
      houseName: 'Shivaji House (Red)',
    ),
  ];

  static StudentModel currentStudent = detailedStudents.first;

  /// Full list of 100+ students for school roster representation
  static List<StudentModel> getAllStudentsRoster() {
    final List<StudentModel> roster = List.from(detailedStudents);
    final indianFirstNames = [
      'Aarav', 'Aditi', 'Advait', 'Akash', 'Amrita', 'Aniket', 'Ananya', 'Anushka',
      'Aryan', 'Bhavya', 'Chirag', 'Dev', 'Diya', 'Divyansh', 'Gauri', 'Harsh',
      'Ishaan', 'Jahnavi', 'Kabir', 'Khushi', 'Kavya', 'Manish', 'Neha', 'Nikhil',
      'Pranav', 'Pooja', 'Riddhima', 'Rishabh', 'Sakshi', 'Sameer', 'Tanvi', 'Varun',
      'Vihaan', 'Yash', 'Zoya'
    ];
    final indianLastNames = [
      'Sharma', 'Verma', 'Gupta', 'Singh', 'Kumar', 'Mishra', 'Pandey', 'Patel',
      'Joshi', 'Chopra', 'Malhotra', 'Bhatia', 'Yadav', 'Reddy', 'Nair', 'Deshmukh',
      'Banerjee', 'Ghosh', 'Chatterjee', 'Iyer', 'Menon', 'Kulkarni'
    ];

    int rollCounter = 32;
    for (int i = detailedStudents.length; i < 100; i++) {
      final fName = indianFirstNames[i % indianFirstNames.length];
      final lName = indianLastNames[(i * 3) % indianLastNames.length];
      final isFemale = (i % 2 == 0);
      final stuId = 'STU${(i + 1).toString().padLeft(3, '0')}';
      final rollStr = (rollCounter++).toString().padLeft(2, '0');
      final cls = (9 + (i % 4)).toString(); // Classes 9 to 12
      final sec = ['A', 'B', 'C'][i % 3];

      roster.add(
        StudentModel(
          id: stuId,
          admissionNo: 'WRM/2020/${1000 + i}',
          fullName: '$fName $lName',
          rollNumber: rollStr,
          className: cls,
          section: sec,
          dateOfBirth: '15 Jan 2010',
          gender: isFemale ? 'Female' : 'Male',
          bloodGroup: ['A+', 'B+', 'O+', 'AB+', 'O-'][i % 5],
          email: '${fName.toLowerCase()}.${lName.toLowerCase()}@worthrm.edu.in',
          phone: '+91 98${(10000000 + i * 137).toString().substring(0, 8)}',
          address: 'Sector ${10 + (i % 40)}, NCR, New Delhi',
          fatherName: 'Mr. ${lName} Sr.',
          fatherOccupation: 'Executive Professional',
          fatherPhone: '+91 99${(20000000 + i * 123).toString().substring(0, 8)}',
          motherName: 'Mrs. ${lName}',
          motherOccupation: 'Educationist',
          motherPhone: '+91 97${(30000000 + i * 111).toString().substring(0, 8)}',
          avatarUrl: isFemale
              ? 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&auto=format&fit=crop&q=80'
              : 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200&auto=format&fit=crop&q=80',
          academicYear: '2026-2027',
          houseName: ['Shivaji House (Red)', 'Tagore House (Blue)', 'Ashoka House (Green)', 'Raman House (Yellow)'][i % 4],
        ),
      );
    }
    return roster;
  }
}
