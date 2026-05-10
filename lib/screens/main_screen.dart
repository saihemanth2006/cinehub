import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../data/profiles_data.dart';
import '../models/models.dart';
import 'home/home_page.dart';
import 'messages/messages_page.dart';
import 'AI/ai.dart';
import 'projects/projects_page.dart';
import 'profile/profile_page.dart';
import 'jobs/jobs_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final Set<int> _bookmarked = {};
  final Set<int> _collaborated = {0, 2};
  final Map<String, List<ChatMessage>> _conversations = {};

  @override
  void initState() {
    super.initState();
    _seedConversation(kAllProfiles[0], [
      ChatMessage(id: '1', text: 'Hey! Thanks for the collaboration request 🎬', isSent: false, time: _ago(120), isRead: true),
      ChatMessage(id: '2', text: 'Would love to work on your next project!', isSent: false, time: _ago(118), isRead: true),
      ChatMessage(id: '3', text: 'Absolutely! I was thinking a short documentary.', isSent: true, time: _ago(115), isRead: true),
      ChatMessage(id: '4', text: 'That sounds amazing. When are you thinking?', isSent: false, time: _ago(100), isRead: true),
      ChatMessage(id: '5', text: 'Maybe late July? We can plan a recce first.', isSent: true, time: _ago(90), isRead: true),
      ChatMessage(id: '6', text: 'Perfect. I\'ll keep those dates free 👍', isSent: false, time: _ago(10), isRead: false),
    ]);
    _seedConversation(kAllProfiles[2], [
      ChatMessage(id: '1', text: 'Hi! Saw your collaboration request. Interested!', isSent: false, time: _ago(300), isRead: true),
      ChatMessage(id: '2', text: 'Great to hear. I need a lead for a thriller.', isSent: true, time: _ago(290), isRead: true),
      ChatMessage(id: '3', text: 'Thriller is my favourite genre 😄', isSent: false, time: _ago(285), isRead: true),
      ChatMessage(id: '4', text: 'Script will be ready by end of month.', isSent: true, time: _ago(280), isRead: true),
      ChatMessage(id: '5', text: 'Excited to read it! 🎭', isSent: false, time: _ago(60), isRead: false),
    ]);
  }

  DateTime _ago(int minutes) => DateTime.now().subtract(Duration(minutes: minutes));

  void _seedConversation(ProfileData p, List<ChatMessage> msgs) {
    _conversations[p.name] = msgs;
  }

  void _toggleBookmark(int index) {
    setState(() {
      _bookmarked.contains(index) ? _bookmarked.remove(index) : _bookmarked.add(index);
    });
  }

  void _addCollaboration(int index) {
    setState(() => _collaborated.add(index));
    final profile = kAllProfiles[index];
    if (!_conversations.containsKey(profile.name)) {
      _conversations[profile.name] = [
        ChatMessage(id: '1', text: 'Hi! I received your collaboration request 🙌', isSent: false, time: DateTime.now(), isRead: false),
      ];
    }
  }

  void _onSendMessage(String profileName, ChatMessage msg) {
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

  static const _navItems = [
    _NavItem(icon: Icons.home_rounded,            label: 'Home'),
    _NavItem(icon: Icons.movie_creation_outlined, label: 'Projects'),
    _NavItem(icon: Icons.auto_awesome_outlined,   label: 'AI'),
    _NavItem(icon: Icons.work_outline_rounded,    label: 'Jobs'),
    _NavItem(icon: Icons.person_outline_rounded,  label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        allProfiles: kAllProfiles,
        onNavigateToMessages: () => setState(() => _currentIndex = 5),
        unreadMessages: _unreadMessageCount,
      ),
      ProjectsPage(
        allProfiles: kAllProfiles,
        bookmarked: _bookmarked,
        collaborated: _collaborated,
        onBookmark: _toggleBookmark,
        onCollaborate: _addCollaboration,
      ),
      const AIPage(),
      const JobsPage(),
      ProfilePage(),
      MessagesPage(
        allProfiles: kAllProfiles,
        collaborated: _collaborated,
        conversations: _conversations,
        onSendMessage: _onSendMessage,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: _FloatingBubbleNavBar(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ── Data class ─────────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ── NavBar widget ──────────────────────────────────────────────────────────
class _FloatingBubbleNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  const _FloatingBubbleNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Dark bar ──────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.55),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
            ),
          ),

          // ── Tab icons ─────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (i) {
                  return _BubbleTab(
                    icon: items[i].icon,
                    selected: currentIndex == i,
                    onTap: () => onTap(i),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single tab with floating bubble + idle float + purple dot ──────────────
class _BubbleTab extends StatefulWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _BubbleTab({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_BubbleTab> createState() => _BubbleTabState();
}

class _BubbleTabState extends State<_BubbleTab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 70,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [

            // ── Floating bubble (selected) ──────────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutBack,
              top: widget.selected ? -22 : 12,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: widget.selected ? 1.0 : 0.0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      final double floatOffset = widget.selected
                          ? math.sin(_floatController.value * 2 * math.pi) * 4.0
                          : 0.0;
                      return Transform.translate(
                        offset: Offset(0, floatOffset),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xffFF8C00), Color(0xffFF3D00)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x88FF5500),
                            blurRadius: 14,
                            spreadRadius: 1,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.icon,
                        size: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Purple dot at bottom (selected indicator) ───────
            Positioned(
              bottom: 6,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: widget.selected ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: widget.selected ? 7 : 0,
                  height: widget.selected ? 7 : 0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffA855F7), // purple-500
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffA855F7).withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Dimmed icon (not selected) ──────────────────────
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.selected ? 0.0 : 1.0,
              child: Icon(
                widget.icon,
                size: 24,
                color: Colors.white38,
              ),
            ),

          ],
        ),
      ),
    );
  }
}