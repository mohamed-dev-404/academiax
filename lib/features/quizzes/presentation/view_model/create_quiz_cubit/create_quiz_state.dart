part of 'create_quiz_cubit.dart';

sealed class CreateQuizState {
  const CreateQuizState();
}

final class CreateQuizInitial extends CreateQuizState {}

final class CreateQuizUIUpdated extends CreateQuizState {}

// * create quiz state

final class CreateQuizLoading extends CreateQuizState {}

final class CreateQuizSuccess extends CreateQuizState {
  final String message;
  const CreateQuizSuccess(this.message);
}

final class CreateQuizFailure extends CreateQuizState {
  final String message;
  const CreateQuizFailure(this.message);
}

// * create classwork state

final class CreateClassworkLoading extends CreateQuizState {}

final class CreateClassworkSuccess extends CreateQuizState {
  final String message;
  const CreateClassworkSuccess(this.message);
}

final class CreateClassworkFailure extends CreateQuizState {
  final String message;
  const CreateClassworkFailure(this.message);
}

// * get available classworks state

final class GetAvailableClassworks extends CreateQuizState {
  const GetAvailableClassworks();
}

final class GetAvailableClassworksLoading extends GetAvailableClassworks {}

final class GetAvailableClassworksSuccess extends GetAvailableClassworks {
  final List<ClassworkItemModel> classworks;
  const GetAvailableClassworksSuccess(this.classworks);
}

final class GetAvailableClassworksFailure extends GetAvailableClassworks {
  final String message;
  const GetAvailableClassworksFailure(this.message);
}

// TODO: think about create another cubit for manage classwork (create, update)
/// and provide it by multi bloc provider in router
