// It’s a simple template for displaying key user info in your app.
/*
The User class defines the main user details that your app can safely show
or use—like name, email, role, and profile picture—while hiding sensitive or unnecessary fields.

If you need to show more information about a user in your app, 
just add more fields here (like section, yearLevel, birthday, etc).
*/

class User {
  final String id; // Unique user identifier (from database)
  final String email; // User’s email address (used for login/contact)
  final String? studentId;
  final String? firstName; // User’s first name (optional)
  final String? lastName; // User’s last name (optional)
  final String? role; // User’s role (e.g., student, admin) (optional)
  final String? avatar; // User’s profile picture URL or filename (optional)
  final String? section; // Student’s section (optional)
  final String? yearLevel; // Student’s year level (optional)
  final String? birthday; // User’s birthday (optional)

  // The constructor lets you easily create a new User object.
  User({
    required this.id,
    required this.email,
    this.studentId,
    this.firstName,
    this.lastName,
    this.role,
    this.avatar,
    this.section,
    this.yearLevel,
    this.birthday,
  });
}
