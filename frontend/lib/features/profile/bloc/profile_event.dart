import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UploadAvatarEvent extends ProfileEvent {
  final XFile file;
  final String userId;

  const UploadAvatarEvent({required this.userId, required this.file});

  @override
  List<Object?> get props => [file, userId];
}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String address;
  final String age;
  final String id;

  const UpdateProfileEvent({
    required this.name,
    required this.address,
    required this.age,
    required this.id,
  });

  @override
  List<Object?> get props => [name, address, age];
}

class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}
