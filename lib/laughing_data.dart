List<WeekData> weeksData = [
  WeekData(
    days: [
      DayData(
        day: 0,
        laughs: 4,
      ),
      DayData(
        day: 1,
        laughs: 4,
      ),
      DayData(
        day: 2,
        laughs: 4,
      ),
      DayData(
        day: 3,
        laughs: 4,
      ),
      DayData(
        day: 4,
        laughs: 4,
      ),
      DayData(
        day: 5,
        laughs: 4,
      ),
      DayData(
        day: 6,
        laughs: 4,
      ),
    ],
  ),
  WeekData(
    days: [
      DayData(
        day: 0,
        laughs: 9,
      ),
      DayData(
        day: 1,
        laughs: 6,
      ),
      DayData(
        day: 2,
        laughs: 11,
      ),
      DayData(
        day: 3,
        laughs: 8,
      ),
      DayData(
        day: 4,
        laughs: 14,
      ),
      DayData(
        day: 5,
        laughs: 10,
      ),
      DayData(
        day: 6,
        laughs: 4,
      ),
    ],
  ),
  WeekData(
    days: [
      DayData(
        day: 0,
        laughs: 0,
      ),
      DayData(
        day: 1,
        laughs: 2,
      ),
      DayData(
        day: 2,
        laughs: 3,
      ),
      DayData(
        day: 3,
        laughs: 0,
      ),
      DayData(
        day: 4,
        laughs: 4,
      ),
      DayData(
        day: 5,
        laughs: 3,
      ),
      DayData(
        day: 6,
        laughs: 3,
      ),
    ],
  ),
];

class WeekData {
  WeekData({required this.days});
  List<DayData> days;
}

class DayData {
  DayData({required this.day, required this.laughs});
  int day;
  int laughs;
}
