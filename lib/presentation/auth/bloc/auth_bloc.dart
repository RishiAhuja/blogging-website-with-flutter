import 'package:blog/data/models/auth/create_user_request.dart';
import 'package:blog/data/models/auth/login_user_request.dart';
import 'package:blog/data/models/auth/no_params.dart';
import 'package:blog/domain/usecases/auth/logout_usecase.dart';
import 'package:blog/domain/usecases/auth/signin_usecase.dart';
import 'package:blog/domain/usecases/auth/signup_usecase.dart';
import 'package:blog/presentation/auth/bloc/auth_event.dart';
import 'package:blog/presentation/auth/bloc/auth_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final SignupUsecase _signUpUseCase;
  final SigninUsecase _signInUseCase;
  final LogoutUsecase _logoutUseCase;

  AuthBloc(SignupUsecase signupUsecase, SigninUsecase signInUsecase,
      LogoutUsecase logoutUsecase)
      : _signUpUseCase = signupUsecase,
        _signInUseCase = signInUsecase,
        _logoutUseCase = logoutUsecase,
        super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase(params: NoParams());
    emit(AuthInitial());
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _logoutUseCase(params: NoParams());

    final userRequest = CreateUserRequest(
        email: event.email,
        name: event.name,
        password: event.password,
        username: event.username);

    final result = await _signUpUseCase(params: userRequest);

    result.fold(
      (failure) => emit(AuthError(errorMessage: failure)), // Handle failure
      (user) => emit(AuthSuccess(userEntity: user)), // Handle success
    );
  }

  Future<void> _onSignInRequested(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _logoutUseCase(params: NoParams());
    final loginUserRequest =
        LoginUserRequest(email: event.email, password: event.password);

    final result = await _signInUseCase(params: loginUserRequest);

    result.fold(
      (failure) => emit(AuthError(errorMessage: failure)),
      (user) => emit(AuthSuccess(userEntity: user)),
    );
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      print('Loading state: $json');
      return AuthState.fromMap(json);
    } catch (e) {
      print('Error loading state: $e');
      return AuthInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    try {
      final map = state.toMap();
      print('Storing state: $map');
      return map;
    } catch (e) {
      print('Error storing state: $e');
      return {};
    }
  }
}



/*

// Hard to test - tightly coupled
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase _signUpUseCase = sl<SignupUseCase>();
}

// Easy to test - can mock dependencies
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase _signUpUseCase;
  AuthBloc(this._signUpUseCase);
}

*/

