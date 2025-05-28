import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitquest/models/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // User profile data
  UserModel? _userProfile;
  UserModel? get userProfile => _userProfile;
  
  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _loadUserProfile();
      return credential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user profile in Firestore
      await _createUserProfile(credential.user!.uid, name, email);
      await _loadUserProfile();
      
      return credential;
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userProfile = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Create user profile in Firestore
  Future<void> _createUserProfile(String uid, String name, String email) async {
    final userData = UserModel(
      id: uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
      xp: 0,
      level: 1,
      streak: 0,
      lastActive: DateTime.now(),
    );
    
    await _firestore.collection('users').doc(uid).set(userData.toMap());
  }
  
  // Load user profile from Firestore
  Future<void> _loadUserProfile() async {
    if (currentUser == null) return;
    
    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      
      if (doc.exists) {
        _userProfile = UserModel.fromMap(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Update user profile
  Future<void> updateUserProfile(UserModel updatedProfile) async {
    if (currentUser == null) return;
    
    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update(updatedProfile.toMap());
      
      _userProfile = updatedProfile;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  // Update user XP and level
  Future<void> updateUserProgress(int xpGained) async {
    if (_userProfile == null) return;
    
    final newXp = _userProfile!.xp + xpGained;
    final newLevel = (newXp ~/ 1000) + 1; // Level up every 1000 XP
    
    final updatedProfile = _userProfile!.copyWith(
      xp: newXp,
      level: newLevel,
      lastActive: DateTime.now(),
    );
    
    await updateUserProfile(updatedProfile);
  }
  
  // Update user streak
  Future<void> updateStreak() async {
    if (_userProfile == null) return;
    
    final now = DateTime.now();
    final lastActive = _userProfile!.lastActive;
    
    // Check if the last active date was yesterday
    final isConsecutiveDay = now.difference(lastActive).inDays == 1;
    
    final newStreak = isConsecutiveDay ? _userProfile!.streak + 1 : 1;
    
    final updatedProfile = _userProfile!.copyWith(
      streak: newStreak,
      lastActive: now,
    );
    
    await updateUserProfile(updatedProfile);
  }
} 