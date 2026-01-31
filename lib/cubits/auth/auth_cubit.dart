import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // For dummy implementation, always succeed
    if (email.isNotEmpty && password.isNotEmpty) {
      emit(AuthAuthenticated());
    } else {
      emit(const AuthError('Invalid credentials'));
    }
  }

  Future<void> signup(String name, String email, String password, String location) async {
    emit(AuthLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    // For dummy implementation, always succeed
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && location.isNotEmpty) {
      emit(AuthAuthenticated());
    } else {
      emit(const AuthError('All fields are required'));
    }
  }

  void logout() {
    emit(AuthUnauthenticated());
  }

  void checkAuthStatus() {
    // For dummy implementation, start as unauthenticated
    emit(AuthUnauthenticated());
  }
}
