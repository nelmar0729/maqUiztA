// ignore_for_file: deprecated_member_use
import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/app_colors.dart';
import '/core/routes/app_router.dart';
import '/shared/constants.dart';
import '/features/auth/domain/usecases/getprograms.dart';
import '../domain/usecases/enroll_student.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/features/auth/data/models/program_model.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/shared/widgets/overlay_loader.dart';
import '/shared/widgets/snackbar.dart';

@RoutePage()
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final AuthRemoteDataSource dataSource;
  late final AuthRepositoryImpl repository;
  late final Getprograms getprograms;
  late final Enrollstudent enrollstudent;
  final localAuth = LocalAuthDataSource();

  int step = 0;

  /// Controllers for storing selected values
  ProgramModel? selectedProgram;
  String? selectedYear;
  String? selectedSection;

  /// For backend processing
  int? get programId => selectedProgram?.programId;
  String? get yearLevel => selectedYear;
  String? get section => selectedSection;
  String? _userId;

  List<ProgramModel> programOptions = [];
  bool isLoadingPrograms = true;

  final stepLabels = [
    "Select Your Program",
    "Select Your Year Level",
    "Select Your Section",
  ];

  final stepIcons = [
    Icons.psychology_alt_rounded, // program icon
    Icons.star_rate_rounded, // year icon
    Icons.groups_rounded, // section icon
  ];

  @override
  void initState() {
    super.initState();
    dataSource = AuthRemoteDataSourceImpl();
    repository = AuthRepositoryImpl(dataSource);
    getprograms = Getprograms(repository);
    enrollstudent = Enrollstudent(repository);
    getPrograms();
    _getUserData();
  }

  void _getUserData() async {
    final userId = await localAuth.getUserId();
    setState(() {
      _userId = userId;
    });
  }

  Future<void> getPrograms() async {
    setState(() => isLoadingPrograms = true);

    final programModels = await safeApiCall<List<ProgramModel>>(
      context,
      () => getprograms(),
    );

    if (!mounted) return;
    if (programModels != null) {
      setState(() {
        programOptions = programModels;
        isLoadingPrograms = false;
      });
    } else {
      setState(() => isLoadingPrograms = false);
      // ⚡ safeApiCall already shows No Internet 🚫 if offline
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load programs.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> handleEnrollStudent() async {
    try {
      if (!context.mounted) return;
      OverlayLoader.show(context, message: "Saving data...");

      final result = await safeApiCall(
        context,
        () => enrollstudent(
          _userId ?? "",
          programId ?? 0,
          yearLevel ?? "",
          section ?? "",
        ),
      );

      if (!context.mounted) return;

      if (result != null && result.success) {
        AppSnack.show(context, result.message, SnackType.success);
        context.router.replace(QuizterNavRoute());
      } else if (result != null) {
        AppSnack.show(context, result.message, SnackType.error);
      }
      // ⚡ If result == null, safeApiCall already handled No Internet 🚫
    } catch (e) {
      if (!context.mounted) return;
      AppSnack.show(context, "Something went wrong: $e", SnackType.error);
    } finally {
      OverlayLoader.hide();
    }
  }

  void nextStep() {
    setState(() => step++);
  }

  void backStep() {
    if (step > 0) setState(() => step--);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / 3.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  child: _buildStep(context, progress),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, double progress) {
    if (step > 2) {
      // Completion screen
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_rounded, color: AppColors.primary, size: 80),
          const SizedBox(height: 24),
          Text(
            "You’re Ready!",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Let the quiz games begin!",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: "Submit",
            onPressed: () {
              // You can now access:
              // programId, yearLevel, section for your controller/processing!
              handleEnrollStudent();
            },
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.primary,
            ),
          ),
        ),
        // Icon for step
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 10),
          child: Icon(stepIcons[step], size: 60, color: AppColors.primary),
        ),
        Text(
          stepLabels[step],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            fontFamily: 'Poppins',
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 18),
        _buildStepContent(context),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context) {
    List<String> options = [];
    String? selected;
    void Function(String) onSelect = (_) {};
    bool showContinue = false;

    // STEP 0: Program (show code only, get id when selected)
    if (step == 0) {
      if (isLoadingPrograms) {
        return const Center(child: CircularProgressIndicator());
      }
      if (programOptions.isEmpty) {
        return Center(
          child: Text(
            "No programs available.",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      options = programOptions.map((e) => e.programCode).toList();
      selected = selectedProgram?.programCode;
      onSelect = (programCode) {
        setState(() {
          selectedProgram = programOptions.firstWhere(
            (e) => e.programCode == programCode,
          );
        });
      };
    }
    // STEP 1: Year
    else if (step == 1) {
      options = AppConstants.years;
      selected = selectedYear;
      onSelect = (v) => setState(() => selectedYear = v);
    }
    // STEP 2: Section
    else {
      options = AppConstants.sections;
      selected = selectedSection;
      onSelect = (v) => setState(() => selectedSection = v);
      showContinue = true;
    }

    return Column(
      children: [
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: WrapAlignment.center,
          children: options.map((opt) {
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () {
                onSelect(opt);
                if (!showContinue) {
                  // For program/year, advance automatically if selected
                  Future.delayed(const Duration(milliseconds: 200), nextStep);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: isSelected ? 2.4 : 1,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.11),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      opt,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? AppColors.primary : Colors.black87,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
        if (showContinue)
          PrimaryButton(
            text: "Finish",
            onPressed: () {
              if (selectedProgram != null &&
                  selectedYear != null &&
                  selectedSection != null) {
                setState(() => step++);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please complete all selections to continue.",
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
        if (step > 0)
          TextButton(onPressed: backStep, child: const Text("Back")),
      ],
    );
  }
}
