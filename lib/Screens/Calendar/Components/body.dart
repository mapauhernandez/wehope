import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wehope/Screens/Login/Components/background.dart';
import 'package:wehope/components/rounded_input_field.dart';
import 'package:wehope/Screens/Preferences/preferences_screen.dart';

import '../../../components/calendar.dart';
import '../../../components/extended_text.dart';
import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../../constants.dart';
import '../../../constants.dart';
import '../../../utils.dart';
import 'event_list.dart';
import '../../Settings/settings_screen.dart';

import 'package:http/http.dart' as http;

import 'package:maps_launcher/maps_launcher.dart';

import 'package:table_calendar/table_calendar.dart';

class CalendarBody extends StatefulWidget {
  const CalendarBody({Key? key}) : super(key: key);

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  @override
  void initState() {
    _getTypes();
    super.initState();
    _getUsername();
    _getNotifPref();
    _getLocations();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  int currentIndex = 0;
  String _username = "No name";
  String _enabled = "Unknown";
  List<String> _locations = List.empty(growable: true);
  List<String> _type_list = List.empty(growable: true);
  bool updated = false;

  Map apis = new Map();

  void _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = (prefs.getString('username') ?? "??");
    });
  }

  void _getNotifPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.containsKey('notifs')
          ? prefs.getBool('notifs')!
              ? "Enabled"
              : "Disabled"
          : 'Disabled';
    });
  }

  void _getTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _type_list = prefs.getStringList('types')!;
    });
  }

  void _getLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations = prefs.getStringList('locations')!;
    });
    for (var loc in _locations) {
      for (var type in _type_list) {
        if (loc == 'SF' && type == 'Dignity on Wheels') {
          apis['SF-DOW'] =
              'https://www.googleapis.com/calendar/v3/calendars/fdm09jjfsg4ll5lsbn4o24q6o8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'East Bay' && type == 'Dignity on Wheels') {
          apis['East Bay-DOW'] =
              'https://www.googleapis.com/calendar/v3/calendars/03bgjolvc1prh750i0m9qujddc@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'South Bay' && type == 'Dignity on Wheels') {
          apis['South Bay-DOW'] =
              'https://www.googleapis.com/calendar/v3/calendars/extreme.wehope@gmail.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Peninsula' && type == 'Dignity on Wheels') {
          apis['Peninsula-DOW'] =
              'https://www.googleapis.com/calendar/v3/calendars/a01n633sb75lqben0i41uhmog8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'LA' && type == 'Dignity on Wheels') {
          apis['LA-DOW'] =
              'https://www.googleapis.com/calendar/v3/calendars/o58iv89dhfspkqo50pkrvtjho8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Marin' && type == 'Dignity on Wheels') {
          apis['Marin-DOW'] =
              'https://www.googleapis.com/calendar/v3/calendars/1f1pdjh8rdsi4ccgus8qhtniao@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'SF' && type == 'Beauty') {
          apis['SF-B'] =
          'https://www.googleapis.com/calendar/v3/calendars/pj91tsbmctbuk395p15llvcn34@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'East Bay' && type == 'Beauty') {
          apis['East Bay-B'] =
          'https://www.googleapis.com/calendar/v3/calendars/vmiprjv5i5qukvbp1pn8cvmn8g@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'South Bay'  && type == 'Beauty') {
          apis['South Bay-B'] =
          'https://www.googleapis.com/calendar/v3/calendars/ju4ilmj9cj9omtfanh5sp3j1u4@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Peninsula' && type == 'Beauty') {
          apis['Peninsula-B'] =
          'https://www.googleapis.com/calendar/v3/calendars/5ksb6c2otl837pd96jqgucqggc@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'LA'  && type == 'Beauty') {
          apis['LA-B'] =
          'https://www.googleapis.com/calendar/v3/calendars/jg5b0j4rdqona4s3r6l0sjq02g@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Marin'  && type == 'Beauty') {
          apis['Marin-B'] =
          'https://www.googleapis.com/calendar/v3/calendars/h71236au321ogc5v5uh023rq1o@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'SF' && type == 'Casework') {
          apis['SF-CW'] =
          'https://www.googleapis.com/calendar/v3/calendars/58anp4lmijosl0a2277mh7k5hs@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'East Bay' && type == 'Casework') {
          apis['East Bay-CW'] =
          'https://www.googleapis.com/calendar/v3/calendars/rhcgkobu2nteadc2qq1gof4pik@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'South Bay' && type == 'Casework') {
          apis['South Bay-CW'] =
          'https://www.googleapis.com/calendar/v3/calendars/squ26o8occ0m5704erv9lq9m4o@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Peninsula' && type == 'Casework') {
          apis['Peninsula-CW'] =
          'https://www.googleapis.com/calendar/v3/calendars/f10nh977rn38nf36fanu3j44ck@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'LA' && type == 'Casework') {
          apis['LA-CW'] =
          'https://www.googleapis.com/calendar/v3/calendars/a3uq0g1khhmniadmkllktnq05g@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Marin' && type == 'Casework') {
          apis['Marin-CW'] =
          'https://www.googleapis.com/calendar/v3/calendars/p8dk4sla9ck1phn8dn2t0k1pjk@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'SF' && type == 'Education') {
          apis['SF-Edu'] =
          'https://www.googleapis.com/calendar/v3/calendars/oh9js5h72kmckifvfssmtqifks@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'East Bay' && type == 'Education') {
          apis['East Bay-Edu'] =
          'https://www.googleapis.com/calendar/v3/calendars/gc6dohpkvj46n5rk46knvj3db8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'South Bay' && type == 'Education') {
          apis['South Bay-Edu'] =
          'https://www.googleapis.com/calendar/v3/calendars/sdg0qu3hl65hsv5jisqm26jirk@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Peninsula' && type == 'Education') {
          apis['Peninsula-Edu'] =
          'https://www.googleapis.com/calendar/v3/calendars/l1mujfljoeotcvicg03bv5cnt4@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'LA' && type == 'Education') {
          apis['LA-Edu'] =
          'https://www.googleapis.com/calendar/v3/calendars/0gi1b8ab2n2absjvi7lan73us0@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Marin' && type == 'Education') {
          apis['Marin-Edu'] =
          'https://www.googleapis.com/calendar/v3/calendars/nvrdg2lfipapcjdocgcvr9j1v4@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'SF' && type == 'Medical') {
          apis['SF-med'] =
          'https://www.googleapis.com/calendar/v3/calendars/kjsc3ndkm2gd4l9nengd6pmh4o@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'East Bay' && type == 'Medical') {
          apis['East Bay-med'] =
          'https://www.googleapis.com/calendar/v3/calendars/bfvluerpp3rs1undkpsmvpd7a8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'South Bay' && type == 'Medical') {
          apis['South Bay-med'] =
          'https://www.googleapis.com/calendar/v3/calendars/0jnr1j69mj9v3fjm5hdbnf9hac@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Peninsula' && type == 'Medical') {
          apis['Peninsula-med'] =
          'https://www.googleapis.com/calendar/v3/calendars/telnat3ibc2mqadj59q6rmpbh4@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'LA' && type == 'Medical') {
          apis['LA-med'] =
          'https://www.googleapis.com/calendar/v3/calendars/cvvdu84o0uoaltqlcion6peek4@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Marin' && type == 'Medical') {
          apis['Marin-med'] =
          'https://www.googleapis.com/calendar/v3/calendars/0lt7hl7gejd689kkfvn9geaeb0@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'SF' && type == 'Other') {
          apis['SF'] =
          'https://www.googleapis.com/calendar/v3/calendars/a0p8g2o53t8ikm6enon99icu00@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'East Bay' && type == 'Other') {
          apis['East Bay'] =
          'https://www.googleapis.com/calendar/v3/calendars/78v6595d0rfi586enu45r6m8c0@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'South Bay' && type == 'Other') {
          apis['South Bay'] =
          'https://www.googleapis.com/calendar/v3/calendars/f080m7rsrmoodrafv4r158rmk0@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Peninsula' && type == 'Other') {
          apis['Peninsula'] =
          'https://www.googleapis.com/calendar/v3/calendars/rpfemitfhepvpprqf0a24ej1t0@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'LA' && type == 'Other') {
          apis['LA'] =
          'https://www.googleapis.com/calendar/v3/calendars/3l9epuqibma5ecc73qi18oeigg@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
        if (loc == 'Marin' && type == 'Other') {
          apis['Marin'] =
          'https://www.googleapis.com/calendar/v3/calendars/jq2djstfuc1gmb5d69t6dbdu3c@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
        }
      }
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Calendar> events = [];
    List<Color> colors = [];
    int count = 0;

    final children = <Widget>[];
    Color col = Colors.black;

    for (var i = 0; i < _locations.length; i++) {
      if (_locations[i] == 'SF') {
        col = kPrimaryLightColor;
      }
      if (_locations[i] == 'East Bay') {
        col = Colors.amber;
      }
      if (_locations[i] == 'South Bay') {
        col = Colors.deepPurpleAccent;
      }
      if (_locations[i] == 'Peninsula') {
        col = Colors.red;
      }
      if (_locations[i] == 'LA') {
        col = Colors.orangeAccent;
      }
      if (_locations[i] == 'Marin') {
        col = Colors.pink;
      }
      children.add(new Text(
        textAlign: TextAlign.center,
        _locations[i],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: col,
        ),
      ));
      children.add(new Text(
        textAlign: TextAlign.center,
        ' ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: col,
        ),
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Text(
              "Hello ",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
            Text(
              _username,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.1),
            Text(
              textAlign: TextAlign.center,
              "This is what your week looks like in ",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
        TableCalendar<Event>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
          ),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            markersMaxCount: 1,
            todayDecoration: BoxDecoration(
              color: kPrimaryLightColor,
              shape: BoxShape.circle,
            ),
          ),
          onDaySelected: _onDaySelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        FutureBuilder<List<Calendar>>(
          future: fetchCalendars(http.Client(), apis),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return EventList(
                calendars: snapshot.data!,
                colors: colors,
                count: count,
                day: _focusedDay,
                eventType: [
                  "DoW",
                  "Beauty",
                  "Casework",
                  "Education",
                  "Medical",
                  "Other"
                ],
              );
            } else {
              return const Text("Loading");
            }
          },
        )
      ],
    );
  }
}
