import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _postController = TextEditingController();
  String _fullName = '';
  String _email = '';
  String _bio = '';
  String? _profilePicturePath;
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadPosts();
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentEmail = prefs.getString('current_user_email');

      if (currentEmail == null) return;

      final usersJson = prefs.getString('all_users_db');
      if (usersJson != null) {
        final users = jsonDecode(usersJson) as Map<String, dynamic>;
        final userData = users[currentEmail] as Map<String, dynamic>;

        setState(() {
          _fullName = userData['fullName'] ?? '';
          _email = currentEmail;
          _bio = userData['bio'] ?? 'Welcome to my profile! 👋';
          _profilePicturePath = userData['profilePicturePath'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentEmail = prefs.getString('current_user_email');

      if (currentEmail == null) return;

      final postsJson = prefs.getString('user_posts_$currentEmail');
      if (postsJson != null) {
        final List<dynamic> postsList = jsonDecode(postsJson);
        setState(() {
          _posts = postsList.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  Future<void> _savePosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentEmail = prefs.getString('current_user_email');

      if (currentEmail == null) return;

      await prefs.setString('user_posts_$currentEmail', jsonEncode(_posts));
    } catch (e) {
      print('Error saving posts: $e');
    }
  }

  void _createPost() {
    if (_postController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please write something!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newPost = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': _postController.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
      'likes': 0,
      'comments': 0,
    };

    setState(() {
      _posts.insert(0, newPost);
    });

    _savePosts();
    _postController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post created! 🎉'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deletePost(String postId) {
    setState(() {
      _posts.removeWhere((post) => post['id'] == postId);
    });
    _savePosts();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post deleted'),
        backgroundColor: Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Post',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _postController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "What's on your mind, $_fullName?",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    _createPost();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xFF1877F2)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 280.h,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1877F2),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1877F2),
                      const Color(0xFF1877F2).withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 40.h),
                      // Profile Picture
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Colors.white,
                          backgroundImage: _profilePicturePath != null
                              ? FileImage(File(_profilePicturePath!))
                              : null,
                          child: _profilePicturePath == null
                              ? Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: const Color(0xFF1877F2),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Name
                      Text(
                        _fullName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Email
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Bio
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          _bio,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Posts Count Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Posts',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1877F2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_posts.length} Posts',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1877F2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Posts List
          _posts.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.all(40.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.post_add,
                          size: 64.sp,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No Posts Yet',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Share your first post!',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = _posts[index];
                    return Container(
                      margin: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Post Header
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor: const Color(
                                    0xFF1877F2,
                                  ).withOpacity(0.1),
                                  backgroundImage: _profilePicturePath != null
                                      ? FileImage(File(_profilePicturePath!))
                                      : null,
                                  child: _profilePicturePath == null
                                      ? Icon(
                                          Icons.person,
                                          size: 20.sp,
                                          color: const Color(0xFF1877F2),
                                        )
                                      : null,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _fullName,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        _formatTimestamp(post['timestamp']),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () => _deletePost(post['id']),
                                ),
                              ],
                            ),
                          ),

                          // Post Content
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              post['content'],
                              style: TextStyle(fontSize: 15.sp, height: 1.4),
                            ),
                          ),

                          SizedBox(height: 12.h),

                          // Post Actions
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildActionButton(
                                  icon: Icons.thumb_up_outlined,
                                  label: '${post['likes']} Like',
                                  onTap: () {},
                                ),
                                _buildActionButton(
                                  icon: Icons.comment_outlined,
                                  label: '${post['comments']} Comment',
                                  onTap: () {},
                                ),
                                _buildActionButton(
                                  icon: Icons.share_outlined,
                                  label: 'Share',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }, childCount: _posts.length),
                ),

          SliverToBoxAdapter(child: SizedBox(height: 80.h)),
        ],
      ),

      // Floating Action Button - Create Post
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostDialog,
        backgroundColor: const Color(0xFF1877F2),
        elevation: 4,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Create Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.grey.shade700),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
