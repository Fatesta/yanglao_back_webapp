<template>
  <div>
    <el-form :inline="true" :model="searchForm">
      <el-form-item label="时间范围">
        <type-select
          v-model="searchDay"
          :items="[
            {value: 1, text: '今天'},
            {value: -1, text: '昨天'},
            {value: 7, text: '7天'}
          ]"
          style="width: 90px"
          @change="onSearchDayChange"
        />
        <span>或</span>
        <el-date-picker
          format="yyyy-MM-dd HH:mm"
          value-format="yyyy-MM-dd HH:mm:ss"
          :default-time="['00:00:00', '23:59:59']"
          align="right"
          type="daterange"
          range-separator="至"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          placeholder="选择时间范围"
          @change="onTimeRangeChange"
        />
      </el-form-item>
      <el-form-item label="呼叫类型">
        <type-select
          v-model="searchForm.contactType"
          :items="contactType"
          style="width: 90px"
        />
      </el-form-item>
      <el-form-item label="挂断原因">
        <type-select
          v-model="searchForm.contactDisposition"
          :items="contactDisposition"
          style="width: 140px"
        />
      </el-form-item>
      <el-form-item label="客户电话/客服">
        <el-input
          v-model="searchForm.criteria"
          style="width: 160px"
        />
      </el-form-item>
      <el-form-item>
        <data-table-query-button :query-params="searchForm" />
      </el-form-item>
    </el-form>
    <data-table
      ref="table"
      url="/api/callcenter/record/page"
      lazy
      :loadFilter="loadFilter"
      :height="540"
    >
      <el-table-column prop="startTime" label="时间" width="170" :formatter="formatters.startTime"></el-table-column>
      <el-table-column prop="customerNumber" label="客户电话" width="120"></el-table-column>
      <el-table-column prop="aliasName" label="姓名" width="80" show-overflow-tooltip></el-table-column>
      <el-table-column prop="sex" label="性别" width="50" :formatter="formatters.sex"></el-table-column>
      <el-table-column prop="age" label="年龄" width="50"></el-table-column>
      <el-table-column prop="contactType" label="呼叫类型" width="80" :formatter="formatters.contactType"></el-table-column>
      <el-table-column prop="duration" label="时长" width="70" :formatter="formatters.duration"></el-table-column>
      <el-table-column prop="contactDisposition" label="挂断原因" width="120" :formatter="formatters.contactDisposition"></el-table-column>
      <el-table-column prop="agentNames" label="客服" width="80" show-overflow-tooltip></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="{row}">
          <el-dropdown
            v-if="row.recordings.length"
            @command="onRecodingCommandClick($event, row)"
            :show-timeout="100"
          >
            <el-button
              split-button
            >
              录音<i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="play">播放</el-dropdown-item>
              <el-dropdown-item command="download">下载</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </data-table>
    
    <audio-dialog ref="audioDialog" title="录音" />
  </div>
</template>


<script>
import { toDurationText } from '@/utils/time-ui';

export default {
  components: {
    AudioDialog: () => import('@/components/AudioDialog')
  },
  data() {
    let contactDisposition = [
      {value: 'Success', text: '正常'},
      {value: 'NoAnswer', text: '无应答'},
      {value: 'Rejected', text: '拒绝'},
      {value: 'Busy', text: '忙'},
      {value: 'AbandonedInContactFlow', text: 'IVR呼损'},
      {value: 'AbandonedInQueue', text: '队列呼损'},
      {value: 'AbandonedRing', text: '久振不接'},
      {value: 'QueueOverflow', text: '等待超时被挂断'}
    ];
    let contactDispositionMap = {};
    for (let item of contactDisposition) {
      contactDispositionMap[item.value] = item.text;
    }

    let contactType = [
      {value: 'Inbound', text: '呼入'},
      {value: 'Outbound', text: '呼出'}
    ];
    let contactTypeMap = {};
    for (let item of contactType) {
      contactTypeMap[item.value] = item.text;
    }

    return {
      searchForm: {
        orderBy: 'DESC',
        startTime: 0,
        stopTime: 0
      },
      searchDay: 7,
      timeRange: [],
      formatters: {
        startTime: (row, col, t) => moment(t).format('YYYY-MM-DD HH:mm:ss'),
        sex: (row, col, v) => v == 0 ? '男' : '女',
        contactType: (row, col, t) => this.maps.contactType[t],
        duration: (row, col, t) => toDurationText(t * 1000),
        contactDisposition: (row, col, t) => this.maps.contactDisposition[t]
      },
      contactDisposition,
      contactType,
      maps: {
        contactType: contactTypeMap,
        contactDisposition: contactDispositionMap
      }
    }
  },
  mounted() {
    this.onSearchDayChange();
    this.$refs.table.query(this.searchForm);
  },
  methods: {
    query() {
      this.$refs.table.reloadCurrentPage();
    },
    loadFilter(data) {
      if (!data.callDetailRecords)
        return [];
      data.callDetailRecords.list.forEach(function(row) {
        Object.assign(row, row.user);
      });
      return {total: data.callDetailRecords.totalCount, rows: data.callDetailRecords.list};
    },
    onSearchDayChange() {
      var days = +this.searchDay;
      if (days) {
        switch (days) {
          case 1:
            this.searchForm.startTime = 0;
            this.searchForm.stopTime = 0;
            break;
          case -1:
            var today = new Date(moment().format('YYYY-MM-DD 00:00:00')).getTime();
            this.searchForm.startTime = today - 1000*60*60*24 * days;
            this.searchForm.stopTime = today;
            break;
          case 7:
            this.searchForm.startTime = new Date(moment().subtract(days - 1, 'days').format('YYYY-MM-DD 00:00:00')).getTime();
            this.searchForm.stopTime = 0;
            break;
        }
      } else {
        if (this.timeRange.length) {
          this.searchForm.startTime = +new Date(this.timeRange[0] + ' 00:00:00');
          this.searchForm.stopTime = +new Date(this.timeRange[1] + ' 00:00:00');         
        }
      }
    },
    onTimeRangeChange(values) {
      this.startTime = values[0];
      this.stopTIme = vlaues[1];
    },
    onRecodingCommandClick(cmd, row) {
      switch (cmd) {
        case 'play':
          this.$refs.audioDialog.show({
            src: `/api/callcenter/record/raw?fileName=${row.recordings[0].fileName}`
          });
          break;
        case 'download':
          location.href = `/api/callcenter/record/download?`
            `fileName=${row.recordings[0].fileName}&returnFileName=${row.recordings[0].fileDescription}.wav`;
          break;
      }
    }
  }
}
</script>
