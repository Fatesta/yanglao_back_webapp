function makeGrammars() {
  // 语法数组
  let grammars = [];

  // 遍历系统导航菜单树生成页面名数组
  function toNameArray(nodes) {
    var names = [];
    for (let node of nodes) {
      names.push(node.text);
      if (node.children.length)
        names = names.concat(toNameArray(node.children));
    }
    return names;
  }
  var pages = toNameArray(app.$refs.navMenu.menuTreeNodes);

  grammars.push(`
    #JSGF V1.0;
    grammar cmd;
    public <cmd> = <pageCmd> | <other>;
    <pageCmd> = (打开 | 关闭) <page>;
    <page> = ${pages.join(' | ')};
    <other> = ((展开 | 收缩) 导航菜单) | 进入 * 全屏 | 退出全屏 | 退出;
  `);

  return grammars;
}
export default makeGrammars;