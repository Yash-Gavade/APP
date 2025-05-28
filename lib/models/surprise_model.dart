import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum SurpriseType {
  gift,
  challenge,
  achievement,
  bonus,
  special
}

enum SurpriseStatus {
  hidden,    // Not yet revealed by AI
  revealed,  // AI has suggested its location
  discovered, // User has found it
  claimed    // User has claimed the reward
}

class SurpriseModel {
  final String id;
  final String title;
  final String description;
  final SurpriseType type;
  final SurpriseStatus status;
  final LatLng location;
  final double radius; // Approximate area where surprise can be found
  final Map<String, dynamic> rewards;
  final DateTime createdAt;
  final DateTime? revealedAt;
  final DateTime? discoveredAt;
  final DateTime? claimedAt;
  final String? aiHint; // AI-generated hint about the surprise
  final String? imageUrl;
  final int xpReward;
  final List<String>? requiredBadges; // Badges needed to claim
  final Map<String, dynamic>? metadata;

  SurpriseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.location,
    required this.radius,
    required this.rewards,
    required this.createdAt,
    this.revealedAt,
    this.discoveredAt,
    this.claimedAt,
    this.aiHint,
    this.imageUrl,
    required this.xpReward,
    this.requiredBadges,
    this.metadata,
  });

  factory SurpriseModel.fromMap(Map<String, dynamic> map) {
    return SurpriseModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      type: SurpriseType.values.firstWhere(
        (e) => e.toString() == 'SurpriseType.${map['type']}',
      ),
      status: SurpriseStatus.values.firstWhere(
        (e) => e.toString() == 'SurpriseStatus.${map['status']}',
      ),
      location: LatLng(
        (map['location'] as GeoPoint).latitude,
        (map['location'] as GeoPoint).longitude,
      ),
      radius: (map['radius'] as num).toDouble(),
      rewards: map['rewards'] as Map<String, dynamic>,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      revealedAt: map['revealedAt'] != null
          ? (map['revealedAt'] as Timestamp).toDate()
          : null,
      discoveredAt: map['discoveredAt'] != null
          ? (map['discoveredAt'] as Timestamp).toDate()
          : null,
      claimedAt: map['claimedAt'] != null
          ? (map['claimedAt'] as Timestamp).toDate()
          : null,
      aiHint: map['aiHint'] as String?,
      imageUrl: map['imageUrl'] as String?,
      xpReward: map['xpReward'] as int,
      requiredBadges: (map['requiredBadges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'location': GeoPoint(location.latitude, location.longitude),
      'radius': radius,
      'rewards': rewards,
      'createdAt': Timestamp.fromDate(createdAt),
      'revealedAt': revealedAt != null ? Timestamp.fromDate(revealedAt!) : null,
      'discoveredAt': discoveredAt != null ? Timestamp.fromDate(discoveredAt!) : null,
      'claimedAt': claimedAt != null ? Timestamp.fromDate(claimedAt!) : null,
      'aiHint': aiHint,
      'imageUrl': imageUrl,
      'xpReward': xpReward,
      'requiredBadges': requiredBadges,
      'metadata': metadata,
    };
  }

  SurpriseModel copyWith({
    String? id,
    String? title,
    String? description,
    SurpriseType? type,
    SurpriseStatus? status,
    LatLng? location,
    double? radius,
    Map<String, dynamic>? rewards,
    DateTime? createdAt,
    DateTime? revealedAt,
    DateTime? discoveredAt,
    DateTime? claimedAt,
    String? aiHint,
    String? imageUrl,
    int? xpReward,
    List<String>? requiredBadges,
    Map<String, dynamic>? metadata,
  }) {
    return SurpriseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      location: location ?? this.location,
      radius: radius ?? this.radius,
      rewards: rewards ?? this.rewards,
      createdAt: createdAt ?? this.createdAt,
      revealedAt: revealedAt ?? this.revealedAt,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      claimedAt: claimedAt ?? this.claimedAt,
      aiHint: aiHint ?? this.aiHint,
      imageUrl: imageUrl ?? this.imageUrl,
      xpReward: xpReward ?? this.xpReward,
      requiredBadges: requiredBadges ?? this.requiredBadges,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods
  bool get isHidden => status == SurpriseStatus.hidden;
  bool get isRevealed => status == SurpriseStatus.revealed;
  bool get isDiscovered => status == SurpriseStatus.discovered;
  bool get isClaimed => status == SurpriseStatus.claimed;
  
  bool canBeClaimed(List<String> userBadges) {
    if (requiredBadges == null || requiredBadges!.isEmpty) return true;
    return requiredBadges!.every((badge) => userBadges.contains(badge));
  }

  String get statusMessage {
    switch (status) {
      case SurpriseStatus.hidden:
        return 'A surprise awaits discovery...';
      case SurpriseStatus.revealed:
        return 'A surprise has been spotted nearby!';
      case SurpriseStatus.discovered:
        return 'You found a surprise!';
      case SurpriseStatus.claimed:
        return 'Surprise claimed!';
    }
  }
} 