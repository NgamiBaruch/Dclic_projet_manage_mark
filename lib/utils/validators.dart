class Validators {
  static String? notEmpty(String? v, {String message = 'Champ requis'}) {
    if (v == null || v.trim().isEmpty) return message;
    return null;
  }

  static String? minLength(String? v, int min, {String? field}) {
    if (v == null || v.trim().length < min) {
      return '${field ?? 'Champ'}: au moins $min caractères';
    }
    return null;
  }
}
