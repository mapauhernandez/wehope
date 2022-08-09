
import 'dart:collection';
import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

import 'calendar_event.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Calendar> fetchCalendars(http.Client client, List<String> locations) async {
  final response = await client
      .get(Uri.parse('https://www.googleapis.com/calendar/v3/calendars/fdm09jjfsg4ll5lsbn4o24q6o8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseCalendars, response.body);
}

// A function that converts a response body into a List<Photo>.
Calendar parseCalendars(String responseBody) {
  Map<String, dynamic> parsed = json.decode(responseBody);
  return Calendar.fromJson(parsed);
}

class Calendar {
  final String calID;
  final String name;
  final List<Event> events;

  const Calendar({
    required this.calID,
    required this.name,
    required this.events,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) {
    final eventData = json['items'] as List<dynamic>?;
    // if the reviews are not missing
    final events = eventData != null
    // map each review to a Review object
        ? eventData.map((reviewData) => Event.fromJson(reviewData))
    // map() returns an Iterable so we convert it to a List
        .toList()
    // use an empty list as fallback value
        : <Event>[];
    // return result passing all the arguments
    return Calendar(
      calID: json['etag'] as String,
      name: json['summary'] as String,
      events: events,
    );
  }
}
