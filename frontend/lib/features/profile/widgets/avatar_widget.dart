import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/profile/bloc/profile_bloc.dart';
import 'package:frontend/features/profile/bloc/profile_state.dart';
import 'package:image_picker/image_picker.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.onTapAvatar,
    this.file,
    this.imageUrl,
  });

  final void Function() onTapAvatar;
  final XFile? file;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        bool isAvatarLoading = state is UploadAvatarLoadingState;
        String? avatarUrl =
            (state is UploadAvatarSuccessState) ? state.avatarUrl : null;
        return GestureDetector(
          onTap: onTapAvatar,

          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              image:
                  file != null
                      ? DecorationImage(image: FileImage(File(file!.path)))
                      : imageUrl != null
                      ? DecorationImage(image: NetworkImage(imageUrl!))
                      : isAvatarLoading || avatarUrl == null
                      ? null
                      : DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      ),
              color: Colors.grey[300],
            ),
            child:
                isAvatarLoading
                    ? Center(child: CircularProgressIndicator())
                    : null,
          ),
        );
      },
    );
  }
}
