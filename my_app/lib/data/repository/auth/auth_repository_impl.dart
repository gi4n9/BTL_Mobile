import 'package:dartz/dartz.dart';
import 'package:my_app/data/models/auth/create_user_req.dart';
import 'package:my_app/data/models/auth/signin_user_req.dart';
import 'package:my_app/data/sources/auth/auth_firebase_service.dart';
import 'package:my_app/domain/entities/auth/user.dart';
import 'package:my_app/domain/repository/auth/auth.dart';
import '../../../service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<String, Unit>> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either<String, Unit>> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    return await sl<AuthFirebaseService>().getUser();
  }
}
