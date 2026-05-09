import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// ─────────────────────────────────────────────
//  DATA MODEL
// ─────────────────────────────────────────────
class FeatureItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final String tag;
  final String emoji;

  const FeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.tag,
    required this.emoji,
  });
}

// ─────────────────────────────────────────────
//  HOME PAGE
// ─────────────────────────────────────────────
class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> with TickerProviderStateMixin {
  late final AnimationController _heroCtrl;
  late final AnimationController _filmStripCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _staggerCtrl;
  late final AnimationController _reelCtrl;

  static const _features = [
    FeatureItem(
      title: 'AI Script\nGenerator',
      subtitle: 'Write compelling screenplays with AI',
      icon: Icons.auto_awesome_rounded,
      gradient: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
      tag: 'AI Powered',
      emoji: '✍️',
    ),
    FeatureItem(
      title: 'Text to\nVideo',
      subtitle: 'Turn your words into cinematic shots',
      icon: Icons.movie_creation_rounded,
      gradient: [Color(0xFFEC4899), Color(0xFFF43F5E)],
      tag: 'New ✨',
      emoji: '🎥',
    ),
    FeatureItem(
      title: 'Project\nManagement',
      subtitle: 'Schedule, budget & task manager',
      icon: Icons.dashboard_customize_rounded,
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
      tag: 'Production',
      emoji: '🎬',
    ),
    FeatureItem(
      title: 'Equipment\nRental',
      subtitle: 'Cameras, lenses, lighting & more',
      icon: Icons.videocam_rounded,
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      tag: 'Marketplace',
      emoji: '📷',
    ),
    FeatureItem(
      title: 'Learning\nCenter',
      subtitle: 'Cinematography, editing & sound',
      icon: Icons.school_rounded,
      gradient: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
      tag: 'Courses',
      emoji: '🎓',
    ),
    FeatureItem(
      title: 'Film\nDistribution',
      subtitle: 'Festivals, OTT & YouTube reach',
      icon: Icons.public_rounded,
      gradient: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
      tag: 'Distribute',
      emoji: '🌐',
    ),
    FeatureItem(
      title: 'Budget\nEstimator',
      subtitle: 'Production cost calculator',
      icon: Icons.calculate_rounded,
      gradient: [Color(0xFF06B6D4), Color(0xFF0891B2)],
      tag: 'Finance',
      emoji: '💰',
    ),
  ];

