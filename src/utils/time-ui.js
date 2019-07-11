const ONE_SECOND = 1000;
const ONE_MINUTE = ONE_SECOND * 60;
const ONE_HOUR = ONE_MINUTE * 60;
const ONE_DAY = ONE_HOUR * 24;

export function toDurationText(time, options) {
  options = options || {};
  const unit = options.unit || 'ms';

  let precisionOrder = 4; // 默认精确到秒
  if (options.precision) {
    precisionOrder = 1 + ['day', 'hour', 'minute', 'seconds'].findIndex(v => v == options.precision);
  }
  
  if (unit == 'day') {
    time *= ONE_DAY;
  }

  let text = '';
  let month = Math.floor(time / (ONE_DAY * 30));
  let d = Math.floor(time % (ONE_DAY * 30) / ONE_DAY);
  let h = Math.floor(time % ONE_DAY / ONE_HOUR);
  let m = Math.floor(time % ONE_DAY % ONE_HOUR / ONE_MINUTE);
  let s = Math.floor(time % ONE_DAY % ONE_HOUR % ONE_MINUTE / ONE_SECOND);
  if (month > 0) text += month + '个月';
  if (month > 0 && d > 0 && precisionOrder > 0) text += '零';
  if (d > 0 && precisionOrder > 0) text += Math.round(d) + '天';
  if (h > 0 && precisionOrder > 1) text += h + '小时';
  if (m > 0 && precisionOrder > 2) text += m + '分钟';
  if (s > 0 && precisionOrder > 3) text += s + '秒';
  return text;
}