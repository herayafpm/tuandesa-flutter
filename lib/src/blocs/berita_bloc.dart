import 'package:bloc/bloc.dart';
import 'package:tuandesa/src/models/berita_model.dart';

abstract class BeritaEvent {}

class GetBerita extends BeritaEvent {}

class RefreshBerita extends BeritaEvent {}

abstract class BeritaState {}

class BeritaUninitialized extends BeritaState {}

class BeritaLoaded extends BeritaState {
  List<BeritaModel> beritas;
  bool hasReach;
  BeritaLoaded({required this.beritas, required this.hasReach});

  BeritaLoaded copyWith({List<BeritaModel>? beritas, required bool hasReach}) {
    return BeritaLoaded(
      beritas: beritas ?? this.beritas,
      hasReach: hasReach,
    );
  }
}

class BeritaBloc extends Bloc<BeritaEvent, BeritaState> {
  BeritaBloc(BeritaState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  BeritaState get initialState => BeritaUninitialized();

  @override
  Stream<BeritaState> mapEventToState(BeritaEvent event) async* {
    if (event is GetBerita) {
      List<BeritaModel> beritas;
      if (state is BeritaUninitialized) {
        beritas = await BeritaModel.getData(4, 0);
        yield BeritaLoaded(beritas: beritas, hasReach: false);
      } else {
        BeritaLoaded beritaLoaded = state as BeritaLoaded;
        beritas = await BeritaModel.getData(4, beritaLoaded.beritas.length);
        yield (beritas.isEmpty)
            ? beritaLoaded.copyWith(hasReach: true)
            : BeritaLoaded(
                beritas: beritaLoaded.beritas + beritas, hasReach: false);
      }
    } else if (event is RefreshBerita) {
      List<BeritaModel> beritas;
      beritas = await BeritaModel.getData(4, 0);
      yield BeritaLoaded(beritas: beritas, hasReach: false);
    }
  }
}
