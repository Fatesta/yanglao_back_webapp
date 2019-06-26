const fs = require('fs');
const glob = require('glob');
const babel = require("@babel/core");
const types = require('@babel/types');
const template = require('@babel/template');
const { hyphen } = require('naming-style');

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
    // 遍历pages中每个**Page.vue/js
    glob.sync('./src/pages/**/*/**Page.+(js|vue)').forEach((filename) => {
      let path = /\.\/src\/pages\/(.*?).(js|vue)/.exec(filename)[1];
      const nameIndex = path.lastIndexOf('/');
      let name = path.substring(nameIndex + 1);
      name = hyphen(name.substring(0, name.length - 4)).toLowerCase();

      let idPath = path.substring(0, nameIndex + 1) + name;
      
      pageProperties.push(
        types.objectProperty(
          types.stringLiteral(`/${idPath}`),
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

    fs.writeFileSync('src/pages.js', babel.transformFromAstSync(program).code);
    console.log('已生成: src/pages.js');
  }
}