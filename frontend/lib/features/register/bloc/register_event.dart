import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class SubmitRegisterEvent extends RegisterEvent {
  final String email;
  final String name;
  final String address;
  final String age;
  final String password;

  const SubmitRegisterEvent({
    required this.email,
    required this.name,
    required this.address,
    required this.age,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, address, age, password];
}
