import '../../components/index'; // 公共vue组件，应全部打包到本入口文件只有一份
import App from './App';
import * as globalvars from './globalvars';
import '@/api';

DictMan.fetch();

Object.assign(Vue.prototype, globalvars.default);

var app = new Vue({
  el: '#app',
  ...App
});

window.app = app;

window.openModuleByCode = function (code, options) {
  var node = Object.assign({}, findFunc(app.$refs.navMenu.menuTreeNodes, code));
  app.openTab(node, options);
  function findFunc(nodes, code) {
      for (var i in nodes) {
          var node = nodes[i];
          if (node.attributes && node.attributes.code == code)
              return node;
          node = findFunc(node.children, code);
          if (node)
              return node;
      }
      return null;
  }
}