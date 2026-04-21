import 'package:get_storage/get_storage.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';

//* Local cache for materials using GetStorage
class MaterialLocalDataSource {
  final _storage = GetStorage();
  static const String _materialsKey = 'CACHED_MATERIALS';

  //? Serialize and write materials list to local storage
  Future<void> cacheMaterials(List<MaterialModel> materials) async {
    final jsonList = materials.map((material) => material.toJson()).toList();
    await _storage.write(_materialsKey, jsonList);
  }

  //* Read and deserialize cached materials — returns empty list if not found
  List<MaterialModel> getCachedMaterials() {
    final List<dynamic>? data = _storage.read(_materialsKey);
    if (data != null) {
      return data.map((json) => MaterialModel.fromJson(json)).toList();
    }
    return [];
  }

  //? Clear cache when needed (e.g., on logout or refresh)
  Future<void> clearCache() async {
    await _storage.remove(_materialsKey);
  }
}
