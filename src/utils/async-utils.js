export function waitNotNull(valueFunc) {
  return new Promise((resolve) => {
    // 先马上检查一次
    setTimeout(() => {
      let value = valueFunc();
      if (value) {
        resolve(value);
      }
    }, 0);
    // 定时检查
    let timer = setInterval(() => {
      let value = valueFunc();
      // 如果值不为空
      if (value) {
        clearInterval(timer);
        resolve(value);
      }
    }, 50);
  });
}