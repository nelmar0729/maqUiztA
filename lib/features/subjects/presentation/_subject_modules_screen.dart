// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/shared/app_colors.dart';
import '/shared/text_styles.dart';
import '/shared/util/mobile_rewarded_ad.dart'; // ✅ use rewarded instead of interstitial
import '/shared/util/mobile_banner_ad.dart';
import '/shared/widgets/snackbar.dart';
import '/shared/util/network_utils.dart';

import '/features/subjects/data/models/subject_model.dart';
import '/features/subjects/data/models/module_model.dart';
import '/features/subjects/domain/usecases/fetch_modules.dart';
import '/features/subjects/data/datasources/remote_data_source.dart';
import '/features/subjects/data/repositories/repository_impl.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SubjectModulesScreen extends StatefulWidget {
  final SubjectModel subject;
  const SubjectModulesScreen({super.key, required this.subject});

  @override
  State<SubjectModulesScreen> createState() => _SubjectModulesScreenState();
}

class _SubjectModulesScreenState extends State<SubjectModulesScreen> {
  late final RemoteDataSource dataSource;
  late final RepositoryImpl repository;
  late final FetchModules fetchModules;

  final localAuth = LocalAuthDataSource();

  List<ModuleModel> _modules = [];
  bool _loading = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    dataSource = RemoteDataSourceImpl();
    repository = RepositoryImpl(dataSource);
    fetchModules = FetchModules(repository, localAuth);
    _getUserData();

    // ✅ Only preload rewarded ads on mobile
    if (!kIsWeb) {
      MobileRewardedAd.load();
    }
  }

  void _getUserData() async {
    final userId = await localAuth.getUserId();
    if (!mounted) return;
    setState(() {
      _userId = userId;
    });
    await _loadModules();
  }

  Future<void> _loadModules() async {
    if (!mounted) return;
    setState(() => _loading = true);

    if (_userId == null) {
      setState(() => _loading = false);
      return;
    }

    final result = await safeApiCall<List<ModuleModel>>(
      context,
      () => fetchModules(widget.subject.facultySubjectId.toString()),
    );

    if (!mounted) return;
    setState(() {
      if (result != null) {
        _modules = result;
      }
      _loading = false;
    });
  }

  /// 📥 Open file directly (web) or after rewarded ad (mobile)
  void _openModule(ModuleModel module) {
    final Uri fileUrl = Uri.parse(module.filePath);

    if (kIsWeb) {
      _openDirectOnWeb(fileUrl);
    } else {
      _rewardedAdBeforeDownloadMobile(fileUrl);
    }
  }

  /// 🌐 Web: open in a new tab (no ads → avoids popup-blocker issues)
  Future<void> _openDirectOnWeb(Uri fileUrl) async {
    try {
      final ok = await launchUrl(
        fileUrl,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_blank', // new tab on web
      );
      if (!ok) {
        AppSnack.show(context, "Could not open the file.", SnackType.error);
      }
    } catch (_) {
      AppSnack.show(context, "Could not open the file.", SnackType.error);
    }
  }

  /// 📱 Mobile: show rewarded ad first, then open externally
  void _rewardedAdBeforeDownloadMobile(Uri fileUrl) {
    bool rewarded = false;

    MobileRewardedAd.show(
      onRewardEarned: (reward) async {
        rewarded = true;
        if (await canLaunchUrl(fileUrl)) {
          await launchUrl(fileUrl, mode: LaunchMode.externalApplication);
        } else {
          AppSnack.show(context, "Could not open the file.", SnackType.error);
        }
      },
      onComplete: () async {
        // ✅ optional fallback so students aren’t blocked if ad fails to show
        if (!rewarded) {
          if (await canLaunchUrl(fileUrl)) {
            await launchUrl(fileUrl, mode: LaunchMode.externalApplication);
          } else {
            AppSnack.show(context, "Could not open the file.", SnackType.error);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.subject.subjectName} - Modules",
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadModules,
        child: Column(
          children: [
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _modules.isEmpty
                  ? const Center(
                      child: Text(
                        "No modules uploaded yet.",
                        style: AppTextStyles.bodyLarge,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _modules.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final module = _modules[index];
                        return _ModuleCard(
                          module: module,
                          onOpen: () => _openModule(module),
                        );
                      },
                    ),
            ),

            // ✅ Banner Ad at bottom — MOBILE ONLY
            if (!kIsWeb) const MobileBannerAd(),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final ModuleModel module;
  final VoidCallback onOpen;

  const _ModuleCard({required this.module, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + File Type Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    module.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: module.fileType == "pdf"
                        ? Colors.redAccent.withOpacity(0.2)
                        : Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    module.fileType.toUpperCase(),
                    style: TextStyle(
                      color: module.fileType == "pdf"
                          ? Colors.redAccent
                          : Colors.blueAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (module.description.isNotEmpty)
              Text(module.description, style: AppTextStyles.bodyMedium),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "By ${module.uploadedByName}",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: onOpen,
                  icon: const Icon(Icons.download),
                  label: const Text("Open"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
