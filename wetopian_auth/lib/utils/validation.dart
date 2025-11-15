enum UsernameType { email, phone, invalid }

bool isValidEmail(String input) {
  final email = input.trim();
  if (email.isEmpty) return false;

  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
    r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );
  return emailRegExp.hasMatch(email);
}

bool isValidPhone(String input, {int minDigits = 7, int maxDigits = 15}) {
  final s = input.trim();
  if (s.isEmpty) return false;
  final cleaned = s.replaceAll(RegExp(r'[ \-\(\)\.]'), '');
  final stripped = cleaned.startsWith('+') ? cleaned.substring(1) : cleaned;
  if (!RegExp(r'^\d+$').hasMatch(stripped)) return false;
  final digits = stripped.length;
  return digits >= minDigits && digits <= maxDigits;
}

UsernameType detectUsernameType(String input) {
  if (isValidEmail(input)) return UsernameType.email;
  if (isValidPhone(input)) return UsernameType.phone;
  return UsernameType.invalid;
}

bool isNameValid(String name, {int minLength = 1}) {
  final s = name.trim();
  if (s.length < minLength) return false;
  final nameRegExp = RegExp(r"^[\p{L} \-']+$", unicode: true);
  return nameRegExp.hasMatch(s);
}

bool isStrongPassword(String password, {int minLength = 8}) {
  if (password.length < minLength) return false;
  final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
  final hasLower = RegExp(r'[a-z]').hasMatch(password);
  final hasDigit = RegExp(r'\d').hasMatch(password);
  final hasSpecial =
      RegExp(r"""[!@#\$%\^&\*\(\)\-_\+=\[\]\{\};:\'"\\|,.<>\/\?~`]""")
          .hasMatch(password);
  return hasUpper && hasLower && hasDigit && hasSpecial;
}

List<String> passwordValidationErrors(String password) {
  final errors = <String>[];

  if (password.length < 8) {
    errors.add('Password must be at least 8 characters long');
  }

  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    errors.add('Password must contain at least one uppercase letter');
  }

  if (!RegExp(r'[a-z]').hasMatch(password)) {
    errors.add('Password must contain at least one lowercase letter');
  }

  if (!RegExp(r'\d').hasMatch(password)) {
    errors.add('Password must contain at least one digit');
  }

  if (!RegExp(r"""[!@#$%^&*()\-_=+\[\]{};:'"\\|,.<>/?~`]""")
      .hasMatch(password)) {
    errors.add(
        'Password must contain at least one special character (e.g. !@#\$%)');
  }

  return errors;
}
