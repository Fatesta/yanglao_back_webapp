function enter(element) {
  element = element || document.documentElement;

  const enterFullscreen = element.requestFullScreen
    || element.msRequestFullscreen
    || element.mozRequestFullScreen
    || element.webkitRequestFullScreen;
  if (enterFullscreen) {
    enterFullscreen.call(element);
  } else {
    alert("当前浏览器不支持全屏");
  }
}

function exit() {
  const exitFullscreen = document.exitFullscreen
    || document.mozCancelFullScreen
    || document.webkitCancelFullScreen
    || document.msExitFullscreen
    || document.oCancelFullScreen;
  exitFullscreen.call(document);
}

export default {
  switch: () => {
    let isFullScreen = window.fullScreen
      || document.webkitIsFullScreen
      || document.msFullscreenEnabled;
    if (isFullScreen) {
      exit();
    } else {
      enter();
    }
  },
  enter,
  exit
};