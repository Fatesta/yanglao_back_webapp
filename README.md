# 后台Web前端项目


源码目录:
```
.
├── package.json
├── public              # 这个目录包含老项目的旧有开发方式的模块的源码和资源
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
1. 在`src/pages`目录新建子目录，目录结构按业务分类，新的页面代码文件命名为`index.vue`或`index.js`。  
2. 查看`src/components`存在的可复用组件。也可以创建新的可复用组件（建议必须是常用的）。  
3. 参考已有代码。
4. 尽可能用vue单文件组件。
6. 尽可能使用动态导入`import(...)`
7. 给vue单文件组件增加`_pageProps`属性，例如：
    ```js
    export default {
      _pageProps: {
        title: '新的页面的标题，会作为tab的标题'
      }
    }
    ```
8. 打开新的页面，请使用`app.pushPage`方法，参数说明：
    |参数|说明|类型
    |:-|:-|:-|
    |path|注意不是url，更像一个组件类的id|string|
    |params|参数|object|
    |title|标题，覆盖组件`_pageProps`属性中的title|string|
    |subTitle|子标题|string|
    |key|默认等于path，根据key判断是否已经打开标签页，如果打开了则选中，否则打开新的|string/number|

    示例：
    ```js
    pushPage('/shop/order/index');

    pushPage({
      path: '/user/details/index',
      params: {id: user.id},
    });
    ```
    页面组件实例方法中，通过`this.$params`得到参数。

### 构建
```shell
npm run build
npm run build-dev #或开发（方便调试）版本
```
#### 原理：
值得注意的是，请查看webpack.config.js中的配置，编译开始时会调用 PageDog 插件，这是一个自定义插件，  
它根据上述开发业务页面中所描述的命名约定，自动生成`path`与`import(.)`的映射定义的文件（src/_pages.js），被`app.pushPage` import使用。  
然后webpack继续编译，src/_pages.js也参与了编译，webpack将根据依赖关系，生成业务页面chunk的懒加载代码。

### 部署
使用maven validate，将`/dist`内容复制到`webapp`目录

## 日志
> 2019-05-12:  
> 创建一个新的项目，独立出前端代码作为此项目内容，新的代码将采用前后端分离模式，使用es6, webpack, babel, vue,element-ui框架等。  
因此将会增加至少一个构建过程。