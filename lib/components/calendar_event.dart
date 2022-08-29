class Event {
  final String name;
  final String description;
  final String location;
  final updated;
  final startTime;
  final endTime;
  final weekday;

  const Event({
    required this.name,
    required this.description,
    required this.location,
    required this.updated,
    required this.startTime,
    required this.endTime,
    required this.weekday,
  });

  factory Event.fromJson(Map<String, dynamic> data) {
    final name = data['summary'] != null
        ? data['summary'] as String
        : "No summary found";
    final location = data['location'] != null
        ? data['location'] as String
        : "Location not found";
    final description = data['description'] != null
        ? data['description'] as String
        : "No Description found";
    final updated = DateTime.parse(data['updated']);
    final unformatted = data['start']['dateTime'];
    String startDate = '';
    int i = 0;
    while(unformatted[i] != 'T'){
      startDate+=unformatted[i];
      i++;
    }
    i++;
    String startTimeU = '';
    while(unformatted[i] != '-'){
      startTimeU+=unformatted[i];
      i++;
    }

    final unformattedend = data['end']['dateTime'];
    String endDate = '';
    int j = 0;
    while(unformattedend[j] != 'T'){
      endDate+=unformattedend[j];
      j++;
    }
    j++;
    String endTimeU = '';
    while(unformattedend[j] != '-'){
      endTimeU+=unformattedend[j];
      j++;
    }
    final startTime = DateTime.parse(startDate + ' ' + startTimeU);
    final endTime = DateTime.parse(endDate + ' ' + endTimeU);

    final recurrence = data['recurrence'] != null ? data['recurrence'][0] as String : "NO";
    var code = recurrence.substring(recurrence.length - 2);
    int weekday = 0;
    switch (code) {
      case "MO":
        {
          weekday = 1;
        }
        break;
      case "TU":
        {
          weekday = 2;
        }
        break;
      case "WE":
        {
          weekday = 3;
        }
        break;
      case "TH":
        {
          weekday = 4;
        }
        break;
      case "FR":
        {
          weekday = 5;
        }
        break;

      case "SA":
        {
          weekday = 6;
        }
        break;
      case "SU":
        {
          weekday = 7;
        }
        break;
      default:
        {
          weekday  = startTime.weekday;

        }
    }
    return Event(
        name: name,
        description: description,
        updated: updated,
        startTime: startTime,
        endTime: endTime,
        location: location,
        weekday: weekday);
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'updated': updated,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'weekday' : weekday,
    };
  }
}