  final List<(String, String)> _filmLabels = [
    ('🎬', 'Action'),
    ('✍️', 'Script'),
    ('🎥', 'Shoot'),
    ('✂️', 'Edit'),
    ('🎵', 'Sound'),
    ('🌐', 'Distribute'),
    ('📣', 'Promote'),
    ('🏆', 'Festival'),
  ];

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();
    _filmStripCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))
      ..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: true);
    _staggerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..forward();
    _reelCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _filmStripCtrl.dispose();
    _pulseCtrl.dispose();
    _staggerCtrl.dispose();
    _reelCtrl.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────
  Animation<double> _interval(AnimationController ctrl, double start, double end,
      {Curve curve = Curves.easeOut}) =>
      CurvedAnimation(parent: ctrl, curve: Interval(start, end, curve: curve));

  // ── build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      body: Stack(
        children: [
          _AmbientOrbs(pulse: _pulseCtrl),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildFilmStrip()),
                SliverToBoxAdapter(child: _buildHeroBanner()),
                SliverToBoxAdapter(child: _buildSectionLabel('All Features', '6 tools')),
                _buildFeatureGrid(),
                SliverToBoxAdapter(child: _buildStatsRow()),
                SliverToBoxAdapter(child: _buildQuickActions()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ────────────────────────────────────
  Widget _buildHeader() {
    final slide = _interval(_heroCtrl, 0.0, 0.55);
    final fade = _interval(_heroCtrl, 0.0, 0.45);
    return AnimatedBuilder(
      animation: _heroCtrl,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, -28 * (1 - slide.value)),
        child: Opacity(
          opacity: fade.value.clamp(0.0, 1.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    _GradientIcon(icon: Icons.movie_filter_rounded, size: 20,
                        colors: const [Color(0xFF8B5CF6), Color(0xFFEC4899)]),
                    const SizedBox(width: 10),
                    ShaderMask(
                      shaderCallback: (r) => const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                      ).createShader(r),
                      child: const Text('CineStudio',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8)),
                    ),
                    const Spacer(),
                    _IconChip(icon: Icons.notifications_none_rounded),
                    const SizedBox(width: 10),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF1E1E2E),
                      child: Icon(Icons.person_rounded, color: Colors.white60, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                // Greeting
                const Text('Lights. Camera.', style: TextStyle(color: Colors.white38, fontSize: 15)),
                const SizedBox(height: 2),
                ShaderMask(
                  shaderCallback: (r) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFCBB6FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(r),
                  child: const Text('Action! 🎬',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          letterSpacing: -0.5)),
                ),
                const SizedBox(height: 6),
                const Text('Your complete filmmaking platform',
                    style: TextStyle(color: Colors.white30, fontSize: 13.5)),
                const SizedBox(height: 18),
                // Search bar
                _SearchBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── FILM STRIP ────────────────────────────────
  Widget _buildFilmStrip() {
    return AnimatedBuilder(
      animation: _filmStripCtrl,
      builder: (_, __) {
        return Container(
          margin: const EdgeInsets.only(top: 22),
          height: 44,
          color: const Color(0xFF111118),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Sprocket holes top & bottom
              Positioned(
                  top: 0, left: 0, right: 0, child: _SprocketRow(anim: _filmStripCtrl)),
              Positioned(
                  bottom: 0, left: 0, right: 0, child: _SprocketRow(anim: _filmStripCtrl)),
              // Moving labels — UnconstrainedBox lets the Row be wider than screen
              // without causing a layout overflow assertion
              Positioned.fill(
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  maxWidth: double.infinity,
                  child: Transform.translate(
                    offset: Offset(-(_filmStripCtrl.value * 704) % 704, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ..._filmLabels.map((l) => _FilmCell(emoji: l.$1, label: l.$2)),
                        ..._filmLabels.map((l) => _FilmCell(emoji: l.$1, label: l.$2)),
                        ..._filmLabels.map((l) => _FilmCell(emoji: l.$1, label: l.$2)),
                      ],
                    ),
                  ),
                ),
              ),
              // Edge fades
              _EdgeFade(fromLeft: true),
              _EdgeFade(fromLeft: false),
            ],
          ),
        );
      },
    );
  }

  // ── HERO BANNER ───────────────────────────────
  Widget _buildHeroBanner() {
    final anim = _interval(_heroCtrl, 0.3, 0.9);
    return AnimatedBuilder(
      animation: _heroCtrl,
      builder: (_, __) => Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - anim.value)),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B1040), Color(0xFF2D1B69), Color(0xFF1E1040)],
              ),
              border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.35), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Glow blob
                  AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (_, __) => Positioned(
                      right: -40, top: -40,
                      child: Container(
                        width: 180, height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFF8B5CF6).withOpacity(0.25 + 0.12 * _pulseCtrl.value),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),
                  ),
                  // Rotating reel
                  Positioned(
                    right: 18, bottom: 14,
                    child: AnimatedBuilder(
                      animation: _reelCtrl,
                      builder: (_, __) => Transform.rotate(
                        angle: _reelCtrl.value * 2 * math.pi,
                        child: Icon(Icons.radio_button_unchecked_rounded,
                            size: 90,
                            color: const Color(0xFF8B5CF6).withOpacity(0.18)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 50, bottom: 46,
                    child: AnimatedBuilder(
                      animation: _reelCtrl,
                      builder: (_, __) => Transform.rotate(
                        angle: -_reelCtrl.value * 2 * math.pi,
                        child: const Icon(Icons.movie_rounded,
                            size: 28, color: Color(0xFF8B5CF6)),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 100, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TagChip(label: '✨  AI Script Generator', color: const Color(0xFF8B5CF6)),
                        const SizedBox(height: 8),
                        const Text('Write your next\nblockbuster screenplay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                height: 1.22)),
                        const SizedBox(height: 10),
                        _GlowButton(
                          label: 'Generate Script',
                          colors: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── SECTION LABEL ─────────────────────────────
  Widget _buildSectionLabel(String title, String badge) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 4),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(badge,
                style: const TextStyle(
                    color: Color(0xFF8B5CF6), fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── FEATURE GRID ──────────────────────────────
  Widget _buildFeatureGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.63,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final start = (i * 0.09).clamp(0.0, 0.6);
            final end = (start + 0.4).clamp(0.0, 1.0);
            final anim = _interval(_staggerCtrl, start, end);
            return AnimatedBuilder(
              animation: _staggerCtrl,
              builder: (_, __) => Transform.translate(
                offset: Offset(0, 32 * (1 - anim.value)),
                child: Opacity(
                  opacity: anim.value.clamp(0.0, 1.0),
                  child: _FeatureCard(feature: _features[i]),
                ),
              ),
            );
          },
          childCount: _features.length,
        ),
      ),
    );
  }

  // ── STATS ROW ─────────────────────────────────
  Widget _buildStatsRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: const [
          _StatItem(value: '12K+', label: 'Filmmakers', color: Color(0xFF8B5CF6)),
          _StatDivider(),
          _StatItem(value: '3.5K', label: 'Projects', color: Color(0xFFEC4899)),
          _StatDivider(),
          _StatItem(value: '800+', label: 'Equipment', color: Color(0xFF10B981)),
          _StatDivider(),
          _StatItem(value: '200+', label: 'Festivals', color: Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  // ── QUICK ACTIONS ─────────────────────────────
  Widget _buildQuickActions() {
    const actions = [
      ('Upload Film', Icons.upload_file_rounded, Color(0xFFEC4899)),
      ('New Project', Icons.add_circle_outline_rounded, Color(0xFF8B5CF6)),
      ('Find Crew', Icons.group_rounded, Color(0xFF10B981)),
      ('Rent Gear', Icons.camera_alt_rounded, Color(0xFFF59E0B)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Quick Actions', ''),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: actions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final a = actions[i];
              return _QuickActionCard(label: a.$1, icon: a.$2, color: a.$3);
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  FEATURE CARD
// ─────────────────────────────────────────────
class _FeatureCard extends StatefulWidget {
  final FeatureItem feature;
  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tap;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _tap = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
  }

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  void _down(_) { setState(() => _pressed = true); _tap.forward(); }
  void _up() { setState(() => _pressed = false); _tap.reverse(); }

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    return GestureDetector(
      onTapDown: _down,
      onTapUp: (_) => _up(),
      onTapCancel: _up,
      onTap: () {
        _up();
        final title = f.title.toLowerCase();
        // Open AI Script Generator
        if (title.contains('ai script')) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AIScriptGeneratorPage(),
          ));
          return;
        }
        // Open Text to Video
        if (title.contains('text to')) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const TextToVideoPage(),
          ));
          return;
        }
        // Open Project Management
        if (title.contains('project')) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const ProjectManagementPage(),
          ));
          return;
        }
        // Open Equipment Rental
        if (title.contains('equipment')) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const EquipmentRentalPage(),
          ));
          return;
        }
        // Open Learning Center
        if (title.contains('learning')) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const LearningCenterPage(),
          ));
          return;
        }
        // Open Film Distribution
        if (title.contains('film') || title.contains('distribution')) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const FilmDistributionPage(),
          ));
          return;
        }
        // Open Budget Estimator
        if (title.contains('budget')) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const BudgetEstimatorPage(),
          ));
          return;
        }
      },
      child: AnimatedBuilder(
        animation: _tap,
        builder: (_, child) => Transform.scale(
          scale: 1.0 - 0.035 * _tap.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: const Color(0xFF111118),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _pressed
                  ? f.gradient.first.withOpacity(0.6)
                  : Colors.white.withOpacity(0.07),
              width: _pressed ? 1.5 : 1,
            ),
            boxShadow: _pressed
                ? [BoxShadow(color: f.gradient.first.withOpacity(0.25), blurRadius: 22, spreadRadius: 1)]
                : [],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with gradient bg
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: f.gradient),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: f.gradient.first.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Icon(f.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 8),
                // Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: f.gradient.first.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(f.tag,
                      style: TextStyle(
                          color: f.gradient.first,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3)),
                ),
                const SizedBox(height: 6),
                Text(f.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.25)),
                const SizedBox(height: 3),
                Text(f.subtitle,
                    style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 10.5,
                        height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Open  →',
                        style: TextStyle(
                            color: f.gradient.first.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: f.gradient),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.arrow_outward_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SMALL WIDGETS
// ─────────────────────────────────────────────

class _AmbientOrbs extends StatelessWidget {
  final AnimationController pulse;
  const _AmbientOrbs({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) => Stack(children: [
        Positioned(
          top: -120, right: -80,
          child: _Orb(
              size: 320,
              color: const Color(0xFF8B5CF6).withOpacity(0.12 + 0.06 * pulse.value)),
        ),
        Positioned(
          bottom: 280, left: -80,
          child: _Orb(
              size: 260,
              color: const Color(0xFFEC4899).withOpacity(0.08 + 0.05 * pulse.value)),
        ),
        Positioned(
          bottom: -60, right: 60,
          child: _Orb(
              size: 200,
              color: const Color(0xFF10B981).withOpacity(0.07 + 0.04 * pulse.value)),
        ),
      ]),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      );
}

class _GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final List<Color> colors;
  const _GradientIcon({required this.icon, required this.size, required this.colors});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      );
}

