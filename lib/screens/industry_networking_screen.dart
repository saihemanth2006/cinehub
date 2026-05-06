import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

/// Industry Networking Screen - Connect with filmmakers and professionals
class IndustryNetworkingScreen extends StatefulWidget {
  const IndustryNetworkingScreen({super.key});

  @override
  State<IndustryNetworkingScreen> createState() =>
      _IndustryNetworkingScreenState();
}

class _IndustryNetworkingScreenState extends State<IndustryNetworkingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final searchController = TextEditingController();
  bool showSearchResults = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Industry Network'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  showSearchResults = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search filmmakers, directors...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          searchController.clear();
                          setState(() => showSearchResults = false);
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(
                  icon: Icon(Icons.people_outline),
                  text: 'Connections',
                ),
                Tab(
                  icon: Icon(Icons.notifications_outlined),
                  text: 'Invitations',
                ),
                Tab(
                  icon: Icon(Icons.chat_outlined),
                  text: 'Messages',
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Connections tab
                _buildConnectionsTab(),
                // Invitations tab
                _buildInvitationsTab(),
                // Messages tab
                _buildMessagesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Suggested connections header
        Text(
          'Suggested Connections',
          style: AppTypography.headline4,
        ),
        const SizedBox(height: AppSpacing.lg),
        // Suggested connections grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            childAspectRatio: 0.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => ConnectionCard(
            name: [
              'Sarah Mitchell',
              'James Rodriguez',
              'Emma Thompson',
              'Marcus Chen',
              'Lisa Anderson',
              'David Kumar',
            ][index],
            role: [
              'Producer',
              'Director of Photography',
              'Sound Designer',
              'Film Editor',
              'Visual Effects Artist',
              'Production Designer',
            ][index],
            imageUrl: 'https://via.placeholder.com/200?text=User${index + 1}',
            connection: '2nd Degree',
            isFollowing: false,
            onFollowTap: () => _showFollowSnackbar(),
            onMessageTap: () => _showMessageSnackbar(),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        // Your connections header
        Text(
          'Your Connections',
          style: AppTypography.headline4,
        ),
        const SizedBox(height: AppSpacing.lg),
        // Your connections list
        ...[
          {
            'name': 'Alex Rivera',
            'role': 'Director',
            'connection': '1st Degree',
          },
          {
            'name': 'Sophie Laurent',
            'role': 'Cinematographer',
            'connection': '1st Degree',
          },
          {
            'name': 'Tom Wilson',
            'role': 'Producer',
            'connection': '1st Degree',
          },
        ]
            .map((conn) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ProfessionalAvatar(
                        name: conn['name']!,
                        size: 56,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conn['name']!,
                              style: AppTypography.bodyLarge,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              conn['role']!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => _showMessageSnackbar(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: const Text('Message'),
                      ),
                    ],
                  ),
                ))
            ,
      ],
    );
  }

  Widget _buildInvitationsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Pending invitations
        Text(
          'Collaboration Invites',
          style: AppTypography.headline4,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...[
          {
            'title': 'Indie Film Project',
            'description': 'Looking for cinematographer for indie film project',
            'from': 'Marcus Chen',
            'role': 'Director',
          },
          {
            'title': 'Commercial Production',
            'description': 'Seeking talented editors for commercial work',
            'from': 'Lisa Anderson',
            'role': 'Producer',
          },
          {
            'title': 'Documentary Series',
            'description': 'Need experienced directors for new documentary series',
            'from': 'David Kumar',
            'role': 'Executive Producer',
          },
        ]
            .map((invite) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppShadows.elevation2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invite['title']!,
                        style: AppTypography.headline4,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        invite['description']!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                        ),
                        child: Row(
                          children: [
                            ProfessionalAvatar(
                              name: invite['from']!,
                              size: 48,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'From ${invite['from']!}',
                                    style: AppTypography.bodyMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    invite['role']!,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Collaboration invite accepted!'),
                                  ),
                                );
                              },
                              child: const Text('Accept'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Decline'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
            ,
      ],
    );
  }

  Widget _buildMessagesTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ...[
          {
            'name': 'Sophie Laurent',
            'title': 'RE: Cinematography Discussion',
            'preview': 'Hi! I wanted to follow up on our discussion...',
            'time': '2 hours ago',
            'unread': true,
          },
          {
            'name': 'Alex Rivera',
            'title': 'Film Project Ideas',
            'preview': 'Have you thought about the new indie project?',
            'time': '5 hours ago',
            'unread': false,
          },
          {
            'name': 'Tom Wilson',
            'title': 'Production Schedule',
            'preview': 'Let me know about your availability for next month',
            'time': 'Yesterday',
            'unread': false,
          },
        ]
            .map((msg) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: msg['unread'] == true
                        ? AppColors.primaryLight
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppShadows.elevation2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ProfessionalAvatar(
                            name: msg['name']! as String,
                            size: 48,
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['name']! as String,
                                  style: AppTypography.bodyLarge.copyWith(
                                    fontWeight: msg['unread'] == true
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  msg['time']! as String,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (msg['unread'] == true)
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        msg['title']! as String,
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        msg['preview']! as String,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ))
            ,
      ],
    );
  }

  void _showFollowSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Following this professional!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMessageSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening conversation...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
