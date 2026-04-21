import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/data/model/update_material.request.dart';

//* Abstract contract for materials data operations
abstract class MaterialRepo {
  //* Fetch all materials for a specific course
  Future<Either<String, List<MaterialModel>>> fetchMaterials({
    required String courseId,
  });

   //* Return cached materials
  List<MaterialModel> getCachedMaterials();

  //* Fetch a single material details
  Future<Either<String, MaterialModel>> fetchMaterialDetails({
    required String materialId,
  });

  //* Upload a new material
  Future<Either<String, MaterialModel>> uploadMaterialFullWorkflow({
    required String courseId,
    required String title,
    required String description,
    required List<XFile> selectedFiles,
  });

//* Update a material title and/or description
  Future<Either<String, MaterialModel>> updateMaterial({
    required String materialId,
    required UpdateMaterialRequest request,
  });

//* Delete an item from material 
  Future<Either<String, MaterialModel>> deleteMaterialItem({
    required String materialId,
    required String itemKey,
  });

//* Add new items to a material 
  Future<Either<String, MaterialModel>> addItemsToMaterial({
    required String materialId,
    required String courseId,
    required List<XFile> newFiles,
  });

  //* Delete an entire material
  Future<Either<String, Unit>> deleteMaterial({
    required String materialId,
  });
}
