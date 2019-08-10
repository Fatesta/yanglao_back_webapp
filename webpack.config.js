const path = require('path');
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const webpack = require('webpack');
const PageDog = require('./dev/PageDog');
const Jarvis = require("webpack-jarvis");


const mode = process.env.NODE_ENV;
const sourcePath = path.join(__dirname, '/src');
const publicPath = path.join(__dirname, '/public');

module.exports = {
  mode,
  entry: {
    index: './src/index'
  },
  output: {
    filename: mode == 'development' ? '[name].[hash:8].js' : '[name].[chunkhash].js',
    chunkFilename: '[chunkhash].js',
    path: path.join(__dirname, '/dist')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        include: [
          sourcePath
        ],
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
          { loader: 'style-loader' },
          { loader: 'css-loader' }
        ]
      },
      {
        test: /\.scss$/,
        use: [
          { loader: 'style-loader' },
          { loader: 'css-loader' },
          { loader: 'sass-loader' }
        ]
      },
      {
        test: /\.(eot|svg|ttf|woff|woff2)$/,
        loader: 'file-loader'
      },
      {
        test: /\.(png|jpg|gif)$/,
        loader: 'url-loader',
        options: {
          limit: 5000,
          name: 'assets/[hash:8].[name].[ext]'
        }
      },
    ]
  },
  resolve: {
    extensions: ['.js', '.vue', '.json'],
    alias: {
      '@': sourcePath,
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
    mode == 'development' && new webpack.HotModuleReplacementPlugin(),
    mode == 'production' && new PageDog(), // 条件是为了修正在启动热更新情况下出现反复编译现象，所以必须先运行npm run build产生pages.js
    new VueLoaderPlugin(),
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    new CleanWebpackPlugin(),
    new CopyWebpackPlugin([
      mode == 'production' &&
      { from: './public/', copyUnmodified: false },
      { from: './src/index.css' }
    ].filter(Boolean)),
    new HtmlWebpackPlugin({
      template: './src/index.html',
      inject: 'body',
      hash: false,
      minify: {
        collapseWhitespace: true
      },
      chunks: ['webpack', 'common', 'index'],
    }),
    new Jarvis({
      watchOnly: true,
      port: 3000
    })
  ].filter(Boolean),
  devServer: {
    proxy: [
      // 新开发模式后端服务器API路径
      {
        context: ['/api'],
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      // 兼容旧开发模式Spring控制器URL
      {
        context: ['**/*.do'],
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      // 兼容旧开发模式代码引用的资源
      {
        context: ['/module', '/lib', '/images', '/css', '/statics'],
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    ],
    contentBase: 'dist',
    inline: true,
    port: 8888,
    compress: true,
    hot: true,
    open: true,
    overlay: {
      errors: true
    }
  },
};