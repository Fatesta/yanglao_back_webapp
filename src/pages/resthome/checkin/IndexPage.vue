<template>
  <el-card shadow="never" v-loading="loading">
    <el-tabs tab-position="top" :value="activeBuilding.id" @tab-click="onBuildingTabClick">
      <el-tab-pane
        v-for="building in buildings"
        :key="building.id"
        :name="building.id"
        :label="building.name || building.buildingNo"
      />
    </el-tabs>
    <el-tabs tab-position="left" :value="activeFloorNo" @tab-click="onFloorTabClick">
      <el-tab-pane
        v-for="num in activeBuilding.floorsNum"
        :key="activeBuilding.floorsNum - num + 1"
        :name="activeBuilding.floorsNum - num + 1"
        :label="`${activeBuilding.floorsNum - num + 1}层`"
      >
        <div
          class="rooms"
          v-loading="roomsLoading"
          element-loading-text="加载房间中">
          <room
            v-for="room in rooms"
            :key="room.id"
            :room="room"
          />
          <el-alert
            v-if="!roomsLoading && rooms.length == 0"
            class="load-info"
            title="没有房间。"
            type="info"
            center
            :closable="false"
          />
        </div>
      </el-tab-pane>
    </el-tabs>
  </el-card>
</template>

<script>
import Room from './Room.vue';

export default {
  pageProps: {
    title: '入住管理'
  },
  components: {
    Room
  },
  data() {
    return {
      loading: true,
      roomsLoading: false,
      buildings: [],
      rooms: [],
      activeBuilding: {},
      activeFloorNo: 1
    };
  },
  computed: {
    buildingMap() {
      let map = {};
      for (let b of this.buildings) {
        map[b.id] = b;
      }
      return map;
    }
  },
  methods: {
    onBuildingTabClick(tab) {
      this.activeBuilding = this.buildingMap[tab.paneName];
      this.rooms = [];
      this.activeFloorNo = 1;
      this.queryRooms(this.activeBuilding.id, this.activeFloorNo);
    },
    onFloorTabClick(tab) {
      this.queryRooms(this.activeBuilding.id, tab.paneName);
    },
    async queryRooms(buildingId, floorNo) {
      this.roomsLoading = true;
      this.rooms = [];
      this.rooms = await this.axios.get('/api/community/berth/checkin/rooms', {params: {buildingId, floorNo}});
      this.roomsLoading = false;
    }
  },
  async mounted() {
    this.buildings = (await this.axios.get('/api/community/berth/berthSetting/building/page',
      {params: {rows: 100, page: 1}})).rows;
    this.activeBuilding = this.buildings[0];
    this.loading = false;
    this.queryRooms(this.activeBuilding.id, this.activeFloorNo);
  }
}
</script>

<style scoped>
.rooms {
  display: flex;
  flex-wrap: wrap;
  padding-bottom: 10px;
  min-height: 430px;
}
.el-tabs >>> .el-tabs__content {
  overflow: auto;
}
</style>

