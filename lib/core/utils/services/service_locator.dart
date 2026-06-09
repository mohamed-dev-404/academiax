import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sams_app/core/enums/enum_user_role.dart';
import 'package:sams_app/core/network/api_consumer.dart';
import 'package:sams_app/core/network/dio_consumer.dart';
import 'package:sams_app/core/utils/services/s3_upload_service.dart';
import 'package:sams_app/features/grades/presentation/view_model/grade_cubit/grade_cubit.dart';
import 'package:sams_app/features/announcements/data/data_sources/announcements_local_data_source.dart';
import 'package:sams_app/features/announcements/data/repos/announcement_repo.dart';
import 'package:sams_app/features/announcements/data/repos/announcemet_repo_impl.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcement_actions/announcement_actions_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/announcements_fetch/announcements_fetch_cubit.dart';
import 'package:sams_app/features/announcements/presentation/view_model/cubit/comment_actions/comment_actions_cubit.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_repo_impl.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_reop.dart';
import 'package:sams_app/features/assignments/data/repos/assignment_submission_repo_impl.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignmemt_submission/assignment_submission_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_details/assignment_details_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/assignment_fetch/assignment_fetch_cubit.dart';
import 'package:sams_app/features/assignments/presentation/view_model/cubits/create_assignment/create_assignment_cubit.dart';
import 'package:sams_app/features/auth/data/repos/auth_repo.dart';
import 'package:sams_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:sams_app/features/grades/data/repos/grade_repo.dart';
import 'package:sams_app/features/grades/data/repos/grade_repo_impl.dart';
import 'package:sams_app/features/home/data/data_sources/home_local_data_sourse.dart';
import 'package:sams_app/features/home/data/repos/home_repo.dart';
import 'package:sams_app/features/home/data/repos/home_repo_impl.dart';
import 'package:sams_app/features/home/presentation/view_models/cubit/home_cubit.dart';
import 'package:sams_app/features/live_sessions/data/repos/meeting_repo.dart';
import 'package:sams_app/features/live_sessions/data/repos/meeting_repo_impl.dart';
import 'package:sams_app/features/live_sessions/presentation/view_model/cubit/meeting_cubit.dart';
import 'package:sams_app/features/materials/data/data_source/material_local_data_source.dart';
import 'package:sams_app/features/materials/data/repos/material_repo.dart';
import 'package:sams_app/features/materials/data/repos/material_repo_impl.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_crud/material_crud_cubit.dart';
import 'package:sams_app/features/materials/presentation/view_model/cubits/material_fetch/material_fetch_cubit.dart';
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

  //! Profile Feature

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

  //! Materials Feature

  //* register MaterialsLocalDataSource
  getIt.registerLazySingleton<MaterialLocalDataSource>(
    () => MaterialLocalDataSource(),
  );

  //* register MaterialsRepo
  getIt.registerLazySingleton<MaterialRepo>(
    () => MaterialRepoImpl(
      api: getIt<ApiConsumer>(),
      localDataSource: getIt<MaterialLocalDataSource>(),
      s3Service: getIt<S3UploadService>(),
    ),
  );

  //* register MaterialFetchCubit (Factory to get a new instance for each course)
  //* This cubit is used to fetch materials
  getIt.registerFactory<MaterialFetchCubit>(
    () => MaterialFetchCubit(getIt<MaterialRepo>()),
  );

  //* register MaterialCrudCubit (Factory to get a new instance for each course)
  //* This cubit is used to upload, update and delete materials
  getIt.registerFactory<MaterialCrudCubit>(
    () => MaterialCrudCubit(getIt<MaterialRepo>()),
  );

  //! Announcements Feature
  //* 1. Register Local Data Source
  getIt.registerLazySingleton<AnnouncementLocalDataSource>(
    () => AnnouncementLocalDataSource(),
  );

  //* 2. Register Repo Implementation
  getIt.registerLazySingleton<AnnouncementsRepo>(
    () => AnnouncementsRepoImpl(
      api: getIt<ApiConsumer>(),
      localDataSource: getIt<AnnouncementLocalDataSource>(),
    ),
  );

  //* 3. Register Fetch Cubit (Factory: to get a fresh instance every time)
  getIt.registerFactory<AnnouncementsFetchCubit>(
    () => AnnouncementsFetchCubit(getIt<AnnouncementsRepo>()),
  );

  //* 4. Register Actions Cubit (Add, Update, Delete)
  getIt.registerFactory<AnnouncementsActionsCubit>(
    () => AnnouncementsActionsCubit(getIt<AnnouncementsRepo>()),
  );
  //* 4. Register Actions Cubit (Add, Update, Delete)
  getIt.registerFactory<CommentActionsCubit>(
    () => CommentActionsCubit(getIt<AnnouncementsRepo>()),
  );

  //! Assignment Feature

  //* register AssignmentRepo
  getIt.registerLazySingleton<AssignmentRepo>(
    () => AssignmentRepoImpl(
      api: getIt<ApiConsumer>(),
      s3Service: getIt<S3UploadService>(),
    ),
  );


  getIt.registerLazySingleton<AssignmentSubmissionRepo>(
    () => AssignmentSubmissionRepoImpl(
      api: getIt<ApiConsumer>(),
      s3Service: getIt<S3UploadService>(),
    ),
  );


  //* register AssignmentFetchCubit
  getIt.registerFactory<AssignmentFetchCubit>(
    () => AssignmentFetchCubit(getIt<AssignmentRepo>()),
  );

  //* register AssignmentDetailsCubit
  getIt.registerFactory<AssignmentDetailsCubit>(
    () => AssignmentDetailsCubit(
      getIt<AssignmentRepo>(), getIt<AssignmentSubmissionRepo>(),
    ),
  );

  //* register CreateAssignmentCubit
  getIt.registerLazySingleton<CreateAssignmentCubit>(
    () => CreateAssignmentCubit(
      assignmentRepo: getIt<AssignmentRepo>(),
      quizRepo: getIt<QuizRepository>(),
    ),
  );

  //* register AssignmentSubmissionFetchCubit
  getIt.registerFactory<AssignmentSubmissionCubit>(
    () => AssignmentSubmissionCubit(getIt<AssignmentSubmissionRepo>()),
  );

  //! Grades Feature

  //* register GradeRepo
  getIt.registerLazySingleton<GradeRepo>(
    () => GradeRepoImpl(api: getIt<ApiConsumer>()),
  );

  //* register GradeCubit (Factory: to get a fresh instance every time)
  getIt.registerFactory<GradeCubit>(
    () => GradeCubit(getIt<GradeRepo>()),
  );

  //! Live Sessions Feature

  //* register MeetingRepo
  getIt.registerLazySingleton<MeetingRepo>(
    () => MeetingRepoImpl(api: getIt<ApiConsumer>()),
  );

  //* register MeetingCubit
  getIt.registerFactory<MeetingCubit>(
    () => MeetingCubit(getIt<MeetingRepo>()),
  );
}
