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
    let last = event.results.length - 1;
    let text = event.results[last][0].transcript;
  
    let matches = text.match(/^(打开|关闭)(.+)/);
    if (matches) {
      let action = matches[1];
      let name = matches[2];

      switch (action) {
        case '打开':
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
          let func = findFuncByText(app.$refs.navMenu.menuTreeNodes, name);
          if (func) {
            app.openTab(func);
          }
          break;
        case '关闭':
          let tab = app.tabs.find(tab => tab.title == name);
          app.closePage(tab.key);
          break;
      }
    }
    else if (functions[text]) {
      functions[text]();
    }
    console.log(text);
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
    console.error('Error occurred in recognition: ', event .error);
  };  
}

function start() {
  if (recognition == null) {
    init();
  }
  try {
    recognition.start();
  } catch (e) {}
}

export default {
  start
}
