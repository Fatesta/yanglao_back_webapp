<template>
  <el-dialog
    :title="title"
    :visible.sync="visible"
    width="600px"
    center
    :close-on-click-modal="false"
    @close="onClose"
  >

    <video controls ref="video" :src="src" style="width:100%;height:400px" />
  </el-dialog>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
      default: "视频"
    }
  },
  data() {
    return {
      visible: false,
      src: ''
    }
  },
  methods: {
    async show(options) {
      this.visible = true;
      this.src = options.src;
      if (this.$refs.video) {
        this.$refs.video.load();
      }
    },
    onClose() {
      const { video } = this.$refs;
      video.pause();
    }
  }
}
</script>

<style scoped>
video {
  margin: 0 auto;
  display: block;
  outline: none;
}
>>> .el-dialog__body {
  background: #111;
}
</style>