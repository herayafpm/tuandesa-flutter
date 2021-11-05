import 'package:bloc/bloc.dart';
import 'package:tuandesa/src/models/aduan_model.dart';

abstract class AduanEvent {}

class GetAduan extends AduanEvent {
  int id;
  GetAduan({required this.id});
}

class RefreshAduan extends AduanEvent {}

abstract class AduanState {}

class AduanUninitialized extends AduanState {}

class AduanLoaded extends AduanState {
  List<AduanModel> aduans;
  bool hasReach;
  AduanLoaded({required this.aduans, required this.hasReach});

  AduanLoaded copyWith({List<AduanModel>? aduans, required bool hasReach}) {
    return AduanLoaded(
      aduans: aduans ?? this.aduans,
      hasReach: hasReach,
    );
  }
}

class AduanBloc extends Bloc<AduanEvent, AduanState> {
  AduanBloc(AduanState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  AduanState get initialState => AduanUninitialized();

  @override
  Stream<AduanState> mapEventToState(AduanEvent event) async* {
    if (event is GetAduan) {
      // GetAduan getAduan = event as GetAduan;
      // print(getAduan.id);
      List<AduanModel> aduans;
      if (state is AduanUninitialized) {
        aduans = await AduanModel.getData(4, 0);
        yield AduanLoaded(aduans: aduans, hasReach: false);
      } else {
        AduanLoaded aduanLoaded = state as AduanLoaded;
        aduans = await AduanModel.getData(4, aduanLoaded.aduans.length);
        yield (aduans.isEmpty)
            ? aduanLoaded.copyWith(hasReach: true)
            : AduanLoaded(aduans: aduanLoaded.aduans + aduans, hasReach: false);
      }
    } else if (event is RefreshAduan) {
      List<AduanModel> aduans;
      aduans = await AduanModel.getData(4, 0);
      yield AduanLoaded(aduans: aduans, hasReach: false);
    }
  }
}
