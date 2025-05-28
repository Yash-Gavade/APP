import 'package:cloud_firestore/cloud_firestore.dart';

class SurpriseModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String type; // 'achievement', 'badge', etc.
  final Map<String, dynamic>? metadata;

  SurpriseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
    required this.type,
    this.metadata,
  });

  factory SurpriseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SurpriseModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      isUnlocked: data['isUnlocked'] ?? false,
      unlockedAt: data['unlockedAt'] != null
          ? (data['unlockedAt'] as Timestamp).toDate()
          : null,
      type: data['type'] ?? 'achievement',
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt != null ? Timestamp.fromDate(unlockedAt!) : null,
      'type': type,
      'metadata': metadata,
    };
  }
} 