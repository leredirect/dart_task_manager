class ValidationUtils {
  static String required(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return "Поле не может быть пустым";
    }
    return null;
  }
}
