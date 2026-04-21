import 'package:intl/intl.dart';
import 'package:sams_app/core/utils/constants/api_keys.dart';

class CommentDetails {
  final String id;           
  final String content;
  final String date;
  final String userName;
  final String authorAcademicId; 
  final String? profilePic;      

  CommentDetails({
    required this.id,
    required this.content,
    required this.date,
    required this.userName,
    required this.authorAcademicId,
    this.profilePic,
  });

  factory CommentDetails.fromJson(Map<String, dynamic> json) {
    final author = json[ApiKeys.author] as Map<String, dynamic>?;

    String rawDate = json[ApiKeys.commentedAt] ?? '';
    String formattedDate = rawDate;

    if (rawDate.isNotEmpty) {
      try {
        DateFormat inputFormat = DateFormat('M/d/yyyy, h:mm:ss a');
        DateTime parsedDate = inputFormat.parse(rawDate);
        
        formattedDate = DateFormat('MMM d, h:mm a').format(parsedDate);
      } catch (e) {
        formattedDate = rawDate;
      }
    }

    return CommentDetails(
      id: json[ApiKeys.id] ?? '',
      content: json[ApiKeys.content] ?? '',
      date: formattedDate, 
      userName: author?[ApiKeys.name] ?? 'User',
      authorAcademicId: author?[ApiKeys.academicId] ?? '',
      profilePic: author?[ApiKeys.profilePic],
    );
  }
}