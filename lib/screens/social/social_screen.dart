import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitventure/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:fitventure/services/social_service.dart';
import 'package:fitventure/widgets/social/friend_request_card.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Animated Social Icon
                      SizedBox(
                        height: 80,
                        child: Lottie.asset(
                          'assets/animations/social_connection.json',
                          repeat: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connect & Share',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: 'Friends'),
                  Tab(text: 'Discover'),
                  Tab(text: 'Groups'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFriendsTab(),
            _buildDiscoverTab(),
            _buildGroupsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show create group or add friend dialog
          _showAddConnectionDialog(context);
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Connect'),
      ),
    );
  }

  Widget _buildFriendsTab() {
    return Column(
      children: [
        // Friend Requests Section
        StreamBuilder<QuerySnapshot>(
          stream: Provider.of<SocialService>(context).getFriendRequests(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final requests = snapshot.data?.docs ?? [];

            if (requests.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Friend Requests',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...requests.map((request) => FriendRequestCard(request: request)),
                  const Divider(),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),

        // Friends List
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<AuthService>(context).user?.uid)
                .collection('friends')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final friends = snapshot.data?.docs ?? [];

              if (friends.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/no_friends.json',
                        height: 200,
                        repeat: true,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No friends yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          _tabController.animateTo(1); // Switch to Discover tab
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Find Friends'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return _buildFriendCard(friend);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            onChanged: (value) {
              setState(() => _isSearching = value.isNotEmpty);
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('name', isGreaterThanOrEqualTo: _searchController.text)
                .where('name', isLessThanOrEqualTo: '${_searchController.text}\uf8ff')
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data?.docs ?? [];

              if (users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/no_results.json',
                        height: 200,
                        repeat: true,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No users found',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildUserCard(user);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .where('members', arrayContains: Provider.of<AuthService>(context).user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final groups = snapshot.data?.docs ?? [];

        if (groups.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/no_groups.json',
                  height: 200,
                  repeat: true,
                ),
                const SizedBox(height: 16),
                Text(
                  'No groups yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    _showCreateGroupDialog(context);
                  },
                  icon: const Icon(Icons.group_add),
                  label: const Text('Create Group'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return _buildGroupCard(group);
          },
        );
      },
    );
  }

  Widget _buildFriendCard(DocumentSnapshot friend) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(friend['photoUrl'] ?? ''),
          child: friend['photoUrl'] == null
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(friend['name'] ?? 'Unknown'),
        subtitle: Text(friend['status'] ?? 'Available'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                // Navigate to chat
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showFriendOptions(context, friend);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(DocumentSnapshot user) {
    final currentUserId = Provider.of<AuthService>(context).user?.uid;
    final isCurrentUser = user.id == currentUserId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user['photoUrl'] ?? ''),
          child: user['photoUrl'] == null
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(user['name'] ?? 'Unknown'),
        subtitle: Text(user['bio'] ?? 'No bio'),
        trailing: isCurrentUser
            ? const Text('You')
            : ElevatedButton(
                onPressed: () {
                  _sendFriendRequest(user.id);
                },
                child: const Text('Connect'),
              ),
      ),
    );
  }

  Widget _buildGroupCard(DocumentSnapshot group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(group['photoUrl'] ?? ''),
              child: group['photoUrl'] == null
                  ? const Icon(Icons.group)
                  : null,
            ),
            title: Text(group['name'] ?? 'Unknown Group'),
            subtitle: Text('${group['memberCount'] ?? 0} members'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showGroupOptions(context, group);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              group['description'] ?? 'No description',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddConnectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Friend'),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1); // Switch to Discover tab
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('Create Group'),
              onTap: () {
                Navigator.pop(context);
                _showCreateGroupDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();
    String? _selectedPhotoUrl;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Group'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Group Photo
              GestureDetector(
                onTap: () {
                  // TODO: Implement photo picker
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: _selectedPhotoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            _selectedPhotoUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Group Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  prefixIcon: Icon(Icons.group),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Group Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              try {
                final socialService = Provider.of<SocialService>(context, listen: false);
                await socialService.createGroup(
                  name: _nameController.text.trim(),
                  description: _descriptionController.text.trim(),
                  photoUrl: _selectedPhotoUrl,
                );
                
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group created successfully')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showFriendOptions(BuildContext context, DocumentSnapshot friend) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to chat
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
    // Implement friend options menu
  }

  void _showGroupOptions(BuildContext context, DocumentSnapshot group) {
    // Implement group options menu
  }

  Future<void> _sendFriendRequest(String userId) async {
    // Implement friend request logic
  }
} 