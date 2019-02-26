import 'dart:async';
import '../../models/models.dart';

class TopicsService {
  final _http;

  TopicsService(this._http);

  Future<List<Topic>> list() async {
    final response = await _http.get('/topics/hot.json');
    Iterable l = response.data as List;

    var _items = l.map((item) => Topic.fromJson(item)).toList();
    return _items;
  }
}
