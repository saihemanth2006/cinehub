import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/ui_components.dart';

/// Job & Casting Board Screen - Browse and apply for opportunities
class JobCastingBoardScreen extends StatefulWidget {
  const JobCastingBoardScreen({super.key});

  @override
  State<JobCastingBoardScreen> createState() => _JobCastingBoardScreenState();
}

class _JobCastingBoardScreenState extends State<JobCastingBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final searchController = TextEditingController();
  Set<int> bookmarkedJobs = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Board'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and filter
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search jobs...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHover,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.tune),
                ),
              ],
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
                  icon: Icon(Icons.work_outline),
                  text: 'All Jobs',
                ),
                Tab(
                  icon: Icon(Icons.bookmark_outline),
                  text: 'Bookmarks',
                ),
                Tab(
                  icon: Icon(Icons.history),
                  text: 'Applied',
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllJobsTab(),
                _buildBookmarksTab(),
                _buildAppliedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllJobsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Featured section
        Text(
          'Featured Opportunities',
          style: AppTypography.headline4,
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.primaryDark.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadii.lg),
            boxShadow: AppShadows.elevation4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppRadii.full),
                ),
                child: Text(
                  'FEATURED',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Lead Director - Major Feature Film',
                style: AppTypography.headline4.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Big Budget Production House',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Los Angeles, CA',
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showApplicationModal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                      ),
                      child: const Text(
                        'Apply Now',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => bookmarkedJobs.add(0));
                      },
                      child: Icon(
                        bookmarkedJobs.contains(0)
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        // All jobs
        Text(
          'All Job Listings',
          style: AppTypography.headline4,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...[
          {
            'title': 'Casting Call - Indie Drama',
            'company': 'Independent Production',
            'location': 'New York, NY',
            'roles': ['Actor', 'Extra', 'Background'],
            'applicants': 245,
          },
          {
            'title': 'Film Crew Wanted',
            'company': 'Production Studio XYZ',
            'location': 'Los Angeles, CA',
            'roles': ['Cinematographer', 'Gaffer', 'Key Grip'],
            'applicants': 128,
          },
          {
            'title': 'Internship - Documentary Production',
            'company': 'Creative Productions Inc',
            'location': 'San Francisco, CA',
            'roles': ['Production Assistant', 'Intern'],
            'applicants': 324,
          },
          {
            'title': 'Assistant Director Role',
            'company': 'Major Film Studio',
            'location': 'Los Angeles, CA',
            'roles': ['Assistant Director', 'Director'],
            'applicants': 89,
          },
          {
            'title': 'Sound Department',
            'company': 'Audio Post-Production',
            'location': 'London, UK',
            'roles': ['Sound Engineer', 'Sound Designer'],
            'applicants': 156,
          },
          {
            'title': 'Visual Effects Team',
            'company': 'VFX Studio',
            'location': 'Vancouver, Canada',
            'roles': ['VFX Artist', 'Motion Graphics', 'Compositor'],
            'applicants': 213,
          },
        ]
            .asMap()
            .entries
            .map((entry) {
              int index = entry.key + 1;
              Map job = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: JobOpportunityCard(
                  title: job['title'] as String,
                  company: job['company'] as String,
                  location: job['location'] as String,
                  roles: List<String>.from(job['roles']),
                  applicants: job['applicants'] as int,
                  isBookmarked: bookmarkedJobs.contains(index),
                  onTap: () => _showApplicationModal(context),
                  onBookmarkTap: () {
                    setState(() {
                      if (bookmarkedJobs.contains(index)) {
                        bookmarkedJobs.remove(index);
                      } else {
                        bookmarkedJobs.add(index);
                      }
                    });
                  },
                ),
              );
            })
            ,
      ],
    );
  }

  Widget _buildBookmarksTab() {
    if (bookmarkedJobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_outline,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Bookmarks Yet',
              style: AppTypography.headline4.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Bookmark jobs to save them for later',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ...[
          {
            'title': 'Casting Call - Indie Drama',
            'company': 'Independent Production',
            'location': 'New York, NY',
            'roles': ['Actor', 'Extra', 'Background'],
            'applicants': 245,
          },
          {
            'title': 'Assistant Director Role',
            'company': 'Major Film Studio',
            'location': 'Los Angeles, CA',
            'roles': ['Assistant Director', 'Director'],
            'applicants': 89,
          },
        ]
            .asMap()
            .entries
            .map((entry) {
              int index = entry.key + 2;
              Map job = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: JobOpportunityCard(
                  title: job['title'] as String,
                  company: job['company'] as String,
                  location: job['location'] as String,
                  roles: List<String>.from(job['roles']),
                  applicants: job['applicants'] as int,
                  isBookmarked: true,
                  onTap: () => _showApplicationModal(context),
                  onBookmarkTap: () {
                    setState(() {
                      bookmarkedJobs.remove(index);
                    });
                  },
                ),
              );
            })
            ,
      ],
    );
  }

  Widget _buildAppliedTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        ...[
          {
            'title': 'Film Crew Wanted',
            'company': 'Production Studio XYZ',
            'location': 'Los Angeles, CA',
            'status': 'Under Review',
            'appliedDate': '2 days ago',
          },
          {
            'title': 'Internship - Documentary Production',
            'company': 'Creative Productions Inc',
            'location': 'San Francisco, CA',
            'status': 'Not Selected',
            'appliedDate': '5 days ago',
          },
          {
            'title': 'Sound Department',
            'company': 'Audio Post-Production',
            'location': 'London, UK',
            'status': 'Under Review',
            'appliedDate': '1 week ago',
          },
        ]
            .map((job) => Container(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['title'] as String,
                                  style: AppTypography.headline4,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  job['company'] as String,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      job['location'] as String,
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: (job['status'] as String) == 'Under Review'
                                  ? AppColors.info.withOpacity(0.1)
                                  : AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppRadii.full),
                            ),
                            child: Text(
                              job['status'] as String,
                              style: AppTypography.labelSmall.copyWith(
                                color: (job['status'] as String) == 'Under Review'
                                    ? AppColors.info
                                    : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Applied ${job['appliedDate'] as String}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('View Application'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Contact'),
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

  void _showApplicationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadii.xl),
            topRight: Radius.circular(AppRadii.xl),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job Application',
                  style: AppTypography.headline3,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Lead Director - Major Feature Film',
                  style: AppTypography.headline4,
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Text(
                          'Your profile perfectly matches this role',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(
                  'Your Application',
                  style: AppTypography.headline4,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Tell them why you\'re the perfect fit...',
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_file,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attach Portfolio',
                              style: AppTypography.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Link to your portfolio or reel',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.add),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Application submitted successfully!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Submit Application'),
                      ),
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

  @override
  void dispose() {
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
