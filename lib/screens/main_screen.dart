import 'package:flutter/material.dart';
import '../data/profiles_data.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import 'home/home_page.dart';
import 'messages/messages_page.dart';
import 'notifications/notifications_page.dart';
import 'AI/ai.dart';
import 'projects/projects_page.dart';
import 'profile/profile_page.dart';
import 'jobs/jobs_page.dart'; // ← add this import (create the file if needed)

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // ── Shared state ─────────────────────────────────────────────────────
  final Set<int> _bookmarked = {};
  final Set<int> _collaborated = {0, 2}; // seeded for demo
  final Map<String, List<ChatMessage>> _conversations = {};
  List<ProfileData> _profiles = kAllProfiles;

  @override
  void initState() {
    super.initState();
    seedConversation(kAllProfiles[0], [
      ChatMessage(
          id: '1',
          text: 'Hey! Thanks for the collaboration request 🎬',
          isSent: false,
          time: ago(120),
          isRead: true),
      ChatMessage(
          id: '2',
          text: 'Would love to work on your next project!',
          isSent: false,
          time: ago(118),
          isRead: true),
      ChatMessage(
          id: '3',
          text: 'Absolutely! I was thinking a short documentary.',
          isSent: true,
          time: ago(115),
          isRead: true),
      ChatMessage(
          id: '4',
          text: 'That sounds amazing. When are you thinking?',
          isSent: false,
          time: ago(100),
          isRead: true),
      ChatMessage(
          id: '5',
          text: 'Maybe late July? We can plan a recce first.',
          isSent: true,
          time: ago(90),
          isRead: true),
      ChatMessage(
          id: '6',
          text: 'Great — let\'s sync dates soon.',
          isSent: true,
          time: ago(10),
          isRead: false),
    ]);

    seedConversation(kAllProfiles[2], [
      ChatMessage(
          id: '1',
          text: 'Hi! Saw your collaboration request. Interested!',
          isSent: false,
          time: ago(300),
          isRead: true),
      ChatMessage(
          id: '2',
          text: 'Great to hear. I need a lead for a thriller.',
          isSent: true,
          time: ago(290),
          isRead: true),
      ChatMessage(
          id: '3',
          text: 'Thriller is my favourite genre 😄',
          isSent: false,
          time: ago(285),
          isRead: true),
      ChatMessage(
          id: '4',
          text: 'Script will be ready by end of month.',
          isSent: true,
          time: ago(280),
          isRead: true),
      ChatMessage(
          id: '5',
          text: 'Excited to read it! 🎭',
          isSent: false,
          time: ago(60),
          isRead: false),
    ]);
            }

  DateTime ago(int minutes) =>
      DateTime.now().subtract(Duration(minutes: minutes));

  void seedConversation(ProfileData p, List<ChatMessage> msgs) {
    _conversations[p.name] = msgs;
  }

  void toggleBookmark(int index) {
    setState(() {
      _bookmarked.contains(index)
          ? _bookmarked.remove(index)
          : _bookmarked.add(index);
    });
  }

  Future<void> addCollaboration(int index) async {
    final profile = (index >= 0 && index < _profiles.length) ? _profiles[index] : null;
    if (profile == null) return;

    if (!_conversations.containsKey(profile.name)) {
      _conversations[profile.name] = [
        ChatMessage(
          id: '1',
          text: 'Hi! I received your collaboration request 🙌',
          isSent: false,
          time: DateTime.now(),
          isRead: false,
        ),
      ];
    }

    // attempt follow on backend if possible
    if (profile.id.isNotEmpty) {
      try {
        final auth = AuthService();
        await auth.follow(profile.id);
      } catch (_) {}
    }

    setState(() => _collaborated.add(index));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadRemoteProfiles();
  }

  Future<void> loadRemoteProfiles() async {
    try {
      final auth = AuthService();
      final users = await auth.fetchAllUsers();
      if (users.isEmpty) return;
      final colors = [
        const Color(0xffFF512F),
        const Color(0xff396afc),
        const Color(0xff11998e),
        const Color(0xff8E2DE2),
        const Color(0xfff953c6),
      ];
      final icons = [
        Icons.videocam_rounded,
        Icons.cut_rounded,
        Icons.theater_comedy_rounded,
        Icons.star_rounded,
        Icons.graphic_eq_rounded,
      ];
      final mapped = users.map((u) {
        final i = users.indexOf(u) % colors.length;
        return ProfileData(
          id: u['_id']?.toString() ?? '',
          name: u['fullName'] ?? (u['username'] ?? 'User'),
          role: u['role'] ?? '',
          type: 'User',
          location: '',
          color1: colors[i],
          color2: colors[(i + 1) % colors.length],
          skills: const [],
          icon: icons[i],
          followers: 0,
        );
      }).toList();
      if (!mounted) return;
      setState(() => _profiles = mapped);
    } catch (_) {}
  }

  void onSendMessage(String profileName, ChatMessage msg) {
    setState(() {
      _conversations[profileName] ??= [];
      _conversations[profileName]!.add(msg);
    });
  }

  int get _unreadMessageCount {
    int count = 0;
    for (final msgs in _conversations.values) {
      count += msgs.where((m) => !m.isSent && !m.isRead).length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    // ─────────────────────────────────────────────────────────
    //  PAGE INDEX MAP
    //  0 → Home
    //  1 → Projects
    //  2 → AI
    //  3 → Jobs        ← NEW (replaces Messages in bottom nav)
    //  4 → Profile
    //  5 → Messages    ← hidden from nav; opened via home header button
    // ─────────────────────────────────────────────────────────
    final List<Widget> pages = [
      // ── 0: Home ──────────────────────────────────────────────
      HomePage(
        allProfiles: _profiles,
        // Messages is now at index 5 in the stack
        onNavigateToMessages: () => setState(() => _currentIndex = 5),
        unreadMessages: _unreadMessageCount,
      ),

      // ── 1: Projects ──────────────────────────────────────────
      ProjectsPage(
        allProfiles: _profiles,
        bookmarked: _bookmarked,
        collaborated: _collaborated,
        onBookmark: toggleBookmark,
        onCollaborate: addCollaboration,
      ),

      // ── 2: AI ────────────────────────────────────────────────
      const AIPage(),

      // ── 3: Jobs (NEW) ────────────────────────────────────────
      const JobsPage(),

      // ── 4: Profile ───────────────────────────────────────────
      ProfilePage(),

      // ── 5: Messages (hidden from bottom nav) ─────────────────
      MessagesPage(
        allProfiles: _profiles,
        collaborated: _collaborated,
        conversations: _conversations,
        onSendMessage: onSendMessage,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // ── 0: Home ────────────────────────────────────────
            navItem(
              icon: Icons.home_rounded,
              label: "Home",
              index: 0,
            ),

            // ── 1: Projects ────────────────────────────────────
            navItem(
              icon: Icons.movie_creation_outlined,
              label: "Projects",
              index: 1,
            ),

            // ── 2: AI ──────────────────────────────────────────
            navItem(
              icon: Icons.auto_awesome_outlined,
              label: "AI",
              index: 2,
            ),

            // ── 3: Jobs (NEW) ──────────────────────────────────
            navItem(
              icon: Icons.work_outline_rounded,
              label: "Jobs",
              index: 3,
            ),

            // ── 4: Profile ─────────────────────────────────────
            navItem(
              icon: Icons.person_outline_rounded,
              label: "Profile",
              index: 4,
            ),

            // NOTE: Messages (index 5) is intentionally NOT listed
            // here. It is accessed via the envelope icon in the
            // Home screen header, which calls onNavigateToMessages
            // → _currentIndex = 5.
          ],
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
    int badge = 0,
  }) {
    // Consider "selected" only for the 5 visible bottom-nav tabs (0–4).
    // When Messages (index 5) is open, no bottom tab lights up — which
    // is the correct behaviour since it has no bottom nav entry.
    final bool sel = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: sel
                  ? const LinearGradient(
                      colors: [Color(0xffFF8C00), Color(0xffFF3D00)])
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white),
                if (sel) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          if (badge > 0)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFF3D00),
                ),
                child: Center(
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}