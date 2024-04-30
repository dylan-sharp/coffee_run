import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

/// [UserProfile] represents the logged in users profile
@JsonSerializable()
class UserProfile extends Equatable {

  const UserProfile(this.id, this.name, this.groupIds);

  final String? id;
  final String name;
  final List<String> groupIds;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  List<Object?> get props => [id, name, groupIds];
}
