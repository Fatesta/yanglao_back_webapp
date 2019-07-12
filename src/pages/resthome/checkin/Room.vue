<template>
  <el-card
    class="room"
    :body-style="{
      'display': 'grid',
      'grid-template-columns': '1fr 1fr',
      'justify-items': 'center',
      'align-items': 'center',
      'gap': '8px 8px',
      'padding': '8px'
    }">
    <div slot="header">
      房{{room.roomNo}}
      <span style="color:#909399">{{room.remark}}</span>
    </div>
    <RoomBerth
      v-for="berth in room.berths"
      :key="berth.id"
      :berth="berth"
    />
  </el-card>
</template>
<script>
import RoomBerth from './RoomBerth.vue';

export default {
  components: {
    RoomBerth
  },
  props: {
    room: Object
  }
}
</script>

<style scoped>
.room {
  position: relative;
  float: left;
  width: 408px;
  margin-left: 8px;
  margin-top: 8px;
  font-size: 14px;
  color: #606266;
}
.room >>> .el-card__header {
  padding: 9px 10px;
  font-weight: 500;
}
</style>
