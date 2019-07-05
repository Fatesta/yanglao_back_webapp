export function toDurationText(time, unit) {
  unit = unit || 'ms';
  if (unit == 'ms') {
      time /= (1000 * 60 * 60 * 24);
  }
  var text = '';
  var m = parseInt(time / 30);
  var d = time % 30;
  if (m > 0) text += m + '个月';
  if (m > 0 && d > 0) text += '零';
  if (d >= 0) text += Math.round(d) + '天';
  return text;
}