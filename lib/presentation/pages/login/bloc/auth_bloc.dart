// blocs/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:taskmanager/core/error/failure.dart';
import 'package:taskmanager/domain/entities/user_entity.dart';
import 'package:taskmanager/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.login(event.email, event.password);
      result.fold(
        (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await authRepository.register(event.email, event.password);
      result.fold(
        (failure) => emit(AuthFailure(_mapFailureToMessage(failure))),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<LogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(AuthInitial());
    });
  }

  String _mapFailureToMessage(Failure failure) {
    // Map failure types to user-friendly messages
    return 'Authentication failed';
  }
}
