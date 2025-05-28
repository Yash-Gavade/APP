import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int xpReward;
  final String type;
  final int requirement;
  final bool isSecret;
  final DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.type,
    required this.requirement,
    this.isSecret = false,
    this.unlockedAt,
  });

  factory AchievementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AchievementModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      xpReward: data['xpReward'] ?? 0,
      type: data['type'] ?? '',
      requirement: data['requirement'] ?? 0,
      isSecret: data['isSecret'] ?? false,
      unlockedAt: data['unlockedAt'] != null
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'xpReward': xpReward,
      'type': type,
      'requirement': requirement,
      'isSecret': isSecret,
      'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
    };
  }

  AchievementModel copyWith({
    String? title,
    String? description,
    String? icon,
    int? xpReward,
    String? type,
    int? requirement,
    bool? isSecret,
    DateTime? unlockedAt,
  }) {
    return AchievementModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      xpReward: xpReward ?? this.xpReward,
      type: type ?? this.type,
      requirement: requirement ?? this.requirement,
      isSecret: isSecret ?? this.isSecret,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final int level;
  final DateTime? earnedAt;

  BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.level,
    this.earnedAt,
  });

  factory BadgeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BadgeModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      category: data['category'] ?? '',
      level: data['level'] ?? 1,
      earnedAt: data['earnedAt'] != null
          ? (data['earnedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'category': category,
      'level': level,
      'earnedAt': earnedAt != null ? Timestamp.fromDate(earnedAt!) : null,
    };
  }

  BadgeModel copyWith({
    String? title,
    String? description,
    String? icon,
    String? category,
    int? level,
    DateTime? earnedAt,
  }) {
    return BadgeModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      level: level ?? this.level,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }
} 