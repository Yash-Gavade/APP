import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? message;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.message,
  });

  factory FriendRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendRequestModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      message: data['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'message': message,
    };
  }

  FriendRequestModel copyWith({
    String? senderId,
    String? receiverId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? message,
  }) {
    return FriendRequestModel(
      id: id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      message: message ?? this.message,
    );
  }
}

class GroupModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String createdBy;
  final DateTime createdAt;
  final List<String> members;
  final List<String> admins;
  final bool isPrivate;
  final String? inviteCode;
  final Map<String, dynamic>? settings;
  final int memberCount;
  final DateTime? lastActivityAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.createdBy,
    required this.createdAt,
    required this.members,
    required this.admins,
    this.isPrivate = false,
    this.inviteCode,
    this.settings,
    required this.memberCount,
    this.lastActivityAt,
  });

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      members: List<String>.from(data['members'] ?? []),
      admins: List<String>.from(data['admins'] ?? []),
      isPrivate: data['isPrivate'] ?? false,
      inviteCode: data['inviteCode'],
      settings: data['settings'],
      memberCount: data['memberCount'] ?? 0,
      lastActivityAt: data['lastActivityAt'] != null
          ? (data['lastActivityAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'members': members,
      'admins': admins,
      'isPrivate': isPrivate,
      'inviteCode': inviteCode,
      'settings': settings,
      'memberCount': memberCount,
      'lastActivityAt': lastActivityAt != null
          ? Timestamp.fromDate(lastActivityAt!)
          : null,
    };
  }

  GroupModel copyWith({
    String? name,
    String? description,
    String? icon,
    String? createdBy,
    DateTime? createdAt,
    List<String>? members,
    List<String>? admins,
    bool? isPrivate,
    String? inviteCode,
    Map<String, dynamic>? settings,
    int? memberCount,
    DateTime? lastActivityAt,
  }) {
    return GroupModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
      admins: admins ?? this.admins,
      isPrivate: isPrivate ?? this.isPrivate,
      inviteCode: inviteCode ?? this.inviteCode,
      settings: settings ?? this.settings,
      memberCount: memberCount ?? this.memberCount,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }

  bool isAdmin(String userId) => admins.contains(userId);
  bool isMember(String userId) => members.contains(userId);
  bool canJoin(String userId) => !isMember(userId) && (!isPrivate || inviteCode != null);
}

class GroupInviteModel {
  final String id;
  final String groupId;
  final String code;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final int maxUses;
  final int usedCount;
  final bool isActive;

  GroupInviteModel({
    required this.id,
    required this.groupId,
    required this.code,
    required this.createdBy,
    required this.createdAt,
    this.expiresAt,
    required this.maxUses,
    required this.usedCount,
    this.isActive = true,
  });

  factory GroupInviteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupInviteModel(
      id: doc.id,
      groupId: data['groupId'] ?? '',
      code: data['code'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : null,
      maxUses: data['maxUses'] ?? 1,
      usedCount: data['usedCount'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'code': code,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt!) : null,
      'maxUses': maxUses,
      'usedCount': usedCount,
      'isActive': isActive,
    };
  }

  GroupInviteModel copyWith({
    String? groupId,
    String? code,
    String? createdBy,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? maxUses,
    int? usedCount,
    bool? isActive,
  }) {
    return GroupInviteModel(
      id: id,
      groupId: groupId ?? this.groupId,
      code: code ?? this.code,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      maxUses: maxUses ?? this.maxUses,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isMaxedOut => usedCount >= maxUses;
  bool get isValid => isActive && !isExpired && !isMaxedOut;
} 