# 后台Web前端项目


## 源码目录
```
.
├── package.json
├── public              # 这个目录包含老项目的旧有开发方式（jquery,easyui,iframe,jsp）的模块的源码和资源
├── dev                 # 开发工具源码
├── src                 # 源码
│   ├── components      # 公共/抽象组件  
│   ├── config          # 配置相关
│   ├── pages           # 业务页面
│   └── index.js        # SPA主入口
│   └── pages.js        # 页面配置
│   └── index.html      # html模板
│   └── index.css       # 基本的全局的样式
└── webpack.config.js
```

## 开发流程
### 安装依赖
```shell
npm i
```

### 开发新业务页面
1.在`src/pages`目录新建子目录，目录结构按业务分类，新的页面代码文件命名为`[name]Page.vue`或`[name]Page.js`。    
2.查看`src/components`存在的可复用组件。也可以创建新的可复用组件（建议必须是常用的）。    
3.参考已有代码。  
4.尽可能用vue单文件组件。  
6.尽可能使用动态导入`import(...)`  
7.给vue单文件组件增加`pageProps`属性，例如：  
```js
export default {
  pageProps: {
    title: '新的页面的标题，会作为tab的标题'
  }
}
```
8.打开新的页面，请使用`app.pushPage`方法，参数说明：

|参数|说明|类型
|:-|:-|:-|
|path|注意不是url，更像一个组件类的id|string|
|params|参数|object|
|title|标题，覆盖组件`pageProps`属性中的title|string|
|subTitle|子标题|string|
|key|默认等于path，根据key判断是否已经打开标签页，如果打开了则选中，否则打开新的|string/number|

示例：
```js
app.pushPage('/shop/order/index');

app.pushPage({
  path: '/user/edit',
  params: {id: user.id},
});
```
页面组件实例方法中，通过`this.$params`得到参数。

#### pushPage的实现原理（ [源码](https://github.com/hulang1024/yanglao_back_webapp/blob/master/src/App.vue#L273) ）
1. 将path + 可选的key 作为tab的key，判断是否已经打开标签页，如果打开了则选中，结束，否则下一步。
2. 按照路径与页面vue/js的映射表（src/pages.js，下文将提到），查询出页面对象，  
该页面对象实际上是一个请求页面组件js并返回Promise的函数，执行请求页面的函数，得到真正的页面组件，组件实际上是一个对象。  
因此可以得到它的`pageProps属性`，以及增加`$params` props。

#### 与pushPage类似的另一个方法: app.openTab（ [源码](https://github.com/hulang1024/yanglao_back_webapp/blob/master/src/App.vue#L336) ）
`app.openTab`是为了兼容旧有代码而存在的，在以前，window.openModuleByCode、window.openTab将打开一个新的content为iframe的easyui tab。  
现在，这些方法的实现将变为对`app.openTab`的调用，而`app.openTab`根据url判断:
- 后缀如果是`.do`，则识别为老页面，用一个渲染iframe的vue组件包装起来，并且[解决easyui模板闪现的问题](https://github.com/hulang1024/yanglao_back_webapp/blob/master/src/App.vue#L396)。
- 后缀如果是`.js`，这是新开发模式页面的url表示方式，转换为对`app.pushPage`的调用。


### 开发调试
```shell
npm start
```

### 构建
```shell
npm run build
```
#### 原理：
值得注意的是，请查看webpack.config.js中的配置，编译开始时会调用 PageDog 插件，这是一个自定义插件，  
它根据上述开发业务页面中所描述的命名约定，自动生成页面组件路径（pushPage的path参数）与`import(页面组件路径)`的映射定义的文件（src/pages.js），被`app.pushPage`使用。  
然后webpack继续编译，src/pages.js也参与了编译，webpack将根据依赖关系，生成业务页面chunk的懒加载代码。

### 部署
将`/dist`内容复制到`webapp`目录
```shell
npm run copy-dev
```

## 日志
> 2019-05-12:  
> 创建一个新的项目，独立出前端代码作为此项目内容，新的代码将采用前后端分离模式，使用es6, webpack, babel, vue,element-ui框架等。  
因此将会增加至少一个构建过程。