class _IconChip extends StatelessWidget {
  final IconData icon;
  const _IconChip({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Icon(icon, color: Colors.white54, size: 18),
      );
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF111118),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.white30, size: 18),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('Search projects, scripts, gear...',
                  style: TextStyle(color: Color(0x47FFFFFF), fontSize: 13.5)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Text('⌘ K',
                  style: TextStyle(
                      color: Color(0xFF8B5CF6), fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

class _SprocketRow extends StatelessWidget {
  final AnimationController anim;
  const _SprocketRow({required this.anim});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: anim,
        builder: (_, __) => SizedBox(
          height: 5,
          width: double.infinity,
          child: CustomPaint(
            painter: _SprocketPainter(anim.value),
          ),
        ),
      );
}

class _SprocketPainter extends CustomPainter {
  final double progress;
  const _SprocketPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF2A2A3A);
    const holeW = 10.0;
    const holeH = 5.0;
    const step = 18.0;
    // shift holes left as progress increases, wrapping with modulo
    final shift = (progress * step * 4) % step;
    for (double x = -step + shift; x < size.width + step; x += step) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, 0, holeW, holeH), const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SprocketPainter old) => old.progress != progress;
}

class _FilmCell extends StatelessWidget {
  final String emoji;
  final String label;
  const _FilmCell({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        width: 88, height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Colors.white.withOpacity(0.06)),
            right: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(label,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 10.5, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _EdgeFade extends StatelessWidget {
  final bool fromLeft;
  const _EdgeFade({required this.fromLeft});

  @override
  Widget build(BuildContext context) => Positioned(
        left: fromLeft ? 0 : null,
        right: fromLeft ? null : 0,
        top: 0, bottom: 0,
        child: Container(
          width: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                fromLeft ? const Color(0xFF09090B) : Colors.transparent,
                fromLeft ? Colors.transparent : const Color(0xFF09090B),
              ],
            ),
          ),
        ),
      );
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;
  const _TagChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4), width: 0.8),
        ),
        child: Text(label,
            style: TextStyle(
                color: color.withOpacity(0.9),
                fontSize: 11.5,
                fontWeight: FontWeight.w700)),
      );
}

class _GlowButton extends StatelessWidget {
  final String label;
  final List<Color> colors;
  final VoidCallback onTap;
  const _GlowButton({required this.label, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: colors.first.withOpacity(0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14),
            ],
          ),
        ),
      );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (r) =>
                  LinearGradient(colors: [color, color.withOpacity(0.7)]).createShader(r),
              child: Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.white30, fontSize: 10.5),
                textAlign: TextAlign.center),
          ],
        ),
      );
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1, height: 28,
        color: Colors.white.withOpacity(0.08),
      );
}

