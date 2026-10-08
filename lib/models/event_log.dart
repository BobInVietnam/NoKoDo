import 'dart:convert';

class EventLog {
  final String trialId;
  final String eventId; // e.g. S0001_20200101_1_02_r_009_highlight
  final String eventType;
  final int eventTimestamp; // millisecondsSinceEpoch
  final Map<String, dynamic> payloadJson;

  EventLog({
    required this.trialId,
    required this.eventId,
    required this.eventType,
    required this.eventTimestamp,
    required this.payloadJson,
  });

  Map<String, dynamic> toMap() {
    return {
      'trialId': trialId,
      'eventId': eventId,
      'eventType': eventType,
      'eventTimestamp': eventTimestamp,
      'payloadJson': jsonEncode(payloadJson),
    };
  }

  factory EventLog.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic> parsedPayload = {};
    if (map['payloadJson'] != null) {
      if (map['payloadJson'] is String) {
        try {
          parsedPayload =
              jsonDecode(map['payloadJson'] as String) as Map<String, dynamic>;
        } catch (_) {
          parsedPayload = {};
        }
      } else if (map['payloadJson'] is Map<String, dynamic>) {
        parsedPayload = map['payloadJson'] as Map<String, dynamic>;
      }
    }

    return EventLog(
      trialId: map['trialId'] as String,
      eventId: map['eventId'] as String,
      eventType: map['eventType'] as String,
      eventTimestamp: (map['eventTimestamp'] as num).toInt(),
      payloadJson: parsedPayload,
    );
  }
}
