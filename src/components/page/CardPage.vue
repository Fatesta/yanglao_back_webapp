<template>
  <el-card
    style="
      margin: 4px 6px 3px 4px;
      min-height: calc(100vh - 112px);
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
    bodyStyle: [Object, String],
    default() {
      return {padding: '20px'}
    }
  }
}
</script>
