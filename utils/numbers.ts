export function minutesBetweenDateAndNow(dateStr: Date) {
  // Both contain the number of milliseconds elapsed since January 1, 1970 00:00:00 UTC.
  let now = Date.now();
  let date = new Date(dateStr).valueOf();

  return now - date;
}
