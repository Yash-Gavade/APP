import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitquest/models/surprise_model.dart';

class SurpriseService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getNearbySurprises() async {
    try {
      // TODO: Implement actual location-based query
      // For now, return mock data
      return [
        {
          'id': '1',
          'title': 'Hidden Achievement',
          'description': 'Complete your first 5K run!',
          'icon': 'https://example.com/icon1.png',
          'isUnlocked': false,
        },
        {
          'id': '2',
          'title': 'Secret Badge',
          'description': 'Visit the park 3 times this week',
          'icon': 'https://example.com/icon2.png',
          'isUnlocked': true,
        },
      ];
    } catch (e) {
      throw Exception('Failed to load nearby surprises: $e');
    }
  }

  Future<void> unlockSurprise(String surpriseId) async {
    try {
      // TODO: Implement actual unlock logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    } catch (e) {
      throw Exception('Failed to unlock surprise: $e');
    }
  }

  Future<SurpriseModel?> getSurpriseDetails(String surpriseId) async {
    try {
      final doc = await _firestore.collection('surprises').doc(surpriseId).get();
      if (!doc.exists) return null;
      return SurpriseModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to load surprise details: $e');
    }
  }
} 