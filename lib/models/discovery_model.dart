import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DiscoveryModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String icon;
  final int xpReward;
  final LatLng location;
  final double radius;
  final DateTime expiresAt;
  final bool isActive;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final String? discoveredBy;
  final DateTime? discoveredAt;

  DiscoveryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    required this.xpReward,
    required this.location,
    required this.radius,
    required this.expiresAt,
    this.isActive = true,
    this.metadata,
    required this.createdAt,
    this.discoveredBy,
    this.discoveredAt,
  });

  factory DiscoveryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final geoPoint = data['location'] as GeoPoint;
    
    return DiscoveryModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      icon: data['icon'] ?? '',
      xpReward: data['xpReward'] ?? 0,
      location: LatLng(geoPoint.latitude, geoPoint.longitude),
      radius: (data['radius'] ?? 50.0).toDouble(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      metadata: data['metadata'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      discoveredBy: data['discoveredBy'],
      discoveredAt: data['discoveredAt'] != null
          ? (data['discoveredAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'icon': icon,
      'xpReward': xpReward,
      'location': GeoPoint(location.latitude, location.longitude),
      'radius': radius,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isActive': isActive,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'discoveredBy': discoveredBy,
      'discoveredAt': discoveredAt != null ? Timestamp.fromDate(discoveredAt!) : null,
    };
  }

  DiscoveryModel copyWith({
    String? title,
    String? description,
    String? type,
    String? icon,
    int? xpReward,
    LatLng? location,
    double? radius,
    DateTime? expiresAt,
    bool? isActive,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    String? discoveredBy,
    DateTime? discoveredAt,
  }) {
    return DiscoveryModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      xpReward: xpReward ?? this.xpReward,
      location: location ?? this.location,
      radius: radius ?? this.radius,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      discoveredBy: discoveredBy ?? this.discoveredBy,
      discoveredAt: discoveredAt ?? this.discoveredAt,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isDiscovered => discoveredBy != null;
  bool get isAvailable => isActive && !isExpired && !isDiscovered;

  double distanceTo(LatLng point) {
    const double earthRadius = 6371000; // meters
    final lat1 = location.latitude * (pi / 180);
    final lat2 = point.latitude * (pi / 180);
    final dLat = (point.latitude - location.latitude) * (pi / 180);
    final dLon = (point.longitude - location.longitude) * (pi / 180);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  bool isWithinRange(LatLng point) => distanceTo(point) <= radius;
}

// Import for pi and math functions
import 'dart:math' show pi, sin, cos, sqrt, atan2; 