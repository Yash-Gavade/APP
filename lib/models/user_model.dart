import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final int xp;
  final int level;
  final int streak;
  final DateTime lastActive;
  final Map<String, dynamic>? preferences;
  final List<String>? badges;
  final Map<String, dynamic>? stats;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.xp,
    required this.level,
    required this.streak,
    required this.lastActive,
    this.preferences,
    this.badges,
    this.stats,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      xp: map['xp'] as int,
      level: map['level'] as int,
      streak: map['streak'] as int,
      lastActive: (map['lastActive'] as Timestamp).toDate(),
      preferences: map['preferences'] as Map<String, dynamic>?,
      badges: (map['badges'] as List<dynamic>?)?.map((e) => e as String).toList(),
      stats: map['stats'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'xp': xp,
      'level': level,
      'streak': streak,
      'lastActive': Timestamp.fromDate(lastActive),
      'preferences': preferences,
      'badges': badges,
      'stats': stats,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
    int? xp,
    int? level,
    int? streak,
    DateTime? lastActive,
    Map<String, dynamic>? preferences,
    List<String>? badges,
    Map<String, dynamic>? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      lastActive: lastActive ?? this.lastActive,
      preferences: preferences ?? this.preferences,
      badges: badges ?? this.badges,
      stats: stats ?? this.stats,
    );
  }

  // Helper methods for gamification
  int get xpToNextLevel => level * 1000;
  double get levelProgress => (xp % 1000) / 1000.0;
  
  bool hasBadge(String badgeId) => badges?.contains(badgeId) ?? false;
  
  void addBadge(String badgeId) {
    badges?.add(badgeId);
  }
  
  // Stats helpers
  int get totalWorkouts => stats?['totalWorkouts'] as int? ?? 0;
  int get totalMinutes => stats?['totalMinutes'] as int? ?? 0;
  int get caloriesBurned => stats?['caloriesBurned'] as int? ?? 0;
  
  void updateStats({
    int? workouts,
    int? minutes,
    int? calories,
  }) {
    stats?.update('totalWorkouts', (value) => (value as int) + (workouts ?? 0),
        ifAbsent: () => workouts ?? 0);
    stats?.update('totalMinutes', (value) => (value as int) + (minutes ?? 0),
        ifAbsent: () => minutes ?? 0);
    stats?.update('caloriesBurned', (value) => (value as int) + (calories ?? 0),
        ifAbsent: () => calories ?? 0);
  }
} 