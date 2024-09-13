class EventModel {
  final int id;
  final int duration;
  final int maxParticipants;
  final String name;
  final String date;
  final String locationX;
  final String locationY;
  final String type;
  final String locationName;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.duration,
    required this.locationX,
    required this.locationY,
    required this.type,
    required this.locationName,
    required this.maxParticipants,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      duration: json['duration'],
      locationX: json['location_x'],
      locationY: json['location_y'],
      type: json['type'],
      locationName: json['location_name'],
      maxParticipants: json['max_participants'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'duration': duration,
      'location_x': locationX,
      'location_y': locationY,
      'type': type,
      'location_name': locationName,
      'max_participants': maxParticipants,
    };
  }
}
