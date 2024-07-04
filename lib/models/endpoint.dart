import 'package:isar/isar.dart';

part 'endpoint.g.dart';

@collection
class Endpoint {
  const Endpoint(this.serverUrl, this.isOAuth);

  // Only one endpoint should be stored in db so id will always be zero.
  static const id = 0;

  final Id isarId = id; 

  final String serverUrl;

  final bool isOAuth;
}