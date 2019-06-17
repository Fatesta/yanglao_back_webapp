模块以及子模块中的jsp、js、css、图片等资源放在本目录下。  
如果是子模块共享的，放在父模块的根目录。

1. 如果有多个css、图片等文件，要创建它们的目录
2. 目录结构规范如下：
```text
  模块名\
    js
      index.js 
      userManage.js
    css
      style.css
    img
      ear.png
```

3. 不要直接引用根路径，而用${modulePath}和CONFIG.modulePath等类似的变量，
以让以后根目录可变化。

规范创建于：2018-12-26，
注：之前的旧代码，如果有时间，慢慢过度到本规范