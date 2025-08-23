import '/shared/util/network_utils.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import '/core/routes/app_router.dart';

import '/shared/constants.dart';
import '/shared/helpers.dart';
import '/shared/widgets/drop_down.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/widgets/primary_text_field.dart';
import '/shared/text_styles.dart';
import '/features/auth/domain/usecases/getprograms.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/features/auth/data/models/program_model.dart';
import '/shared/widgets/overlay_loader.dart';
import '/shared/widgets/snackbar.dart';

import '/features/profile/data/datasources/data_source.dart';
import '/features/profile/data/repositories/repository_impl.dart';
import '/features/profile/domain/usecases/get_user_data.dart';
import '/features/profile/domain/usecases/update_user_data.dart';

import '/features/auth/data/datasources/local_auth_datasource.dart';
import '/features/profile/data/models/user_model.dart';
import '/shared/app_colors.dart';
import '/shared/response.dart';
@RoutePage()
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _studentIdController = TextEditingController();
  String? _avatarUrl;
  String? _oldEmail;

  // Program-related
  late final AuthRemoteDataSource dataSource;
  late final AuthRepositoryImpl repository;
  late final Getprograms getprograms;
  late final UpdateUserData updateUserData;
  List<ProgramModel> programOptions = [];
  ProgramModel? selectedProgram;
  String? selectedYear;
  String? selectedSection;
  bool isLoadingPrograms = true;

  // User-related
  late final LocalAuthDataSource localAuth;
  late final DataSource userDataSource;
  late final RepositoryImpl userRepository;
  late final GetUserData getUserData;
  UserModel? user;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    // Setup for programs
    dataSource = AuthRemoteDataSourceImpl();
    repository = AuthRepositoryImpl(dataSource);
    getprograms = Getprograms(repository);

    // Setup for user data
    localAuth = LocalAuthDataSource();
    userDataSource = DataSourceImpl();
    userRepository = RepositoryImpl(userDataSource);
    getUserData = GetUserData(userRepository, localAuth);
    updateUserData = UpdateUserData(userRepository, localAuth);

    _loadUserAndPrograms();
  }

  Future<void> _loadUserAndPrograms() async {
    setState(() {
      isLoadingUser = true;
      isLoadingPrograms = true;
    });

    // Wrap both API calls with safeApiCall
    final fetchedUser = await safeApiCall<UserModel>(
      context,
      () => getUserData.call(),
    );

    final list = await safeApiCall<List<ProgramModel>>(
      context,
      () => getprograms(),
    );

    setState(() {
      if (fetchedUser != null) {
        user = fetchedUser;
        _firstNameController.text = user?.firstName ?? '';
        _lastNameController.text = user?.lastName ?? '';
        _emailController.text = user?.email ?? '';
        _studentIdController.text = user?.studentId ?? '';
        _avatarUrl = user?.avatar ?? '';
        selectedYear = user?.yearLevel;
        selectedSection = user?.section;
        _oldEmail = user?.email ?? '';
      }

      if (list != null) {
        programOptions = list;
        selectedProgram = programOptions.firstWhereOrNull(
          (prog) => prog.programCode == user?.programCode,
        );
      }

      isLoadingUser = false;
      isLoadingPrograms = false;
    });
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> handleUpdateUserData() async {
    if (!context.mounted) return;
    OverlayLoader.show(context, message: "Updating...");

    final result = await safeApiCall<ResponseResult>(
      context,
      () => updateUserData(
        firstname: _firstNameController.text.trim(),
        lastname: _lastNameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        email: _emailController.text.trim(),
        avatar: _imageFile,
        programId: selectedProgram?.programId ?? 0,
        yearLevel: selectedYear ?? '',
        section: selectedSection ?? '',
      ),
    );

    if (!context.mounted) return;

    if (result != null && result.success) {
      if (_oldEmail != _emailController.text.trim()) {
        AppSnack.show(
          context,
          "Profile updated! Please verify your new email",
          SnackType.success,
        );
        context.router.push(
          NewEmailVerificationRoute(email: _emailController.text.trim()),
        );
      } else {
        AppSnack.show(context, "Profile updated!", SnackType.success);
        context.router.pop();
      }
    } else if (result != null) {
      AppSnack.show(context, result.message, SnackType.error);
    }

    OverlayLoader.hide();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = isLoadingUser || isLoadingPrograms;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
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

      body: isBusy
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserAndPrograms,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.grey.shade200,
                              child: ClipOval(
                                child: _imageFile != null
                                    ? Image.file(
                                        _imageFile!,
                                        width: 104,
                                        height: 104,
                                        fit: BoxFit.cover,
                                      )
                                    : (_avatarUrl?.isNotEmpty ?? false)
                                    ? Image.network(
                                        _avatarUrl!,
                                        width: 104,
                                        height: 104,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
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
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Color(0xFF00C6FB),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),

                      // Name, Email, Student ID
                      PrimaryTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        prefixIcon: Icons.person,
                        validator: AppHelpers.required(
                          "First name is required!",
                        ),
                      ),
                      const SizedBox(height: 22),
                      PrimaryTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        prefixIcon: Icons.person,
                        validator: AppHelpers.required(
                          "Last name is required!",
                        ),
                      ),
                      const SizedBox(height: 22),
                      PrimaryTextField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required!';
                          }
                          if (!RegExp(
                            r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      PrimaryTextField(
                        controller: _studentIdController,
                        label: 'Student ID',
                        prefixIcon: Icons.badge,
                        validator: AppHelpers.multi([
                          AppHelpers.required('Please enter your student ID'),
                          AppHelpers.studentId(
                            'Invalid student ID (eg. XXXX-XXXX-A)',
                          ),
                        ]),
                      ),
                      const SizedBox(height: 36),
                      // Program Dropdown
                      PrimaryDropdown<ProgramModel>(
                        value: selectedProgram,
                        label: "Program",
                        prefixIcon: Icons.school_rounded,
                        items: programOptions
                            .map(
                              (prog) => DropdownMenuItem(
                                value: prog,
                                child: Text(
                                  prog.programCode,
                                  style: AppTextStyles.bodyLarge,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (prog) =>
                            setState(() => selectedProgram = prog),
                        validator: (v) => v == null ? "Select a program" : null,
                      ),
                      const SizedBox(height: 22),

                      // Year Dropdown
                      PrimaryDropdown<String>(
                        value: selectedYear,
                        label: "Year Level",
                        prefixIcon: Icons.star_rounded,
                        items: AppConstants.years
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(
                                  year,
                                  style: AppTextStyles.bodyLarge,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (year) =>
                            setState(() => selectedYear = year),
                        validator: (v) =>
                            v == null ? "Select year level" : null,
                      ),
                      const SizedBox(height: 22),

                      // Section Dropdown
                      PrimaryDropdown<String>(
                        value: selectedSection,
                        label: "Section",
                        prefixIcon: Icons.group_rounded,
                        items: AppConstants.sections
                            .map(
                              (section) => DropdownMenuItem(
                                value: section,
                                child: Text(
                                  section,
                                  style: AppTextStyles.bodyLarge,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (section) =>
                            setState(() => selectedSection = section),
                        validator: (v) => v == null ? "Select section" : null,
                      ),
                      const SizedBox(height: 22),

                      PrimaryButton(
                        text: "Save Changes",
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            handleUpdateUserData();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
