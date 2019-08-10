<template>
  <plain-page
    style="
      display: flex;
      flex-wrap: wrap;
      justify-content: center;"
  >
    <el-card shadow="hover" style="width: 600px;">
      <div slot="header">
        欢迎使用
      </div>
      <p style="margin-top: 0px;">点击左侧导航菜单项目打开功能。</p>
      <p>点击导航菜单下方 <i class="el-icon-s-fold" /> 来收缩 或 <i class="el-icon-s-unfold" /> 来展开导航菜单。</p>
      <p style="margin-bottom: 8px;">快捷键：</p>  
      <el-card shadow="never">
        <el-row class="op-tip-row">
          <el-col :span="5" class="op-text-col">关闭标签页</el-col>
          <el-col :span="14" class="op-keys-col"><span class="key">Esc</span></el-col>
        </el-row>
        <el-row class="op-tip-row">
          <el-col :span="5" class="op-text-col">退出</el-col>
          <el-col :span="14" class="op-keys-col"><span class="key">Esc</span></el-col>
        </el-row>
      </el-card>
    </el-card>
  </plain-page>
</template>

<script>
export default {
  pageProps: {
    title: '首页'
  }
}
</script>

<style scoped>
.op-tip-row {
  line-height: 32px;
}
.op-text-col {
  text-align: left;
}
.op-keys-col {
  text-align: left;
}
.key {
  display: inline-block;
  padding: 1px 4px;
  min-width: 32px;
  background: #f4f4f5;
  color: #909399;
  border: 1px solid #e9e9eb;
  border-radius: 4px;
  font-size: 14px;
  text-align: center;
  line-height: 20px;
  vertical-align: middle;
}
</style>
