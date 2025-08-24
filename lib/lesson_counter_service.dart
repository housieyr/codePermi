import 'package:firebase_database/firebase_database.dart';

class LessonCounterService {
  // point into /bandito/lessonStats to match your rules
  final DatabaseReference _root =
      FirebaseDatabase.instance.ref('bandito/lessonStats');

  Future<Map<String, int>> fetchAll() async {
    final snap = await _root.get();
    final out = <String, int>{};
    if (snap.exists && snap.value is Map) {
      final map = snap.value as Map;
      map.forEach((k, v) {
        out[k.toString()] = v is num ? v.toInt() : int.tryParse(v.toString()) ?? 0;
      });
    }
    return out;
  }

  Future<void> increment(String key) {
    return _root.child(key).runTransaction((current) {
      final n = current is num ? current.toInt() : 0;
      return Transaction.success(n + 1);
    });
    // Or: return _root.child(key).set(ServerValue.increment(1));
    // (Works with your permissive rules too)
  }
}
