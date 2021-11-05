import 'dart:convert';

import 'package:equatable/equatable.dart';

class ResponseModel extends Equatable {
  final bool status;
  final String messages;
  final String data;
  ResponseModel(
      {required this.status, required this.messages, required this.data});
  factory ResponseModel.fromJson(Map<String, dynamic> data) {
    return ResponseModel(
        status: data['status'],
        messages: data['messages'],
        data: json.encode(data['data']));
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
