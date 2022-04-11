String convertToTwelveHour(int time) {
  String formattedTime, meridiem;
  var hour = (time / 100).floor() - 12;
  var minute = time % 100;

  if (hour >= 12) {
    meridiem = 'PM';
  } else {
    meridiem = 'AM';
  }

  if (hour == 0) {
    hour = 12;
  }

  if (minute < 10) {
    formattedTime = '$hour:0$minute $meridiem';
  } else {
    formattedTime = '$hour:$minute $meridiem';
  }
  return formattedTime;
}
