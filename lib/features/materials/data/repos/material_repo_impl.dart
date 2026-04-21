import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sams_app/core/errors/exceptions/api_exception.dart';
import 'package:sams_app/core/extentions/filter_files_helper.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/utils/constants/api_endpoints.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';
import 'package:sams_app/core/utils/services/s3_upload_service.dart';
import 'package:sams_app/features/materials/data/data_source/material_local_data_source.dart';
import 'package:sams_app/features/materials/data/model/add_material_item_request.dart';
import 'package:sams_app/features/materials/data/model/file_upload_reference.dart';
import 'package:sams_app/features/materials/data/model/material_model.dart';
import 'package:sams_app/features/materials/data/model/presigned_url_model.dart';
import 'package:sams_app/features/materials/data/model/update_material.request.dart';
import 'package:sams_app/features/materials/data/repos/material_repo.dart';

//* Implementation of materials data operations using API and local cache
class MaterialRepoImpl implements MaterialRepo {
  final ApiConsumer api;
  final MaterialLocalDataSource localDataSource;
  final S3UploadService s3Service;

  MaterialRepoImpl({
    required this.api,
    required this.localDataSource,
    required this.s3Service,
  });

  //* GET materials → cache locally → return list
  @override
  Future<Either<String, List<MaterialModel>>> fetchMaterials({
    required String courseId,
  }) async {
    try {
      final response = await api.get(EndPoints.getMaterials(courseId));

      List<MaterialModel> materials =
          (response[ApiKeys.data] as List?)
              ?.map((item) => MaterialModel.fromJson(item))
              .toList() ??
          [];

      await localDataSource.cacheMaterials(materials);

      return right(materials);
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* Returns materials from local cache
  @override
  List<MaterialModel> getCachedMaterials() {
    return localDataSource.getCachedMaterials();
  }

  //* GET single material details
  @override
  Future<Either<String, MaterialModel>> fetchMaterialDetails({
    required String materialId,
  }) async {
    try {
      final response = await api.get(EndPoints.materialDetails(materialId));

      return right(MaterialModel.fromJson(response[ApiKeys.data]));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* UPLOAD material with full workflow
  @override
  Future<Either<String, MaterialModel>> uploadMaterialFullWorkflow({
    required String courseId,
    required String title,
    required String description,
    required List<XFile> selectedFiles,
  }) async {
    try {
      //! Step 1: Request Presigned URLs
      final List<PresignedUrlModel> metadataList = await _getBatchPresignedUrls(
        selectedFiles,
        courseId,
      );

      //! Step 2: Parallel S3 Upload
      await Future.wait(
        metadataList.asMap().entries.map((entry) {
          final index = entry.key;
          final metadata = entry.value;

          return s3Service.uploadFile(
            url: metadata.uploadUrl,
            xFile: selectedFiles[index],
            fileName: metadata.originalFileName,
            contentType: selectedFiles[index].name.fileContentType,
          );
        }),
      );

      //! Step 3: Confirm upload and get the created Material Object
      final createdMaterial = await _confirmUpload(
        courseId: courseId,
        metadata: metadataList,
        title: title,
        description: description,
      );

      return Right(createdMaterial);
    } on ApiException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left('Upload failed: ${e.toString()}');
    }
  }

  /// Final Confirmation that returns the created Material object
  Future<MaterialModel> _confirmUpload({
    required String courseId,
    //
    required String title,
    required String description,
    //
    required List<PresignedUrlModel> metadata,
  }) async {
    //* Map metadata to FileUploadReference object
    final List<FileUploadReference> items = metadata
        .map(
          (m) => FileUploadReference(
            originalFileName: m.originalFileName, // original file name
            contentType: m.originalFileName.fileContentType, // file type
            contentReference: m.key, // s3 key
          ),
        )
        .toList();

    final createResponse = await api.post(
      EndPoints.addMaterial(courseId),
      data: {
        ApiKeys.title: title,
        ApiKeys.description: description,
      },
    );

    final materialId = createResponse[ApiKeys.data][ApiKeys.id];

    final requestBody = AddMaterialItemsRequest(materialItems: items);

    final response = await api.post(
      EndPoints.addMaterialItems(materialId),
      data: requestBody.toJson(),
    );

    return MaterialModel.fromJson(response[ApiKeys.data]);
  }

  /// Requests upload URLs from the server
  Future<List<PresignedUrlModel>> _getBatchPresignedUrls(
    List<XFile> files,
    String courseId,
  ) async {
    final filesMetadata = await Future.wait(
      files.map((f) async {
        final name = f.name.isNotEmpty ? f.name : f.path.split('/').last;
        final bytes = await f.readAsBytes();
        return {
          ApiKeys.originalFileName: name,
          ApiKeys.contentType: name.fileContentType,
          ApiKeys.fileSize: bytes.length,
        };
      }),
    );
    //* Request upload URLs from the server
    final response = await api.post(
      EndPoints.createMaterialUploadUrls(courseId),
      data: {
        ApiKeys.context: 'materials',
        ApiKeys.filesMetadata: filesMetadata},
    );

    final List data = response[ApiKeys.data];
    return data.map((e) => PresignedUrlModel.fromJson(e)).toList();
  }

  //* PATCH material title and/or description
  @override
  Future<Either<String, MaterialModel>> updateMaterial({
    required String materialId,
    required UpdateMaterialRequest request,
  }) async {
    try {
      final response = await api.patch(
        EndPoints.updateMaterialData(materialId),
        data: request.toJson(),
      );

      return right(MaterialModel.fromJson(response[ApiKeys.data]));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* UPLOAD new items to an existing material (Full Workflow)
  @override
  Future<Either<String, MaterialModel>> addItemsToMaterial({
    required String materialId,
    required String courseId,
    required List<XFile> newFiles,
  }) async {
    try {
      //! Step 1: Request Presigned URLs for new files
      final List<PresignedUrlModel> metadataList = await _getBatchPresignedUrls(
        newFiles,
        courseId,
      );

      //! Step 2: Parallel S3 Upload
      await Future.wait(
        metadataList.asMap().entries.map((entry) {
          final index = entry.key;
          final metadata = entry.value;

          return s3Service.uploadFile(
            url: metadata.uploadUrl,
            xFile: newFiles[index],
            fileName: metadata.originalFileName,
            contentType: newFiles[index].name.fileContentType,
          );
        }),
      );

      //! Step 3: Confirm new items upload to backend
      final List<FileUploadReference> itemsRefs = metadataList
          .map(
            (m) => FileUploadReference(
              originalFileName: m.originalFileName,
              contentType: m.originalFileName.fileContentType,
              contentReference: m.key,
            ),
          )
          .toList();

      final response = await api.post(
        EndPoints.addMaterialItems(materialId),
        data: AddMaterialItemsRequest(materialItems: itemsRefs).toJson(),
      );

      return right(MaterialModel.fromJson(response[ApiKeys.data]));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left('Failed to add items: ${e.toString()}');
    }
  }

  //* DELETE single item from material using its S3 key
  @override
  Future<Either<String, MaterialModel>> deleteMaterialItem({
    required String materialId,
    required String itemKey,
  }) async {
    try {
      final response = await api.delete(
        EndPoints.deleteMaterialItem(materialId),
        queryParameters: {ApiKeys.itemKey: itemKey},
      );

      return right(MaterialModel.fromJson(response[ApiKeys.data]));
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }

  //* DELETE entire material
  @override
  Future<Either<String, Unit>> deleteMaterial({
    required String materialId,
  }) async {
    try {
      
      await api.delete(EndPoints.deleteMaterial(materialId));

      return right(unit); // Success: returns unit (functional void)
    } on ApiException catch (e) {
      return left(e.errorModel.errorMessage);
    } catch (e) {
      return left(e.toString());
    }
  }
}
