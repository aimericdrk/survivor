class EncounterModel {
  final int id;
  final int customerId;
  final int rating;
  final String date;
  final String comment;
  final String source;

  EncounterModel({
    required this.id,
    required this.rating,
    required this.customerId,
    required this.date,
    required this.comment,
    required this.source,
  });

  factory EncounterModel.fromJson(Map<String, dynamic> json) {
    return EncounterModel(
      id: json['id'],
      customerId: json['customer_id'],
      date: json['date'],
      rating: json['rating'],
      comment: json['comment'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'date': date,
      'rating': rating,
      'comment': comment,
      'source': source,
    };
  }
}
