<template>
  <card-page
    v-infinite-scroll="load"
    body-style="overflow:auto;"
  >
    <el-card
      v-for="resthome in resthomePage.rows"
      :key="resthome.id"
      class="resthome"
    >
      <div slot="header" style="color:#303133;font-size: 16px;">
        {{resthome.name}}
      </div>
      <div class="stat">
        <div class="item">总床位数：<span class="number">{{resthome.berthCount}}</span></div>
        <div class="item">已入住数：<span class="number" style="color:#F56C6C">{{resthome.usedBerthCount}}</span></div>
        <div class="item">空床位数：<span class="number" style="color:#67C23A">{{resthome.emptyBerthCount}}</span></div>
      </div>
      <div class="operations">
        <el-button type="primary" plain @click="onCheckinClick(resthome)">入住管理</el-button>
        <el-button type="default" @click="onCheckinRecordClick(resthome)">入住记录</el-button>
        <el-button type="default" @click="onBerthSettingClick(resthome)">床位设置</el-button>
        <el-button type="default" @click="onBerthTypeSettingClick(resthome)">床位类型管理</el-button>
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
  </card-page>
</template>

<script>
export default {
  data() {
    return {
      resthomePage: {
        rows: [],
        total: 0
      },
      loading: false,
      noMore: false,
      // 分页相关
      pageSize: 20,
      currentPage: 1
    };
  },
  mounted() {
    app.$refs.navMenu.collapsed = true;
    this.load();
  },
  methods: {
    onCheckinClick(resthome) {
      if (resthome.berthCount == 0) {
        this.$alert('无床位数据');
        return;
      }
      this.pushPage({
        path: '/resthome/checkin/index',
        params: { resthome },
        subTitle: resthome.name,
        key: resthome.id
      });
    },
    onCheckinRecordClick(resthome) {
      this.pushPage({
        path: '/resthome/checkin/record/checkin-record',
        params: {
          resthomeId: resthome.id
        },
        subTitle: resthome.name
      });
    },
    onBerthSettingClick(resthome) {
      openTab({
        url: 'view/community/berth/berthSetting/index.do?_func_id=397&resthome_id=' + resthome.id,
        title: resthome.name + ' - 床位设置'
      });
    },
    onBerthTypeSettingClick(resthome) {
      openTab({
        url: 'view/community/berth/berthType/index.do?_func_id=400&resthome_id=' + resthome.id,
        title: resthome.name + ' - 床位类型设置'
      });
    },
    async load() {
      if (this.noMore || this.loading) {
        return;
      }
      this.loading = true;
      let page = await this.axios.get('/api/resthome',
        {params: { rows: this.pageSize, page: this.currentPage }});
      this.resthomePage = {rows: this.resthomePage.rows.concat(page.rows)};
      this.currentPage++;
      this.noMore = page.rows == 0;
      this.loading = false;
    }
  }
}
</script>

<style scoped>
.resthome {
  width: 400px;
  height: 160px;
  margin: 8px 8px;
  float: left;
}

.stat {
  color: #909399;
  margin-bottom: 16px;
  font-size: 14px;
}
.stat > .item {
  display: inline;
  padding-right: 24px;
}
.stat > .item > .number {
  font-weight: bold;
  color: #303133;
  font-size: 16px;
}
.operations > .el-button {
  margin-left: 0px;
}

.load-info {
  clear: both;
  width: 300px;
  margin: 0 auto;
  text-align: center;
}
</style>
