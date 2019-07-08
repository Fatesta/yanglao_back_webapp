<template>
  <el-card
    style="
      margin: 4px 6px 4px 4px;
      min-height: calc(100vh - 114px);
    "
    :body-style="bodyStyle"
    v-bind="$attrs"
    shadow="never"
  >
    <slot></slot>
  </el-card>
</template>

<script>
export default {
  name: 'card-page',
  inheritAttrs: false,
  props: {
    bodyStyle: Object,
    default() {
      return {padding: '20px'}
    }
  }
}
</script>
