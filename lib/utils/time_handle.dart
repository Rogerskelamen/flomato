DateTime getTodayBegin() {
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day
  );
}

String displayDuration(Duration time) {
  if (time.inHours % 24 == 0) {
    return (time.inMinutes % 60).toString() + ' : '
         + (time.inSeconds % 60).toString();
  } else {
    return (time.inHours % 24).toString() + ' : '
          + (time.inMinutes % 60).toString() + ' : '
          + (time.inSeconds % 60).toString();
  }
}