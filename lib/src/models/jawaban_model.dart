import 'package:equatable/equatable.dart';

class JawabanModel extends Equatable {
  final String id, jawaban, nilai;
  JawabanModel({required this.id, required this.jawaban, required this.nilai});
  factory JawabanModel.createJawaban(Map<String, dynamic> data) {
    return JawabanModel(
        id: data['id'].toString(),
        jawaban: data['jawaban'],
        nilai: data['nilai'].toString());
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
