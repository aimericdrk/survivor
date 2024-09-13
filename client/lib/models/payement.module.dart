class PayementModel {
  final int payementId;
  final double amount;
  final String date;
  final String paymentMethod;
  final String comment;

  PayementModel({
    required this.payementId,
    required this.date,
    required this.paymentMethod,
    required this.amount,
    required this.comment,
  });

  factory PayementModel.fromJson(Map<String, dynamic> json) {
    return PayementModel(
      payementId: json['id'],
      date: json['date'],
      paymentMethod: json['payment_method'],
      amount: json['amount'].toDouble(),
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': payementId,
      'date': date,
      'payment_method': paymentMethod,
      'amount': amount,
      'comment': comment,
    };
  }
}
