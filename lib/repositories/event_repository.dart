import '../api/api_client.dart';
import '../models/event.dart';

class EventRepository {
  EventRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  Future<List<Event>> getEvents({
    String? search,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _api.getEvents();
    return response.data;
  }
}
