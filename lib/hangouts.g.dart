// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hangouts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return Participant(json['fallback_name'] as String);
}

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{'fallback_name': instance.name};

ConversationMetaData _$ConversationMetaDataFromJson(Map<String, dynamic> json) {
  return ConversationMetaData((json['participant_data'] as List)
      .map((e) => Participant.fromJson(e as Map<String, dynamic>))
      .toList());
}

Map<String, dynamic> _$ConversationMetaDataToJson(
        ConversationMetaData instance) =>
    <String, dynamic>{'participant_data': instance.participants};

ConversationWithId _$ConversationWithIdFromJson(Map<String, dynamic> json) {
  return ConversationWithId(ConversationMetaData.fromJson(
      json['conversation'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ConversationWithIdToJson(ConversationWithId instance) =>
    <String, dynamic>{'conversation': instance.metadata};

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(Event._dateTimeFromEpochUs(json['timestamp'] as String));
}

Map<String, dynamic> _$EventToJson(Event instance) =>
    <String, dynamic>{'timestamp': Event._dateTimeToEpochUs(instance.datetime)};

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return Conversation(
      ConversationWithId.fromJson(json['conversation'] as Map<String, dynamic>),
      (json['events'] as List)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList());
}

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'conversation': instance.internal,
      'events': instance.events
    };

Hangouts _$HangoutsFromJson(Map<String, dynamic> json) {
  return Hangouts((json['conversations'] as List)
      .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
      .toList());
}

Map<String, dynamic> _$HangoutsToJson(Hangouts instance) =>
    <String, dynamic>{'conversations': instance.conversations};
