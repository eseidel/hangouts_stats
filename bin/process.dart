import 'dart:convert';
import 'dart:io';

import 'package:chat_graphs/hangouts.dart';

dynamic main() {
  var jsonString = File('Hangouts.json').readAsStringSync();
  Map json = jsonDecode(jsonString);
  Hangouts hangouts = Hangouts.fromJson(json);
  hangouts.conversations.forEach((conversation) {
    List<String> names = conversation.participants
        .map<String>((participant) => participant.name)
        .toList();
    print(names);
  });
}
