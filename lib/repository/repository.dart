import 'package:frnt/model/model.dart';

import '../provider/name_provider.dart';

class NameRepository {
  final NameProvider provider;

  NameRepository(this.provider);

  Future<List<NameModel>> fetchNames() => provider.fetchNames();

  Future<NameModel> createName(String name) => provider.createName(name);

  Future<NameModel> updateName(int id, String name) =>
      provider.updateName(id, name);

  Future<void> deleteName(int id) => provider.deleteName(id);
}
