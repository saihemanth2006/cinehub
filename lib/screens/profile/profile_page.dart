import 'package:flutter/material.dart';
import '../notifications/notifications_page.dart';

// ─── Data models ────────────────────────────────────────────────────────────

class _Project {
  final String title;
  final String role;
  final String year;
  final String genre;
  final String status; // "Done" | "Active" | "In Progress"
  final Color color;
  const _Project({
    required this.title,
    required this.role,
    required this.year,
    required this.genre,
    required this.status,
    required this.color,
  });
}

class _Testimonial {
  final String quote;
  final String name;
  final String role;
  const _Testimonial(
      {required this.quote, required this.name, required this.role});
}

class _Tool {
  final String name;
  final IconData icon;
  const _Tool({required this.name, required this.icon});
}

// ─── Page ────────────────────────────────────────────────────────────────────

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  bool _aboutExpanded = false;

  // ── Data ────────────────────────────────────────────────────────────
  final String _aboutFull =
      'Award-winning director with 10+ years in independent Indian cinema. '
      'Known for visually rich storytelling and morally complex characters. '
      'My work spans drama, documentary, and experimental formats. Passionate '
      'about collaborating with emerging talent and pushing the boundaries of '
      'Indian independent cinema.';

  final List<String> _skills = [
    'Direction',
    'Screenplay',
    'Storyboarding',
    'Final Cut Pro',
    'VFX Supervision',
    'Documentary',
    'Color Grading',
    'Casting',
    'Producer',
  ];

  final List<_Project> _projects = const [
    _Project(
      title: 'Echoes of Dawn',
      role: 'Director',
      year: '2024',
      genre: 'Drama',
      status: 'Done',
      color: Color(0xffFF8C00),
    ),
    _Project(
      title: 'Urban Lens',
      role: 'Producer',
      year: '2024',
      genre: 'Documentary',
      status: 'Active',
      color: Color(0xff38ef7d),
    ),
    _Project(
      title: 'Shadows & Light',
      role: 'Writer',
      year: '2023',
      genre: 'Thriller',
      status: 'Done',
      color: Color(0xffFF8C00),
    ),
  ];

  final List<_Testimonial> _testimonials = const [
    _Testimonial(
      quote:
          '"Vikram\'s vision is unparalleled. Every frame feels like a painting come to life."',
      name: 'Ananya Sharma',
      role: 'Lead Actress',
    ),
    _Testimonial(
      quote:
          '"Working with Vikram means being pushed to your absolute creative best."',
      name: 'Rohan Mehta',
      role: 'Cinematographer',
    ),
    _Testimonial(
      quote:
          '"His scripts have a rare emotional depth that brings out the best in every actor."',
      name: 'Priya Das',
      role: 'Screenplay Editor',
    ),
  ];

  final List<_Tool> _tools = const [
    _Tool(name: 'Final Cut', icon: Icons.video_settings_rounded),
    _Tool(name: 'DaVinci', icon: Icons.palette_rounded),
    _Tool(name: 'Celtx', icon: Icons.description_rounded),
    _Tool(name: 'Logic Pro', icon: Icons.music_note_rounded),
    _Tool(name: 'Canva', icon: Icons.brush_rounded),
    _Tool(name: 'Notion', icon: Icons.note_rounded),
  ];

  // ── Awards data ──────────────────────────────────────────────────────
  final List<Map<String, String>> _awards = const [
    {
      'title': 'Best Director',
      'event': 'Mumbai Film Festival',
      'year': '2024',
    },
    {
      'title': 'Best Screenplay',
      'event': 'Indian Indie Awards',
      'year': '2023',
    },
    {
      'title': 'Jury Special Mention',
      'event': 'MAMI',
      'year': '2022',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Colors ───────────────────────────────────────────────────────────
  static const Color _bg = Color(0xff09090B);
  static const Color _card = Color(0xff111114);
  static const Color _orange1 = Color(0xffFF8C00);
  static const Color _orange2 = Color(0xffFF3D00);
  static const Color _purple1 = Color(0xff8E2DE2);
  static const Color _purple2 = Color(0xff4A00E0);
  static const Color _green = Color(0xff38ef7d);

  // ── Helpers ──────────────────────────────────────────────────────────
  Widget _divider() => const Divider(color: Colors.white10, height: 1);

  Widget _sectionTitle(String t) => Text(
        t,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
      );

  Widget _skillChip(String s) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xff1E1E26),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white10),
        ),
        child: Text(s,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      );

  Widget _toolChip(_Tool t) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(t.icon, size: 15, color: _orange1),
          const SizedBox(width: 6),
          Text(t.name,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ]),
      );

  Widget _projectCard(_Project p) {
    final bool done = p.status == 'Done';
    final Color statusColor = done ? _green : _orange1;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(children: [
        // Left accent bar
        Container(
          width: 4,
          height: 44,
          decoration: BoxDecoration(
            color: p.color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        // Icon box
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: p.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.movie_creation_rounded,
              size: 20, color: p.color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text('${p.role} · ${p.year} · ${p.genre}',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5))),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(p.status,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor)),
        ),
      ]),
    );
  }

  Widget _testimonialCard(_Testimonial t) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.quote,
              style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.85))),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
              child:
                  const Icon(Icons.person_rounded, size: 18, color: Colors.white70),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              Text(t.role,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5))),
            ]),
          ]),
        ]),
      );

  Widget _awardTile(Map<String, String> a) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(
                  colors: [Color(0xffF7971E), Color(0xffFFD200)]),
            ),
            child: const Icon(Icons.emoji_events_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a['title']!,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('${a['event']} · ${a['year']}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5))),
              ],
            ),
          ),
        ]),
      );

  // ── Overview tab content ─────────────────────────────────────────────
  Widget _overviewTab() {
    final String aboutText = _aboutFull;
    final bool isLong = aboutText.length > 130;
    final String displayText = _aboutExpanded || !isLong
        ? aboutText
        : '${aboutText.substring(0, 130)}...';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        // About
        _sectionTitle('About'),
        const SizedBox(height: 10),
        Text(
          displayText,
          style: TextStyle(
              fontSize: 13.5,
              height: 1.7,
              color: Colors.white.withOpacity(0.7)),
        ),
        if (isLong) ...[
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _aboutExpanded = !_aboutExpanded),
            child: Text(
              _aboutExpanded ? 'Show less' : 'Read more',
              style: const TextStyle(
                  color: _orange1,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],

        const SizedBox(height: 26),

        // Skills
        _sectionTitle('Skills & Expertise'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _skills.map(_skillChip).toList(),
        ),

        const SizedBox(height: 26),

        // Recent Projects
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Recent Projects'),
            GestureDetector(
              onTap: () => _tab.animateTo(1),
              child: const Text('See all',
                  style: TextStyle(
                      color: _orange1,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._projects.map(_projectCard),

        const SizedBox(height: 26),

        // Testimonials
        _sectionTitle('What Collaborators Say'),
        const SizedBox(height: 12),
        ..._testimonials.map(_testimonialCard),

        const SizedBox(height: 26),

        // Tools
        _sectionTitle('Tools & Software'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tools.map(_toolChip).toList(),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  // ── Projects tab ─────────────────────────────────────────────────────
  Widget _projectsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        Text('All Projects (${_projects.length})',
            style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 14),
        ..._projects.map(_projectCard),
      ],
    );
  }

  // ── Awards tab ───────────────────────────────────────────────────────
  Widget _awardsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: [
        Text('Awards & Recognition',
            style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 14),
        ..._awards.map(_awardTile),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Fixed top bar ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(children: [
                const Text('My Profile',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                const Spacer(),
                _topIconBtn(Icons.notifications_none_rounded, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsPage()),
                  );
                }),
                const SizedBox(width: 10),
                _topIconBtn(Icons.settings_outlined, onTap: () {
                  _showSettingsSheet(context);
                }),
              ]),
            ),

            // ── Profile header card ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(22),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.07)),
                ),
                child: Column(children: [
                  // Avatar row
                  Row(children: [
                    Stack(children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                              colors: [_purple1, _purple2]),
                          boxShadow: [
                            BoxShadow(
                              color: _purple1.withOpacity(0.4),
                              blurRadius: 18,
                            )
                          ],
                        ),
                        child: const Icon(Icons.person_rounded,
                            size: 36, color: Colors.white),
                      ),
                      // Edit pencil
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () =>
                              _showEditProfileSheet(context),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _bg,
                              border:
                                  Border.all(color: Colors.white24),
                            ),
                            child: const Icon(Icons.edit_rounded,
                                size: 13, color: Colors.white),
                          ),
                        ),
                      ),
                      // Online dot
                      Positioned(
                        bottom: 2,
                        left: 2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _green,
                            border: Border.all(
                                color: _card, width: 2),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Text('Vikram Nair',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded,
                                size: 16, color: _orange1),
                          ]),
                          const SizedBox(height: 3),
                          Text('Director & Screenwriter',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white
                                      .withOpacity(0.6))),
                          const SizedBox(height: 8),
                          Row(children: [
                            _miniChip(Icons.location_on_rounded,
                                'Mumbai',
                                color: Colors.white24),
                            const SizedBox(width: 8),
                            _miniChip(Icons.workspace_premium_rounded,
                                'Pro',
                                color:
                                    _orange1.withOpacity(0.25),
                                textColor: _orange1,
                                iconColor: _orange1),
                          ]),
                        ],
                      ),
                    ),
                  ]),

                  const SizedBox(height: 16),
                  _divider(),
                  const SizedBox(height: 16),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statCol('4', 'Projects'),
                      _vertLine(),
                      _statCol('4.9★', 'Rating'),
                      _vertLine(),
                      _statCol('1.2K', 'Followers'),
                      _vertLine(),
                      _statCol('10+', 'Years'),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showEditProfileSheet(context),
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(
                                colors: [_orange1, _orange2]),
                          ),
                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_rounded,
                                  size: 16, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Edit Profile',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _shareProfile(context),
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.share_rounded,
                                size: 16,
                                color: Colors.white
                                    .withOpacity(0.8)),
                            const SizedBox(width: 8),
                            Text('Share',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.white
                                        .withOpacity(0.8))),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ]),
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab bar ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: TabBar(
                  controller: _tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.w500),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                        colors: [_orange1, _orange2]),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.all(4),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Projects'),
                    Tab(text: 'Awards'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4),

            // ── Tab views ───────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _overviewTab(),
                  _projectsTab(),
                  _awardsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Small helpers ────────────────────────────────────────────────────

  Widget _topIconBtn(IconData icon, {required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
            border: Border.all(color: Colors.white12),
          ),
          child: Icon(icon, size: 19, color: Colors.white),
        ),
      );

  Widget _miniChip(IconData icon, String label,
      {required Color color,
      Color textColor = Colors.white70,
      Color iconColor = Colors.white54}) =>
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
        ]),
      );

  Widget _statCol(String value, String label) => Column(children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        const SizedBox(height: 3),
        Text(label,
            style: TextStyle(
                fontSize: 11, color: Colors.white.withOpacity(0.5))),
      ]);

  Widget _vertLine() => Container(
        width: 1,
        height: 36,
        color: Colors.white12,
      );

  // ── Bottom sheets / actions ──────────────────────────────────────────

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff111114),
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (_) => const _EditProfileSheet(),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff111114),
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _SettingsSheet(),
    );
  }

  void _shareProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xff111111),
      margin: const EdgeInsets.all(16),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Row(children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [Color(0xffFF8C00), Color(0xffFF3D00)]),
          ),
          child: const Icon(Icons.share_rounded,
              size: 13, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Text('Profile link copied! 🎬',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ]),
      duration: const Duration(seconds: 3),
    ));
  }
}

