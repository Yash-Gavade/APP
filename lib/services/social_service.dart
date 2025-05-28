import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitventure/services/auth_service.dart';

class SocialService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService;

  SocialService(this._authService);

  // Friend Requests
  Stream<QuerySnapshot> getFriendRequests() {
    final userId = _authService.user?.uid;
    if (userId == null) return Stream.value(null as QuerySnapshot);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friendRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  Future<void> sendFriendRequest(String targetUserId) async {
    final currentUser = _authService.user;
    if (currentUser == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();

    // Add to sender's sent requests
    final sentRequestRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('sentRequests')
        .doc(targetUserId);

    batch.set(sentRequestRef, {
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Add to receiver's friend requests
    final receivedRequestRef = _firestore
        .collection('users')
        .doc(targetUserId)
        .collection('friendRequests')
        .doc(currentUser.uid);

    batch.set(receivedRequestRef, {
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': currentUser.uid,
      'senderName': currentUser.displayName,
      'senderPhotoUrl': currentUser.photoURL,
    });

    await batch.commit();
  }

  Future<void> acceptFriendRequest(String senderId) async {
    final currentUser = _authService.user;
    if (currentUser == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();

    // Update request status
    final requestRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friendRequests')
        .doc(senderId);

    batch.update(requestRef, {'status': 'accepted'});

    // Add to friends collection for both users
    final currentUserFriendRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friends')
        .doc(senderId);

    final senderFriendRef = _firestore
        .collection('users')
        .doc(senderId)
        .collection('friends')
        .doc(currentUser.uid);

    // Get sender's data
    final senderDoc = await _firestore.collection('users').doc(senderId).get();
    final currentUserDoc = await _firestore.collection('users').doc(currentUser.uid).get();

    batch.set(currentUserFriendRef, {
      'name': senderDoc.data()?['name'],
      'photoUrl': senderDoc.data()?['photoUrl'],
      'status': 'active',
      'timestamp': FieldValue.serverTimestamp(),
    });

    batch.set(senderFriendRef, {
      'name': currentUserDoc.data()?['name'],
      'photoUrl': currentUserDoc.data()?['photoUrl'],
      'status': 'active',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> rejectFriendRequest(String senderId) async {
    final currentUser = _authService.user;
    if (currentUser == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();

    // Update request status
    final requestRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('friendRequests')
        .doc(senderId);

    batch.update(requestRef, {'status': 'rejected'});

    // Update sent request status
    final sentRequestRef = _firestore
        .collection('users')
        .doc(senderId)
        .collection('sentRequests')
        .doc(currentUser.uid);

    batch.update(sentRequestRef, {'status': 'rejected'});

    await batch.commit();
  }

  // Groups
  Future<void> createGroup({
    required String name,
    required String description,
    String? photoUrl,
    List<String> initialMembers = const [],
  }) async {
    final currentUser = _authService.user;
    if (currentUser == null) throw Exception('User not authenticated');

    final groupRef = _firestore.collection('groups').doc();
    final members = [...initialMembers, currentUser.uid];

    await groupRef.set({
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
      'createdBy': currentUser.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'members': members,
      'memberCount': members.length,
      'admins': [currentUser.uid],
    });

    // Add group reference to each member's groups collection
    final batch = _firestore.batch();
    for (final memberId in members) {
      final userGroupRef = _firestore
          .collection('users')
          .doc(memberId)
          .collection('groups')
          .doc(groupRef.id);

      batch.set(userGroupRef, {
        'joinedAt': FieldValue.serverTimestamp(),
        'role': memberId == currentUser.uid ? 'admin' : 'member',
      });
    }

    await batch.commit();
  }

  Future<void> joinGroup(String groupId) async {
    final currentUser = _authService.user;
    if (currentUser == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();

    // Add user to group members
    final groupRef = _firestore.collection('groups').doc(groupId);
    batch.update(groupRef, {
      'members': FieldValue.arrayUnion([currentUser.uid]),
      'memberCount': FieldValue.increment(1),
    });

    // Add group to user's groups
    final userGroupRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('groups')
        .doc(groupId);

    batch.set(userGroupRef, {
      'joinedAt': FieldValue.serverTimestamp(),
      'role': 'member',
    });

    await batch.commit();
  }

  Future<void> leaveGroup(String groupId) async {
    final currentUser = _authService.user;
    if (currentUser == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();

    // Remove user from group members
    final groupRef = _firestore.collection('groups').doc(groupId);
    batch.update(groupRef, {
      'members': FieldValue.arrayRemove([currentUser.uid]),
      'memberCount': FieldValue.increment(-1),
      'admins': FieldValue.arrayRemove([currentUser.uid]),
    });

    // Remove group from user's groups
    final userGroupRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('groups')
        .doc(groupId);

    batch.delete(userGroupRef);

    await batch.commit();
  }

  Future<void> updateGroupSettings({
    required String groupId,
    String? name,
    String? description,
    String? photoUrl,
  }) async {
    final currentUser = _authService.user;
    if (currentUser == null) throw Exception('User not authenticated');

    // Check if user is admin
    final groupDoc = await _firestore.collection('groups').doc(groupId).get();
    final admins = List<String>.from(groupDoc.data()?['admins'] ?? []);
    
    if (!admins.contains(currentUser.uid)) {
      throw Exception('Only group admins can update group settings');
    }

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (photoUrl != null) updates['photoUrl'] = photoUrl;

    await _firestore.collection('groups').doc(groupId).update(updates);
  }
} 