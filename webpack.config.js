const path = require('path');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const glob = require('glob');

/* 创建多个入口描述，出口输出目录将与源目录一致 */
//遍历pages中每个index.js，
var entries = {};
const jsfilenames = glob.sync('./src/pages/**/*/index.+(js|vue)');
jsfilenames.forEach((filename) => {
  let name = /\.\/src\/(.*?).(js|vue)/.exec(filename)[1];
  entries[name] = filename;
});

entries['vendors'] = ['@babel/polyfill'];

module.exports = {
  mode: process.env.NODE_ENV,
  entry: entries,
  output: {
    filename: '[name].js',
    path: path.join(__dirname, '..', 'hbManager/src/main/webapp'),
    libraryTarget: 'amd'
  },
  externals: [
    function(context, request, callback) {
      // 公共组件代码不打包到单个页面代码中
      if (request.startsWith('@/components')) {
        callback(null, 'root ' + request);
      } else {
        callback();
      }
    }
  ],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.vue$/,
        use: {
          loader: 'vue-loader'
        }
      },
      {
        test: /\.css$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              //modules: true,
              //localIdentName: '[hash:base64:5]',
              //camelCase: true
            }
          }
        ]
      }
    ]
  },
  resolve: {
    // 自动补全的扩展名
    extensions: ['.js', '.vue', '.json'],
    // 默认路径代理
    // 例如 import Vue from 'vue'，会自动到 'vue/dist/vue.common.js'中寻找
    alias: {
      '@': path.join(__dirname, '', 'src'),
      //'@config': resolve('config'),
      //'vue$': 'vue/dist/vue.common.js'
    }
  },
  optimization: {
    splitChunks: {
      chunks: "initial",
      cacheGroups: {
        vendors: {
          test: /[\\/]node_modules[\\/]/,
          minSize: Infinity,
          priority: -10
        },
        utilCommon: {
          name: "common",
          minSize: 0,
          minChunks: 2,
          priority: -20
        }
      }
    },
    runtimeChunk: {
        name:'webpack.runtime'
    }
  },
  plugins: [
    new VueLoaderPlugin()
    //new CleanWebpackPlugin(-)//危险，不需要
  ]
};