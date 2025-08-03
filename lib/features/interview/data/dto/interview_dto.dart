class InterviewDto {
  final String id;
  InterviewDto({required this.id});

  factory InterviewDto.fromJson(Map<String, dynamic> json) {
    return InterviewDto(id: json['_id']);
  }
}