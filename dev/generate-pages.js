const fs = require('fs');
const glob = require('glob');
const babel = require("@babel/core");
const types = require('@babel/types');
const template = require('@babel/template');

module.exports = {
  generate: function() {
    /*
    构造：
    export deafult {
      组件1 path: () => import(组件定义源码路径),
      组件2
      组件N
      ...
    }
    */
    let pageProperties = [];
    // 遍历pages中每个index.vue/js
    glob.sync('./src/pages/**/*/index.+(js|vue)').forEach((filename) => {
      let path = /\.\/src\/pages\/(.*?).(js|vue)/.exec(filename)[1];
      
      pageProperties.push(
        types.objectProperty(
          types.stringLiteral(`/${path}`),
          template.expression(`() => import(COMPONENT_PATH)`, {
            plugins: ['dynamicImport']
          })({
            COMPONENT_PATH: types.stringLiteral(`@/pages/${path}`)
          })
        )
      );
    });

    let program = types.program([
      types.exportDefaultDeclaration(
        types.objectExpression(pageProperties))
    ]);

    fs.writeFileSync('src/_pages.js', babel.transformFromAstSync(program).code);
    console.log('已生成: src/_pages.js');
  }
}