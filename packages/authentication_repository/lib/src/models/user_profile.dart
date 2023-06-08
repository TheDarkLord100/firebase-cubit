import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? email;
  final String id;
  final String? name;
  final String? profileUrl;

  const UserProfile({this.email, required this.id, this.name, this.profileUrl});

  @override
  List<Object?> get props => [email, id, name, profileUrl];

  static UserProfile empty = const UserProfile(id: "");
}
