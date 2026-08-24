class TrialLog {
  final String sessionId;
  final String trialId;
  final String trialType; // READING (r), LETTER_SEARCH (s), READING_LOCAL (rl), EVALUATION_TEST (e)
  final int trialStartTime; // millisecondsSinceEpoch
  int? trialEndTime; // millisecondsSinceEpoch
  String? conditionId;
  String? conditionName;
  String? comment;
  bool validTrial;
  bool assistanceGiven;
  bool interrupted;
  bool technicalIssue;
  String? invalidReason;

  TrialLog({
    required this.sessionId,
    required this.trialId,
    required this.trialType,
    required this.trialStartTime,
    this.trialEndTime,
    this.conditionId,
    this.conditionName,
    this.comment,
    this.validTrial = true,
    this.assistanceGiven = false,
    this.interrupted = false,
    this.technicalIssue = false,
    this.invalidReason,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'trialId': trialId,
      'trialType': trialType,
      'trialStartTime': trialStartTime,
      'trialEndTime': trialEndTime,
      'conditionId': conditionId,
      'conditionName': conditionName,
      'comment': comment,
      'validTrial': validTrial ? 1 : 0,
      'assistanceGiven': assistanceGiven ? 1 : 0,
      'interrupted': interrupted ? 1 : 0,
      'technicalIssue': technicalIssue ? 1 : 0,
      'invalidReason': invalidReason,
    };
  }

  factory TrialLog.fromMap(Map<String, dynamic> map) {
    return TrialLog(
      sessionId: map['sessionId'] as String,
      trialId: map['trialId'] as String,
      trialType: map['trialType'] as String,
      trialStartTime: (map['trialStartTime'] as num).toInt(),
      trialEndTime: map['trialEndTime'] != null ? (map['trialEndTime'] as num).toInt() : null,
      conditionId: map['conditionId'] as String?,
      conditionName: map['conditionName'] as String?,
      comment: map['comment'] as String?,
      validTrial: map['validTrial'] == 1 || map['validTrial'] == true,
      assistanceGiven: map['assistanceGiven'] == 1 || map['assistanceGiven'] == true,
      interrupted: map['interrupted'] == 1 || map['interrupted'] == true,
      technicalIssue: map['technicalIssue'] == 1 || map['technicalIssue'] == true,
      invalidReason: map['invalidReason'] as String?,
    );
  }
}
