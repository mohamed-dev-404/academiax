import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/network/dio_consumer.dart';
import 'package:sams_app/core/utils/services/s3_upload_service.dart';
import 'package:sams_app/features/auth/data/repos/auth_repo.dart';
import 'package:sams_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:sams_app/features/home/data/data_sources/home_local_data_sourse.dart';
import 'package:sams_app/features/home/data/repos/home_repo.dart';
import 'package:sams_app/features/home/data/repos/home_repo_impl.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/profile/data/repos/profile_repo.dart';
import 'package:sams_app/features/profile/data/repos/profile_repo_impl.dart';
import 'package:sams_app/features/profile/data/services/image_processor.dart';
import 'package:sams_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository.dart';
import 'package:sams_app/features/quizzes/data/repos/quiz_repository_impl.dart';

final GetIt getIt = GetIt.instance;
void setupServiceLocator() {
  //! shared network services
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(getIt<Dio>()));

  //! Auth Feature

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(getIt<ApiConsumer>()),
  );

  //! Home Feature

  //* register HomeLocalDataSource
  getIt.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSource(),
  );

  //* register HomeRepo
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(
      api: getIt<ApiConsumer>(),
      localDataSource: getIt<HomeLocalDataSource>(),
    ),
  );

  //*  New HomeCubit every time
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<HomeRepo>(), role: CurrentRole.role),
  );

  //* register S3UploadService
  getIt.registerLazySingleton<S3UploadService>(() => S3UploadService());

  //* register ImageProcessor
  getIt.registerLazySingleton<ImageProcessor>(() => ImageProcessorImpl());

  //* register ProfileRepo
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(
      api: getIt<ApiConsumer>(),
      s3Service: getIt<S3UploadService>(),
      imageProcessor: getIt<ImageProcessor>(),
    ),
  );

  //* register ProfileCubit
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<ProfileRepo>()),
  );

  //! Quizzes Feature

  //* register QuizRepo
  getIt.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(api: getIt<ApiConsumer>()),
  );
}