// ─── Edit Profile Sheet ──────────────────────────────────────────────────────

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _nameCtrl = TextEditingController(text: 'Vikram Nair');
  final _roleCtrl =
      TextEditingController(text: 'Director & Screenwriter');
  final _bioCtrl = TextEditingController(
      text:
          'Award-winning director with 10+ years in independent Indian cinema.');
  final _locationCtrl = TextEditingController(text: 'Mumbai');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _roleCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const Text('Edit Profile',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white54),
              ),
            ]),
            const SizedBox(height: 20),
            _field('Name', _nameCtrl),
            const SizedBox(height: 14),
            _field('Role / Title', _roleCtrl),
            const SizedBox(height: 14),
            _field('Location', _locationCtrl),
            const SizedBox(height: 14),
            _field('Bio', _bioCtrl, maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xff111111),
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      content: const Text(
                          'Profile updated successfully! ✅',
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                        colors: [Color(0xffFF8C00), Color(0xffFF3D00)]),
                  ),
                  child: const Center(
                    child: Text('Save Changes',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.5))),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffFF8C00)),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
      ]);
}

// ─── Settings Sheet ──────────────────────────────────────────────────────────

class _SettingsSheet extends StatefulWidget {
  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  bool _notifications = true;
  bool _publicProfile = true;
  bool _availableForWork = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('Settings',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close_rounded,
                  color: Colors.white54),
            ),
          ]),
          const SizedBox(height: 20),
          _toggle('Push Notifications', _notifications,
              (v) => setState(() => _notifications = v)),
          _divider(),
          _toggle('Public Profile', _publicProfile,
              (v) => setState(() => _publicProfile = v)),
          _divider(),
          _toggle('Available for Work', _availableForWork,
              (v) => setState(() => _availableForWork = v)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Logged out'),
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.red.withOpacity(0.1),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: const Center(
                child: Text('Log Out',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(color: Colors.white10, height: 1);

  Widget _toggle(String label, bool val, ValueChanged<bool> onChange) =>
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title:
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        value: val,
        activeColor: const Color(0xffFF8C00),
        onChanged: onChange,
      );
}