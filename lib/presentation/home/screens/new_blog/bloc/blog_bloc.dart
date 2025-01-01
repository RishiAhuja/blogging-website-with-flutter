import 'package:blog/domain/entities/blog/blog_entity.dart';
import 'package:blog/domain/services/markdown_service.dart';
import 'package:blog/domain/usecases/hive/update_usecase.dart';
import 'package:blog/presentation/home/screens/new_blog/bloc/blog_event.dart';
import 'package:blog/presentation/home/screens/new_blog/bloc/blog_state.dart';
import 'package:blog/service_locator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class BlogBloc extends HydratedBloc<BlogEvent, BlogState> {
  final MarkdownService markDownService;

  BlogBloc({required this.markDownService})
      : super(BlogEditing(content: '', htmlPreview: '', title: '')) {
    on<ContentChanged>(_onContentChanged);
    on<SaveDraft>(_onSaveDraft);
  }

  void _onContentChanged(ContentChanged event, Emitter<BlogState> emit) {
    final htmlPreview = markDownService.parseMarkdown(event.content);
    print("succesfully emiiting");
    emit(BlogEditing(
      content: event.content,
      htmlPreview: htmlPreview,
      title: event.title,
    ));
  }

  void _onTitleChanged(TitleChanged event, Emitter<BlogState> emit) {
    final currentState = state as BlogEditing;
    emit(BlogEditing(
      content: currentState.content,
      htmlPreview: currentState.htmlPreview,
      title: event.title,
    ));
  }

  void _onSaveDraft(SaveDraft event, Emitter<BlogState> emit) {
    emit(BlogSaving());
    print("saving draft");
    sl<UpdateUsecase>().call(
        params: BlogEntity(
            uid: event.uid,
            content: event.content,
            htmlPreview: event.htmlPreview,
            title: event.title));
    print("saved draft");
    emit(BlogSaved());
  }

  @override
  BlogState? fromJson(Map<String, dynamic> json) {
    try {
      return BlogEditing(
        content: json['content'] as String? ?? '',
        htmlPreview: json['htmlPreview'] as String? ?? '',
        title: json['title'] as String? ?? '',
      );
    } catch (e) {
      print('Error loading blog state from JSON: $e');
      return BlogEditing(content: '', htmlPreview: '', title: '');
    }
  }

  @override
  Map<String, dynamic>? toJson(BlogState state) {
    if (state is BlogEditing) {
      return {
        'content': state.content,
        'htmlPreview': state.htmlPreview,
        'title': state.title,
      };
    }
    return null;
  }
}