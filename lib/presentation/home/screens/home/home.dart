import 'package:blog/common/helper/extensions/is_dark.dart';
import 'package:blog/common/helper/extensions/is_mobile.dart';
import 'package:blog/common/router/app_router.dart';
import 'package:blog/common/widgets/appbar/appbar.dart';
import 'package:blog/core/configs/theme/app_colors.dart';
import 'package:blog/domain/entities/blog/blog_entity.dart';
import 'package:blog/domain/usecases/hive/add_usecase.dart';
import 'package:blog/domain/usecases/hive/get_all_usecase.dart';
import 'package:blog/presentation/auth/bloc/auth_bloc.dart';
import 'package:blog/presentation/auth/bloc/auth_state.dart';
import 'package:blog/presentation/home/widgets/appbar_popup.dart';
import 'package:blog/presentation/landing/landing.dart';
import 'package:blog/responsive/responsive_layout.dart';
import 'package:blog/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, BlogEntity> localBlogs = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBlogs();
  }

  Future<void> loadBlogs() async {
    try {
      print('Loading blogs...');
      final res = await sl<GetAllUsecase>()();
      print('Loaded blogs: ${res.length}');
      print('Blog data: $res');

      setState(() {
        localBlogs = res;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading blogs: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthSuccess) {
          return const Landing();
        }
        return Scaffold(
            appBar: BasicAppBar(
                isLanding: false,
                customActionWidgetPrefix: appBarInfoPopup(
                    context.isDark,
                    state.userEntity.name,
                    state.userEntity.username,
                    state.userEntity.email,
                    state.userEntity.id)),
            body: ResponsiveLayout(
              mobileWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: _firstHalf(context.isDark, context.isMobile,
                          context, state.userEntity.id)),
                  Expanded(
                      flex: 1,
                      child: _secondHalf(context.isDark, state.userEntity.id)),
                ],
              ),
              desktopWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: _firstHalf(context.isDark, context.isMobile,
                          context, state.userEntity.id)),
                  Expanded(
                      flex: 1,
                      child: _secondHalf(context.isDark, state.userEntity.id)),
                ],
              ),
            ));
      },
    );
  }

  Widget _firstHalf(
      bool isDark, bool isMobile, BuildContext context, String userUid) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Build your community, start a new project',
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              style: GoogleFonts.spaceGrotesk(fontSize: 34),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Uuid uuid = const Uuid();
                final blogUid = uuid.v4();
                sl<AddUsecase>()(
                    params: BlogEntity(
                        uid: blogUid,
                        content: '',
                        htmlPreview: '',
                        title: '',
                        userUid: userUid));
                context.go(
                  '${AppRouterConstants.newblog}/$blogUid',
                  extra: {
                    'userUid': userUid,
                    'title': '',
                    'content': '',
                    'htmlPreview': '',
                  },
                );
              },
              child: _blogButton(isDark),
            )
          ],
        ),
      ),
    );
  }

  Widget _secondHalf(bool isDark, String userUid) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Blogs and drafts',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(fontSize: 34),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Locally Available Blogs",
                  style: GoogleFonts.spaceGrotesk(fontSize: 18)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: localBlogs.length,
                itemBuilder: (context, index) {
                  print(localBlogs.length);
                  final blog = localBlogs.values.elementAt(index);
                  return ListTile(
                    title: Text(blog.uid),
                    subtitle: Text(blog.title),
                    onTap: () {
                      final extraData = {
                        'title': blog.title,
                        'content': blog.content,
                        'htmlPreview': blog.htmlPreview,
                        'userUid': blog.userUid
                      };
                      // print('Sending data: $extraData'); // Debug print
                      context.go(
                        '${AppRouterConstants.newblog}/${blog.uid}',
                        extra: extraData,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Text("Remote Blogs",
                  style: GoogleFonts.spaceGrotesk(fontSize: 18)),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userUid)
                    .collection('Blogs')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return const Center(child: Text('No remote blogs found'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final blog = docs[index].data() as Map<String, dynamic>;
                      if (localBlogs.keys.toList().contains(blog['uid'])) {
                        return const SizedBox.shrink();
                      }
                      return ListTile(
                        title: Text(blog['uid']),
                        subtitle: Text(blog['title']),
                        onTap: () {
                          final extraData = {
                            'title': blog['title'],
                            'content': blog['content'],
                            'htmlPreview': blog['htmlPreview'],
                            'userUid': userUid
                          };
                          // print('Sending data: $extraData'); // Debug print
                          context.go(
                            '${AppRouterConstants.newblog}/${blog['uid']}',
                            extra: extraData,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blogButton(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          border: Border.all(
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          )),
      child: Text(
        'New Blog',
        style: GoogleFonts.robotoMono(fontSize: 24),
      ),
    );
  }
}
