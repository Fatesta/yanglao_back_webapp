<template>
  <card-page
    style="
      width: 700px;
      margin-left: auto;
      margin-right: auto;"
  >
    <div class="section">
      通过智能语音助手（在“设置”中启动），您就能以语音指令的方式来使用本软件。
    </div>
    <div class="section">
      <h1>语音指令</h1>
      对着麦克风，你可以说以下几类短语：
      <ul>
        <li>打开使用手册：<el-tag type="info">打开使用手册</el-tag></li>
        <li>打开或关闭菜单功能，例如说：<el-tag type="info">打开设置</el-tag>，<el-tag type="info">关闭设置</el-tag>
          、<el-tag type="info">打开用户管理</el-tag></li>
        <li><el-tag type="info">展开导航菜单</el-tag>、<el-tag type="info">收缩导航菜单</el-tag></li>
        <li><el-tag type="info">退出全屏</el-tag></li>
        <li>退出系统：<el-tag type="info">退出</el-tag></li>
      </ul>
    </div>
    <div class="section">
      <h1>运行条件</h1>
      <ol>
        <li>
          当前网络必须能够（使用VPN）访问
          <el-link
            type="primary"
            target="_blank"
            underline
            href="https://www.google.com"
            style="top: -2px;">google.com</el-link>。</li>
        <li>启用麦克风。</li>
      </ol>
    </div>
  </card-page>
</template>

<script>
export default {
  pageProps: {
    title: '智能语音助手使用手册'
  }
}
</script>


<style scoped>
.el-card >>> .el-card__header {
  font-weight: bold;
}
.section {
  margin-top: 40px;
}
li {
  line-height: 30px;
}
</style>
