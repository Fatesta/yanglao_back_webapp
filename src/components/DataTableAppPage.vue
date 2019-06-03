<template>
  <el-card class="box-card" shadow="never">
    <data-table-app-view>
      <slot></slot>
    </data-table-app-view>
  </el-card>
</template>

<script>
export default {
  name: 'data-table-app-page'
}
</script>
