List weeksData = <WeekData>[
  WeekData(
    days: [
      DayData(
        day: 0,
        laughs: 12,
      ),
      DayData(
        day: 1,
        laughs: 4,
      ),
      DayData(
        day: 2,
        laughs: 8,
      ),
      DayData(
        day: 3,
        laughs: 2,
      ),
      DayData(
        day: 4,
        laughs: 1,
      ),
      DayData(
        day: 5,
        laughs: 4,
      ),
      DayData(
        day: 6,
        laughs: 18,
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
        laughs: 4,
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
        laughs: 1,
      ),
      DayData(
        day: 4,
        laughs: 2,
      ),
      DayData(
        day: 5,
        laughs: 8,
      ),
      DayData(
        day: 6,
        laughs: 7,
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
