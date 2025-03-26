// lib/domain/entities/auth/user.dart
class UserEntity {
  final String? email;
  final String? fullName;
  final String? imageURL; // Thêm thuộc tính imageURL

  const UserEntity({
    this.email,
    this.fullName,
    this.imageURL, // Thêm vào constructor
  });
}
