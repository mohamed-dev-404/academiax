enum MeetingStateEnum {
  ongoing,
  ended,
  scheduled
  ;

  static MeetingStateEnum fromString(String status) {
    return switch (status.toUpperCase()) {
      'ONGOING' => MeetingStateEnum.ongoing,
      'SCHEDULED' => MeetingStateEnum.scheduled,
      'ENDED' => MeetingStateEnum.ended,
      _ => MeetingStateEnum.ended,
    };
  }
}
