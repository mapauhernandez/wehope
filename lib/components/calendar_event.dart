class Event {
  final String name;
  final String description;
  final String location;
  final updated;
  final startTime;
  final endTime;
  final weekday;
  final recurrence;
  final endDate;
  final cancelled;
  final code;
  final startDate;

  const Event({
    required this.name,
    required this.description,
    required this.location,
    required this.updated,
    required this.startTime,
    required this.endTime,
    required this.weekday,
    required this.recurrence,
    required this.endDate,
    required this.cancelled,
    required this.code,
    required this.startDate,
  });

  factory Event.fromJson(Map<String, dynamic> data) {
    if (data['status'] != 'cancelled') {
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
      String startDateD = '';
      int i = 0;
      final recurrence =
      data['recurrence'] != null ? data['recurrence'][0] as String : "SINGLE";
      DateTime endDate;

      var startTime;
      var endTime;

      while (unformatted[i] != 'T') {
        startDateD += unformatted[i];
        i++;
      }
      i++;
      String startTimeU = '';
      while (unformatted[i] != 'Z' && unformatted[i] != '-') {
        startTimeU += unformatted[i];
        i++;
      }
      bool weirdTime = false;
      if (unformatted[i] == 'Z') {
        weirdTime = true;
      }

      final unformattedend = data['end']['dateTime'];
      String endDateT = '';
      int j = 0;
      while (unformattedend[j] != 'T') {
        endDateT += unformattedend[j];
        j++;
      }
      j++;
      String endTimeU = '';
      while (unformattedend[j] != 'Z' && unformattedend[j] != '-') {
        endTimeU += unformattedend[j];
        j++;
      }
      var startDate = DateTime.parse(startDateD);
      startTime = DateTime.parse(startDateD + ' ' + startTimeU);
      endTime = DateTime.parse(endDateT + ' ' + endTimeU);

      if (weirdTime) {
        startTime = startTime.subtract(const Duration(hours: 7));
        endTime = endTime.subtract(const Duration(hours: 7));
      }

      var code =
      recurrence != null ? recurrence.substring(recurrence.length - 2) : "NO";
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
            weekday = startTime.weekday;
          }
      }

      String test = "";
      endDate = DateTime(2030);
      if (recurrence != null) {
        if (recurrence.contains("UNTIL")) {
          int k = 0;
          while (recurrence[k] != ';') {
            k++;
          }
          k++;
          while (recurrence[k] != 'L') {
            k++;
          }
          k++;
          k++;
          while (recurrence[k] != 'T') {
            test += recurrence[k];
            k++;
          }
          endDate = DateTime.parse(test);
        }
      } else if (recurrence != "SINGLE") {
        endDate = DateTime(2030);
      }
      return Event(
        name: name,
        description: description,
        updated: updated,
        startTime: startTime,
        endTime: endTime,
        location: location,
        weekday: weekday,
        recurrence: recurrence,
        endDate: endDate,
        cancelled: false,
        code: data['id'] == null ? "NOID" : data['id'],
        startDate: startDate,
      );
    }
    else {
      return Event(
        name: "Cancelled event",
        description: "This event was cancelled for this date",
        updated: DateTime(2030),
        startTime: DateTime(2030),
        endTime: DateTime(2030),
        startDate: DateTime(2030),
        location: "873 Grove St",
        weekday: 1,
        recurrence: "SINGLE",
        endDate: DateTime(2030),
        cancelled: true,
        code: data['recurringEventId'],
      );

    }
  }

    Map<String, dynamic> toJson() {
      return {
        'name': name,
        'description': description,
        'updated': updated,
        'startTime': startTime,
        'endTime': endTime,
        'location': location,
        'weekday': weekday,
        'endDate': endDate,
        'code':  code,
      };
    }
}
