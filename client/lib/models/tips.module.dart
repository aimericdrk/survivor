class TipsModel {
  final String title;
  final String tips;

  TipsModel({
    required this.title,
    required this.tips,
  });

  factory TipsModel.fromJson(Map<String, dynamic> json) {
    return TipsModel(
      title: json['title'],
      tips: json['tip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'tip': tips,
    };
  }
}
