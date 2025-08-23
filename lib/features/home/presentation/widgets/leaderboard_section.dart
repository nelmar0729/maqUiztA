import 'package:flutter/material.dart';
import '/shared/text_styles.dart';
import '/shared/app_colors.dart';
import '/features/home/data/models/leader_board_model.dart';
import '/features/subjects/data/models/subject_model.dart';

class LeaderboardSection extends StatelessWidget {
  final List<SubjectModel> subjects;
  final Map<String, List<LeaderboardEntryModel>> leaderboards;

  const LeaderboardSection({
    super.key,
    required this.subjects,
    required this.leaderboards,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: subjects.length,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Leaderboard", style: AppTextStyles.titleLarge)],
          ),
          SizedBox(
            height: 400,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textPrimary,
                  labelStyle: AppTextStyles.bodyLarge,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2.5,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 25),
                  ),
                  tabs: [
                    for (final subject in subjects)
                      Tab(text: subject.subjectCode),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final subject in subjects)
                        MinimalLeaderboardTab(
                          subjectCode: subject.subjectCode,
                          entries: leaderboards[subject.subjectCode] ?? [],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

class MinimalLeaderboardTab extends StatelessWidget {
  final String subjectCode;
  final List<LeaderboardEntryModel> entries;

  const MinimalLeaderboardTab({
    super.key,
    required this.subjectCode,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final topEntries = entries.take(20).toList();

    if (topEntries.isEmpty) {
      return Center(
        child: Text(
          'No data yet for $subjectCode',
          style: AppTextStyles.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Text(subjectCode, style: AppTextStyles.bodyLarge),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            itemCount: topEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 2),
            itemBuilder: (context, idx) {
              final student = topEntries[idx];
              final rank = student.rank;
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: Text('$rank', style: AppTextStyles.bodyLarge),
                ),
                title: Text(student.name, style: AppTextStyles.bodyMedium),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: AppColors.accent, size: 17),
                    const SizedBox(width: 3),
                    Text(
                      '${student.score} score',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