class _QuickActionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _QuickActionCard({required this.label, required this.icon, required this.color});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tap;

  @override
  void initState() {
    super.initState();
    _tap = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
  }

  @override
  void dispose() { _tap.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _tap.forward(),
        onTapUp: (_) => _tap.reverse(),
        onTapCancel: () => _tap.reverse(),
        child: AnimatedBuilder(
          animation: _tap,
          builder: (_, child) =>
              Transform.scale(scale: 1.0 - 0.04 * _tap.value, child: child),
          child: Container(
            width: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF111118),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: widget.color.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 18),
                ),
                const SizedBox(height: 8),
                Text(widget.label,
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
//  AI Script Generator Screen
// ─────────────────────────────────────────────
class AIScriptGeneratorPage extends StatefulWidget {
  const AIScriptGeneratorPage({super.key});

  @override
  State<AIScriptGeneratorPage> createState() => _AIScriptGeneratorPageState();
}

class _AIScriptGeneratorPageState extends State<AIScriptGeneratorPage> {
  final TextEditingController _promptCtrl = TextEditingController();
  final TextEditingController _charactersCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();
  String _genre = 'Action';
  String _durationVal = '5 min';
  String _style = 'Cinematic';
  final String _tone = 'Dramatic';
  bool _isGenerating = false;
  final List<String> _results = [];

  @override
  void dispose() {
    _promptCtrl.dispose();
    _charactersCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final prompt = _promptCtrl.text.trim();
    if (prompt.isEmpty) return;
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 900));

    // Fake generation for demo: craft a simple screenplay snippet including new fields
    final header = '${_genre.toUpperCase()} • $_durationVal • $_style • $_tone';
    final body = StringBuffer();
    body.writeln(header);
    body.writeln('');
    body.writeln('SCENE: A generated scene based on the prompt.');
    body.writeln(prompt);
    if (_charactersCtrl.text.trim().isNotEmpty) {
      body.writeln('');
      body.writeln('CHARACTERS: ${_charactersCtrl.text.trim()}');
    }
    if (_notesCtrl.text.trim().isNotEmpty) {
      body.writeln('');
      body.writeln('NOTES: ${_notesCtrl.text.trim()}');
    }

    setState(() {
      _results.insert(0, body.toString());
      _isGenerating = false;
    });
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF8B5CF6) : const Color(0xFF111118),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(label,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.white60,
                  fontWeight: FontWeight.w700)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('AI Script Generator', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline_rounded))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TagChip(label: 'AI Script Generator', color: const Color(0xFF8B5CF6)),
              const SizedBox(height: 12),
              const Text('Fill in the fields below to generate a script.', style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 12),

              // Form area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Genre
                      const Text('Genre', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _genre,
                          dropdownColor: const Color(0xFF111118),
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(value: 'Action', child: Text('Action')),
                            DropdownMenuItem(value: 'Drama', child: Text('Drama')),
                            DropdownMenuItem(value: 'Comedy', child: Text('Comedy')),
                            DropdownMenuItem(value: 'Horror', child: Text('Horror')),
                          ],
                          onChanged: (v) => setState(() => _genre = v ?? 'Action'),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Duration
                      const Text('Duration', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _durationVal,
                          dropdownColor: const Color(0xFF111118),
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(value: '1 min', child: Text('1 min')),
                            DropdownMenuItem(value: '3 min', child: Text('3 min')),
                            DropdownMenuItem(value: '5 min', child: Text('5 min')),
                            DropdownMenuItem(value: '10 min', child: Text('10 min')),
                          ],
                          onChanged: (v) => setState(() => _durationVal = v ?? '5 min'),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Style
                      const Text('Style', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _style,
                          dropdownColor: const Color(0xFF111118),
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(value: 'Cinematic', child: Text('Cinematic')),
                            DropdownMenuItem(value: 'Documentary', child: Text('Documentary')),
                            DropdownMenuItem(value: 'Experimental', child: Text('Experimental')),
                          ],
                          onChanged: (v) => setState(() => _style = v ?? 'Cinematic'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Theme / Message (prompt)
                      const Text('Theme / Message *', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _promptCtrl,
                          maxLines: 5,
                          style: const TextStyle(color: Colors.white70),
                          decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g., A detective solving a mysterious crime', hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Characters
                      const Text('Characters (comma-separated)', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _charactersCtrl,
                          maxLines: 2,
                          style: const TextStyle(color: Colors.white70),
                          decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g., Detective John, Suspect Sarah, Witness Tom', hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Additional Notes
                      const Text('Additional Notes', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: _notesCtrl,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white70),
                          decoration: const InputDecoration(border: InputBorder.none, hintText: 'Any additional requirements or story elements', hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Generate button
              Row(children: [
                Expanded(
                  child: _GlowButton(
                    label: _isGenerating ? 'Generating...' : '✨  Generate Script',
                    colors: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    onTap: _isGenerating ? () {} : _generate,
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Text → Video Generator Screen
// ─────────────────────────────────────────────
class TextToVideoPage extends StatefulWidget {
  const TextToVideoPage({super.key});

  @override
  State<TextToVideoPage> createState() => _TextToVideoPageState();
}

class _TextToVideoPageState extends State<TextToVideoPage> {
  final TextEditingController _prompt = TextEditingController();
  String _quality = 'High';
  int _qualityNumber = 75;
  String _resolution = '1080p';
  final double _duration = 12.0;
  bool _isGenerating = false;
  final List<Map<String, String>> _videos = [];

  @override
  void dispose() {
    _prompt.dispose();
    super.dispose();
  }

  Future<void> _generateVideo() async {
    final text = _prompt.text.trim();
    if (text.isEmpty) return;
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final title = '$_quality ($_qualityNumber) • $_resolution • ${_duration.toInt()}s';
    final url = 'https://cinehub.local/generated/$id.mp4';

    setState(() {
      _videos.insert(0, {'id': id, 'title': title, 'url': url, 'prompt': text});
      _isGenerating = false;
    });
    // user feedback
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Generated video: $title')));
  }

  // removed preset chips — replaced by quality selector in UI

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Text → Video', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16.0 + bottomInset),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _TagChip(label: 'Text to Video', color: const Color(0xFFF43F5E)),
            const SizedBox(height: 12),
            const Text('Describe the scene or shot you want to create.', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.04))),
              padding: const EdgeInsets.all(12),
              child: Column(children: [
                TextField(
                  controller: _prompt,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white70),
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g. A misty coastal sunrise, a lone boat...', hintStyle: TextStyle(color: Colors.white24)),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Text('Quality', style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _quality,
                        dropdownColor: const Color(0xFF111118),
                        items: const [
                          DropdownMenuItem(value: 'Low', child: Text('Low')),
                          DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'High', child: Text('High')),
                        ],
                        onChanged: (v) => setState(() => _quality = v ?? 'High'),
                      ),
                      const SizedBox(width: 18),
                      const Text('Resolution', style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _resolution,
                        dropdownColor: const Color(0xFF111118),
                        items: const [
                          DropdownMenuItem(value: '720p', child: Text('720p')),
                          DropdownMenuItem(value: '1080p', child: Text('1080p')),
                          DropdownMenuItem(value: '4K', child: Text('4K')),
                        ],
                        onChanged: (v) => setState(() => _resolution = v ?? '1080p'),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Text('Quality Number', style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(trackHeight: 6, thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
                          child: Slider(
                            value: _qualityNumber.toDouble(),
                            min: 1,
                            max: 100,
                            divisions: 99,
                            label: '$_qualityNumber',
                            activeColor: const Color(0xFFF97316),
                            onChanged: (v) => setState(() => _qualityNumber = v.toInt()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFF111118), borderRadius: BorderRadius.circular(8)),
                        child: Text('$_qualityNumber', style: const TextStyle(color: Colors.white70)),
                      )
                    ])
                  ],
                )
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _GlowButton(label: _isGenerating ? 'Generating...' : 'Generate Video', colors: const [Color(0xFFF43F5E), Color(0xFFF97316)], onTap: _isGenerating ? () {} : _generateVideo)),
              const SizedBox(width: 12),
              Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFF111118), borderRadius: BorderRadius.circular(12)), child: IconButton(icon: const Icon(Icons.refresh_rounded, color: Colors.white54), onPressed: () { setState(() { _prompt.clear(); _videos.clear(); }); })),
            ]),
            const SizedBox(height: 14),
            const Text('Generated', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Expanded(child: _videos.isEmpty ? Center(child: Text('No videos yet — generate one.', style: TextStyle(color: Colors.white24))) : ListView.separated(itemCount: _videos.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (_, i) {
              final v = _videos[i];
              return Container(
                decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.03))),
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    // Thumbnail placeholder
                    Container(width: 92, height: 56, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: const LinearGradient(colors: [Color(0xFFF43F5E), Color(0xFFF97316)])), child: const Center(child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(v['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text(v['prompt'] ?? '', style: const TextStyle(color: Colors.white70), maxLines: 2, overflow: TextOverflow.ellipsis)])),
                    PopupMenuButton<String>(onSelected: (s) async {
                      if (s == 'copy') { await Clipboard.setData(ClipboardData(text: v['url'] ?? '')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Link copied'))); }
                      if (s == 'share') {}
                      if (s == 'play') {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: const Color(0xFF0F0F14),
                            title: const Text('Preview'),
                            content: const SizedBox(
                              height: 100,
                              child: Center(child: Icon(Icons.play_circle_outline_rounded, size: 64, color: Colors.white)),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))
                            ],
                          ),
                        );
                      }
                    }, itemBuilder: (_) => [const PopupMenuItem(value: 'play', child: Text('Play Preview')), const PopupMenuItem(value: 'copy', child: Text('Copy Link')), const PopupMenuItem(value: 'share', child: Text('Share'))])
                  ]),
                ]),
              );
            })),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROJECT MANAGEMENT SCREEN
