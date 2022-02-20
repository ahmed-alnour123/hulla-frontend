import 'package:flutter/material.dart';

Future<DateTimeRange?> selectDateRange(BuildContext context) async {
  final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      currentDate: DateTime.now(),
      firstDate: DateTime(2020, 5),
      lastDate: DateTime(2101, 11));

  return picked;
}

Future<DateTime?> selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020, 5),
      lastDate: DateTime(2101, 11),
      initialDate: DateTime.now());

  return picked;
}
