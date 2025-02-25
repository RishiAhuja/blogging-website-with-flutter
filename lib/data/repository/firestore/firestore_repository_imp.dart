import 'package:blog/data/models/firestore/follow_model.dart';
import 'package:blog/data/models/firestore/profile_blog_model.dart';
import 'package:blog/data/models/firestore/profile_model.dart';
import 'package:blog/data/sources/firestore/firestore_service.dart';
import 'package:blog/domain/entities/blog/blog_preview_entity.dart';
import 'package:blog/domain/entities/profile/blogs_entity.dart';
import 'package:blog/domain/entities/profile/profile_entity.dart';
import 'package:blog/domain/repository/firestore/firestore_repository.dart';
import 'package:blog/service_locator.dart';
import 'package:dartz/dartz.dart';

class FirestoreRepositoryImp extends FirestoreRepository {
  @override
  Future<Either<String, ProfileEntity>> getProfileData(
      ProfileModel profileModel) {
    return sl<FirestoreService>().getProfileData(profileModel);
  }

  @override
  Future<Either> follow(FollowModel followModel) {
    return sl<FirestoreService>().follow(followModel);
  }

  @override
  Future<Either<String, BlogPreviewEntity>> getBlogPreview(String uid) {
    return sl<FirestoreService>().getBlogData(uid);
  }

  @override
  Future<Either<String, List<ProfileBlogEntity>>> getProfileBlogs(
      ProfileBlogModel profileBlogModel) {
    return sl<FirestoreService>().getUserBlogs(profileBlogModel);
  }
}
