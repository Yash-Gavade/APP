import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fitquest/models/surprise_model.dart';
import 'package:fitquest/services/auth_service.dart';
import 'package:fitquest/services/ai_service.dart';

class SurpriseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService;
  final AIService _aiService;
  
  SurpriseService(this._authService, this._aiService);
  
  // Get all surprises within a radius of a location
  Stream<List<SurpriseModel>> getNearbySurprises(LatLng location, double radiusInMeters) {
    // Convert radius to degrees (approximate)
    final radiusInDegrees = radiusInMeters / 111000.0;
    
    final bounds = LatLngBounds(
      southwest: LatLng(
        location.latitude - radiusInDegrees,
        location.longitude - radiusInDegrees,
      ),
      northeast: LatLng(
        location.latitude + radiusInDegrees,
        location.longitude + radiusInDegrees,
      ),
    );
    
    return _firestore
        .collection('surprises')
        .where('status', whereIn: ['hidden', 'revealed'])
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SurpriseModel.fromMap(doc.data()))
              .where((surprise) {
                // Additional filtering for exact radius
                final distance = _calculateDistance(
                  location.latitude,
                  location.longitude,
                  surprise.location.latitude,
                  surprise.location.longitude,
                );
                return distance <= radiusInMeters;
              })
              .toList();
        });
  }
  
  // Create a new surprise
  Future<SurpriseModel> createSurprise({
    required String title,
    required String description,
    required SurpriseType type,
    required LatLng location,
    required double radius,
    required Map<String, dynamic> rewards,
    required int xpReward,
    String? imageUrl,
    List<String>? requiredBadges,
    Map<String, dynamic>? metadata,
  }) async {
    final docRef = _firestore.collection('surprises').doc();
    
    final surprise = SurpriseModel(
      id: docRef.id,
      title: title,
      description: description,
      type: type,
      status: SurpriseStatus.hidden,
      location: location,
      radius: radius,
      rewards: rewards,
      createdAt: DateTime.now(),
      xpReward: xpReward,
      imageUrl: imageUrl,
      requiredBadges: requiredBadges,
      metadata: metadata,
    );
    
    await docRef.set(surprise.toMap());
    return surprise;
  }
  
  // Reveal a surprise (called by AI)
  Future<void> revealSurprise(String surpriseId, String aiHint) async {
    final docRef = _firestore.collection('surprises').doc(surpriseId);
    
    await docRef.update({
      'status': SurpriseStatus.revealed.toString().split('.').last,
      'revealedAt': FieldValue.serverTimestamp(),
      'aiHint': aiHint,
    });
  }
  
  // Mark a surprise as discovered
  Future<void> discoverSurprise(String surpriseId) async {
    final docRef = _firestore.collection('surprises').doc(surpriseId);
    final user = _authService.currentUser;
    
    if (user == null) throw Exception('User not authenticated');
    
    await docRef.update({
      'status': SurpriseStatus.discovered.toString().split('.').last,
      'discoveredAt': FieldValue.serverTimestamp(),
    });
    
    // Notify AI about the discovery
    await _aiService.onSurpriseDiscovered(surpriseId);
  }
  
  // Claim a surprise reward
  Future<void> claimSurprise(String surpriseId) async {
    final docRef = _firestore.collection('surprises').doc(surpriseId);
    final user = _authService.currentUser;
    
    if (user == null) throw Exception('User not authenticated');
    
    final surpriseDoc = await docRef.get();
    if (!surpriseDoc.exists) throw Exception('Surprise not found');
    
    final surprise = SurpriseModel.fromMap(surpriseDoc.data()!);
    if (surprise.status != SurpriseStatus.discovered) {
      throw Exception('Surprise must be discovered before claiming');
    }
    
    final userProfile = _authService.userProfile;
    if (userProfile == null) throw Exception('User profile not found');
    
    if (!surprise.canBeClaimed(userProfile.badges ?? [])) {
      throw Exception('User does not meet requirements to claim this surprise');
    }
    
    // Update surprise status
    await docRef.update({
      'status': SurpriseStatus.claimed.toString().split('.').last,
      'claimedAt': FieldValue.serverTimestamp(),
    });
    
    // Award XP to user
    await _authService.updateUserProgress(surprise.xpReward);
    
    // Process rewards
    await _processRewards(surprise.rewards);
    
    // Notify AI about the claim
    await _aiService.onSurpriseClaimed(surpriseId);
  }
  
  // Process surprise rewards
  Future<void> _processRewards(Map<String, dynamic> rewards) async {
    // TODO: Implement reward processing logic
    // This could include:
    // - Adding items to user inventory
    // - Unlocking new features
    // - Awarding special badges
    // - etc.
  }
  
  // Calculate distance between two points using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = pi / 180;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) *
            cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) /
            2;
    return 12742 * asin(sqrt(a)) * 1000; // Distance in meters
  }
  
  // Get AI recommendation for nearby surprises
  Future<List<SurpriseModel>> getAIRecommendedSurprises(LatLng location) async {
    final nearbySurprises = await getNearbySurprises(location, 5000).first;
    if (nearbySurprises.isEmpty) return [];
    
    // Get AI recommendations
    final recommendations = await _aiService.getSurpriseRecommendations(
      location,
      nearbySurprises,
    );
    
    // Reveal recommended surprises
    for (final surprise in recommendations) {
      if (surprise.isHidden) {
        await revealSurprise(
          surprise.id,
          recommendations.firstWhere((s) => s.id == surprise.id).aiHint ?? '',
        );
      }
    }
    
    return recommendations;
  }
} 