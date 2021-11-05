import 'package:bloc/bloc.dart';
import 'package:tuandesa/src/models/comment_model.dart';

abstract class CommentEvent {}

class GetComment extends CommentEvent {
  String id;
  GetComment({required this.id});
}

class RefreshComment extends CommentEvent {
  String id;
  RefreshComment({required this.id});
}

abstract class CommentState {}

class CommentUninitialized extends CommentState {}

class CommentLoaded extends CommentState {
  List<CommentModel> comments;
  bool hasReach;
  CommentLoaded({required this.comments, required this.hasReach});

  CommentLoaded copyWith(
      {List<CommentModel>? comments, required bool hasReach}) {
    return CommentLoaded(
      comments: comments ?? [],
      hasReach: hasReach,
    );
  }
}

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc(CommentState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  CommentState get initialState => CommentUninitialized();

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is GetComment) {
      GetComment getComment = event as GetComment;
      List<CommentModel> comments;
      if (state is CommentUninitialized) {
        comments = await CommentModel.getData(getComment.id, 6, 0);
        yield CommentLoaded(comments: comments, hasReach: false);
      } else {
        CommentLoaded commentLoaded = state as CommentLoaded;
        comments = await CommentModel.getData(
            getComment.id, 6, commentLoaded.comments.length);
        yield (comments.isEmpty)
            ? commentLoaded.copyWith(hasReach: true)
            : CommentLoaded(
                comments: commentLoaded.comments + comments, hasReach: false);
      }
    } else if (event is RefreshComment) {
      RefreshComment refreshComment = event as RefreshComment;
      List<CommentModel> comments;
      comments = await CommentModel.getData(refreshComment.id, 6, 0);
      yield CommentLoaded(comments: comments, hasReach: false);
    }
  }
}
