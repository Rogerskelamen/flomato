DateTime getTodayBegin() {
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day
  );
}

String displayDuration(Duration time) {
  return (time.inHours % 24).toString() + ' : '
         + (time.inMinutes % 60).toString() + ' : '
         + (time.inSeconds % 60).toString();
}