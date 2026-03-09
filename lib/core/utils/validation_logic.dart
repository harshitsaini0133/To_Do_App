abstract final class ValidationLogic {
  static String? requiredText(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredText(value, fieldName: 'Email');
    if (requiredError != null) {
      return requiredError;
    }
    final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredText(value, fieldName: 'Password');
    if (requiredError != null) {
      return requiredError;
    }
    if (value!.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final requiredError = requiredText(value, fieldName: 'Confirm password');
    if (requiredError != null) {
      return requiredError;
    }
    if (value!.trim() != password.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? taskTitle(String? value) {
    final requiredError = requiredText(value, fieldName: 'Task title');
    if (requiredError != null) {
      return requiredError;
    }
    if (value!.trim().length < 3) {
      return 'Task title must be at least 3 characters';
    }
    return null;
  }
}
