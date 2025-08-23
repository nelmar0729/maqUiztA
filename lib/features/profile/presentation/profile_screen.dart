import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/features/profile/presentation/_change_password.dart';
import '/core/routes/app_router.dart';
import '/shared/app_colors.dart';
import '/shared/widgets/primary_button_icon.dart';
import '/shared/text_styles.dart';
import '/features/profile/data/datasources/data_source.dart';
import '/features/profile/data/repositories/repository_impl.dart';
import '/features/profile/domain/usecases/get_user_data.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/shared/widgets/overlay_loader.dart';
import '/shared/widgets/snackbar.dart';
import '/features/profile/data/models/user_model.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final localAuth = LocalAuthDataSource();
  late final DataSource dataSource;
  late final RepositoryImpl repository;
  late final GetUserData getUserData;

  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    dataSource = DataSourceImpl();
    repository = RepositoryImpl(dataSource);
    getUserData = GetUserData(repository, localAuth);

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    final fetchedUser = await safeApiCall<UserModel>(
      context,
      () => getUserData.call(),
    );

    if (!mounted) return; // 🔹 prevent setState after dispose

    setState(() {
      if (fetchedUser != null) {
        user = fetchedUser; // ✅ only update if valid
      }
      isLoading = false;
    });
  }

  // --- New method for auto-refresh after Edit ---
  Future<void> _navigateAndRefreshProfile() async {
    await context.pushRoute(EditProfileRoute());
    await _loadUserData();
  }

  Future<void> handleLogout() async {
    try {
      if (!mounted) return;
      OverlayLoader.show(context, message: "Logging out...");
      await localAuth.clearToken();
      if (!mounted) return;
      context.router.replace(const LoginRoute());
    } catch (e) {
      if (!mounted) return;
      AppSnack.show(context, e.toString(), SnackType.error);
    } finally {
      OverlayLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? RefreshIndicator(
              onRefresh: _loadUserData,
              child: ListView(
                children: const [
                  SizedBox(
                    height: 300,
                    child: Center(child: Text('No user data found.')),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.accent,
                      child: ClipOval(
                        child: (user!.avatar ?? '').isNotEmpty
                            ? Image.network(
                                user!.avatar!,
                                width: 104,
                                height: 104,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/user.png',
                                    width: 104,
                                    height: 104,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/user.png',
                                width: 104,
                                height: 104,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      "${user!.firstName ?? ''} ${user!.lastName ?? ''}",
                      style: AppTextStyles.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(user!.email, style: AppTextStyles.bodyLarge),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: Text(
                      "Student ID: ${user!.studentId ?? '-'}",
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // --- Program Code, Year Level, Section in "BSIT 1-B" style ---
                  Builder(
                    builder: (context) {
                      final programCode = user!.programCode ?? '';
                      final yearLevel = user!.yearLevel ?? '';
                      final section = user!.section ?? '';

                      String programDetails = '';
                      if (programCode.isNotEmpty &&
                          yearLevel.isNotEmpty &&
                          section.isNotEmpty) {
                        programDetails = '$programCode $yearLevel-$section';
                      } else if (programCode.isNotEmpty &&
                          yearLevel.isNotEmpty) {
                        programDetails = '$programCode $yearLevel';
                      } else if (programCode.isNotEmpty) {
                        programDetails = programCode;
                      }

                      return programDetails.isNotEmpty
                          ? Center(
                              child: Text(
                                programDetails,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 22),
                  Center(
                    child: PrimaryButtonWithIcon(
                      text: "Edit",
                      icon: Icons.edit,
                      iconPosition: IconPosition.start,
                      onPressed: _navigateAndRefreshProfile, // <-- Here!
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(height: 32, thickness: 1.2),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      // ignore: deprecated_member_use
                      color: AppColors.textPrimary.withOpacity(0.72),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Quiz History',
                      style: AppTextStyles.bodyLarge,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.router.push(const QuizHistoryRoute());
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.lock_outline,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Change Password',
                      style: AppTextStyles.bodyLarge,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.primary),
                    title: const Text('Logout', style: AppTextStyles.bodyLarge),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          title: const Text(
                            'Confirm Logout',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          content: const Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'No',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Yes'),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );
                      if (!context.mounted) return;
                      if (shouldLogout == true) {
                        handleLogout();
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
