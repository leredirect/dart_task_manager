import 'package:hive/hive.dart';

class HiveUtils {
  static const _taskBoxKey = '_taskBox';
  static const _taskKey = '_taskKey';

  final Box<dynamic> _taskBox;

  HiveUtils._(this._taskBox);

  static Future<HiveUtils> getInstance() async {
    final box = await Hive.openBox<dynamic>(_taskBoxKey);
    return HiveUtils._(box);
  }

  T _getValue<T>(dynamic key, {T defaultValue}) =>
      _taskBox.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => _taskBox.put(key, value);

  Future<void> setTasks(dynamic tasks) => _setValue(_taskKey, tasks);

  dynamic getTasks() => _getValue(_taskKey);
}