// ─────────────────────────────────────────────
class ProjectManagementPage extends StatefulWidget {
  const ProjectManagementPage({super.key});

  @override
  State<ProjectManagementPage> createState() => _ProjectManagementPageState();
}

class _ProjectManagementPageState extends State<ProjectManagementPage> {
  int _selectedTab = 0;
  final List<Map<String, dynamic>> _projects = [
    {
      'name': 'The Last Knight',
      'status': 'In Production',
      'progress': 0.65,
      'budget': '\$250K',
      'spent': '\$162.5K',
      'team': 8,
      'tasks': 42,
      'daysLeft': 18,
      'image': '🎬',
    },
    {
      'name': 'Neon Nights',
      'status': 'Pre-Production',
      'progress': 0.28,
      'budget': '\$180K',
      'spent': '\$50.4K',
      'team': 5,
      'tasks': 31,
      'daysLeft': 35,
      'image': '🌙',
    },
    {
      'name': 'Ocean Deep',
      'status': 'Post-Production',
      'progress': 0.92,
      'budget': '\$320K',
      'spent': '\$294.4K',
      'team': 12,
      'tasks': 15,
      'daysLeft': 5,
      'image': '🌊',
    },
  ];

  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Location Scouting', 'project': 'The Last Knight', 'status': 'In Progress', 'dueDate': 'May 15', 'assignee': 'Alex', 'priority': 'High'},
    {'title': 'Script Revisions', 'project': 'Neon Nights', 'status': 'Pending', 'dueDate': 'May 18', 'assignee': 'Jordan', 'priority': 'High'},
    {'title': 'Color Grading', 'project': 'Ocean Deep', 'status': 'In Progress', 'dueDate': 'May 20', 'assignee': 'Sam', 'priority': 'Medium'},
    {'title': 'Sound Design', 'project': 'The Last Knight', 'status': 'Completed', 'dueDate': 'May 10', 'assignee': 'Casey', 'priority': 'Medium'},
  ];

  final List<Map<String, dynamic>> _teamMembers = [
    {'name': 'Alex Morgan', 'role': 'Director', 'initials': 'AM', 'color': Color(0xFF8B5CF6)},
    {'name': 'Jordan Lee', 'role': 'Producer', 'initials': 'JL', 'color': Color(0xFFEC4899)},
    {'name': 'Sam Kim', 'role': 'DP', 'initials': 'SK', 'color': Color(0xFF10B981)},
    {'name': 'Casey Brown', 'role': 'Editor', 'initials': 'CB', 'color': Color(0xFFF59E0B)},
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'In Production':
      case 'In Progress':
        return const Color(0xFF3B82F6);
      case 'Pre-Production':
      case 'Pending':
        return const Color(0xFFF59E0B);
      case 'Post-Production':
      case 'Completed':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Project Management', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline_rounded))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(child: _buildTab('Projects', 0)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTab('Tasks', 1)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTab('Team', 2)),
                ],
              ),
            ),
            // Content
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _buildProjectsTab(),
                  _buildTasksTab(),
                  _buildTeamTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProjectsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Stats Overview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statBadge('3', 'Projects', Colors.white),
                _statBadge('25', 'Days Avg', Colors.white),
                _statBadge('\$750K', 'Budget', Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Project Cards
          ..._projects.map((p) => _buildProjectCard(p)),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [_statusColor(project['status']).withOpacity(0.6), _statusColor(project['status'])]),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(project['image'], style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project['name'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(project['status'], style: TextStyle(color: _statusColor(project['status']), fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${project['daysLeft']}d left', style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: project['progress'],
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor(project['status'])),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _projectMetric(project['team'].toString(), '👥 Team'),
              _projectMetric(project['tasks'].toString(), '✓ Tasks'),
              _projectMetric(project['spent'], '💰 Spent'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _projectMetric(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9)),
      ],
    );
  }

  Widget _statBadge(String value, String label, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildTasksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTaskFilter(),
          const SizedBox(height: 12),
          ..._tasks.map((t) => _buildTaskCard(t)),
        ],
      ),
    );
  }

  Widget _buildTaskFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list_rounded, color: Colors.white38, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'In Progress', 'Pending', 'Completed']
                    .map((f) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: f == 'All' ? const Color(0xFF8B5CF6) : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(f, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                task['status'] == 'Completed' ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: _statusColor(task['status']),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  task['title'],
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: task['priority'] == 'High' ? const Color(0xFFEF4444).withOpacity(0.15) : const Color(0xFFF59E0B).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task['priority'],
                  style: TextStyle(
                    color: task['priority'] == 'High' ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(task['project'], style: const TextStyle(color: Colors.white54, fontSize: 10)),
              const SizedBox(width: 12),
              Icon(Icons.calendar_today_rounded, size: 10, color: Colors.white38),
              const SizedBox(width: 4),
              Text(task['dueDate'], style: const TextStyle(color: Colors.white38, fontSize: 10)),
              const SizedBox(width: 12),
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                child: Text(task['assignee'][0], style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildTeamStats(),
          const SizedBox(height: 20),
          ..._teamMembers.map((m) => _buildTeamMemberCard(m)),
        ],
      ),
    );
  }

  Widget _buildTeamStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Team Overview', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _teamStatItem('${_teamMembers.length}', 'Members'),
              _teamStatItem('${_tasks.where((t) => t['status'] == 'In Progress').length}', 'Active Tasks'),
              _teamStatItem('${_projects.length}', 'Projects'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _teamStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  Widget _buildTeamMemberCard(Map<String, dynamic> member) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [member['color'], member['color'].withOpacity(0.6)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(member['initials'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member['name'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(member['role'], style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white30),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  EQUIPMENT RENTAL SCREEN
// ─────────────────────────────────────────────
class EquipmentRentalPage extends StatefulWidget {
  const EquipmentRentalPage({super.key});

  @override
  State<EquipmentRentalPage> createState() => _EquipmentRentalPageState();
}

class _EquipmentRentalPageState extends State<EquipmentRentalPage> {
  int _selectedCategory = 0;
  final List<String> _categories = ['Cameras', 'Lenses', 'Lighting', 'Audio', 'Rigs'];
  final List<Map<String, dynamic>> _equipment = [
    {'name': 'RED Komodo', 'category': 'Cameras', 'price': '\$800/day', 'specs': '6K • Full-Frame', 'rating': 4.9, 'available': true, 'icon': '📷'},
    {'name': 'Zeiss Master Prime 32mm', 'category': 'Lenses', 'price': '\$400/day', 'specs': 'T1.3 • Vintage', 'rating': 4.8, 'available': true, 'icon': '🔍'},
    {'name': 'Arri SkyPanel X60', 'category': 'Lighting', 'price': '\$300/day', 'specs': 'RGB • 60x60cm', 'rating': 4.7, 'available': false, 'icon': '💡'},
    {'name': 'Sennheiser MKE 600', 'category': 'Audio', 'price': '\$120/day', 'specs': 'Shotgun • Compact', 'rating': 4.6, 'available': true, 'icon': '🎤'},
    {'name': 'Technocrane', 'category': 'Rigs', 'price': '\$1200/day', 'specs': 'Motion Control • 3D', 'rating': 5.0, 'available': true, 'icon': '🚀'},
    {'name': 'Sony FX30', 'category': 'Cameras', 'price': '\$600/day', 'specs': '4K • Compact', 'rating': 4.5, 'available': true, 'icon': '📷'},
  ];

  List<Map<String, dynamic>> get _filteredEquipment => _equipment.where((e) => e['category'] == _categories[_selectedCategory]).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Equipment Rental', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF111118),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: Colors.white30, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(
                      decoration: InputDecoration(border: InputBorder.none, hintText: 'Search equipment...', hintStyle: TextStyle(color: Colors.white30)),
                      style: const TextStyle(color: Colors.white),
                    )),
                  ],
                ),
              ),
            ),
            // Category tabs
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => setState(() => _selectedCategory = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: _selectedCategory == i ? const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]) : null,
                      color: _selectedCategory == i ? null : const Color(0xFF111118),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _selectedCategory == i ? Colors.transparent : Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(_categories[i], style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Equipment list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _filteredEquipment.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _buildEquipmentCard(_filteredEquipment[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentCard(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(item['icon'], style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item['specs'], style: const TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star_rounded, color: const Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 4),
                    Text('${item['rating']}', style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item['price'], style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: item['available'] ? const Color(0xFF10B981).withOpacity(0.15) : const Color(0xFF6B7280).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(item['available'] ? 'Available' : 'Booked', style: TextStyle(color: item['available'] ? const Color(0xFF10B981) : Colors.white38, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  LEARNING CENTER SCREEN
// ─────────────────────────────────────────────
class LearningCenterPage extends StatefulWidget {
  const LearningCenterPage({super.key});

  @override
  State<LearningCenterPage> createState() => _LearningCenterPageState();
}

class _LearningCenterPageState extends State<LearningCenterPage> {
  final List<Map<String, dynamic>> _courses = [
    {'title': 'Cinematography Fundamentals', 'instructor': 'Roger Deakins', 'level': 'Beginner', 'duration': '8 weeks', 'progress': 0.65, 'icon': '🎥'},
    {'title': 'Advanced Color Grading', 'instructor': 'Yedlin', 'level': 'Advanced', 'duration': '6 weeks', 'progress': 1.0, 'icon': '🎨'},
    {'title': 'Sound Design for Film', 'instructor': 'David Sonnenschein', 'level': 'Intermediate', 'duration': '4 weeks', 'progress': 0.35, 'icon': '🎵'},
    {'title': 'Editing Rhythms', 'instructor': 'Thelma Schoonmaker', 'level': 'Intermediate', 'duration': '5 weeks', 'progress': 0.0, 'icon': '✂️'},
    {'title': 'Lighting for Drama', 'instructor': 'John Seale', 'level': 'Advanced', 'duration': '7 weeks', 'progress': 0.45, 'icon': '💡'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Learning Center', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured course
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Featured Course', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    const Text('Master Cinematography', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('with Roger Deakins', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('8 Weeks', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                            Text('Beginner', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Enroll Now', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Continue learning
              const Text('Continue Learning', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ..._courses.map((course) => _buildCourseCard(course)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final color = course['level'] == 'Beginner' ? const Color(0xFF10B981) : course['level'] == 'Intermediate' ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(course['icon'], style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course['title'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(course['instructor'], style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(course['level'], style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: course['progress'],
              minHeight: 4,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(course['progress'] * 100).toInt()}% Complete', style: const TextStyle(color: Colors.white70, fontSize: 10)),
              Text(course['duration'], style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FILM DISTRIBUTION SCREEN
// ─────────────────────────────────────────────
class FilmDistributionPage extends StatefulWidget {
  const FilmDistributionPage({super.key});

  @override
  State<FilmDistributionPage> createState() => _FilmDistributionPageState();
}

class _FilmDistributionPageState extends State<FilmDistributionPage> {
  int _selectedTab = 0;
  final List<Map<String, dynamic>> _submissions = [
    {'festival': 'Sundance', 'film': 'The Last Knight', 'status': 'Accepted', 'date': 'Jan 2026', 'icon': '🎬'},
    {'festival': 'Cannes', 'film': 'Ocean Deep', 'status': 'Under Review', 'date': 'May 2026', 'icon': '🌊'},
    {'festival': 'TIFF', 'film': 'Neon Nights', 'status': 'Submitted', 'date': 'Jun 2026', 'icon': '🌙'},
    {'festival': 'Berlin', 'film': 'The Last Knight', 'status': 'Rejected', 'date': 'Feb 2026', 'icon': '🎬'},
  ];

  final List<Map<String, dynamic>> _platforms = [
    {'name': 'Netflix', 'revenue': '\$45.2K', 'views': '128K', 'icon': '🎥'},
    {'name': 'Amazon Prime', 'revenue': '\$32.8K', 'views': '89K', 'icon': '🎬'},
    {'name': 'YouTube', 'revenue': '\$12.4K', 'views': '245K', 'icon': '📺'},
    {'name': 'Apple TV+', 'revenue': '\$28.6K', 'views': '76K', 'icon': '🍎'},
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Accepted':
        return const Color(0xFF10B981);
      case 'Under Review':
        return const Color(0xFFF59E0B);
      case 'Submitted':
        return const Color(0xFF3B82F6);
      case 'Rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Film Distribution', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline_rounded))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(child: _buildDistTab('Festivals', 0)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDistTab('Platforms', 1)),
                ],
              ),
            ),
            // Content
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _buildFestivalsTab(),
                  _buildPlatformsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFEC4899) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildFestivalsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF111118),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _distStat('4', 'Submissions'),
                _distStat('1', 'Accepted'),
                _distStat('2', 'Pending'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._submissions.map((s) => _buildSubmissionCard(s)),
        ],
      ),
    );
  }

  Widget _buildSubmissionCard(Map<String, dynamic> submission) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_statusColor(submission['status']).withOpacity(0.6), _statusColor(submission['status'])]),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(submission['icon'], style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(submission['festival'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(submission['film'], style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _statusColor(submission['status']).withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(submission['status'], style: TextStyle(color: _statusColor(submission['status']), fontSize: 9, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 4),
              Text(submission['date'], style: const TextStyle(color: Colors.white38, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Revenue overview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFF43F5E)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Revenue', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                const Text('\$119.0K', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                const Text('Total Views: 538K', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._platforms.map((p) => _buildPlatformCard(p)),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(Map<String, dynamic> platform) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFEC4899), Color(0xFFF43F5E)]),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(platform['icon'], style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(platform['name'], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(platform['views'], style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(platform['revenue'], style: const TextStyle(color: Color(0xFFEC4899), fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _distStat(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(color: Color(0xFFEC4899), fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  BUDGET ESTIMATOR SCREEN
// ─────────────────────────────────────────────
class BudgetEstimatorPage extends StatefulWidget {
  const BudgetEstimatorPage({super.key});

  @override
  State<BudgetEstimatorPage> createState() => _BudgetEstimatorPageState();
}

class _BudgetEstimatorPageState extends State<BudgetEstimatorPage> {
  // Form controllers for the new layout
  final TextEditingController _scriptCtrl = TextEditingController();
  final TextEditingController _actorsCtrl = TextEditingController();
  final TextEditingController _locationsCtrl = TextEditingController();
  final TextEditingController _additionalCtrl = TextEditingController();
  String _equipmentLevel = 'Professional';
  bool _isPredicting = false;
  double? _predictedBudget;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scriptCtrl.dispose();
    _actorsCtrl.dispose();
    _locationsCtrl.dispose();
    _additionalCtrl.dispose();
    super.dispose();
  }

  // Simple mock predictor to produce a believable budget number
  double _computeBudget({required int actors, required int locations, required String equipment, required String notes}) {
    double base = 30000; // base production cost
    base += actors * 2500; // per actor
    base += locations * 6000; // per location

    double equipMul = 1.0;
    if (equipment == 'Professional') equipMul = 1.3;
    if (equipment == 'Semi-Pro') equipMul = 1.0;
    if (equipment == 'Low-Budget') equipMul = 0.75;

    double notesFactor = 1.0;
    final ln = notes.toLowerCase();
    if (ln.contains('international')) notesFactor += 0.25;
    if (ln.contains('special') || ln.contains('effects') || ln.contains('vfx')) notesFactor += 0.25;

    final subtotal = base * equipMul * notesFactor;
    final contingency = subtotal * 0.15; // default 15%
    return subtotal + contingency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Film Cost Predictor', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 6),
            _TagChip(label: 'Production Details', color: const Color(0xFF8B5CF6)),
            const SizedBox(height: 12),

            // Script Description
            const Text('Script Description *', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _scriptCtrl,
                maxLines: 4,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g., Action thriller with 3 main scenes', hintStyle: TextStyle(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 12),

            // Number of Actors
            const Text('Number of Actors *', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _actorsCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g., 5', hintStyle: TextStyle(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 12),

            // Number of Locations
            const Text('Number of Locations *', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _locationsCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g., 3', hintStyle: TextStyle(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 12),

            // Equipment Level
            const Text('Equipment Level', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
              child: DropdownButton<String>(
                isExpanded: true,
                value: _equipmentLevel,
                dropdownColor: const Color(0xFF111118),
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: 'Professional', child: Text('Professional')),
                  DropdownMenuItem(value: 'Semi-Pro', child: Text('Semi-Pro')),
                  DropdownMenuItem(value: 'Low-Budget', child: Text('Low-Budget')),
                ],
                onChanged: (v) => setState(() => _equipmentLevel = v ?? 'Professional'),
              ),
            ),
            const SizedBox(height: 12),

            // Additional Details
            const Text('Additional Details', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: const Color(0xFF0F0F14), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.04))),
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _additionalCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.white70),
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g., International crew, special effects required', hintStyle: TextStyle(color: Colors.white24)),
              ),
            ),

            const SizedBox(height: 12),

            // Predict button
            Row(
              children: [
                Expanded(
                  child: _GlowButton(
                    label: _isPredicting ? 'Predicting...' : '📊  Predict Budget',
                    colors: const [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    onTap: _isPredicting
                        ? () {}
                        : () async {
                            final actors = int.tryParse(_actorsCtrl.text.trim()) ?? 0;
                            final locations = int.tryParse(_locationsCtrl.text.trim()) ?? 0;
                            setState(() => _isPredicting = true);
                            await Future.delayed(const Duration(milliseconds: 600));
                            final budget = _computeBudget(actors: actors, locations: locations, equipment: _equipmentLevel, notes: _additionalCtrl.text);
                            setState(() {
                              _predictedBudget = budget;
                              _isPredicting = false;
                            });
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: const Color(0xFF0F0F14),
                              isScrollControlled: true,
                              useSafeArea: true,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                              builder: (_) => SingleChildScrollView(
                                padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Estimated Budget', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                                    const SizedBox(height: 8),
                                    Text('\$${budget.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 12),
                                    const Text('Breakdown', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 8),
                                    Text('Actors: $actors', style: const TextStyle(color: Colors.white70)),
                                    Text('Locations: $locations', style: const TextStyle(color: Colors.white70)),
                                    Text('Equipment: $_equipmentLevel', style: const TextStyle(color: Colors.white70)),
                                    if (_additionalCtrl.text.trim().isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text('Notes: ${_additionalCtrl.text.trim()}', style: const TextStyle(color: Colors.white60)),
                                    ],
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.of(context).pop(),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              decoration: BoxDecoration(color: const Color(0xFF111118), borderRadius: BorderRadius.circular(12)),
                                              alignment: Alignment.center,
                                              child: const Text('Close', style: TextStyle(color: Colors.white70)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Budget saved: \$${budget.toStringAsFixed(0)}')));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)]), borderRadius: BorderRadius.circular(12)),
                                              alignment: Alignment.center,
                                              child: const Text('Save Estimate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  
}