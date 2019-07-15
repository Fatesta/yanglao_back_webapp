<template>
  <el-dialog
    :title="title"
    :visible.sync="visible"
    width="400px"
    center
    :modal="false"
    :close-on-click-modal="false"
    @close="onClose"
  >

    <audio controls ref="audio" :src="src" />
  </el-dialog>
</template>

<script>
export default {
  props: {
    title: String,
    default: "音频"
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
      if (this.$refs.audio) {
        this.$refs.audio.load();
      }
    },
    onClose() {
      const { audio } = this.$refs;
      audio.pause();
    }
  }
}
</script>

<style scoped>
audio {
  margin: 0 auto;
  display: block;
  outline: none;
}
</style>