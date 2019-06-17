const path = require('path');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const glob = require('glob');
const webpack = require('webpack');
const Jarvis = require("webpack-jarvis");

/* 创建多个入口描述，出口输出目录将与源目录一致 */
//遍历pages中每个index.js，
var entries = {};
const jsfilenames = glob.sync('./src/pages/**/*/index.+(js|vue)');
jsfilenames.forEach((filename) => {
  let name = /\.\/src\/(.*?).(js|vue)/.exec(filename)[1];
  entries[name] = filename;
});

entries['index'] = './src/index.js';
entries['vendors'] = ['@babel/polyfill', 'core-js', 'vue', 'vue-router', 'element-ui', 'moment', 'qs'];

module.exports = {
  mode: process.env.NODE_ENV,
  entry: entries,
  output: {
    filename: '[name].js',
    libraryTarget: 'amd'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            cacheDirectory: true
          }
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
      },
      {
        test: /\.(eot|svg|ttf|woff|woff2)$/,
        loader: 'file-loader'
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.vue', '.json'],
    alias: {
      '@': path.join(__dirname, '', 'src'),
      vue: 'vue/dist/vue.runtime.esm.js'
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
        name:'common'
    }
  },
  plugins: [
    new VueLoaderPlugin(),
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    //new CleanWebpackPlugin(-)
    new CopyWebpackPlugin([
      { from: './public/' },
      { from: './src/index.css' }
    ]),
    new Jarvis({
      watchOnly: true,
      port: 3000
    })
  ]
};