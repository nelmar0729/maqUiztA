import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart';
import '/shared/widgets/primary_button.dart';

import '/features/subjects/domain/usecases/join_subject.dart';
import '/features/subjects/domain/usecases/fetch_subject.dart';
import '/features/subjects/data/datasources/remote_data_source.dart';
import '/features/subjects/data/repositories/repository_impl.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

import '/shared/widgets/overlay_loader.dart';
import '/shared/widgets/snackbar.dart';
// If you have your sample data in a file, adjust the import
import '/features/subjects/data/models/subject_model.dart';

@RoutePage()
class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late final RemoteDataSource dataSource;
  late final RepositoryImpl repository;
  late final FetchSubject fetchSubject;

  final localAuth = LocalAuthDataSource();
  List<SubjectModel> _subjects = [];

  bool _loadingSubjects = false;
  String? _userId;
  // Simulate fetching enrolled subjects
  Future<void> fetchSubjects() async {
    if (!mounted) return;
    setState(() => _loadingSubjects = true);

    // Ensure _userId is available
    if (_userId == null) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (_userId == null) {
      if (!mounted) return;
      setState(() => _loadingSubjects = false);
      return;
    }

    final result = await safeApiCall<List<SubjectModel>>(
      context,
      () => fetchSubject(_userId!),
    );

    if (!mounted) return;
    setState(() {
      if (result != null) {
        _subjects = result; // ✅ only update if valid
      }
      _loadingSubjects = false;
    });
  }

  void _getUserData() async {
    final userId = await localAuth.getUserId();
    if (!mounted) return; // ✅ prevent setState after dispose
    setState(() {
      _userId = userId;
    });

    // Fetch subjects once userId is ready
    await fetchSubjects();
  }

  @override
  void initState() {
    super.initState();
    dataSource = RemoteDataSourceImpl();
    repository = RepositoryImpl(dataSource);
    fetchSubject = FetchSubject(repository);
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Subjects",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: fetchSubjects,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          children: [
            PrimaryButton(
              text: "Join Subject",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _JoinSubjectDialog(
                    onSuccess: (subject) {
                      // After joining, refresh subjects from backend!
                      fetchSubjects();
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 28),
            const Divider(height: 32, thickness: 1.2),
            Text(
              "Joined Subjects",
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _loadingSubjects
                ? const Center(child: CircularProgressIndicator())
                : _subjects.isEmpty
                ? const Center(
                    child: Text(
                      "You have not joined any subjects yet.",
                      style: AppTextStyles.bodyLarge,
                    ),
                  )
                : Column(
                    children: _subjects
                        .map(
                          (subject) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: const Icon(
                                Icons.book,
                                color: AppColors.primary,
                              ),
                              title: Text(
                                subject.subjectName,
                                style: AppTextStyles.bodyLarge,
                              ),
                              subtitle: Text(
                                "Code: ${subject.subjectCode}\nInstructor: ${subject.instructor}",
                                style: AppTextStyles.bodyMedium,
                              ),
                              isThreeLine: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

class _JoinSubjectDialog extends StatefulWidget {
  final void Function(Map<String, dynamic> subject)? onSuccess;
  const _JoinSubjectDialog({this.onSuccess});

  @override
  State<_JoinSubjectDialog> createState() => _JoinSubjectDialogState();
}

class _JoinSubjectDialogState extends State<_JoinSubjectDialog> {
  late final RemoteDataSource dataSource;
  late final RepositoryImpl repository;
  late final JoinSubject joinSubject;
  final localAuth = LocalAuthDataSource();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool _loading = false;
  String? _errorText;
  String? _userId;
  @override
  void initState() {
    super.initState();
    dataSource = RemoteDataSourceImpl();
    repository = RepositoryImpl(dataSource);
    joinSubject = JoinSubject(repository);
    _getUserData();
  }

  void _getUserData() async {
    final userId = await localAuth.getUserId();
    //final userRole = await localAuth.getUserRole();
    // You can also setState if you want to show these in the UI:
    setState(() {
      _userId = userId;
    });
  }

  Future<void> _handleJoin() async {
    try {
      if (!_formKey.currentState!.validate()) return;
      if (!context.mounted) return;

      OverlayLoader.show(context, message: "Joining subject...");
      setState(() {
        _loading = true;
        _errorText = null;
      });

      final code = _codeController.text.trim();
      final result = await joinSubject(_userId ?? "0", code);

      if (!context.mounted) return;
      if (result.success) {
        // No data usage here!
        AppSnack.show(context, result.message, SnackType.success);
        Navigator.of(context).pop(); // Close modal
      } else {
        setState(() {
          _errorText = result.message;
        });
      }
    } catch (e) {
      if (!context.mounted) return;
      setState(() {
        _errorText = "An error occurred. Please try again.";
      });
    } finally {
      if (context.mounted) {
        setState(() {
          _loading = false;
        });
        OverlayLoader.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Join Subject"),
      content: SizedBox(
        width: 300,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: "Access Code",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Code required" : null,
                enabled: !_loading,
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _handleJoin,
          child: _loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Join"),
        ),
      ],
    );
  }
}
