<template>
  <data-table-app-page>
    <el-form :inline="true" :model="searchForm">
      <el-form-item>
        <el-input v-model="searchForm.oldmanValue" clearable style="width: 324px">
          <el-select
            slot="prepend" 
            v-model="searchForm.oldmanKey"
            size="mini"
            placeholder="请选择"
            style="width: 120px"
          >
            <el-option label="姓名" value="name"></el-option>
            <el-option label="身份证号码" value="idcard"></el-option>
            <el-option label="联系电话" value="phone"></el-option>
          </el-select>
        </el-input>
      </el-form-item>
      <el-form-item label="年龄">
        <el-input-number v-model="searchForm.gteqAge" :controls="false" placeholder=">=" style="width: 60px" />
      </el-form-item>
      <el-form-item label="所属区域">
        <org-select v-model="searchForm.areaId" :level="3" />
      </el-form-item>
      <el-form-item label="所在社区">
        <el-select v-model="searchForm.communityName" clearable filterable>
          <el-option
            v-for="name in communityNames"
            :key="name"
            :label="name"
            :value="name"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="居住街道">
        <el-select v-model="searchForm.street" clearable filterable>
          <el-option
            v-for="name in streetNames"
            :key="name"
            :label="name"
            :value="name"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="申请对象类型">
        <el-select
          v-model="searchForm.applyTypeJoinPredicate"
          placeholder="请选择"
          style="width: 134px"
        >
          <el-option label="至少符合一个" value="or">至少符合一个</el-option>
          <el-option label="同时符合全部" value="and">同时符合全部</el-option>
        </el-select>
        <type-select
          v-model="searchForm.applyTypes"
          :items="DictMan.items('evalOldman.applyType')"
          multiple
          collapse-tags
          clearable
          filterable
          style="width: 204px"
        />
      </el-form-item>
      <el-form-item label="评估状态" style="width: 266px;">
        <type-select
          v-model="searchForm.evalState"
          :items="DictMan.items('evalOldman.evalState')"
          clearable
          filterable
          style="width: 120px"
        />
      </el-form-item>
      <el-form-item label="评估分数">
        <el-input-number v-model="searchForm.evalScore" :controls="false" placeholder=">=" style="width: 60px" />
      </el-form-item>
      <el-form-item>
        <data-table-query-button :query-params="queryParams" />
      </el-form-item>
    </el-form>
    <data-table
      ref="table"
      url="/api/user/evalOldman/findAll"
    >
      <el-table-column prop="name" label="姓名" width="80" show-overflow-tooltip></el-table-column>
      <el-table-column prop="age" label="年龄" width="50"></el-table-column>
      <el-table-column prop="idcard" label="身份证号码" width="174"></el-table-column>
      <el-table-column prop="phone" label="联系电话" width="120"></el-table-column>
      <el-table-column prop="communityName" label="所在社区" width="140" show-overflow-tooltip></el-table-column>
      <el-table-column prop="street" label="居住街道" width="100" show-overflow-tooltip></el-table-column>
      <el-table-column prop="applyTypesText" label="申请对象类型" width="120" :formatter="formatters.applyTypesText" show-overflow-tooltip></el-table-column>
      <el-table-column prop="evalScore" label="评估分数" width="80" :formatter="formatters.evalScore"></el-table-column>
      <el-table-column prop="evalStateText" label="评估状态" width="80"></el-table-column>
      <el-table-column prop="allowanceMoney" label="拟享受市补贴" width="110" :formatter="formatters.allowanceMoney"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="{row}">
          <el-button
            @click="onDetailsClick(row)"
          >
            详情
          </el-button>
        </template>
      </el-table-column>
    </data-table>

    <eval-info-details ref="evalInfoDetails" />
  </data-table-app-page>
</template>


<script>
import { Select } from 'element-ui';

export default {
  pageProps: {
    title: '评估对象管理'
  },
  components: {
    EvalInfoDetails: () => import('./EvalInfoDetails'),
    OrgSelect: () => ({ component: import('@/pages/org/OrgSelect.vue'), loading: Select, delay: 0 })
  },
  data() {
    return {
      formatters: {
        sex(row, col, val) { return DictMan.itemMap('user.gender')[val]; },
        applyTypesText(row, col, val) { return val || '未申请'; },
        evalScore(row, col, val) { return val || 0; },
        allowanceMoney(row, col, val) { return val || 0; },
      },
      searchForm: {
        oldmanKey: 'name',
        applyTypeJoinPredicate: 'or'
      },
      communityNames: [],
      streetNames: []
    }
  },
  mounted() {
    this.$http.get('/api/user/evalOldman/dictByName.do?name=community_name').then(ret => {
      this.communityNames = ret;
    });
    this.$http.get('/api/user/evalOldman/dictByName.do?name=street').then(ret => {
      this.streetNames = ret;
    });
  },
  methods: {
    queryParams() {
      let params = {...this.searchForm};
      params[params.oldmanKey] = params.oldmanValue;
      delete params.oldmanKey;
      delete params.oldmanValue;
      if (params.applyTypes)
        params.applyTypes = params.applyTypes.join(',');
      return params;
    },
    onQuerierShowClick() {
      this.$refs.userQuerier.show({
        values: this.searchForm,
        table: this.$refs.table
      });
    },
    onDetailsClick(evalInfo) {
      this.$refs.evalInfoDetails.show(evalInfo);
    }
  }
}
</script>