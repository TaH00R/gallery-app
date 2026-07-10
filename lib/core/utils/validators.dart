class Validators {
  Validators._();

  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static bool isNotEmpty(String? value) {
    return !isEmpty(value);
  }
}