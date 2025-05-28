import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final String role;
  final int level;
  final int xp;
  final int streak;
  final List<String> badges;
  final Map<String, dynamic> settings;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.bio,
    required this.role,
    required this.level,
    required this.xp,
    required this.streak,
    required this.badges,
    required this.settings,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      role: data['role'] ?? 'user',
      level: data['level'] ?? 1,
      xp: data['xp'] ?? 0,
      streak: data['streak'] ?? 0,
      badges: List<String>.from(data['badges'] ?? []),
      settings: Map<String, dynamic>.from(data['settings'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'role': role,
      'level': level,
      'xp': xp,
      'streak': streak,
      'badges': badges,
      'settings': settings,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    String? role,
    int? level,
    int? xp,
    int? streak,
    List<String>? badges,
    Map<String, dynamic>? settings,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      badges: badges ?? this.badges,
      settings: settings ?? this.settings,
      createdAt: createdAt,
    );
  }
} 