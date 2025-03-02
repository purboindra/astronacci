// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  address: json['address'] as String,
  age: (json['age'] as num?)?.toInt(),
  avatar: json['avatar'] as String?,
  password: json['password'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'address': instance.address,
      'age': instance.age,
      'avatar': instance.avatar,
      'password': instance.password,
    };
