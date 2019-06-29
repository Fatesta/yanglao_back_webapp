<template>
  <el-card shadow="never"
    v-infinite-scroll="load"
    body-style="overflow:auto"
  >
    <el-card
      v-for="resthome in resthomePage.rows"
      :key="resthome.id"
      class="resthome"
    >
      <div slot="header">
        {{resthome.name}}
      </div>
      <div style="text-align:center">
        <el-button type="text" @click="onCheckinClick(resthome)">入住管理</el-button>
        <el-button type="text" @click="onCheckinRecordClick(resthome)">入住记录</el-button>
        <el-button type="text" @click="onBerthSettingClick(resthome)">床位设置</el-button>
        <el-button type="text" @click="onBerthTypeSettingClick(resthome)">床位类型管理</el-button>
      </div>
    </el-card>

    <el-alert
      v-if="loading"
      class="load-info"
      title="加载中..."
      type="info"
      center
      :closable="false"
    />
    <el-alert
      v-if="noMore"
      class="load-info"
      title="没有更多了"
      type="warning"
      center
      :closable="false"
    />
  </el-card>
</template>

<script>
export default {
  data() {
    return {
      resthomePage: {
        rows: [],
        total: 0
      },
      loading: true,
      noMore: false,
      // 分页相关
      pageSize: 20,
      currentPage: 1
    };
  },
  methods: {
    onCheckinClick(resthome) {
      app.pushPage({
        path: '/resthome/checkin/index',
        params: { resthome },
        subTitle: resthome.name,
        key: resthome.id
      });
    },
    onCheckinRecordClick(resthome) {

    },
    onBerthSettingClick(resthome) {

    },
    onBerthTypeSettingClick(resthome) {

    },
    async load() {
      if (this.noMore) {
        return;
      }
      this.loading = true;
      this.currentPage++;
      let page = await this.axios.get('/api/resthome',
        {params: { rows: this.pageSize, page: this.currentPage }});
      this.resthomePage = {rows: this.resthomePage.rows.concat(page.rows)};
      this.noMore = page.rows == 0;
      this.loading = false;
    }
  },
  mounted() {
    this.load();
  }
}
</script>

<style scoped>
.resthome {
  width: 340px;
  height: 130px;
  margin: 10px 10px;
  float: left;
}
.resthome:hover {
  font-weight: bolder;
}

.load-info {
  clear: both;
  width: 300px;
  margin: 0 auto;
  text-align: center;
}
</style>
