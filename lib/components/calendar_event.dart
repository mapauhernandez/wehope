class Event {
  final String name;
  final String description;
  final String location;
  final  updated;
  final  startTime;
  final  endTime;

  const Event({
    required this.name,
    required this.description,
    required this.location,
    required this.updated,
    required this.startTime,
    required this.endTime,

  });

  factory Event.fromJson(Map<String, dynamic> data) {
    final name = data['summary'] as String;
    final location = data['location'] as String;
    final description = data['description'] as String;
    final updated = data['updated'];
    final startTime = data['start']['dateTime'];
    final endTime = data['end']['dateTime'];

    return Event(name: name, description: description, updated: updated, startTime: startTime, endTime: endTime, location: location);
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'description' : description,
      'updated' : updated,
      'startTime' : startTime,
      'endTime' : endTime,
      'location' : location,

    };
  }
}