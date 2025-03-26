import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/core/config/constants/app_urls.dart';
import 'package:my_app/data/models/auth/create_user_req.dart';
import 'package:my_app/data/models/auth/signin_user_req.dart';
import 'package:my_app/data/models/auth/user.dart';
import 'package:my_app/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either<String, Unit>> signup(CreateUserReq createUserReq);
  Future<Either<String, Unit>> signin(SigninUserReq signinUserReq);
  Future<Either<String, UserEntity>> getUser();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either<String, Unit>> signin(SigninUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signinUserReq.email, password: signinUserReq.password);
      return const Right(unit); // Trả về Unit thay vì String
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user';
      } else {
        message = e.message ?? 'An error occurred during signin';
      }
      return Left(message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> signup(CreateUserReq createUserReq) async {
    try {
      // Tạo người dùng
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createUserReq.email, password: createUserReq.password);

      // Đăng nhập ngay sau khi tạo để xác thực phiên
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: createUserReq.email, password: createUserReq.password);

      // Lưu thông tin vào Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(data.user?.uid)
          .set({
        'name': createUserReq.fullName,
        'email': data.user?.email,
      });

      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else {
        message = e.message ?? 'An error occurred during signup';
      }
      return Left(message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var user = await firebaseFirestore
          .collection('Users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();
      UserModel userModel = UserModel.fromJson(user.data()!);
      userModel.imageURL =
          firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return const Left('An error occurred');
    }
  }
}
