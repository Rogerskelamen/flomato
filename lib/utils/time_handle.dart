// 返回当日零点时刻
DateTime getTodayBegin() {
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day
  );
}

// 用于在倒计时UI中显示
String displayDuration(Duration time) {
  // 如果时间小于一小时，不显示hours
  if (time.inHours % 24 == 0) {
    return (time.inMinutes % 60).toString() + ' : '
         + (time.inSeconds % 60).toString();
  } else {
    return (time.inHours % 24).toString() + ' : '
         + (time.inMinutes % 60).toString() + ' : '
         + (time.inSeconds % 60).toString();
  }
}

// 用于在时钟列表的副标题中显示
String displayLast(Duration time) {
  if (time.inHours % 24 == 0) {
    return (time.inMinutes % 60).toString() + '分钟';
  }else {
    return (time.inHours % 24).toString() + '小时'
         + (time.inMinutes % 60).toString() + '分钟';
  }
}