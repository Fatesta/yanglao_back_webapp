<template>
  <el-card
    shadow="hover"
    class="room-berth"
    :style="{
      'background-color': berth.isEmpty ? '#ecf5ff' : '#fef0f0'
    }"
    :body-style="{
      'padding': '10px'
    }">
    <div slot="header">
      床位{{berth.berthNo}}
      <span style="color:#909399">{{berth.berthTypeName}}</span>
      <el-dropdown @command="onCommand" style="float: right;">
        <span class="el-dropdown-link">
          <i class="el-icon-setting"></i>
        </span>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item command="updateDeposit" v-if="!berth.isEmpty">交押金</el-dropdown-item>
          <el-dropdown-item command="userInfo" v-if="!berth.isEmpty">当前入住人详情</el-dropdown-item>
          <el-dropdown-item command="checkinRecord">历史入住记录</el-dropdown-item>
          <el-dropdown-item command="checkinPayRecord">历史账单</el-dropdown-item>
          <el-dropdown-item command="setServicePlan">服务计划</el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
    <el-row>
      <el-col :span="12" style="text-align:center">
        <img :src="berth.isEmpty ?
          empty_bed :
          (berth.berthCheckin.userInfo.sex == 1 ? photo_icon_woman : photo_icon_man)"
        />
      </el-col>
      <el-col v-if="berth.isEmpty" :span="12" style="line-height: 90px;text-align:center">
        <el-button
          size="mini"
          type="primary"
          @click="onCheckinClick"
        >入住</el-button>
      </el-col>
      <el-col v-else :span="12">
        <div class="user-info">
          <el-row>
            <el-col>{{berth.berthCheckin.userInfo.realName}}</el-col>
          </el-row>
          <el-row>
            <el-col>
              <span>{{berth.berthCheckin.userInfo.sex == 1 ? '女' : '男'}}</span>
              <span style="margin-left:4px;">{{berth.berthCheckin.userInfo.age}}岁</span>
            </el-col>
          </el-row>
          <el-row>
            <el-col>
              <el-button
                size="mini"
                type="danger"
                plain
                @click="onCheckoutClick"
              >退住</el-button>
            </el-col>
          </el-row>
        </div>
      </el-col>
    </el-row>

    <user-basic-details ref="userBasicDetails"></user-basic-details>
  </el-card>
</template>

<script>
import empty_bed from './img/empty_bed.png';
import photo_icon_man from './img/photo_icon_man.png';
import photo_icon_woman from './img/photo_icon_woman.png';

export default {
  props: {
    berth: Object
  },
  components: {
    UserBasicDetails: () => import('@/pages/user/UserBasicDetails.vue'),
  },
  data() {
    return {
      empty_bed,
      photo_icon_man,
      photo_icon_woman
    };
  },
  methods: {
    onCheckinClick() {
      openTab({
        url: 'view/community/berth/checkin/checkinForm.do?berthId='
          + this.berth.id + '&berthNo=' + this.berth.berthNo,
        title: '登记入住'
      });
    },
    onCheckoutClick() {
      openTab({
        url: 'community/berth/checkin/leaveForm.do?berthId=' + this.berth.id,
        title: '办理退住'
      });
    },
    onCommand(cmd) {
      switch (cmd) {
        case 'updateDeposit':
          this.$alert('更新中');
          break;
        case 'userInfo':
          this.$refs.userBasicDetails.show({id: this.berth.berthCheckin.userId});
          break;
        case 'checkinRecord':
          openTab({
            url: 'view/community/berth/checkinRecord.do?berthId=' + this.berth.id,
            title: '入住记录'
          });
          break;
        case 'checkinPayRecord':
          openTab({
            url: 'view/community/berth/checkinPayRecord.do?berthId=' + this.berth.id,
            title: `床位${this.berth.berthNo}历史账单`
          });
          break;
        case 'setServicePlan':
          openModuleByCode('servicePlan');
          break;
      }
    }
  },
  created() {
    let { berth } = this;
    if (!berth.isEmpty) {
      if (berth.berthCheckin == null) {
          berth.berthCheckin = {userInfo: {}};
      }
    }
  }
}
</script>

<style scoped>
.room-berth {
  width: 190px;
  font-size: 14px;
}
.room-berth >>> .el-card__header {
  padding: 4px 5px;
}
.user-info > .el-row > .el-col {
  height: 30px;
}
</style>
