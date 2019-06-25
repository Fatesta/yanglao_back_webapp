const path = require('path');
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const webpack = require('webpack');
const PageDog = require('./dev/PageDog');
const Jarvis = require("webpack-jarvis");


module.exports = {
  mode: process.env.NODE_ENV,
  entry: {
    index: './src/index'
  },
  output: {
    filename: '[name].[chunkhash].js',
    chunkFilename: '[chunkhash].js',
    path: path.join(__dirname, '/dist')
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
      chunks: "all", // 包括异步
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
        name:'webpack' //独立出清单变化
    }
  },
  plugins: [
    new PageDog(),
    new VueLoaderPlugin(),
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    new CleanWebpackPlugin(),
    new CopyWebpackPlugin([
      process.env.NODE_ENV == 'production' &&
      { from: './public/', copyUnmodified: false },
      { from: './src/index.html' },
      { from: './src/index.css' }
    ]),
    new HtmlWebpackPlugin({
      template: 'src/index.html',
      inject: 'body',
      hash: false,
      minify: true,
      chunks: ['webpack', 'common', 'index'],
    }),
    new Jarvis({
      watchOnly: true,
      port: 3000
    })
  ]
};