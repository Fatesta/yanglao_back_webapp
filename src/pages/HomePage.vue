<template>
  <plain-page
    style="
      display: flex;
      flex-wrap: wrap;
      justify-content: center;"
  >
    <el-card shadow="hover" style="width: 600px;">
      <div slot="header">
        操作提示
      </div>
      <p style="margin-top: 0px;">点击左侧导航菜单项目打开功能。</p>
      <p>点击导航菜单下方 <i class="el-icon-s-fold" /> 来收缩 或 <i class="el-icon-s-unfold" /> 来展开导航菜单。</p>
      <p style="margin-bottom: 8px;">快捷键提示：</p>  
      <el-card shadow="never">
        <el-row class="op-tip-row">
          <el-col :span="5" class="op-text-col">关闭标签页</el-col>
          <el-col :span="14" class="op-keys-col"><span class="key">Esc</span></el-col>
        </el-row>
        <el-row class="op-tip-row">
          <el-col :span="5" class="op-text-col">退出</el-col>
          <el-col :span="14" class="op-keys-col"><span class="key">Esc</span></el-col>
        </el-row>
        <el-row class="op-tip-row">
          <el-col :span="5" class="op-text-col">打开设置</el-col>
          <el-col :span="14" class="op-keys-col">
            <span class="key">Ctrl</span>
            <span class="key">S</span>
          </el-col>
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
