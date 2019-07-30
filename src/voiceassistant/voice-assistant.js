import makeGrammars from './grammars';
import fullScreen from '@/utils/fullscreen';

// 定义 操作名
const functions = {
  '展开导航菜单': () => {
    app.$refs.navMenu.expand();
  },
  '收缩导航菜单': () => {
    app.$refs.navMenu.collapse();
  },
  '进入全屏': () => {
    fullScreen.enter();
  },
  '退出全屏': () => {
    fullScreen.exit();
  },
  '退出': () => {
    app.logout();
  }
};

const SpeechRecognition = SpeechRecognition || webkitSpeechRecognition
const SpeechGrammarList = SpeechGrammarList || webkitSpeechGrammarList
//const SpeechRecognitionEvent = SpeechRecognitionEvent || webkitSpeechRecognitionEvent

let recognition = null;
let recognzing = true;
var speechSynthesisUtterance = new window.SpeechSynthesisUtterance();
speechSynthesisUtterance.onstart = () => {
  recognzing = false;
  recognition.stop();
};
speechSynthesisUtterance.onend = () => {
  if (!recognzing) {
    recognzing = true;
    recognition.start();
  }
};
function speak(text) {
  speechSynthesisUtterance.text = text;
  window.speechSynthesis.speak(speechSynthesisUtterance);
}

function init() {
  recognition = new SpeechRecognition();

  let speechRecognitionList = new SpeechGrammarList();
  let grammars = makeGrammars();
  for (let i = 0; i < grammars.length; i++) {
    speechRecognitionList.addFromString(grammars[i], i + 1);
  }
  recognition.grammars = speechRecognitionList;

  recognition.continuous = true;
  recognition.lang = 'zh-CN';
  recognition.interimResults = false;
  recognition.maxAlternatives = 1;
  
  recognition.onresult = function(event) {
    if (!recognzing) {
      return;
    }

    let text = event.results[0][0].transcript;

    console.log(text);

    let matches = null;

    if (text == '如何说') {
      speak(`你可以说以下几类短语：
        1 打开或关闭菜单功能，例如说 打开设置，关闭设置；
        2 展开导航菜单；
        3 收缩导航菜单；
        4 退出全屏；
        5 退出，即退出系统；`);
      return;
    }
    matches = text.match(/^旋转(\d+)度$/);
    if (matches) {
      document.body.style.transform = `rotate(${matches[1]}deg)`;
      return;
    }
    matches = text.match(/^(打开|关闭)(.+)/);
    if (matches) {
      let action = matches[1];
      let name = matches[2];

      function findFuncByText(nodes, text) {
        for (var i in nodes) {
          var node = nodes[i];
          if (node.text == text)
            return node;
          node = findFuncByText(node.children, name);
          if (node)
            return node;
        }
        return null;
      }
      switch (action) {
        case '打开':
          let func = findFuncByText(app.$refs.navMenu.menuTreeNodes, name);
          if (func) {
            if (func.children.length) {
              app.$refs.navMenu.$refs.menu.open(func.id.toString());
            } else {
              app.openTab(func);
            }
          } else {
            speak('不能打开 ' + name);
          }
          break;
        case '关闭':
          let tab = app.tabs.find(tab => tab.title == name);
          if (tab) {
            app.closePage(tab.key);
          } else {
            let func = findFuncByText(app.$refs.navMenu.menuTreeNodes, name);
            if (func && func.children.length) {
              app.$refs.navMenu.$refs.menu.close(func.id.toString());
            } else {
              speak('不能关闭 ' + name);
            }
          }
          break;
      }
    }
    else if (functions[text]) {
      functions[text]();
    }
  };
  
  recognition.onend = function() {
    setTimeout(() => {
      start();
    }, 2000);
  };

  recognition.onerror = function(event) {
    setTimeout(() => {
      start();
    }, 2000);
    if (event.error == 'network') {
      app.$message.error('语音识别服务器连接失败，语音助手无法工作');
    }
    console.error('Error occurred in recognition: ', event .error);
  };  
}

function start() {
  if (recognition == null) {
    init();
  }
  try {
    recognition.start();
    recognzing = true;
  } catch (e) {}
}

export default {
  start
}
