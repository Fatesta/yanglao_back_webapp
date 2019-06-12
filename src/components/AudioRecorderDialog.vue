<template>
  <el-dialog
    title="音频录制"
    :visible.sync="visible"
    width="360px"
    center
    :modal="false"
    v-loading="loading"
    :close="onClose"
  >

    <audio controls ref="audio" v-show="state == 'play'" />
    <div v-show="state != 'play'">
      <div class="time">{{timeText}}</div>
      <div class="record-button" @click="onRecordClick">
        <div :class="state"></div>
      </div>
    </div>
    <span
      slot="footer"
      v-show="state == 'play'"
    >
      <el-button type="default" plain @click="onRestart">重录</el-button>
      <el-button type="primary" plain @click="onOk">确定</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  data() {
    return {
      visible: false,
      loading: true,
      state: 'start',
      timeText: ''
    }
  },
  methods: {
    async show(options) {
      this.visible = true;
      requirejs(['/lib/recorder/recorder.min.js'], (Recorder) => {
        if (!Recorder.isRecordingSupported()) {
          this.$alert('对不起，不支持当前环境');
          return;
        }
        this.timer = new Timer((text) => this.timeText = text);
        this.recorder = new Recorder({
          encoderPath: '/lib/recorder/waveWorker.min.js'
        });
        this.recorder.onstart = () => {
          this.$refs.audio.src = null;
          this.blod = null;
          this.timer.start();
        };
        this.recorder.onstop = () => {
          this.timer.stop();
        };
        this.recorder.ondataavailable = (typedArray) => {
          this.blod = new Blob([typedArray], {type: 'audio/wav'});
          this.$refs.audio.src = URL.createObjectURL(this.blod);
        };
        this.state = 'start';
        this.loading = false;
        this.options = options;
      });
    },
    onRecordClick() {
      switch (this.state) {
        case 'start':
          this.recorder.start();
          this.state = 'stop';
          break;
        case 'stop':
          this.recorder.stop();
          this.state = 'play';
          break;
      }
    },
    onRestart() {
      this.$refs.audio.pause();
      this.timer.clear();
      this.state = 'start';
    },
    onOk() {
      this.options.onSuccess({blod: this.blod, objectUrl: this.objectUrl});
      this.visible = false;
    },
    onClose() {
      this.timer.stop();
    },
  }
}

class Timer {
  constructor(timeText) {
    this.timeText = timeText;
    this.timer = null;
    this.clear();
  }

  start() {
    let seconds = 0;
    this.timer = setInterval(() => {
      this.updateTimeText(++seconds);
    }, 1000);
  }

  stop() {
    clearInterval(this.timer);
  }

  clear() {
    this.updateTimeText(0);
  }

  updateTimeText(seconds) {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    const leftPad0 = n => n > 9 ? n : '0' + n;
    this.timeText(leftPad0(m) + ':' + leftPad0(s));
  }
}

</script>

<style scoped>
.time {
  text-align: center;
  width: 100%;
  margin-bottom: 16px;
}
.record-button {
  position: relative;
  width: 50px;
  height: 50px;
  background: transparent;
  margin: 0 auto;
  border: 1px solid #ccc;
  border-radius: 100%;
  cursor: pointer;
}
.record-button > div {
  position: relative;
  background: deeppink;
}
.record-button > .start {
  top: 5px;
  left: 5px;
  width: 40px;
  height: 40px;
  border-radius: 100%;
}
.record-button > .start:hover {
  background: red;
}
.record-button > .stop {
  top: 11px;
  left: 11px;
  width: 28px;
  height: 28px;
  border-radius: 4px;
}

audio {
  margin: 0 auto;
  display: block;
  outline: none;
}
</style>