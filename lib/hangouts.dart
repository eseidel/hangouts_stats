import 'package:json_annotation/json_annotation.dart';

part 'hangouts.g.dart';

@JsonSerializable()
class ParticipantId {
  ParticipantId(this.gaia_id);

  String gaia_id;

  factory ParticipantId.fromJson(Map<String, dynamic> json) =>
      _$ParticipantIdFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantIdToJson(this);
}

@JsonSerializable()
class Participant {
  Participant(this.name);

  @JsonKey(name: 'fallback_name')
  String name;

  ParticipantId id;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}

@JsonSerializable()
class ConversationMetaData {
  ConversationMetaData(this.participants);

  @JsonKey(name: 'participant_data', nullable: false)
  List<Participant> participants;

  factory ConversationMetaData.fromJson(Map<String, dynamic> json) =>
      _$ConversationMetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationMetaDataToJson(this);
}

@JsonSerializable()
class ConversationWithId {
  ConversationWithId(this.metadata);

  @JsonKey(name: 'conversation', nullable: false)
  ConversationMetaData metadata;

  factory ConversationWithId.fromJson(Map<String, dynamic> json) =>
      _$ConversationWithIdFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationWithIdToJson(this);
}

@JsonSerializable()
class Event {
  Event(this.datetime);

  @JsonKey(
      name: 'timestamp',
      fromJson: _dateTimeFromEpochUs,
      toJson: _dateTimeToEpochUs,
      nullable: false)
  DateTime datetime;

  @JsonKey(name: 'sender_id')
  ParticipantId senderId;

  static DateTime _dateTimeFromEpochUs(String us) =>
      DateTime.fromMicrosecondsSinceEpoch(int.parse(us));

  static String _dateTimeToEpochUs(DateTime dateTime) =>
      dateTime.microsecondsSinceEpoch.toString();

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}

@JsonSerializable()
class Conversation {
  Conversation(this.internal, this.events);

  @JsonKey(name: 'conversation', nullable: false)
  ConversationWithId internal;

  List<Participant> get participants => internal.metadata.participants;

  @JsonKey(nullable: false)
  List<Event> events;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
}

@JsonSerializable()
class Hangouts {
  Hangouts(this.conversations);

  @JsonKey(nullable: false)
  List<Conversation> conversations;

  factory Hangouts.fromJson(Map<String, dynamic> json) =>
      _$HangoutsFromJson(json);

  Map<String, dynamic> toJson() => _$HangoutsToJson(this);
}
