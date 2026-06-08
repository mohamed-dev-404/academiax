enum SignUpStatus {
  initial,
  loading,
  codeSent,
  codeResent,
  success,
  failure,
}

class SignUpState {
  final String? email;
  final SignUpStatus status;
  final String? errorMessage;
  final String? successMessage;
  final String? codeSentMessage;

  const SignUpState({
    this.email,
    this.status = SignUpStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.codeSentMessage,
  });

  SignUpState copyWith({
    String? email,
    SignUpStatus? status,
    String? errorMessage,
    String? successMessage,
    String? codeSentMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      codeSentMessage: codeSentMessage,
    );
  }
}
